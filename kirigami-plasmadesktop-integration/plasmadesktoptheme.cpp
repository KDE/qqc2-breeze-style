/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
    SPDX-FileCopyrightText: 2021 Arjen Hiemstra <ahiemstra@heimr.nl>
    SPDX-License-Identifier: LGPL-2.0-or-later
*/

#include "plasmadesktoptheme.h"
#include <KColorScheme>
#include <KColorUtils>
#include <KConfigGroup>
#include <KIconLoader>
#include <QDBusConnection>
#include <QDebug>
#include <QGuiApplication>
#include <QPalette>
#include <QQmlContext>
#include <QQmlEngine>
#include <QQuickRenderControl>
#include <QQuickWindow>

class IconLoaderSingleton
{
public:
    IconLoaderSingleton() = default;

    KIconLoader self;
};

Q_GLOBAL_STATIC(IconLoaderSingleton, privateIconLoaderSelf)

class StyleSingleton : public QObject
{
    Q_OBJECT

public:
    struct Colors {
        QPalette palette;
        KColorScheme selectionScheme;
        KColorScheme scheme;
    };

    explicit StyleSingleton()
        : QObject()
        , buttonScheme(QPalette::Active, KColorScheme::ColorSet::Button)
    {
        connect(qGuiApp, &QGuiApplication::paletteChanged, this, &StyleSingleton::refresh);

        // Use DBus in order to listen for kdeglobals changes directly, as the
        // QApplication doesn't expose the font variants we're looking for,
        // namely smallFont.
        QDBusConnection::sessionBus().connect(QString(),
                                              QStringLiteral("/KGlobalSettings"),
                                              QStringLiteral("org.kde.KGlobalSettings"),
                                              QStringLiteral("notifyChange"),
                                              this,
                                              SLOT(notifyWatchersConfigurationChange()));

        connect(qGuiApp, &QGuiApplication::fontDatabaseChanged, this, &StyleSingleton::notifyWatchersConfigurationChange);

        /* QtTextRendering uses less memory, so use it in low power mode.
         *
         * For scale factors greater than 2, native rendering doesn't actually do much.
         * Does native rendering even work when scaleFactor >= 2?
         *
         * NativeTextRendering is still distorted sometimes with fractional scale
         * factors, despite https://bugreports.qt.io/browse/QTBUG-67007 being closed.
         * 1.5x scaling looks generally OK, but there are occasional and difficult to
         * reproduce issues with all fractional scale factors.
         */
        qreal devicePixelRatio = qGuiApp->devicePixelRatio();
        QQuickWindow::TextRenderType defaultTextRenderType = (int(devicePixelRatio) == devicePixelRatio //
                                                                  ? QQuickWindow::NativeTextRendering
                                                                  : QQuickWindow::QtTextRendering);

        // Allow setting the text rendering type with an environment variable
        QByteArrayList validInputs = {"qttextrendering", "qtrendering", "nativetextrendering", "nativerendering"};
        QByteArray input = qgetenv("QT_QUICK_DEFAULT_TEXT_RENDER_TYPE").toLower();
        if (validInputs.contains(input)) {
            if (input == validInputs[0] || input == validInputs[1]) {
                defaultTextRenderType = QQuickWindow::QtTextRendering;
            } else {
                defaultTextRenderType = QQuickWindow::NativeTextRendering;
            }
        }

        QQuickWindow::setTextRenderType(defaultTextRenderType);
    }

    void refresh()
    {
        m_cache.clear();
        buttonScheme = KColorScheme(QPalette::Active, KColorScheme::ColorSet::Button);

        notifyWatchersPaletteChange();
    }

    Colors loadColors(Kirigami::PlatformTheme::ColorSet cs, QPalette::ColorGroup group)
    {
        const auto key = qMakePair(cs, group);
        auto it = m_cache.constFind(key);
        if (it != m_cache.constEnd())
            return *it;

        using Kirigami::PlatformTheme;

        KColorScheme::ColorSet set;

        switch (cs) {
        case PlatformTheme::Button:
            set = KColorScheme::ColorSet::Button;
            break;
        case PlatformTheme::Selection:
            set = KColorScheme::ColorSet::Selection;
            break;
        case PlatformTheme::Tooltip:
            set = KColorScheme::ColorSet::Tooltip;
            break;
        case PlatformTheme::View:
            set = KColorScheme::ColorSet::View;
            break;
        case PlatformTheme::Complementary:
            set = KColorScheme::ColorSet::Complementary;
            break;
        case PlatformTheme::Header:
            set = KColorScheme::ColorSet::Header;
            break;
        case PlatformTheme::Window:
        default:
            set = KColorScheme::ColorSet::Window;
        }

        // HACK/FIXME: Working around the fact that KColorScheme changes the selection background color when inactive by default.
        // Yes, this is horrible.
        QPalette::ColorGroup selectionGroup = group == QPalette::Inactive ? QPalette::Active : group;
        Colors ret = {{}, KColorScheme(selectionGroup, KColorScheme::ColorSet::Selection), KColorScheme(group, set)};

        QPalette pal;
        for (auto state : {QPalette::Active, QPalette::Inactive, QPalette::Disabled}) {
            pal.setBrush(state, QPalette::WindowText, ret.scheme.foreground());
            pal.setBrush(state, QPalette::Window, ret.scheme.background());
            pal.setBrush(state, QPalette::Base, ret.scheme.background());
            pal.setBrush(state, QPalette::Text, ret.scheme.foreground());
            pal.setBrush(state, QPalette::Button, ret.scheme.background());
            pal.setBrush(state, QPalette::ButtonText, ret.scheme.foreground());
            pal.setBrush(state, QPalette::Highlight, ret.selectionScheme.background());
            pal.setBrush(state, QPalette::HighlightedText, ret.selectionScheme.foreground());
            pal.setBrush(state, QPalette::ToolTipBase, ret.scheme.background());
            pal.setBrush(state, QPalette::ToolTipText, ret.scheme.foreground());

            pal.setColor(state, QPalette::Light, ret.scheme.shade(KColorScheme::LightShade));
            pal.setColor(state, QPalette::Midlight, ret.scheme.shade(KColorScheme::MidlightShade));
            pal.setColor(state, QPalette::Mid, ret.scheme.shade(KColorScheme::MidShade));
            pal.setColor(state, QPalette::Dark, ret.scheme.shade(KColorScheme::DarkShade));
            pal.setColor(state, QPalette::Shadow, QColor(0, 0, 0, 51 /* 20% */)); // ret.scheme.shade(KColorScheme::ShadowShade));

            pal.setBrush(state, QPalette::AlternateBase, ret.scheme.background(KColorScheme::AlternateBackground));
            pal.setBrush(state, QPalette::Link, ret.scheme.foreground(KColorScheme::LinkText));
            pal.setBrush(state, QPalette::LinkVisited, ret.scheme.foreground(KColorScheme::VisitedText));

            pal.setBrush(state, QPalette::PlaceholderText, ret.scheme.foreground(KColorScheme::InactiveText));
            pal.setBrush(state,
                         QPalette::BrightText,
                         KColorUtils::hcyColor(KColorUtils::hue(pal.buttonText().color()),
                                               KColorUtils::chroma(pal.buttonText().color()),
                                               1 - KColorUtils::luma(pal.buttonText().color())));
        }
        ret.palette = pal;
        m_cache.insert(key, ret);
        return ret;
    }

    void notifyWatchersPaletteChange()
    {
        for (auto watcher : qAsConst(watchers)) {
            watcher->syncColors();
        }
    }

    Q_SLOT void notifyWatchersConfigurationChange()
    {
        for (auto watcher : qAsConst(watchers)) {
            watcher->syncFont();
        }
    }

    KColorScheme buttonScheme;

    QVector<QPointer<PlasmaDesktopTheme>> watchers;

private:
    QHash<QPair<Kirigami::PlatformTheme::ColorSet, QPalette::ColorGroup>, Colors> m_cache;
};
Q_GLOBAL_STATIC_WITH_ARGS(QScopedPointer<StyleSingleton>, s_style, (new StyleSingleton))

PlasmaDesktopTheme::PlasmaDesktopTheme(QObject *parent)
    : PlatformTheme(parent)
{
    // TODO: MOVE THIS SOMEWHERE ELSE
    m_lowPowerHardware = QByteArrayList{"1", "true"}.contains(qgetenv("KIRIGAMI_LOWPOWER_HARDWARE").toLower());

    setSupportsIconColoring(true);

    auto parentItem = qobject_cast<QQuickItem *>(parent);
    if (parentItem) {
        connect(parentItem, &QQuickItem::enabledChanged, this, &PlasmaDesktopTheme::syncColors);
        connect(parentItem, &QQuickItem::windowChanged, this, &PlasmaDesktopTheme::syncWindow);
    }

    (*s_style)->watchers.append(this);

    syncFont();
    syncWindow();
    syncColors();
}

PlasmaDesktopTheme::~PlasmaDesktopTheme()
{
    (*s_style)->watchers.removeOne(this);
}

void PlasmaDesktopTheme::syncWindow()
{
    if (m_window) {
        disconnect(m_window.data(), &QWindow::activeChanged, this, &PlasmaDesktopTheme::syncColors);
    }

    QWindow *window = nullptr;

    auto parentItem = qobject_cast<QQuickItem *>(parent());
    if (parentItem) {
        QQuickWindow *qw = parentItem->window();

        window = QQuickRenderControl::renderWindowFor(qw);
        if (!window) {
            window = qw;
        }
        if (qw) {
            connect(qw, &QQuickWindow::sceneGraphInitialized, this, &PlasmaDesktopTheme::syncWindow);
        }
    }
    m_window = window;

    if (window) {
        connect(m_window.data(), &QWindow::activeChanged, this, &PlasmaDesktopTheme::syncColors);
        syncColors();
    }
}

void PlasmaDesktopTheme::syncFont()
{
    KSharedConfigPtr ptr = KSharedConfig::openConfig();
    KConfigGroup general(ptr->group("general"));
    setSmallFont(general.readEntry("smallestReadableFont", []() {
        auto smallFont = qApp->font();
        if (smallFont.pixelSize() != -1) {
            smallFont.setPixelSize(smallFont.pixelSize() - 2);
        } else {
            smallFont.setPointSize(smallFont.pointSize() - 2);
        }
        return smallFont;
    }()));

    setDefaultFont(qGuiApp->font());
}

QIcon PlasmaDesktopTheme::iconFromTheme(const QString &name, const QColor &customColor)
{
    QPalette pal = palette();
    if (customColor != Qt::transparent) {
        for (auto state : {QPalette::Active, QPalette::Inactive, QPalette::Disabled}) {
            pal.setBrush(state, QPalette::WindowText, customColor);
        }
    }

    privateIconLoaderSelf->self.setCustomPalette(pal);

    return KDE::icon(name, &privateIconLoaderSelf->self);
}

void PlasmaDesktopTheme::syncColors()
{
    QPalette::ColorGroup group = (QPalette::ColorGroup)colorGroup();
    auto parentItem = qobject_cast<QQuickItem *>(parent());
    if (parentItem) {
        if (!parentItem->isEnabled()) {
            group = QPalette::Disabled;
        } else if (m_window && !m_window->isActive() && m_window->isExposed()) {
            // Why also checking the window is exposed?
            // in the case of QQuickWidget the window() will never be active
            // and the widgets will always have the inactive palette.
            // better to always show it active than always show it inactive
            group = QPalette::Inactive;
        }
    }

    const auto colors = (*s_style)->loadColors(colorSet(), group);

    // foreground
    setTextColor(colors.scheme.foreground(KColorScheme::NormalText).color());
    setDisabledTextColor(colors.scheme.foreground(KColorScheme::InactiveText).color());
    setHighlightedTextColor(colors.selectionScheme.foreground(KColorScheme::NormalText).color());
    setActiveTextColor(colors.scheme.foreground(KColorScheme::ActiveText).color());
    setLinkColor(colors.scheme.foreground(KColorScheme::LinkText).color());
    setVisitedLinkColor(colors.scheme.foreground(KColorScheme::VisitedText).color());
    setNegativeTextColor(colors.scheme.foreground(KColorScheme::NegativeText).color());
    setNeutralTextColor(colors.scheme.foreground(KColorScheme::NeutralText).color());
    setPositiveTextColor(colors.scheme.foreground(KColorScheme::PositiveText).color());

    // background
    setHighlightColor(colors.selectionScheme.background(KColorScheme::NormalBackground).color());
    setBackgroundColor(colors.scheme.background(KColorScheme::NormalBackground).color());

    // HACK: It's awful, but people sometimes complain about their color scheme not working well with the theme.
    // This is because I'm using colors that weren't used before and lots of themes have bad colors for previously unused colors.
    QColor alternateBackgroundOriginalColor = colors.scheme.background(KColorScheme::AlternateBackground).color();
    // #bdc3c7 is the old default for the Breeze color scheme.
    // #4d4d4d is the old default for the Breeze Dark color scheme.
    // Most color schemes use one of these 2 colors.
    if (colorSet() == ColorSet::Button && (alternateBackgroundOriginalColor == QColor("#bdc3c7") || alternateBackgroundOriginalColor == QColor("#4d4d4d"))) {
        setAlternateBackgroundColor(KColorUtils::tint(backgroundColor(), highlightColor(), 0.4));
    } else {
        setAlternateBackgroundColor(alternateBackgroundOriginalColor);
    }
    setActiveBackgroundColor(colors.scheme.background(KColorScheme::ActiveBackground).color());
    setLinkBackgroundColor(colors.scheme.background(KColorScheme::LinkBackground).color());
    setVisitedLinkBackgroundColor(colors.scheme.background(KColorScheme::VisitedBackground).color());
    setNegativeBackgroundColor(colors.scheme.background(KColorScheme::NegativeBackground).color());
    setNeutralBackgroundColor(colors.scheme.background(KColorScheme::NeutralBackground).color());
    setPositiveBackgroundColor(colors.scheme.background(KColorScheme::PositiveBackground).color());

    // decoration
    setHoverColor(colors.scheme.decoration(KColorScheme::HoverColor).color());
    setFocusColor(colors.scheme.decoration(KColorScheme::FocusColor).color());

    // Breeze QQC2 style colors
    const QColor &buttonTextColor = (*s_style)->buttonScheme.foreground(KColorScheme::NormalText).color();
    const QColor &buttonBackgroundColor = (*s_style)->buttonScheme.background(KColorScheme::NormalBackground).color();
    auto separatorColor = [](const QColor &bg, const QColor &fg, const qreal baseRatio = 0.2) {
        return KColorUtils::luma(bg) > 0.5 ? KColorUtils::mix(bg, fg, baseRatio) : KColorUtils::mix(bg, fg, baseRatio / 2);
    };

    m_buttonSeparatorColor = separatorColor(buttonBackgroundColor, buttonTextColor, 0.3);

    switch (colorSet()) {
        // case ColorSet::View:
        // case ColorSet::Window:
    case ColorSet::Button:
        m_separatorColor = m_buttonSeparatorColor;
        break;
    case ColorSet::Selection:
        m_separatorColor = focusColor();
        break;
        // case ColorSet::Tooltip:
        // case ColorSet::Complementary:
        // case ColorSet::Header:
    default:
        m_separatorColor = separatorColor(backgroundColor(), textColor());
    }
}

bool PlasmaDesktopTheme::event(QEvent *event)
{
    if (event->type() == Kirigami::PlatformThemeEvents::DataChangedEvent::type) {
        syncFont();
        syncColors();
    }

    if (event->type() == Kirigami::PlatformThemeEvents::ColorSetChangedEvent::type) {
        syncColors();
    }

    if (event->type() == Kirigami::PlatformThemeEvents::ColorGroupChangedEvent::type) {
        syncColors();
    }

    return PlatformTheme::event(event);
}

// Breeze QQC2 style colors
QColor PlasmaDesktopTheme::separatorColor() const
{
    return m_separatorColor;
}

QColor PlasmaDesktopTheme::buttonSeparatorColor() const
{
    return m_buttonSeparatorColor;
}

bool PlasmaDesktopTheme::lowPowerHardware() const
{
    return m_lowPowerHardware;
}

#include "plasmadesktoptheme.moc"
