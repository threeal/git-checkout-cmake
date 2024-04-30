list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})

include(Assertion)
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

  set(MOCK_MESSAGE ON)
  _git_incomplete_clone(https://github.com/threeal/project-starter project-starter)

  assert_message(FATAL_ERROR "Unable to clone 'https://github.com/threeal/project-starter' to 'project-starter' because the path already exists and is not a Git repository")
endfunction()

function(test_incompletely_clone_an_invalid_git_repository)
  set(MOCK_MESSAGE ON)
  _git_incomplete_clone(https://github.com/threeal/invalid-project invalid-project)

  assert_message(FATAL_ERROR "Failed to clone 'https://github.com/threeal/invalid-project' (128)")
endfunction()

if(NOT DEFINED TEST_COMMAND)
  message(FATAL_ERROR "The 'TEST_COMMAND' variable should be defined")
elseif(NOT COMMAND test_${TEST_COMMAND})
  message(FATAL_ERROR "Unable to find a command named 'test_${TEST_COMMAND}'")
endif()

cmake_language(CALL test_${TEST_COMMAND})
