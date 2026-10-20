#include "AndroidShip.h"

#include <QDir>
#include <QDirIterator>
#include <QFile>
#include <QFileInfo>
#include <QSaveFile>
#include <QStandardPaths>
#include <QTextStream>

namespace {

const char kAssetRoot[] = "assets:/EditForthAnd";
const char kMarkerName[] = ".shipped-apk-version";
// Bump when the set of shipped files changes and must be recopied.
const char kShipVersion[] = "0.1.0-resources";

bool writeFile(const QString &destPath, const QByteArray &bytes) {
    QDir().mkpath(QFileInfo(destPath).absolutePath());
    QSaveFile out(destPath);
    if (!out.open(QIODevice::WriteOnly | QIODevice::Truncate))
        return false;
    if (out.write(bytes) != bytes.size())
        return false;
    return out.commit();
}

bool copyAssetFile(const QString &assetPath, const QString &destPath) {
    QFile in(assetPath);
    if (!in.open(QIODevice::ReadOnly))
        return false;
    return writeFile(destPath, in.readAll());
}

} // namespace

QString ensureAndroidShippedResources() {
    const QString destRoot =
        QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) +
        QStringLiteral("/EditForthAnd");
    QDir().mkpath(destRoot);

    const QString markerPath = destRoot + QLatin1Char('/') + QLatin1String(kMarkerName);
    QFile marker(markerPath);
    if (marker.open(QIODevice::ReadOnly)) {
        const QByteArray have = marker.readAll().trimmed();
        marker.close();
        if (have == QByteArray(kShipVersion))
            return destRoot;
    }

    // Fresh copy from APK assets. Replace tree contents for Library/AutoLoad/Docs/Config.
    const QStringList trees = {QStringLiteral("Library"), QStringLiteral("AutoLoad"),
                               QStringLiteral("Docs"), QStringLiteral("Config")};
    for (const QString &tree : trees) {
        const QString destTree = destRoot + QLatin1Char('/') + tree;
        if (QDir(destTree).exists())
            QDir(destTree).removeRecursively();
    }

    QDirIterator it(QLatin1String(kAssetRoot), QDirIterator::Subdirectories);
    const QString prefix = QLatin1String(kAssetRoot) + QLatin1Char('/');
    int copied = 0;
    while (it.hasNext()) {
        const QString assetPath = it.next();
        if (!it.fileInfo().isFile())
            continue;
        if (!assetPath.startsWith(prefix))
            continue;
        const QString rel = assetPath.mid(prefix.size());
        if (rel.isEmpty())
            continue;
        const QString destPath = destRoot + QLatin1Char('/') + rel;
        if (!copyAssetFile(assetPath, destPath))
            continue;
        ++copied;
    }

    if (marker.open(QIODevice::WriteOnly | QIODevice::Truncate | QIODevice::Text)) {
        QTextStream(&marker) << kShipVersion << '\n' << "files=" << copied << '\n';
        marker.close();
    }
    return destRoot;
}
