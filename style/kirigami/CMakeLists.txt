project(qqc2breezestyle)

file(GLOB kirigamifiles
    RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}"
    CONFIGURE_DEPENDS
    "*.qml"
)
install(FILES ${kirigamifiles} DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/kirigami/styles/org.kde.breeze)
