project(qqc2breezestyle)

ecm_add_qml_module(qqc2breezestyleplugin URI "org.kde.breeze" CLASSNAME QQC2BreezeStylePlugin)
ecm_add_qml_module_dependencies(qqc2breezestyleplugin
DEPENDS
    "QtQuick.Controls 2.15"
    "org.kde.kirigami 2.14"
)
target_sources(qqc2breezestyleplugin PRIVATE
    qqc2breezestyleplugin.cpp
    impl/paintedsymbolitem.cpp
    impl/iconlabellayout.cpp
    impl/qquickicon.cpp
    impl/kcolorutilssingleton.cpp
    impl/breezedial.cpp
)
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

ecm_finalize_qml_module(qqc2breezestyleplugin DESTINATION ${KDE_INSTALL_QMLDIR})
