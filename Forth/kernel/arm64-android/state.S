/* Generated from Forth/kernel/arm64/state.asm. Do not edit. */
    .data
    .p2align 3
    .global latest_var
    .global last_cfa
    .global noname_xt
    .global here_ptr
    .global state_var
    .global bye_flag
    .global inited
    .global emit_fn
    .global file_op_hook
    .global float_op_hook
    .extern host_float_op
    .global key_fn
    .global facility_op_hook
    .global vm_tos
    .global vm_dsp
    .global vm_rsp
    .global source_cur
    .global source_end
    .global source_base
    .global to_in
    .global throw_handler
    .global pad_buffer
    .global redef_warn
    .global block_file
    .global block_upd
    .global block_nr
    .global block_buf
    .global scr_var
    .global blk_var
    .global blk_stack
    .global forget_cut
    .global native_dsp_end
    .global jit_exec_mode
    .global cfa_flit
    .global cfa_local_init
    .global cfa_local_at
    .global cfa_local_store
    .global cfa_loop
    .global cfa_plusloop
    .global local_name_count
    .global local_init_count
    .global local_init_reverse
    .global local_declaring
    .global local_brace_phase
    .global local_names
    .global local_frame_depth
    .global local_frames
    .global local_frame_rsp
    .global local_frame_n
    .global slit_esc_buf
    .global slit_esc_buf2
    .global slit_esc_which
    .global line_mode
    .global line_origin
    .global line_limit
    .global line_next
    .global source_id
    .global file_echo
    .global file_echo_pos
    .global file_echo_stack
    .global source_sp
    .global source_stack
    .global eval_resume_sp
    .global eval_resume_stack
    .global resolve_buf
    .global catch_ok_cell
    .global tw_continue_cell
    .global dict_end
    .global base_var
    .global current_var
    .global search_order
    .global search_order_n
    .global pending_help_addr
    .global pending_help_len
    .global word_scratch
    .global wordlist_reg
    .global wordlist_reg_n
    .global words_user_base
    .global words_filter
    .global words_filter_len
    .global words_nk_tmp
    .global words_cfa
    .global cfa_branch
    .global cfa_0branch
    .global cfa_does
    .global cfa_slit
    .global cfa_cstr
    .global cfa_execute
    .global cfa_comma
    .global library_path_buf
    .global exit_cfa
    .global cfa_exit
    .global lit_cfa
    .global cfa_lit
    .global restart_cell
    .global restart_cfa
    .global kernel_inited
    .global emit_hook
    .global key_hook
    .global data_stack
    .global return_stack
    .global user_dict_area
    .global user_dict_size_cell
    .global grow_memory_used
    .global xchar_emit_buf
    .global numbuf
    .global dstack
    .global rstack
    .global dictmem
latest_var:
    .space 128
last_cfa:
    .quad 0
noname_xt:
    .quad 0
here_ptr:
    .quad 0
state_var:
    .quad 0
base_var:
    .quad 10
current_var:
    .quad latest_var
search_order:
    .quad latest_var
    .quad 0, 0, 0, 0, 0, 0, 0
search_order_n:
    .quad 1
pending_help_addr:
    .quad 0
pending_help_len:
    .quad 0
wordlist_reg_n:
    .quad 0
bye_flag:
    .quad 0
kernel_inited:
inited:
    .quad 0
emit_hook:
emit_fn:
    .quad 0
file_op_hook:
    .quad 0
float_op_hook:
    .quad host_float_op
key_hook:
key_fn:
    .quad 0
facility_op_hook:
    .quad 0
vm_tos:
    .quad 0
vm_dsp:
    .quad 0
vm_rsp:
    .quad 0
source_base:
    .quad 0
source_cur:
    .quad 0
source_end:
    .quad 0
to_in:
    .quad 0
throw_handler:
    .quad 0
cfa_flit:
    .quad 0
cfa_local_init:
    .quad 0
cfa_local_at:
    .quad 0
cfa_local_store:
    .quad 0
cfa_loop:
    .quad 0
cfa_plusloop:
    .quad 0
local_name_count:
    .quad 0
local_init_count:
    .quad 0
local_init_reverse:
    .quad 0
local_declaring:
    .quad 0
local_brace_phase:
    .quad 0
local_frame_depth:
    .quad 0
local_names:
    .space 1024
local_frames:
    .space 4096
local_frame_rsp:
    .space 128
local_frame_n:
    .space 128
slit_esc_buf:
    .space 256
slit_esc_buf2:
    .space 256
slit_esc_which:
    .quad 0
line_mode:
    .quad 0
line_origin:
    .quad 0
line_limit:
    .quad 0
line_next:
    .quad 0
source_id:
    .quad 0
file_echo:
    .quad 0
file_echo_pos:
    .quad 0
file_echo_stack:
    .space 64
source_sp:
    .quad 0
eval_resume_sp:
    .quad 0
source_stack:
    .space 512
eval_resume_stack:
    .space 64
resolve_buf:
    .space 256
pad_buffer:
    .space 1024
library_path_buf:
    .space 1024
redef_warn:
    .quad 0
block_file:
    .quad 0
block_upd:
    .quad 0
block_nr:
    .quad -1
scr_var:
    .quad 0
blk_var:
    .quad 0
blk_stack:
    .space 64
forget_cut:
    .quad 0
jit_exec_mode:
    .quad 0
native_dsp_mem:
    .space 8192
native_dsp_end:
block_buf:
    .space 1024
catch_ok_cell:
    .quad catch_ok_cfa
tw_continue_cell:
    .quad tw_continue_cfa
cfa_exit:
exit_cfa:
    .quad 0
cfa_lit:
lit_cfa:
    .quad 0
cfa_branch:
    .quad 0
cfa_0branch:
    .quad 0
cfa_does:
    .quad 0
cfa_slit:
    .quad 0
cfa_cstr:
    .quad 0
cfa_execute:
    .quad 0
cfa_comma:
    .quad 0
restart_cell:
    .quad restart_cfa
numbuf:
    .space 32
word_scratch:
    .space 80
wordlist_reg:
    .space 256
words_user_base:
    .quad 0
words_filter_len:
    .quad 0
words_nk_tmp:
    .quad 0
words_filter:
    .space 64
words_cfa:
    .space 8192
data_stack:
dstack:
    .space 4096
return_stack:
rstack:
    .space 4096
user_dict_size_cell:
    .quad 8388608
grow_memory_used:
    .quad 0
xchar_emit_buf:
    .space 8
    .bss
    .p2align 3
user_dict_area:
dictmem:
    .space 268435456
dict_end:
    .data
    .p2align 3
restart_cfa:
    .quad XRESTART
catch_ok_cfa:
    .quad XCATCH_OK
    .global tw_continue_cfa
tw_continue_cfa:
    .quad XTW_CONTINUE
    .extern XRESTART
    .extern XCATCH_OK
    .extern XTW_CONTINUE
