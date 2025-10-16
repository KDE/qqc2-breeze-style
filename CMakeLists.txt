cmake_minimum_required(VERSION 3.16)

project(qqc2-breeze-style)
set(PROJECT_VERSION "6.5.0")

set(QT_MIN_VERSION "6.9.0")
set(KF6_MIN_VERSION "6.18.0")
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

# shall we use DBus?
# enabled per default on Linux & BSD systems
set(USE_DBUS_DEFAULT OFF)
if(UNIX AND NOT APPLE AND NOT ANDROID AND NOT HAIKU)
    set(USE_DBUS_DEFAULT ON)
endif()
option(USE_DBUS "Build components using DBus" ${USE_DBUS_DEFAULT})
if(USE_DBUS)
  find_package(Qt6 ${REQUIRED_QT_VERSION} CONFIG REQUIRED DBus)
  set(HAVE_DBUS ON)
endif()

find_package(KF6 ${KF6_MIN_VERSION} REQUIRED COMPONENTS GuiAddons Config KirigamiPlatform ColorScheme IconThemes)

if (NOT APPLE AND NOT WIN32)
    find_package(X11)
endif()

set_package_properties(IconThemes PROPERTIES DESCRIPTION "KF6 IconThemes framework"
                       TYPE OPTIONAL
                       PURPOSE "Optional integration of Kirigami with KIconLoader icons handling for a better integration with Plasma Desktop"
                      )
set_package_properties(ColorScheme PROPERTIES DESCRIPTION "KF6 ColorScheme framework"
                       TYPE OPTIONAL
                       PURPOSE "Optional integration of Kirigami with KColorScheme for color palettes integration with Plasma Desktop"
                      )

ecm_setup_version(PROJECT
    VARIABLE_PREFIX QQC2BREEZESTYLE
    PACKAGE_VERSION_FILE "${CMAKE_CURRENT_BINARY_DIR}/QQC2BreezeStyleConfigVersion.cmake"
    SOVERSION 5)

add_definitions(-DQT_NO_FOREACH)
add_definitions(-DQT_DISABLE_DEPRECATED_BEFORE=0x050d00)
add_definitions(-DKF_DISABLE_DEPRECATED_BEFORE_AND_AT=0x054900)

add_subdirectory(style)

add_subdirectory(kirigami-plasmadesktop-integration)

set(CMAKECONFIG_INSTALL_DIR "${KDE_INSTALL_CMAKEPACKAGEDIR}/QQC2BreezeStyle")

install(EXPORT QQC2BreezeStyleTargets DESTINATION "${CMAKECONFIG_INSTALL_DIR}" FILE QQC2BreezeStyleTargets.cmake)

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

feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)

# add clang-format target for all our real source files
file(GLOB_RECURSE ALL_CLANG_FORMAT_SOURCE_FILES *.cpp *.h)
kde_clang_format(${ALL_CLANG_FORMAT_SOURCE_FILES})
kde_configure_git_pre_commit_hook(CHECKS CLANG_FORMAT)
