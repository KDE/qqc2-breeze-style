
set(org.kde.breeze_SRCS
    plasmadesktoptheme.cpp
    kirigamiplasmafactory.cpp
    units.cpp
)

add_library(org.kde.breeze MODULE ${org.kde.breeze_SRCS})

target_link_libraries(org.kde.breeze
    PUBLIC
        Qt::Core
        KF6::KirigamiPlatform
    PRIVATE
        Qt::Qml
        Qt::Quick
        KF6::GuiAddons
        KF6::ColorScheme
)

if(NOT ANDROID)
    target_link_libraries(org.kde.breeze PRIVATE Qt::DBus KF6::IconThemes)
else()
    set_target_properties(org.kde.breeze PROPERTIES OUTPUT_NAME libplugins_kf6_kirigami_platform_org.kde.breeze)
endif()

install(TARGETS org.kde.breeze DESTINATION ${KDE_INSTALL_PLUGINDIR}/kf6/kirigami/platform)

