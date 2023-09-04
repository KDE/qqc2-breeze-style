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
target_link_libraries(qqc2breezestyleplugin PRIVATE
    Qt::Core
    Qt::Gui
    Qt::Qml
    Qt::Quick
    Qt::QuickControls2
    Qt::QuickTemplates2
    KF6::ConfigCore
    KF6::Kirigami2
    KF6::GuiAddons
)

add_subdirectory(impl)
add_subdirectory(qtquickcontrols)
add_subdirectory(kirigami)

ecm_finalize_qml_module(qqc2breezestyleplugin DESTINATION ${KDE_INSTALL_QMLDIR})

if(ANDROID)
    install(FILES BreezeLight.colors BreezeDark.colors DESTINATION ${KDE_INSTALL_DATADIR}/color-schemes)
endif()
