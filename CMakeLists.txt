cmake_minimum_required(VERSION 3.16)

set(KF_VERSION "5.240.0") # handled by release scripts
set(KF_DEP_VERSION "5.240.0") # handled by release scripts

project(qqc2-breeze-style VERSION 1.0)

set(REQUIRED_QT_VERSION 6.4.0)

################# Disallow in-source build #################

if("${CMAKE_SOURCE_DIR}" STREQUAL "${CMAKE_BINARY_DIR}")
   message(FATAL_ERROR "qqc2-breeze-style requires an out of source build. Please create a separate build directory and run 'cmake -S /path/to/qqc2-breeze-style' there.")
endif()



# Make CPack available to easy generate binary packages
include(CPack)
include(FeatureSummary)

################# set KDE specific information #################

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(ECM ${KF_DEP_VERSION} REQUIRED NO_MODULE)

# where to look first for cmake modules, before ${CMAKE_ROOT}/Modules/ is checked
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH})

include(ECMSetupVersion)
include(ECMGenerateHeaders)
include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDECompilerSettings NO_POLICY_SCOPE)
include(KDEClangFormat)
include(KDEGitCommitHooks)
include(ECMQmlModule)

find_package(Qt${QT_MAJOR_VERSION} ${REQUIRED_QT_VERSION} REQUIRED NO_MODULE COMPONENTS Core Gui Qml Quick QuickControls2 QuickTemplates2)

if (NOT ANDROID)
    find_package(Qt${QT_MAJOR_VERSION} ${REQUIRED_QT_VERSION} REQUIRED COMPONENTS DBus)
    find_package(KF6IconThemes ${KF_DEP_VERSION} REQUIRED)
endif()

find_package(KF6 ${KF_DEP_VERSION} REQUIRED COMPONENTS GuiAddons Config Kirigami2 CoreAddons ColorScheme)

if (NOT APPLE AND NOT WIN32)
    find_package(X11)
endif()

# When building as a static plugin, dependencies may add a -lQt5X11Extras
# to the linker, in that case, it requires to have the proper variables
# to exists.
if(X11_FOUND AND NOT QT_MAJOR_VERSION EQUAL "5")
    find_package(Qt6X11Extras ${REQUIRED_QT_VERSION} NO_MODULE QUIET)
endif()

set_package_properties(IconThemes PROPERTIES DESCRIPTION "KF6 IconThemes framework"
                       TYPE OPTIONAL
                       PURPOSE "Optional integration of Kirigami with KIconLoader icons handling for a better integration with Plasma Desktop"
                      )
set_package_properties(ColorScheme PROPERTIES DESCRIPTION "KF6 WidgetAddons framework"
                       TYPE OPTIONAL
                       PURPOSE "Optional integration of Kirigami with KColorScheme for color palettes integration with Plasma Desktop"
                      )

find_package(PkgConfig)

set(CMAKECONFIG_INSTALL_DIR "${KDE_INSTALL_CMAKEPACKAGEDIR}/KF5QQC2BreezeStyle")

configure_package_config_file(
  "${CMAKE_CURRENT_SOURCE_DIR}/KF6QQC2BreezeStyleConfig.cmake.in"
  "${CMAKE_CURRENT_BINARY_DIR}/KF6QQC2BreezeStyleConfig.cmake"
  INSTALL_DESTINATION  ${CMAKECONFIG_INSTALL_DIR}
  PATH_VARS  KDE_INSTALL_INCLUDEDIR_KF CMAKE_INSTALL_PREFIX
)

install(FILES
  "${CMAKE_CURRENT_BINARY_DIR}/KF6QQC2BreezeStyleConfig.cmake"
  "${CMAKE_CURRENT_BINARY_DIR}/KF6QQC2BreezeStyleConfigVersion.cmake"
  DESTINATION "${CMAKECONFIG_INSTALL_DIR}"
  COMPONENT Devel
)


ecm_setup_version(PROJECT
    VARIABLE_PREFIX QQC2BREEZESTYLE
    PACKAGE_VERSION_FILE "${CMAKE_CURRENT_BINARY_DIR}/KF6QQC2BreezeStyleConfigVersion.cmake"
    SOVERSION 5)

#########################################################################
add_definitions(-DQT_NO_FOREACH)
add_definitions(-DQT_DISABLE_DEPRECATED_BEFORE=0x050d00)
add_definitions(-DKF_DISABLE_DEPRECATED_BEFORE_AND_AT=0x054900)

add_subdirectory(style)

add_subdirectory(kirigami-plasmadesktop-integration)

set(QQC2_VERSION_MINOR "${Qt6QuickControls2_VERSION_MINOR}")
set(QQC2_VERSION "2.${QQC2_VERSION_MINOR}")

set(DISABLE_UNDER_QT_5_14 "")
set(DISABLE_AT_QT_5_14 "//Disabled since Qt 5.14 ")

# TODO: Automate Kirigami version
# This code doesn't work yet
# set(KIRIGAMI_VERSION "2.${KF5_DEP_VERSION_MINOR}")

# Find all the source qml files

FILE(GLOB_RECURSE inFiles RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" "*.qml")

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
#[[
FOREACH(infileName ${inFiles})
    configure_package_config_file(
        "${CMAKE_CURRENT_SOURCE_DIR}/${infileName}"
        "${CMAKE_CURRENT_BINARY_DIR}/${infileName}"
        INSTALL_DESTINATION  ${CMAKECONFIG_INSTALL_DIR}
        PATH_VARS KIRIGAMI_VERSION
    )
ENDFOREACH(infileName)
]]

feature_summary(WHAT ALL INCLUDE_QUIET_PACKAGES FATAL_ON_MISSING_REQUIRED_PACKAGES)

# add clang-format target for all our real source files
file(GLOB_RECURSE ALL_CLANG_FORMAT_SOURCE_FILES *.cpp *.h)
kde_clang_format(${ALL_CLANG_FORMAT_SOURCE_FILES})
kde_configure_git_pre_commit_hook(CHECKS CLANG_FORMAT)
