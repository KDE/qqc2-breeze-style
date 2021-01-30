project(qqc2breezestyle)

set(qqc2breezestyle_SRCS
    qqc2breezestyleplugin.cpp
    impl/paintedsymbolitem.cpp
    impl/iconlabellayout.cpp
    impl/qquickicon.cpp
    impl/kcolorutilssingleton.cpp
)

#[[ I don't actually know if this would work.
ecm_qt_declare_logging_category(qqc2breezestyle_SRCS
    HEADER qqc2breezestyle_debug.h
    IDENTIFIER QQC2BreezeStyle_LOG
    CATEGORY_NAME org.kde.breeze
    DESCRIPTION "QQC2BreezeStyle"
    EXPORT QQC2BreezeStyle
)
]]

add_library(qqc2breezestyleplugin SHARED ${qqc2breezestyle_SRCS})
target_link_libraries(qqc2breezestyleplugin
    Qt::Core
    Qt::Gui
    Qt::Qml
    Qt::Quick
    Qt::QuickControls2
    Qt::QuickTemplates2
    KF5::ConfigCore
    KF5::Kirigami2
    KF5::GuiAddons
)

if(KF5ConfigWidgets_FOUND)
    target_link_libraries(qqc2breezestyleplugin
        KF5::ConfigWidgets
    )
endif()

add_subdirectory(impl)
add_subdirectory(qtquickcontrols)
add_subdirectory(kirigami)

install(TARGETS qqc2breezestyleplugin DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/breeze)
install(FILES qmldir DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/breeze)
