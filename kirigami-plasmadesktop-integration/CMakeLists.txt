
set(org.kde.breeze_SRCS
    plasmadesktoptheme.cpp
    kirigamiplasmafactory.cpp
    units.cpp
)

add_library(org.kde.breeze MODULE ${org.kde.breeze_SRCS})

target_link_libraries(org.kde.breeze
    PUBLIC
        Qt::Core
        KF6::Kirigami2
    PRIVATE
        Qt::Qml
        Qt::Quick
        KF6::GuiAddons
        KF6::ColorScheme
)

if(NOT ANDROID)
    target_link_libraries(org.kde.breeze PRIVATE Qt::DBus KF6::IconThemes)
endif()

install(TARGETS org.kde.breeze DESTINATION ${KDE_INSTALL_PLUGINDIR}/kf6/kirigami)

