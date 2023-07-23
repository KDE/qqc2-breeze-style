

set(org.kde.breeze_SRCS
    plasmadesktoptheme.cpp
    kirigamiplasmafactory.cpp
    units.cpp
)

kcoreaddons_add_plugin(org.kde.breeze SOURCES ${org.kde.breeze_SRCS} INSTALL_NAMESPACE "kf5/kirigami" JSON kirigamiplasmaintegration.json)

target_link_libraries(org.kde.breeze
    PUBLIC
        Qt::Core
        KF5::Kirigami2
    PRIVATE
        Qt::Qml
        Qt::Quick
        KF5::GuiAddons
        KF5::ConfigWidgets
)

if(NOT ANDROID)
    target_link_libraries(org.kde.breeze PRIVATE Qt::DBus KF5::IconThemes)
endif()

if(TARGET KF5::ColorScheme)
    target_link_libraries(org.kde.breeze PRIVATE KF5::ColorScheme)
endif()
