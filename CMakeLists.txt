cmake_minimum_required(VERSION 3.21)

project(
  GitCheckout
  VERSION 1.1.0
  DESCRIPTION "Clone and check out a Git repository from a CMake project"
  HOMEPAGE_URL https://github.com/threeal/git-checkout-cmake
  LANGUAGES NONE
)

option(GIT_CHECKOUT_ENABLE_INSTALL "Enable install targets."
  "${PROJECT_IS_TOP_LEVEL}")

include(cmake/GitCheckout.cmake)

if(PROJECT_IS_TOP_LEVEL AND BUILD_TESTING)
  enable_testing()
  add_subdirectory(test)
endif()

if(GIT_CHECKOUT_ENABLE_INSTALL)
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
