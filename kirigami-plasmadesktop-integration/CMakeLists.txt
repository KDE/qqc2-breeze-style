

set(org.kde.breeze_SRCS
    plasmadesktoptheme.cpp
    kirigamiplasmafactory.cpp
)


add_library(org.kde.breeze MODULE ${org.kde.breeze_SRCS})

target_link_libraries(org.kde.breeze
    PUBLIC
        Qt::Core
        KF5::Kirigami2
    PRIVATE
        Qt::Qml
        Qt::Quick
        KF5::GuiAddons
        KF5::ConfigWidgets
        KF5::IconThemes
)

if(NOT ANDROID)
    target_link_libraries(org.kde.breeze PRIVATE Qt::DBus)
endif()

install(TARGETS org.kde.breeze DESTINATION ${KDE_INSTALL_PLUGINDIR}/kf5/kirigami)

