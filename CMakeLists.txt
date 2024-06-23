cmake_minimum_required(VERSION 3.21)

project(
  GitCheckout
  VERSION 1.1.0
  DESCRIPTION "Clone and check out a Git repository from a CMake project"
  HOMEPAGE_URL https://github.com/threeal/git-checkout-cmake
  LANGUAGES NONE
)

list(PREPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
if(NOT PROJECT_IS_TOP_LEVEL)
  set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}" PARENT_SCOPE)
endif()

if(PROJECT_IS_TOP_LEVEL)
  if(BUILD_TESTING)
    enable_testing()
    add_subdirectory(test)
  endif()

  include(CMakePackageConfigHelpers)
  write_basic_package_version_file(
    GitCheckoutConfigVersion.cmake
    COMPATIBILITY SameMajorVersion
  )

  install(
    FILES
      cmake/GitCheckout.cmake
      cmake/GitCheckoutConfig.cmake
      ${CMAKE_CURRENT_BINARY_DIR}/GitCheckoutConfigVersion.cmake
    DESTINATION lib/cmake/GitCheckout
  )
endif()
