add_subdirectory(impl)
add_subdirectory(qtquickcontrols)
add_subdirectory(kirigami)

if(ANDROID)
    install(FILES BreezeLight.colors BreezeDark.colors DESTINATION ${KDE_INSTALL_DATADIR}/color-schemes)
endif()
