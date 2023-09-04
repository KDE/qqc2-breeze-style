ecm_add_qml_module(qqc2breezestyleplugin URI "org.kde.breeze" CLASSNAME QQC2BreezeStylePlugin)
ecm_add_qml_module_dependencies(qqc2breezestyleplugin
DEPENDS
    "QtQuick.Controls 2.15"
    "org.kde.kirigami 2.14"
)

add_subdirectory(impl)
add_subdirectory(qtquickcontrols)
add_subdirectory(kirigami)

ecm_finalize_qml_module(qqc2breezestyleplugin DESTINATION ${KDE_INSTALL_QMLDIR})

if(ANDROID)
    install(FILES BreezeLight.colors BreezeDark.colors DESTINATION ${KDE_INSTALL_DATADIR}/color-schemes)
endif()
