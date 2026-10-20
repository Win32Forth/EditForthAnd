#!/usr/bin/env python3
"""Translate EditForth ARM64 armasm into Clang GAS for Android NDK.

Reads Forth/kernel/arm64 and writes Forth/kernel/arm64-android/*.S
(except identity.S, which is hand-maintained).

Same workflow idea as arm64_to_ml64.py: ARM64 armasm stays the source of
truth; this script produces the Android dialect. Instruction stream stays
real AArch64 (unlike the x64 virtual-register translation).

Set EDITFORTHAND to override the project root (default: parent of GrokTools).
"""

from __future__ import annotations

import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.environ.get(
    "EDITFORTHAND",
    os.path.abspath(os.path.join(HERE, "..")),
)
SRC = os.path.join(ROOT, "Forth", "kernel", "arm64")
OUT = os.path.join(ROOT, "Forth", "kernel", "arm64-android")

FILES = [
    "state.asm",
    "emit.asm",
    "boot_begin.asm",
    "prims.asm",
    "prims_k1.asm",
    "prims_k2.asm",
    "prims_k3.asm",
    "sa_print.asm",
    "sa_files.asm",
    "sa_float.asm",
    "prims_dbg.asm",
    "dict.asm",
    "entry.asm",
    "cold.asm",
    "boot_end.asm",
]

# Directives / opcodes handled specially; everything else passes through.
SKIP_HAND_IDENTITY = True

REG = re.compile(r"^[xwvbhsdq]\d+$", re.I)
IMM = re.compile(r"^#")
LO12_SYM = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*$")


class AsmError(Exception):
    pass


def strip_comment(line: str) -> str:
    out = []
    quote = None
    for ch in line:
        if quote:
            out.append(ch)
            if ch == quote:
                quote = None
            continue
        if ch == '"':
            quote = ch
            out.append(ch)
            continue
        if ch == ";":
            break
        out.append(ch)
    return "".join(out).strip()


def first_token(line: str) -> tuple[str, str]:
    line = line.strip()
    match = re.match(r"(\S+)(?:\s+(.*))?$", line)
    if not match:
        return "", ""
    return match.group(1), (match.group(2) or "").strip()


def split_commas(text: str, brackets: bool = True) -> list[str]:
    out: list[str] = []
    buf: list[str] = []
    depth = 0
    quote = None
    for ch in text:
        if quote:
            buf.append(ch)
            if ch == quote:
                quote = None
            continue
        if ch == '"':
            quote = ch
            buf.append(ch)
            continue
        if brackets and ch == "[":
            depth += 1
        elif brackets and ch == "]" and depth > 0:
            depth -= 1
        if ch == "," and depth == 0:
            out.append("".join(buf).strip())
            buf = []
            continue
        buf.append(ch)
    if buf:
        part = "".join(buf).strip()
        if part:
            out.append(part)
    return [part for part in out if part != ""]


def eval_expr(text: str, equ: dict[str, int]):
    expr = (
        text.replace(":OR:", "|")
        .replace(":AND:", "&")
        .replace(":SHL:", "<<")
        .replace(":SHR:", ">>")
        .replace(":NOT:", "~")
        .replace(":MOD:", "%")
    )

    def repl(match: re.Match[str]) -> str:
        name = match.group(0)
        if name not in equ:
            raise AsmError(f"unknown symbol in expression: {name}")
        return str(equ[name])

    expr = re.sub(r"(?<![A-Za-z0-9_])[A-Za-z_][A-Za-z0-9_]*", repl, expr)
    if not re.fullmatch(r"[0-9A-Fa-fXx+\-*/<>=|&~() \t]+", expr):
        raise AsmError(f"bad expression: {text}")
    return eval(expr, {"__builtins__": {}}, {})


def area_kind(line: str) -> str:
    match = re.search(r"\|([^|]+)\|", line)
    name = match.group(1).lower() if match else ".text"
    if name in (".text", "text"):
        return "text"
    if name in (".data", "data"):
        return "data"
    if name in (".rdata", "rdata"):
        return "rodata"
    if name in (".bss", "bss"):
        return "bss"
    if "bootptr" in name:
        return "bootptr"
    if "bootword" in name:
        return "bootword"
    if "bwstr" in name:
        return "bwstr"
    raise AsmError(f"unknown area: {line}")


def is_opcode(token: str) -> bool:
    low = token.lower()
    if low in {
        "add", "adds", "sub", "subs", "adc", "sbc", "cmp", "cmn", "tst",
        "and", "ands", "orr", "eor", "bic", "mvn", "neg",
        "mov", "movz", "movk", "lsl", "lsr", "asr",
        "mul", "umulh", "smulh", "msub", "udiv", "sdiv",
        "ldr", "ldrb", "str", "strb", "ldp", "stp",
        "adrp", "adr", "lea",
        "cbz", "cbnz", "tbz", "tbnz", "b", "bl", "br", "blr", "ret",
        "csel", "csneg", "cset", "csetm", "ccmp", "extr",
        "fmov", "fadd", "fsub", "fmul", "fdiv", "fmax", "fmin",
        "fneg", "fabs", "fsqrt", "fcmp", "fcvt", "fcvtzs", "scvtf", "ucvtf",
        "dcb", "dcq", "dcd", "space", "align",
    }:
        return True
    return low.startswith("b.")


class Expander:
    def __init__(self, src_root: str, project_root: str):
        self.src_root = src_root
        self.project_root = project_root
        self.macros: dict[str, tuple[list[str], list[str]]] = {}
        self.equ: dict[str, int] = {}
        self.lines: list[tuple[str, str]] = []
        self.mode = ["run"]
        self.defining: list[str] | None = None
        self.proto: tuple[str, list[str]] | None = None
        self.expect_proto = False
        self.depth = 0
        self.origin = ""

    def read_lines(self, path: str) -> list[str]:
        with open(path, "r", encoding="utf-8", errors="replace") as handle:
            return handle.read().splitlines()

    def expand_file(self, name: str) -> tuple[list[tuple[str, str]], dict[str, int]]:
        self.macros = {}
        self.equ = {}
        self.lines = []
        self.mode = ["run"]
        self.defining = None
        self.proto = None
        self.expect_proto = False
        self.depth = 0
        self.process_file(os.path.join(self.src_root, name))
        return self.lines, dict(self.equ)

    def resolve_include(self, inc: str) -> str:
        candidates = [
            os.path.join(self.project_root, inc),
            os.path.join(self.src_root, inc),
            os.path.join(self.src_root, os.path.basename(inc)),
            os.path.join(self.project_root, "Forth", "kernel", "arm64", os.path.basename(inc)),
        ]
        for path in candidates:
            if os.path.isfile(path):
                return path
        raise AsmError(f"INCLUDE not found: {inc}")

    def process_file(self, path: str) -> None:
        old = self.origin
        self.origin = path
        for raw in self.read_lines(path):
            if self.process_line(strip_comment(raw)) == "end":
                self.origin = old
                return
        self.origin = old

    def process_line(self, line: str) -> str | None:
        if not line:
            return None
        if self.expect_proto:
            name, rest = first_token(line)
            params = []
            if rest:
                params = [part.strip().lstrip("$") for part in split_commas(rest, False)]
            elif name.startswith("$"):
                params = [name.lstrip("$")]
                name = ""
            if not name or name.startswith("$"):
                raise AsmError(f"bad macro prototype: {line}")
            self.proto = (name, params)
            self.defining = []
            self.expect_proto = False
            return None
        if self.defining is not None:
            if line.upper() == "MEND":
                assert self.proto is not None
                name, params = self.proto
                self.macros[name] = (params, self.defining)
                self.defining = None
                self.proto = None
            else:
                self.defining.append(line)
            return None

        token, rest = first_token(line)
        upper = token.upper()
        if upper == "MACRO":
            self.expect_proto = True
            return None
        if upper == "IF":
            self.do_if(rest)
            return None
        if upper == "ELSE":
            self.do_else()
            return None
        if upper == "ENDIF":
            self.do_endif()
            return None
        if self.mode[-1] != "run":
            return None
        if upper == "INCLUDE":
            inc = rest.strip().strip('"')
            self.process_file(self.resolve_include(inc))
            return None
        if upper == "END":
            return "end"
        if upper == "ENDP":
            self.lines.append((line, self.origin))
            return None
        second, _ = first_token(rest) if rest else ("", "")
        if second.upper() == "EQU":
            _, rhs = first_token(rest)
            self.equ[token] = int(eval_expr(rhs, self.equ))
            return None
        if token in self.macros:
            self.invoke(token, rest, line)
            return None
        self.lines.append((line, self.origin))
        return None

    def do_if(self, expr: str) -> None:
        if self.mode[-1] != "run":
            self.mode.append("skip")
            return
        value = eval_expr(expr, self.equ)
        self.mode.append("run" if value else "skip")

    def do_else(self) -> None:
        if len(self.mode) < 2:
            raise AsmError("ELSE without IF")
        parent = self.mode[-2]
        if parent != "run":
            return
        self.mode[-1] = "skip" if self.mode[-1] == "run" else "run"

    def do_endif(self) -> None:
        if len(self.mode) < 2:
            raise AsmError("ENDIF without IF")
        self.mode.pop()

    def invoke(self, name: str, rest: str, line: str) -> None:
        params, body = self.macros[name]
        args = split_commas(rest, False) if rest else []
        if len(args) != len(params):
            raise AsmError(f"{name} wants {len(params)} args, got {len(args)}: {line}")
        self.depth += 1
        if self.depth > 30:
            raise AsmError(f"macro recursion at {line}")
        pairs = sorted(zip(params, args), key=lambda item: len(item[0]), reverse=True)
        for body_line in body:
            text = body_line
            for param, arg in pairs:
                text = text.replace("$" + param, arg)
            self.process_line(text.strip())
        self.depth -= 1


class GasTranslator:
    def __init__(self, equ: dict[str, int], origin_name: str, project_root: str):
        self.equ = equ
        self.origin_name = origin_name
        self.project_root = project_root
        self.body: list[str] = []
        self.section = ""
        self.globals: set[str] = set()
        self.pending_adrp: tuple[str, str] | None = None  # (reg, sym)

    def emit(self, text: str) -> None:
        self.body.append(text)

    def set_section(self, kind: str) -> None:
        if kind == self.section:
            return
        self.section = kind
        if kind == "text":
            self.emit('    .text')
            self.emit('    .p2align 2')
        elif kind == "data":
            self.emit('    .data')
            self.emit('    .p2align 3')
        elif kind == "rodata":
            self.emit('    .section .rodata,"a",@progbits')
            self.emit('    .p2align 3')
        elif kind == "bss":
            self.emit('    .bss')
            self.emit('    .p2align 3')
        elif kind == "bootptr":
            # Writable so ABS64 pointer rows can relocate in a PIC .so
            self.emit('    .section .bootptr,"aw",@progbits')
            self.emit('    .p2align 3')
        elif kind == "bootword":
            self.emit('    .section .bootword,"aw",@progbits')
            self.emit('    .p2align 3')
        elif kind == "bwstr":
            self.emit('    .section .bwstr,"aw",@progbits')
            self.emit('    .p2align 0')
        else:
            raise AsmError(kind)

    def align_bytes(self, n: int) -> None:
        # armasm ALIGN n => align to n-byte boundary
        if n <= 0:
            return
        # .p2align log2(n) when power of two
        if n & (n - 1) == 0:
            import math
            self.emit(f"    .p2align {int(math.log2(n))}")
        else:
            self.emit(f"    .balign {n}")

    def translate(self, lines: list[tuple[str, str]]) -> str:
        self.emit(f"/* Generated from Forth/kernel/arm64/{self.origin_name}. Do not edit. */")
        for name in sorted(self.equ.keys()):
            self.emit(f"    .equ {name}, {self.equ[name]}")
        for text, _origin in lines:
            try:
                self.translate_line(text)
            except AsmError as exc:
                raise AsmError(f"{self.origin_name}: {exc} | {text}") from exc
        if self.pending_adrp is not None:
            raise AsmError(f"{self.origin_name}: unpaired adrp {self.pending_adrp}")
        return "\n".join(self.body) + "\n"

    def translate_line(self, line: str) -> None:
        token, rest = first_token(line)
        upper = token.upper()
        if upper == "AREA":
            self.set_section(area_kind(line))
            return
        if upper == "EXPORT":
            name = rest.split()[0]
            self.globals.add(name)
            self.emit(f"    .global {name}")
            return
        if upper == "EXTERN":
            name = rest.split()[0]
            self.emit(f"    .extern {name}")
            return
        if upper == "INCBIN":
            self.emit_incbin(rest.strip().strip('"'))
            return
        if upper == "ENDP":
            self.pending_adrp = None
            return
        if upper == "ALIGN":
            self.align_bytes(int(eval_expr(rest, self.equ)))
            return
        if is_opcode(token):
            self.translate_op(token.lower(), rest, line)
            return
        if not rest:
            self.emit(f"{token}:")
            return
        second, after = first_token(rest)
        if second.upper() == "PROC":
            self.emit(f"{token}:")
            if after:
                self.translate_line(after)
            return
        # label + instruction on one line
        self.emit(f"{token}:")
        self.translate_line(rest)

    def emit_incbin(self, rel: str) -> None:
        # cold.asm uses Forth/kernel1.fth from project root → kernel1.fth under Forth/
        path = rel.replace("\\", "/")
        if path.startswith("Forth/"):
            path = path[len("Forth/"):]
        self.emit(f'    .incbin "{path}"')

    def translate_op(self, op: str, rest: str, line: str) -> None:
        ops = split_commas(rest) if rest else []
        if op == "align":
            self.align_bytes(int(eval_expr(ops[0], self.equ)))
            return
        if op == "space":
            count = int(eval_expr(ops[0], self.equ))
            self.emit(f"    .space {count}")
            return
        if op == "dcb":
            self.emit_dcb(ops)
            return
        if op == "dcq":
            self.emit_dc(ops, ".quad")
            return
        if op == "dcd":
            self.emit_dc(ops, ".word")
            return
        if op == "adr":
            # PIC-safe local address: adrp + :lo12: (pools may live in .data).
            if len(ops) != 2:
                raise AsmError("adr needs 2 operands")
            self.emit(f"    adrp {ops[0]}, {ops[1]}")
            self.emit(f"    add {ops[0]}, {ops[0]}, :lo12:{ops[1]}")
            return
        if op == "adrp":
            if len(ops) != 2:
                raise AsmError("adrp needs 2 operands")
            # Android .so requires PIC: materialize &sym via GOT.
            self.pending_adrp = (ops[0], ops[1])
            return
        if op == "add" and self.pending_adrp is not None:
            reg, sym = self.pending_adrp
            if (
                len(ops) == 3
                and ops[0] == reg
                and ops[1] == reg
                and ops[2] == sym
            ):
                self.emit(f"    adrp {reg}, :got:{sym}")
                self.emit(f"    ldr {reg}, [{reg}, :got_lo12:{sym}]")
                self.pending_adrp = None
                return
            raise AsmError(f"expected add {reg}, {reg}, {sym} after adrp")
        if self.pending_adrp is not None:
            raise AsmError(f"expected add after adrp, got {op}")

        # Default: emit AArch64 line as-is (opcodes match GAS).
        if rest:
            self.emit(f"    {op} {rest}")
        else:
            self.emit(f"    {op}")

    def emit_dcb(self, ops: list[str]) -> None:
        # Mix of "string", numbers, expressions
        for item in ops:
            item = item.strip()
            if item.startswith('"') and item.endswith('"'):
                # armasm DCB "text" is raw bytes without NUL unless ,0 follows
                raw = bytes(item[1:-1], "utf-8").decode("unicode_escape")
                # Prefer .ascii for non-empty; empty still emit
                escaped = (
                    raw.replace("\\", "\\\\")
                    .replace('"', '\\"')
                    .replace("\n", "\\n")
                    .replace("\r", "\\r")
                    .replace("\t", "\\t")
                )
                self.emit(f'    .ascii "{escaped}"')
            else:
                value = int(eval_expr(item, self.equ))
                self.emit(f"    .byte {value & 0xFF}")

    def emit_dc(self, ops: list[str], directive: str) -> None:
        parts = []
        needs_reloc = False
        for item in ops:
            item = item.strip()
            if LO12_SYM.match(item) and item not in self.equ:
                parts.append(item)  # relocatable symbol
                needs_reloc = True
            else:
                try:
                    parts.append(str(int(eval_expr(item, self.equ))))
                except AsmError:
                    parts.append(item)
                    needs_reloc = True
        # ABS64 pointer cells must live in writable sections inside a PIC .so.
        # Labels / aligns emitted just above the DCQ must move with the cell;
        # otherwise adrp/:lo12: resolves to .text and ldr reads an instruction.
        if needs_reloc and directive == ".quad" and self.section in ("text", "rodata"):
            moved: list[str] = []
            while self.body:
                last = self.body[-1]
                stripped = last.strip()
                if stripped.endswith(":") and not last.startswith((" ", "\t")):
                    moved.append(self.body.pop())
                    continue
                if stripped.startswith(".p2align"):
                    moved.append(self.body.pop())
                    continue
                break
            self.set_section("data")
            for line in reversed(moved):
                self.body.append(line)
        self.emit(f"    {directive} " + ", ".join(parts))


def translate_one(name: str) -> None:
    expander = Expander(SRC, ROOT)
    lines, equ = expander.expand_file(name)
    # Pre-seed common EQUs that appear before use in some files via includes
    translator = GasTranslator(equ, name, ROOT)
    text = translator.translate(lines)
    out_name = os.path.splitext(name)[0] + ".S"
    out_path = os.path.join(OUT, out_name)
    with open(out_path, "w", encoding="utf-8", newline="\n") as handle:
        handle.write(text)
    print(f"wrote {out_path} ({len(text.splitlines())} lines)")


def main() -> int:
    if not os.path.isdir(SRC):
        print(f"ARM64 source not found: {SRC}", file=sys.stderr)
        return 1
    os.makedirs(OUT, exist_ok=True)
    # Keep hand-written identity.S and README.md
    for name in FILES:
        translate_one(name)
    print(f"done. OUT={OUT}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
