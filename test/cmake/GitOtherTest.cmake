file(
  DOWNLOAD https://threeal.github.io/assertion-cmake/v0.1.0 ${CMAKE_BINARY_DIR}/Assertion.cmake
  EXPECTED_MD5 3c9c0dd5e971bde719d7151c673e08b4
)
include(${CMAKE_BINARY_DIR}/Assertion.cmake)

include(GitCheckout)

function(test_find_the_git_executable)
  _find_git()

  assert_defined(GIT_EXECUTABLE)
  assert_exists("${GIT_EXECUTABLE}")
endfunction()

function(test_get_the_git_check_out_directory_with_an_absolute_directory_provided)
  _get_git_checkout_directory(https://github.com/threeal/project-starter /path/to/some-directory DIRECTORY)

  assert_defined(DIRECTORY)
  assert_strequal("${DIRECTORY}" /path/to/some-directory)
endfunction()

function(test_get_the_git_check_out_directory_with_a_relative_directory_provided)
  _get_git_checkout_directory(https://github.com/threeal/project-starter some-directory DIRECTORY)

  assert_defined(DIRECTORY)
  assert_strequal("${DIRECTORY}" ${CMAKE_CURRENT_BINARY_DIR}/some-directory)
endfunction()

function(test_get_the_git_check_out_directory_without_any_directory_provided)
  _get_git_checkout_directory(https://github.com/threeal/project-starter "" DIRECTORY)

  assert_defined(DIRECTORY)
  assert_strequal("${DIRECTORY}" ${CMAKE_CURRENT_BINARY_DIR}/project-starter)
endfunction()

if(NOT DEFINED TEST_COMMAND)
  message(FATAL_ERROR "The 'TEST_COMMAND' variable should be defined")
elseif(NOT COMMAND test_${TEST_COMMAND})
  message(FATAL_ERROR "Unable to find a command named 'test_${TEST_COMMAND}'")
endif()

cmake_language(CALL test_${TEST_COMMAND})
