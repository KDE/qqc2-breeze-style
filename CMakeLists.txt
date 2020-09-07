cmake_minimum_required(VERSION 3.5)

set(KF5_VERSION "5.75.0") # handled by release scripts
set(KF5_DEP_VERSION "5.74.0") # handled by release scripts

project(qqc2-breeze-style VERSION ${KF5_VERSION})

set(REQUIRED_QT_VERSION 5.12.0)

################# Disallow in-source build #################

if("${CMAKE_SOURCE_DIR}" STREQUAL "${CMAKE_BINARY_DIR}")
   message(FATAL_ERROR "qqc2-breeze-style requires an out of source build. Please create a separate build directory and run 'cmake -S /path/to/qqc2-breeze-style' there.")
endif()



# Make CPack available to easy generate binary packages
include(CPack)
include(FeatureSummary)

################# set KDE specific information #################

find_package(ECM ${KF5_DEP_VERSION} REQUIRED NO_MODULE)

# where to look first for cmake modules, before ${CMAKE_ROOT}/Modules/ is checked
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH})

include(ECMSetupVersion)
include(ECMGenerateHeaders)
include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDEFrameworkCompilerSettings NO_POLICY_SCOPE)

find_package(Qt5 ${REQUIRED_QT_VERSION} REQUIRED NO_MODULE COMPONENTS Core Quick Gui QuickControls2 DBus)

find_package(KF5 ${KF5_DEP_VERSION} REQUIRED COMPONENTS Config Kirigami2)

# IconThemes and ConfigWidgets are optional
find_package(KF5IconThemes ${KF5_DEP_VERSION})
find_package(KF5ConfigWidgets ${KF5_DEP_VERSION})

if (NOT APPLE AND NOT WIN32)
    find_package(X11)
endif()

# When building as a static plugin, dependencies may add a -lQt5X11Extras
# to the linker, in that case, it requires to have the proper variables
# to exists.
if(X11_FOUND)
    find_package(Qt5X11Extras ${REQUIRED_QT_VERSION} NO_MODULE QUIET)
endif()

set_package_properties(IconThemes PROPERTIES DESCRIPTION "KF5 IconThemes framework"
                       TYPE OPTIONAL
                       PURPOSE "Optional integration of Kirigami with KIconLoader icons handling for a better integration with Plasma Desktop"
                      )
set_package_properties(ConfigWidgets PROPERTIES DESCRIPTION "KF5 WidgetAddons framework"
                       TYPE OPTIONAL
                       PURPOSE "Optional integration of Kirigami with KColorScheme for color palettes integration with Plasma Desktop"
                      )

find_package(PkgConfig)

set(CMAKECONFIG_INSTALL_DIR "${KDE_INSTALL_CMAKEPACKAGEDIR}/KF5QQC2BreezeStyle")

configure_package_config_file(
  "${CMAKE_CURRENT_SOURCE_DIR}/KF5QQC2BreezeStyleConfig.cmake.in"
  "${CMAKE_CURRENT_BINARY_DIR}/KF5QQC2BreezeStyleConfig.cmake"
  INSTALL_DESTINATION  ${CMAKECONFIG_INSTALL_DIR}
  PATH_VARS  KF5_INCLUDE_INSTALL_DIR CMAKE_INSTALL_PREFIX
)

install(FILES
  "${CMAKE_CURRENT_BINARY_DIR}/KF5QQC2BreezeStyleConfig.cmake"
  "${CMAKE_CURRENT_BINARY_DIR}/KF5QQC2BreezeStyleConfigVersion.cmake"
  DESTINATION "${CMAKECONFIG_INSTALL_DIR}"
  COMPONENT Devel
)


ecm_setup_version(PROJECT
    VARIABLE_PREFIX QQC2BREEZESTYLE
    PACKAGE_VERSION_FILE "${CMAKE_CURRENT_BINARY_DIR}/KF5QQC2BreezeStyleConfigVersion.cmake"
    SOVERSION 5)

#########################################################################
add_definitions(-DQT_NO_FOREACH)
add_definitions(-DQT_DISABLE_DEPRECATED_BEFORE=0x050d00)
add_definitions(-DKF_DISABLE_DEPRECATED_BEFORE_AND_AT=0x054900)
add_subdirectory(plugin)

if (KF5IconThemes_FOUND AND KF5WidgetsAddons_FOUND)
add_subdirectory(kirigami-plasmadesktop-integration)
endif(KF5IconThemes_FOUND AND KF5WidgetsAddons_FOUND)

# FIXME: this assumes there will always be a QQC2 release for each Qt release, needs
# something to discover what's the latest qqc2 version available
# Since 5.12, QQC2 version is sync with Qt's minor version:
# https://github.com/qt/qtquickcontrols2/commit/3c7bfc156797b2f3ef08a8cf620b79da80e4b061
set(QQC2_VERSION "2.${Qt5QuickControls2_VERSION_MINOR}")

if (Qt5Qml_VERSION_STRING VERSION_GREATER_EQUAL 5.14)
    set(DISABLE_UNDER_QT_5_14 "")
    set(DISABLE_AT_QT_5_14 "//Disabled since Qt 5.14 ")
else()
    set(DISABLE_UNDER_QT_5_14 "//Needs Qt 5.14 ")
    set(DISABLE_AT_QT_5_14 "")
endif()

# TODO: Automate Kirigami version
# This code doesn't work yet
# set(KIRIGAMI_VERSION "2.${KF5_DEP_VERSION_MINOR}")

# Find all the source qml files
FILE(GLOB_RECURSE inFiles RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}"
    "${CMAKE_CURRENT_SOURCE_DIR}/style/*")

#for each file, replace @QQC2_VERSION@ with the version we found
FOREACH(infileName ${inFiles})
    configure_package_config_file(
        "${CMAKE_CURRENT_SOURCE_DIR}/${infileName}"
        "${CMAKE_CURRENT_BINARY_DIR}/${infileName}"
        INSTALL_DESTINATION  ${CMAKECONFIG_INSTALL_DIR}
        PATH_VARS  QQC2_VERSION
    )
ENDFOREACH(infileName)

# TODO: Automate Kirigami version
# This code doesn't work yet
#for each file, replace @KIRIGAMI_VERSION@ with the version we found
#FOREACH(infileName ${inFiles})
    #configure_package_config_file(
        #"${CMAKE_CURRENT_SOURCE_DIR}/${infileName}"
        #"${CMAKE_CURRENT_BINARY_DIR}/${infileName}"
        #INSTALL_DESTINATION  ${CMAKECONFIG_INSTALL_DIR}
        #PATH_VARS KIRIGAMI_VERSION
    #)
#ENDFOREACH(infileName)

file(GLOB_RECURSE qtquickcontrolsFiles LIST_DIRECTORIES true "${CMAKE_CURRENT_SOURCE_DIR}/style/qtquickcontrols/*")
install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/style/qtquickcontrols/ DESTINATION ${KDE_INSTALL_QMLDIR}/QtQuick/Controls.2/org.kde.breeze)

file(GLOB_RECURSE kirigamiFiles LIST_DIRECTORIES true "${CMAKE_CURRENT_SOURCE_DIR}/style/kirigami/*")
install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/style/kirigami/ DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/kirigami.2/styles/org.kde.breeze)

feature_summary(WHAT ALL INCLUDE_QUIET_PACKAGES FATAL_ON_MISSING_REQUIRED_PACKAGES)

