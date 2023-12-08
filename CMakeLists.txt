project(qqc2-breeze-style)
set(PROJECT_VERSION "5.90.90")

cmake_minimum_required(VERSION 3.16)

set(QT_MIN_VERSION "6.6.0")
set(KF6_MIN_VERSION "5.240.0")
set(KF_DEP_VERSION "5.240.0")
set(KDE_COMPILERSETTINGS_LEVEL "5.82")

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(ECM ${KF6_MIN_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} )

################# Disallow in-source build #################

if("${CMAKE_SOURCE_DIR}" STREQUAL "${CMAKE_BINARY_DIR}")
   message(FATAL_ERROR "qqc2-breeze-style requires an out of source build. Please create a separate build directory and run 'cmake -S /path/to/qqc2-breeze-style' there.")
endif()

# Make CPack available to easy generate binary packages
include(CPack)
include(FeatureSummary)

################# set KDE specific information #################

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

find_package(Qt6 ${QT_MIN_VERSION} REQUIRED NO_MODULE COMPONENTS Core Gui Qml Quick QuickControls2 QuickTemplates2)

if (NOT ANDROID)
    find_package(Qt6 ${QT_MIN_VERSION} REQUIRED COMPONENTS DBus)
    find_package(KF6IconThemes ${KF6_MIN_VERSION} REQUIRED)
endif()

find_package(KF6 ${KF6_MIN_VERSION} REQUIRED COMPONENTS GuiAddons Config KirigamiPlatform CoreAddons ColorScheme QuickCharts)

if (NOT APPLE AND NOT WIN32)
    find_package(X11)
endif()

# When building as a static plugin, dependencies may add a -lQt5X11Extras
# to the linker, in that case, it requires to have the proper variables
# to exists.
find_package(Qt6X11Extras ${QT_MIN_VERSION} NO_MODULE QUIET)

set_package_properties(QuickCharts PROPERTIES DESCRIPTION "KF6 QuickCharts framework"
                       TYPE REQUIRED
                       PURPOSE "Used to implement the BusyIndicator style"
                      )
set_package_properties(IconThemes PROPERTIES DESCRIPTION "KF6 IconThemes framework"
                       TYPE OPTIONAL
                       PURPOSE "Optional integration of Kirigami with KIconLoader icons handling for a better integration with Plasma Desktop"
                      )
set_package_properties(ColorScheme PROPERTIES DESCRIPTION "KF6 ColorScheme framework"
                       TYPE OPTIONAL
                       PURPOSE "Optional integration of Kirigami with KColorScheme for color palettes integration with Plasma Desktop"
                      )

set(CMAKECONFIG_INSTALL_DIR "${KDE_INSTALL_CMAKEPACKAGEDIR}/QQC2BreezeStyle")

configure_package_config_file(
  "${CMAKE_CURRENT_SOURCE_DIR}/QQC2BreezeStyleConfig.cmake.in"
  "${CMAKE_CURRENT_BINARY_DIR}/QQC2BreezeStyleConfig.cmake"
  INSTALL_DESTINATION  ${CMAKECONFIG_INSTALL_DIR}
  PATH_VARS  KDE_INSTALL_INCLUDEDIR_KF CMAKE_INSTALL_PREFIX
)

install(FILES
  "${CMAKE_CURRENT_BINARY_DIR}/QQC2BreezeStyleConfig.cmake"
  "${CMAKE_CURRENT_BINARY_DIR}/QQC2BreezeStyleConfigVersion.cmake"
  DESTINATION "${CMAKECONFIG_INSTALL_DIR}"
  COMPONENT Devel
)


ecm_setup_version(PROJECT
    VARIABLE_PREFIX QQC2BREEZESTYLE
    PACKAGE_VERSION_FILE "${CMAKE_CURRENT_BINARY_DIR}/QQC2BreezeStyleConfigVersion.cmake"
    SOVERSION 5)

#########################################################################
add_definitions(-DQT_NO_FOREACH)
add_definitions(-DQT_DISABLE_DEPRECATED_BEFORE=0x050d00)
add_definitions(-DKF_DISABLE_DEPRECATED_BEFORE_AND_AT=0x054900)

add_subdirectory(style)

add_subdirectory(kirigami-plasmadesktop-integration)

feature_summary(WHAT ALL INCLUDE_QUIET_PACKAGES FATAL_ON_MISSING_REQUIRED_PACKAGES)

# add clang-format target for all our real source files
file(GLOB_RECURSE ALL_CLANG_FORMAT_SOURCE_FILES *.cpp *.h)
kde_clang_format(${ALL_CLANG_FORMAT_SOURCE_FILES})
kde_configure_git_pre_commit_hook(CHECKS CLANG_FORMAT)
