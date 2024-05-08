cmake_minimum_required(VERSION 3.5)

file(
  DOWNLOAD https://threeal.github.io/assertion-cmake/v0.1.0 ${CMAKE_CURRENT_BINARY_DIR}/Assertion.cmake
  EXPECTED_MD5 3c9c0dd5e971bde719d7151c673e08b4
)
include(${CMAKE_CURRENT_BINARY_DIR}/Assertion.cmake)

include(${CMAKE_CURRENT_LIST_DIR}/Assertion.cmake)
include(GitCheckout)

function(test_incompletely_clone_a_Git_repository)
  if(EXISTS project-starter)
    file(REMOVE_RECURSE project-starter)
  endif()

  _git_incomplete_clone(https://github.com/threeal/project-starter project-starter)

  assert_git_incomplete_clone(project-starter)
endfunction()

function(test_incompletely_clone_a_git_repository_into_an_existing_git_directory)
  test_incompletely_clone_a_Git_repository()

  _git_incomplete_clone(https://github.com/threeal/project-starter project-starter)
  assert_git_incomplete_clone(project-starter)
endfunction()

function(test_incompletely_clone_a_git_repository_into_an_existing_path)
  if(EXISTS project-starter)
    file(REMOVE_RECURSE project-starter)
  endif()
  file(TOUCH project-starter)

  mock_message()
    _git_incomplete_clone(https://github.com/threeal/project-starter project-starter)
  end_mock_message()

  assert_message(FATAL_ERROR "Unable to clone 'https://github.com/threeal/project-starter' to 'project-starter' because the path already exists and is not a Git repository")
endfunction()

function(test_incompletely_clone_an_invalid_git_repository)
  mock_message()
    _git_incomplete_clone(https://github.com/threeal/invalid-project invalid-project)
  end_mock_message()

  assert_message(FATAL_ERROR "Failed to clone 'https://github.com/threeal/invalid-project' (128)")
endfunction()

if(NOT DEFINED TEST_COMMAND)
  message(FATAL_ERROR "The 'TEST_COMMAND' variable should be defined")
elseif(NOT COMMAND test_${TEST_COMMAND})
  message(FATAL_ERROR "Unable to find a command named 'test_${TEST_COMMAND}'")
endif()

cmake_language(CALL test_${TEST_COMMAND})
