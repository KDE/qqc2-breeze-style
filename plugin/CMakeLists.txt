project(qqc2breezestyle)

set(qqc2breezestyle_SRCS
    qqc2breezestyleplugin.cpp
    )

add_library(qqc2breezestyleplugin SHARED ${qqc2breezestyle_SRCS})
target_link_libraries(qqc2breezestyleplugin Qt5::Core Qt5::Qml Qt5::Quick Qt5::Gui KF5::ConfigCore KF5::Kirigami2)

if(KF5ConfigWidgets_FOUND)
    target_link_libraries(qqc2breezestyleplugin
        KF5::ConfigWidgets
    )
endif()

install(TARGETS qqc2breezestyleplugin DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/qqc2breezestyle)
install(FILES qmldir DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/qqc2breezestyle)
