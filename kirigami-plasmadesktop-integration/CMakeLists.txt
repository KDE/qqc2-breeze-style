if (BUILD_SHARED_LIBS)
    add_library(org.kde.breeze MODULE)
else()
    add_library(org.kde.breeze)
endif()

target_sources(org.kde.breeze PRIVATE
    plasmadesktoptheme.cpp
    kirigamiplasmafactory.cpp
    units.cpp
)

target_link_libraries(org.kde.breeze
    PUBLIC
        Qt::Core
        KF6::KirigamiPlatform
    PRIVATE
        Qt::Qml
        Qt::Quick
        KF6::GuiAddons
        KF6::ColorScheme
        KF6::IconThemes
)

if(NOT ANDROID)
    target_link_libraries(org.kde.breeze PRIVATE Qt::DBus)
else()
    set_target_properties(org.kde.breeze PROPERTIES OUTPUT_NAME libplugins_kf6_kirigami_platform_org.kde.breeze)
endif()

if (NOT BUILD_SHARED_LIBS)
    target_compile_definitions(org.kde.breeze PRIVATE QT_STATICPLUGIN=1)
    set_target_properties(org.kde.breeze PROPERTIES QT_PLUGIN_CLASS_NAME KirigamiPlasmaFactory)
    __qt_internal_add_static_plugin_init_object_library(org.kde.breeze plugin_init_target)
    __qt_internal_propagate_object_library(org.kde.breeze "${plugin_init_target}")
endif()

install(TARGETS org.kde.breeze ${plugin_init_target} DESTINATION ${KDE_INSTALL_PLUGINDIR}/kf6/kirigami/platform EXPORT QQC2BreezeStyleTargets)

