file(GLOB qmlfiles
    RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}"
    CONFIGURE_DEPENDS
    "*.qml"
)
install(FILES qmldir DESTINATION ${KDE_INSTALL_QMLDIR}/QtQuick/Controls.2/org.kde.breeze/impl)
install(FILES ${qmlfiles} DESTINATION ${KDE_INSTALL_QMLDIR}/QtQuick/Controls.2/org.kde.breeze/impl)
install(FILES qmldir DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/kirigami/styles/org.kde.breeze/impl)
install(FILES ${qmlfiles} DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/kirigami/styles/org.kde.breeze/impl)
install(FILES qmldir DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/breeze/impl)
install(FILES ${qmlfiles} DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/breeze/impl)
