#include "md3windowhelper.h"
#include "md3win_p.h"

#include <QGuiApplication>
#include <QImage>
#include <QScreen>
#include <QWindow>

#if defined(Q_OS_WIN)
#  include <dwmapi.h>
#endif

void Md3WindowHelper::applyCornerPreference(QObject *window, bool rounded)
{
#if defined(Q_OS_WIN)
    auto *qw = qobject_cast<QWindow *>(window);
    const HWND hwnd = md3HwndOf(qw);
    if (!hwnd)
        return;
    const int pref = rounded ? DWMWCP_ROUND : DWMWCP_DONOTROUND;
    DwmSetWindowAttribute(hwnd, DWMWA_WINDOW_CORNER_PREFERENCE, &pref, sizeof(pref));
#else
    Q_UNUSED(window);
    Q_UNUSED(rounded);
#endif
}

void Md3WindowHelper::showSystemMenu(QObject *window, qreal globalX, qreal globalY)
{
#if defined(Q_OS_WIN)
    auto *qw = qobject_cast<QWindow *>(window);
    const HWND hwnd = md3HwndOf(qw);
    if (!hwnd)
        return;

    md3UpdateSystemMenuState(hwnd);
    const HMENU menu = GetSystemMenu(hwnd, FALSE);
    if (!menu)
        return;

    const int x = qRound(globalX);
    const int y = qRound(globalY);
    const UINT cmd = TrackPopupMenu(menu,
                                    TPM_RETURNCMD | TPM_LEFTBUTTON | TPM_RIGHTBUTTON,
                                    x, y, 0, hwnd, nullptr);
    if (cmd)
        PostMessageW(hwnd, WM_SYSCOMMAND, cmd, 0);
#else
    Q_UNUSED(window);
    Q_UNUSED(globalX);
    Q_UNUSED(globalY);
#endif
}

void Md3WindowHelper::setImmersiveDarkMode(QObject *window, bool dark)
{
#if defined(Q_OS_WIN)
    auto *qw = qobject_cast<QWindow *>(window);
    const HWND hwnd = md3HwndOf(qw);
    if (!hwnd)
        return;
    const BOOL useDark = dark ? TRUE : FALSE;
    DwmSetWindowAttribute(hwnd, DWMWA_USE_IMMERSIVE_DARK_MODE, &useDark, sizeof(useDark));
#else
    Q_UNUSED(window);
    Q_UNUSED(dark);
#endif
}

void Md3WindowHelper::setSystemBackdrop(QObject *window, int backdrop)
{
#if defined(Q_OS_WIN)
    auto *qw = qobject_cast<QWindow *>(window);
    const HWND hwnd = md3HwndOf(qw);
    if (!hwnd)
        return;

    md3EnsureWinChromeStyles(qw);

    int type = DWMSBT_NONE;
    switch (backdrop) {
    case BackdropAuto: type = DWMSBT_AUTO; break;
    case BackdropMica: type = DWMSBT_MAINWINDOW; break;
    case BackdropAcrylic: type = DWMSBT_TRANSIENTWINDOW; break;
    case BackdropTabbed: type = DWMSBT_TABBEDWINDOW; break;
    case BackdropNone:
    default: type = DWMSBT_NONE; break;
    }

    const BOOL alpha = TRUE;
    DwmSetWindowAttribute(hwnd, DWMWA_REDIRECTIONBITMAP_ALPHA, &alpha, sizeof(alpha));

    if (type != DWMSBT_NONE) {
        const MARGINS margins{ -1, -1, -1, -1 };
        DwmExtendFrameIntoClientArea(hwnd, &margins);
        const COLORREF noColor = DWMWA_COLOR_NONE;
        DwmSetWindowAttribute(hwnd, DWMWA_CAPTION_COLOR, &noColor, sizeof(noColor));
    } else {
        const MARGINS margins{ 0, 0, 0, 0 };
        DwmExtendFrameIntoClientArea(hwnd, &margins);
    }
    DwmSetWindowAttribute(hwnd, DWMWA_SYSTEMBACKDROP_TYPE, &type, sizeof(type));

    SetWindowPos(hwnd, nullptr, 0, 0, 0, 0,
                 SWP_FRAMECHANGED | SWP_NOMOVE | SWP_NOSIZE | SWP_NOZORDER | SWP_NOOWNERZORDER
                     | SWP_NOACTIVATE);
#else
    Q_UNUSED(window);
    Q_UNUSED(backdrop);
#endif
}

void Md3WindowHelper::setBorderColor(QObject *window, const QString &cssColor)
{
#if defined(Q_OS_WIN)
    auto *qw = qobject_cast<QWindow *>(window);
    const HWND hwnd = md3HwndOf(qw);
    if (!hwnd)
        return;

    COLORREF color = DWMWA_COLOR_DEFAULT;
    if (cssColor.trimmed().isEmpty()
        || cssColor.compare(QLatin1String("default"), Qt::CaseInsensitive) == 0) {
        color = DWMWA_COLOR_DEFAULT;
    } else if (cssColor.compare(QLatin1String("none"), Qt::CaseInsensitive) == 0) {
        color = DWMWA_COLOR_NONE;
    } else {
        bool ok = false;
        color = md3ParseCssColor(cssColor, &ok);
        if (!ok)
            color = DWMWA_COLOR_DEFAULT;
    }
    DwmSetWindowAttribute(hwnd, DWMWA_BORDER_COLOR, &color, sizeof(color));
#else
    Q_UNUSED(window);
    Q_UNUSED(cssColor);
#endif
}

void Md3WindowHelper::setCaptionTextColor(QObject *window, const QString &cssColor)
{
#if defined(Q_OS_WIN)
    auto *qw = qobject_cast<QWindow *>(window);
    const HWND hwnd = md3HwndOf(qw);
    if (!hwnd)
        return;
    COLORREF color = DWMWA_COLOR_DEFAULT;
    if (cssColor.trimmed().isEmpty()
        || cssColor.compare(QLatin1String("default"), Qt::CaseInsensitive) == 0) {
        color = DWMWA_COLOR_DEFAULT;
    } else if (cssColor.compare(QLatin1String("none"), Qt::CaseInsensitive) == 0) {
        color = DWMWA_COLOR_NONE;
    } else {
        bool ok = false;
        color = md3ParseCssColor(cssColor, &ok);
        if (!ok)
            color = DWMWA_COLOR_DEFAULT;
    }
    DwmSetWindowAttribute(hwnd, DWMWA_TEXT_COLOR, &color, sizeof(color));
#else
    Q_UNUSED(window);
    Q_UNUSED(cssColor);
#endif
}

void Md3WindowHelper::setExcludedFromPeek(QObject *window, bool excluded)
{
#if defined(Q_OS_WIN)
    auto *qw = qobject_cast<QWindow *>(window);
    const HWND hwnd = md3HwndOf(qw);
    if (!hwnd)
        return;
    const BOOL v = excluded ? TRUE : FALSE;
    DwmSetWindowAttribute(hwnd, DWMWA_EXCLUDED_FROM_PEEK, &v, sizeof(v));
#else
    Q_UNUSED(window);
    Q_UNUSED(excluded);
#endif
}

void Md3WindowHelper::setDisallowPeek(QObject *window, bool disallow)
{
#if defined(Q_OS_WIN)
    auto *qw = qobject_cast<QWindow *>(window);
    const HWND hwnd = md3HwndOf(qw);
    if (!hwnd)
        return;
    const BOOL v = disallow ? TRUE : FALSE;
    DwmSetWindowAttribute(hwnd, DWMWA_DISALLOW_PEEK, &v, sizeof(v));
#else
    Q_UNUSED(window);
    Q_UNUSED(disallow);
#endif
}

void Md3WindowHelper::setExcludeFromCapture(QObject *window, bool exclude)
{
#if defined(Q_OS_WIN)
    auto *qw = qobject_cast<QWindow *>(window);
    const HWND hwnd = md3HwndOf(qw);
    if (!hwnd)
        return;
    SetWindowDisplayAffinity(hwnd, exclude ? WDA_EXCLUDEFROMCAPTURE : WDA_NONE);
#else
    Q_UNUSED(window);
    Q_UNUSED(exclude);
#endif
}

void Md3WindowHelper::setAlwaysOnTop(QObject *window, bool onTop)
{
    auto *qw = qobject_cast<QWindow *>(window);
    if (!qw)
        return;
#if defined(Q_OS_WIN)
    const HWND hwnd = md3HwndOf(qw);
    if (!hwnd)
        return;
    SetWindowPos(hwnd, onTop ? HWND_TOPMOST : HWND_NOTOPMOST, 0, 0, 0, 0,
                 SWP_NOMOVE | SWP_NOSIZE | SWP_NOACTIVATE);
#else
    qw->setFlag(Qt::WindowStaysOnTopHint, onTop);
#endif
}

void Md3WindowHelper::setWindowCloaked(QObject *window, bool cloaked)
{
#if defined(Q_OS_WIN)
    auto *qw = qobject_cast<QWindow *>(window);
    const HWND hwnd = md3HwndOf(qw);
    if (!hwnd)
        return;
    const BOOL v = cloaked ? TRUE : FALSE;
    DwmSetWindowAttribute(hwnd, DWMWA_CLOAK, &v, sizeof(v));
#else
    Q_UNUSED(window);
    Q_UNUSED(cloaked);
#endif
}

void Md3WindowHelper::setPreferredAppMode(bool dark)
{
#if defined(Q_OS_WIN)
    // Undocumented uxtheme API used by Win10/11 dark-mode aware apps
    enum PreferredAppMode { Default = 0, AllowDark = 1, ForceDark = 2, ForceLight = 3 };
    using SetPreferredAppModeFn = PreferredAppMode (WINAPI *)(PreferredAppMode);
    if (HMODULE ux = LoadLibraryW(L"uxtheme.dll")) {
        // ordinal 135 on Win10 1809+
        auto fn = reinterpret_cast<SetPreferredAppModeFn>(GetProcAddress(ux, MAKEINTRESOURCEA(135)));
        if (fn)
            fn(dark ? ForceDark : ForceLight);
        // Flush theme so menus/dialogs pick it up
        using FlushFn = void (WINAPI *)();
        if (auto flush = reinterpret_cast<FlushFn>(GetProcAddress(ux, MAKEINTRESOURCEA(136))))
            flush();
    }
#else
    Q_UNUSED(dark);
#endif
}

QString Md3WindowHelper::systemAccentColor() const
{
#if defined(Q_OS_WIN)
    DWORD colorization = 0;
    BOOL opaque = FALSE;
    if (SUCCEEDED(DwmGetColorizationColor(&colorization, &opaque))) {
        const int r = int((colorization >> 16) & 0xFF);
        const int g = int((colorization >> 8) & 0xFF);
        const int b = int(colorization & 0xFF);
        return QStringLiteral("#%1%2%3")
            .arg(r, 2, 16, QLatin1Char('0'))
            .arg(g, 2, 16, QLatin1Char('0'))
            .arg(b, 2, 16, QLatin1Char('0'));
    }
    const COLORREF hi = GetSysColor(COLOR_HIGHLIGHT);
    return QStringLiteral("#%1%2%3")
        .arg(GetRValue(hi), 2, 16, QLatin1Char('0'))
        .arg(GetGValue(hi), 2, 16, QLatin1Char('0'))
        .arg(GetBValue(hi), 2, 16, QLatin1Char('0'));
#else
    return QStringLiteral("#6750A4");
#endif
}

QString Md3WindowHelper::wallpaperSeedColor() const
{
#if defined(Q_OS_WIN)
    wchar_t path[MAX_PATH] = {};
    DWORD type = 0;
    DWORD cb = sizeof(path);
    if (RegGetValueW(HKEY_CURRENT_USER, L"Control Panel\\Desktop", L"WallPaper",
                     RRF_RT_REG_SZ, &type, path, &cb) != ERROR_SUCCESS
        || path[0] == 0) {
        return systemAccentColor();
    }

    QImage img(QString::fromWCharArray(path));
    if (img.isNull())
        return systemAccentColor();

    img = img.scaled(32, 32, Qt::IgnoreAspectRatio, Qt::SmoothTransformation)
              .convertToFormat(QImage::Format_ARGB32);
    qint64 rSum = 0, gSum = 0, bSum = 0, n = 0;
    for (int y = 0; y < img.height(); ++y) {
        const QRgb *line = reinterpret_cast<const QRgb *>(img.constScanLine(y));
        for (int x = 0; x < img.width(); ++x) {
            const QRgb px = line[x];
            if (qAlpha(px) < 32)
                continue;
            rSum += qRed(px);
            gSum += qGreen(px);
            bSum += qBlue(px);
            ++n;
        }
    }
    if (n <= 0)
        return systemAccentColor();
    const int r = int(rSum / n);
    const int g = int(gSum / n);
    const int b = int(bSum / n);
    return QStringLiteral("#%1%2%3")
        .arg(r, 2, 16, QLatin1Char('0'))
        .arg(g, 2, 16, QLatin1Char('0'))
        .arg(b, 2, 16, QLatin1Char('0'));
#else
    return systemAccentColor();
#endif
}

int Md3WindowHelper::monitorCount() const
{
    return QGuiApplication::screens().size();
}

bool Md3WindowHelper::moveToMonitor(QObject *window, int monitorIndex)
{
    auto *qw = qobject_cast<QWindow *>(window);
    const QList<QScreen *> screens = QGuiApplication::screens();
    if (!qw || monitorIndex < 0 || monitorIndex >= screens.size())
        return false;
    QScreen *screen = screens.at(monitorIndex);
    if (!screen)
        return false;
    const QRect avail = screen->availableGeometry();
    const int w = qw->width() > 0 ? qw->width() : 800;
    const int h = qw->height() > 0 ? qw->height() : 600;
    qw->setScreen(screen);
    qw->setPosition(avail.x() + (avail.width() - w) / 2,
                    avail.y() + (avail.height() - h) / 2);
    return true;
}
