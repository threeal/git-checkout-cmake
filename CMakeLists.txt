cmake_minimum_required(VERSION 3.19)

project(
  GitCheckout
  VERSION 1.0.0
  DESCRIPTION "Clone and check out a Git repository from a CMake project"
  HOMEPAGE_URL https://github.com/threeal/git-checkout-cmake
  LANGUAGES NONE
)

if(NOT CMAKE_CURRENT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
  set(SUBPROJECT TRUE)
endif()

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
if(SUBPROJECT)
  set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} PARENT_SCOPE)
endif()

if(NOT SUBPROJECT)
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
