file(
  DOWNLOAD https://threeal.github.io/assertion-cmake/v0.2.0
    ${CMAKE_BINARY_DIR}/Assertion.cmake
  EXPECTED_MD5 4ee0e5217b07442d1a31c46e78bb5fac
)
include(${CMAKE_BINARY_DIR}/Assertion.cmake)

find_package(GitCheckout REQUIRED PATHS ${CMAKE_CURRENT_LIST_DIR}/../../cmake)
include(GitCheckout)

function("Find the Git executable")
  _find_git()

  assert(DEFINED GIT_EXECUTABLE)
  assert(EXISTS "${GIT_EXECUTABLE}")
endfunction()

function("Get the Git check out directory with an absolute directory provided")
  _get_git_checkout_directory(https://github.com/threeal/project-starter /path/to/some-directory DIRECTORY)

  assert(DEFINED DIRECTORY)
  assert(DIRECTORY STREQUAL /path/to/some-directory)
endfunction()

function("Get the Git check out directory with a relative directory provided")
  _get_git_checkout_directory(https://github.com/threeal/project-starter some-directory DIRECTORY)

  assert(DEFINED DIRECTORY)
  assert(DIRECTORY STREQUAL ${CMAKE_CURRENT_BINARY_DIR}/some-directory)
endfunction()

function("Get the Git check out directory without any directory provided")
  _get_git_checkout_directory(https://github.com/threeal/project-starter "" DIRECTORY)

  assert(DEFINED DIRECTORY)
  assert(DIRECTORY STREQUAL ${CMAKE_CURRENT_BINARY_DIR}/project-starter)
endfunction()

cmake_language(CALL "${TEST_COMMAND}")
