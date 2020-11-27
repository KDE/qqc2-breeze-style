

set(org.kde.breeze_SRCS
    plasmadesktoptheme.cpp
    kirigamiplasmafactory.cpp
)


add_library(org.kde.breeze MODULE ${org.kde.breeze_SRCS})

target_link_libraries(org.kde.breeze
    PUBLIC
        Qt5::Core
        KF5::Kirigami2
    PRIVATE
        Qt5::DBus
        Qt5::Qml
        Qt5::Quick
        KF5::GuiAddons
        KF5::ConfigWidgets
        KF5::IconThemes
)

install(TARGETS org.kde.breeze DESTINATION ${KDE_INSTALL_PLUGINDIR}/kf5/kirigami)

