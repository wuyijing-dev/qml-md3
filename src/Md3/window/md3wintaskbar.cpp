#include "md3windowhelper.h"
#include "md3win_p.h"

#include <QCoreApplication>
#include <QDir>
#include <QImage>
#include <QPixmap>
#include <QScreen>
#include <QVariantMap>
#include <QWindow>

#include <cstring>

#if defined(Q_OS_WIN)
#  include <windows.h>
#endif

void Md3WindowHelper::flashTaskbar(QObject *window, bool flash)
{
#if defined(Q_OS_WIN)
    auto *qw = qobject_cast<QWindow *>(window);
    const HWND hwnd = md3HwndOf(qw);
    if (!hwnd)
        return;
    FLASHWINFO fi{};
    fi.cbSize = sizeof(fi);
    fi.hwnd = hwnd;
    fi.dwFlags = flash ? (FLASHW_ALL | FLASHW_TIMER | FLASHW_TRAY) : FLASHW_STOP;
    fi.uCount = flash ? 8 : 0;
    fi.dwTimeout = 0;
    FlashWindowEx(&fi);
#else
    Q_UNUSED(window);
    Q_UNUSED(flash);
#endif
}

bool Md3WindowHelper::setAppUserModelId(const QString &appId)
{
#if defined(Q_OS_WIN)
    if (appId.isEmpty())
        return false;
    const HRESULT hr = SetCurrentProcessExplicitAppUserModelID(
        reinterpret_cast<PCWSTR>(appId.utf16()));
    return SUCCEEDED(hr);
#else
    Q_UNUSED(appId);
    return false;
#endif
}

void Md3WindowHelper::setTaskbarProgress(QObject *window, qreal value, int state)
{
#if defined(Q_OS_WIN)
    auto *qw = qobject_cast<QWindow *>(window);
    const HWND hwnd = md3HwndOf(qw);
    ITaskbarList3 *tbl = md3TaskbarList3();
    if (!hwnd || !tbl)
        return;

    TBPFLAG flag = TBPF_NOPROGRESS;
    switch (state) {
    case ProgressIndeterminate: flag = TBPF_INDETERMINATE; break;
    case ProgressNormal: flag = TBPF_NORMAL; break;
    case ProgressError: flag = TBPF_ERROR; break;
    case ProgressPaused: flag = TBPF_PAUSED; break;
    case ProgressNoProgress:
    default: flag = TBPF_NOPROGRESS; break;
    }
    tbl->SetProgressState(hwnd, flag);
    if (flag == TBPF_NORMAL || flag == TBPF_ERROR || flag == TBPF_PAUSED) {
        const ULONGLONG completed = ULONGLONG(qBound(0.0, value, 1.0) * 1000.0);
        tbl->SetProgressValue(hwnd, completed, 1000);
    }
#else
    Q_UNUSED(window);
    Q_UNUSED(value);
    Q_UNUSED(state);
#endif
}

void Md3WindowHelper::clearTaskbarProgress(QObject *window)
{
    setTaskbarProgress(window, 0, ProgressNoProgress);
}

bool Md3WindowHelper::setTaskbarOverlayIcon(QObject *window, const QUrl &iconUrl,
                                            const QString &description)
{
#if defined(Q_OS_WIN)
    auto *qw = qobject_cast<QWindow *>(window);
    const HWND hwnd = md3HwndOf(qw);
    ITaskbarList3 *tbl = md3TaskbarList3();
    if (!hwnd || !tbl)
        return false;

    const QIcon icon = md3LoadIconMultiSize(iconUrl);
    if (icon.isNull())
        return false;
    const QPixmap pm = icon.pixmap(QSize(16, 16), qw->devicePixelRatio());
    HICON hIcon = md3CreateHIconFromImage(pm.toImage());
    if (!hIcon)
        return false;
    const HRESULT hr = tbl->SetOverlayIcon(hwnd, hIcon,
                                           description.isEmpty()
                                               ? nullptr
                                               : reinterpret_cast<LPCWSTR>(description.utf16()));
    DestroyIcon(hIcon);
    return SUCCEEDED(hr);
#else
    Q_UNUSED(window);
    Q_UNUSED(iconUrl);
    Q_UNUSED(description);
    return false;
#endif
}

void Md3WindowHelper::clearTaskbarOverlayIcon(QObject *window)
{
#if defined(Q_OS_WIN)
    auto *qw = qobject_cast<QWindow *>(window);
    const HWND hwnd = md3HwndOf(qw);
    ITaskbarList3 *tbl = md3TaskbarList3();
    if (!hwnd || !tbl)
        return;
    tbl->SetOverlayIcon(hwnd, nullptr, nullptr);
#else
    Q_UNUSED(window);
#endif
}

void Md3WindowHelper::setThumbnailClip(QObject *window, qreal x, qreal y, qreal w, qreal h)
{
#if defined(Q_OS_WIN)
    auto *qw = qobject_cast<QWindow *>(window);
    const HWND hwnd = md3HwndOf(qw);
    ITaskbarList3 *tbl = md3TaskbarList3();
    if (!hwnd || !tbl || !qw)
        return;
    const qreal dpr = qw->devicePixelRatio();
    RECT rc{};
    rc.left = LONG(qRound(x * dpr));
    rc.top = LONG(qRound(y * dpr));
    rc.right = LONG(qRound((x + w) * dpr));
    rc.bottom = LONG(qRound((y + h) * dpr));
    tbl->SetThumbnailClip(hwnd, &rc);
#else
    Q_UNUSED(window);
    Q_UNUSED(x);
    Q_UNUSED(y);
    Q_UNUSED(w);
    Q_UNUSED(h);
#endif
}

void Md3WindowHelper::clearThumbnailClip(QObject *window)
{
#if defined(Q_OS_WIN)
    auto *qw = qobject_cast<QWindow *>(window);
    const HWND hwnd = md3HwndOf(qw);
    ITaskbarList3 *tbl = md3TaskbarList3();
    if (!hwnd || !tbl)
        return;
    tbl->SetThumbnailClip(hwnd, nullptr);
#else
    Q_UNUSED(window);
#endif
}

void Md3WindowHelper::setThumbnailTooltip(QObject *window, const QString &text)
{
#if defined(Q_OS_WIN)
    auto *qw = qobject_cast<QWindow *>(window);
    const HWND hwnd = md3HwndOf(qw);
    ITaskbarList3 *tbl = md3TaskbarList3();
    if (!hwnd || !tbl)
        return;
    tbl->SetThumbnailTooltip(hwnd, text.isEmpty() ? nullptr
                                                  : reinterpret_cast<LPCWSTR>(text.utf16()));
#else
    Q_UNUSED(window);
    Q_UNUSED(text);
#endif
}

bool Md3WindowHelper::registerApplicationRestart(const QString &commandLineArgs)
{
#if defined(Q_OS_WIN)
    const HRESULT hr = RegisterApplicationRestart(
        commandLineArgs.isEmpty() ? nullptr
                                  : reinterpret_cast<PCWSTR>(commandLineArgs.utf16()),
        0);
    return SUCCEEDED(hr);
#else
    Q_UNUSED(commandLineArgs);
    return false;
#endif
}

void Md3WindowHelper::unregisterApplicationRestart()
{
#if defined(Q_OS_WIN)
    UnregisterApplicationRestart();
#endif
}

bool Md3WindowHelper::setJumpListTasks(const QVariantList &tasks)
{
#if defined(Q_OS_WIN)
    ICustomDestinationList *cdl = nullptr;
    if (FAILED(CoCreateInstance(CLSID_DestinationList, nullptr, CLSCTX_INPROC_SERVER,
                                IID_PPV_ARGS(&cdl)))
        || !cdl)
        return false;

    UINT maxSlots = 0;
    IObjectArray *removed = nullptr;
    if (FAILED(cdl->BeginList(&maxSlots, IID_PPV_ARGS(&removed)))) {
        cdl->Release();
        return false;
    }
    if (removed)
        removed->Release();

    IObjectCollection *collection = nullptr;
    if (FAILED(CoCreateInstance(CLSID_EnumerableObjectCollection, nullptr, CLSCTX_INPROC_SERVER,
                                IID_PPV_ARGS(&collection)))
        || !collection) {
        cdl->AbortList();
        cdl->Release();
        return false;
    }

    const QString exe = QCoreApplication::applicationFilePath();
    const QString exeNative = QDir::toNativeSeparators(exe);

    for (const QVariant &item : tasks) {
        const QVariantMap map = item.toMap();
        const QString title = map.value(QStringLiteral("title")).toString();
        if (title.isEmpty())
            continue;
        const QString args = map.value(QStringLiteral("arguments")).toString();
        const QString desc = map.value(QStringLiteral("description")).toString();

        IShellLinkW *link = nullptr;
        if (FAILED(CoCreateInstance(CLSID_ShellLink, nullptr, CLSCTX_INPROC_SERVER,
                                    IID_PPV_ARGS(&link)))
            || !link)
            continue;

        link->SetPath(reinterpret_cast<LPCWSTR>(exeNative.utf16()));
        if (!args.isEmpty())
            link->SetArguments(reinterpret_cast<LPCWSTR>(args.utf16()));
        if (!desc.isEmpty())
            link->SetDescription(reinterpret_cast<LPCWSTR>(desc.utf16()));

        const QString iconUrl = map.value(QStringLiteral("iconUrl")).toString();
        const int iconIndex = map.value(QStringLiteral("iconIndex"), 0).toInt();
        if (!iconUrl.isEmpty() && iconUrl.startsWith(QLatin1String("file:"))) {
            const QUrl u(iconUrl);
            link->SetIconLocation(reinterpret_cast<LPCWSTR>(u.toLocalFile().utf16()), iconIndex);
        } else {
            link->SetIconLocation(reinterpret_cast<LPCWSTR>(exeNative.utf16()), iconIndex);
        }

        IPropertyStore *store = nullptr;
        if (SUCCEEDED(link->QueryInterface(IID_PPV_ARGS(&store))) && store) {
            PROPVARIANT pv;
            if (SUCCEEDED(InitPropVariantFromString(reinterpret_cast<LPCWSTR>(title.utf16()), &pv))) {
                store->SetValue(PKEY_Title, pv);
                store->Commit();
                PropVariantClear(&pv);
            }
            store->Release();
        }
        collection->AddObject(link);
        link->Release();
    }

    IObjectArray *tasksArray = nullptr;
    bool ok = false;
    if (SUCCEEDED(collection->QueryInterface(IID_PPV_ARGS(&tasksArray))) && tasksArray) {
        ok = SUCCEEDED(cdl->AddUserTasks(tasksArray));
        tasksArray->Release();
    }
    collection->Release();
    if (ok)
        ok = SUCCEEDED(cdl->CommitList());
    else
        cdl->AbortList();
    cdl->Release();
    return ok;
#else
    Q_UNUSED(tasks);
    return false;
#endif
}

void Md3WindowHelper::clearJumpList()
{
#if defined(Q_OS_WIN)
    ICustomDestinationList *cdl = nullptr;
    if (SUCCEEDED(CoCreateInstance(CLSID_DestinationList, nullptr, CLSCTX_INPROC_SERVER,
                                   IID_PPV_ARGS(&cdl)))
        && cdl) {
        cdl->DeleteList(nullptr);
        cdl->Release();
    }
#endif
}

bool Md3WindowHelper::setThumbBarButtons(QObject *window, const QVariantList &buttons)
{
#if defined(Q_OS_WIN)
    auto *qw = qobject_cast<QWindow *>(window);
    const HWND hwnd = md3HwndOf(qw);
    ITaskbarList3 *tbl = md3TaskbarList3();
    if (!hwnd || !tbl)
        return false;

    clearThumbIcons();
    THUMBBUTTON thumbs[7]{};
    const int count = qMin(7, buttons.size());
    if (count <= 0) {
        clearThumbBarButtons(window);
        return true;
    }

    for (int i = 0; i < count; ++i) {
        const QVariantMap map = buttons.at(i).toMap();
        thumbs[i].dwMask = THB_ICON | THB_TOOLTIP | THB_FLAGS;
        thumbs[i].iId = map.value(QStringLiteral("id"), i + 1).toUInt();
        thumbs[i].dwFlags = THUMBBUTTONFLAGS(map.value(QStringLiteral("flags"), 0).toUInt());
        const QString tip = map.value(QStringLiteral("tooltip")).toString();
        const int tipLen = qMin(259, tip.size());
        if (tipLen > 0)
            memcpy(thumbs[i].szTip, tip.utf16(), size_t(tipLen) * sizeof(WCHAR));

        const QUrl iconUrl = map.value(QStringLiteral("icon")).toUrl();
        HICON hIcon = nullptr;
        if (iconUrl.isValid() && !iconUrl.isEmpty()) {
            const QIcon icon = md3LoadIconMultiSize(iconUrl);
            const QPixmap pm = icon.pixmap(QSize(16, 16), qw->devicePixelRatio());
            hIcon = md3CreateHIconFromImage(pm.toImage());
        }
        thumbs[i].hIcon = hIcon;
        if (hIcon)
            m_thumbIcons.append(hIcon);
    }

    HRESULT hr = tbl->ThumbBarAddButtons(hwnd, UINT(count), thumbs);
    if (FAILED(hr))
        hr = tbl->ThumbBarUpdateButtons(hwnd, UINT(count), thumbs);
    return SUCCEEDED(hr);
#else
    Q_UNUSED(window);
    Q_UNUSED(buttons);
    return false;
#endif
}

void Md3WindowHelper::clearThumbBarButtons(QObject *window)
{
#if defined(Q_OS_WIN)
    auto *qw = qobject_cast<QWindow *>(window);
    const HWND hwnd = md3HwndOf(qw);
    ITaskbarList3 *tbl = md3TaskbarList3();
    if (!hwnd || !tbl)
        return;
    THUMBBUTTON thumbs[7]{};
    for (int i = 0; i < 7; ++i) {
        thumbs[i].dwMask = THB_FLAGS;
        thumbs[i].iId = UINT(i + 1);
        thumbs[i].dwFlags = THBF_HIDDEN;
    }
    tbl->ThumbBarUpdateButtons(hwnd, 7, thumbs);
    clearThumbIcons();
#else
    Q_UNUSED(window);
#endif
}

void Md3WindowHelper::setForceIconicRepresentation(QObject *window, bool enabled)
{
#if defined(Q_OS_WIN)
    auto *qw = qobject_cast<QWindow *>(window);
    const HWND hwnd = md3HwndOf(qw);
    if (!hwnd)
        return;
    const BOOL v = enabled ? TRUE : FALSE;
    DwmSetWindowAttribute(hwnd, DWMWA_FORCE_ICONIC_REPRESENTATION, &v, sizeof(v));
    DwmSetWindowAttribute(hwnd, DWMWA_HAS_ICONIC_BITMAP, &v, sizeof(v));
#else
    Q_UNUSED(window);
    Q_UNUSED(enabled);
#endif
}

bool Md3WindowHelper::setIconicThumbnail(QObject *window, const QUrl &imageUrl)
{
#if defined(Q_OS_WIN)
    auto *qw = qobject_cast<QWindow *>(window);
    if (!qw)
        return false;
    m_iconicUrl = imageUrl;
    setForceIconicRepresentation(window, true);
    DwmInvalidateIconicBitmaps(md3HwndOf(qw));
    return true;
#else
    Q_UNUSED(window);
    Q_UNUSED(imageUrl);
    return false;
#endif
}

void Md3WindowHelper::clearIconicThumbnail(QObject *window)
{
#if defined(Q_OS_WIN)
    m_iconicUrl.clear();
    clearIconicBitmap();
    setForceIconicRepresentation(window, false);
#else
    Q_UNUSED(window);
#endif
}

#if defined(Q_OS_WIN)
void Md3WindowHelper::clearThumbIcons()
{
    for (void *p : m_thumbIcons) {
        if (p)
            DestroyIcon(static_cast<HICON>(p));
    }
    m_thumbIcons.clear();
}

void Md3WindowHelper::clearIconicBitmap()
{
    if (m_iconicBitmap) {
        DeleteObject(static_cast<HBITMAP>(m_iconicBitmap));
        m_iconicBitmap = nullptr;
    }
}

bool Md3WindowHelper::respondIconicThumbnail(void *hwndPtr, int width, int height)
{
    const HWND hwnd = static_cast<HWND>(hwndPtr);
    if (!hwnd || width <= 0 || height <= 0)
        return false;

    QImage img;
    if (!m_iconicUrl.isEmpty()) {
        const QIcon icon = md3LoadIconMultiSize(m_iconicUrl);
        img = icon.pixmap(QSize(width, height)).toImage();
    }
    if (img.isNull() && m_filter && m_filter->window) {
        const QPixmap grab = m_filter->window->screen()->grabWindow(m_filter->window->winId());
        img = grab.toImage().scaled(width, height, Qt::KeepAspectRatio, Qt::SmoothTransformation);
    }
    if (img.isNull())
        return false;

    HBITMAP hbmp = md3CreateHBitmapFromImage(img);
    if (!hbmp)
        return false;
    const HRESULT hr = DwmSetIconicThumbnail(hwnd, hbmp, 0);
    DeleteObject(hbmp);
    return SUCCEEDED(hr);
}

bool Md3WindowHelper::respondIconicLivePreview(void *hwndPtr)
{
    const HWND hwnd = static_cast<HWND>(hwndPtr);
    if (!hwnd || !m_filter || !m_filter->window)
        return false;
    const QPixmap grab = m_filter->window->screen()->grabWindow(m_filter->window->winId());
    HBITMAP hbmp = md3CreateHBitmapFromImage(grab.toImage());
    if (!hbmp)
        return false;
    const HRESULT hr = DwmSetIconicLivePreviewBitmap(hwnd, hbmp, nullptr, 0);
    DeleteObject(hbmp);
    return SUCCEEDED(hr);
}
#endif
