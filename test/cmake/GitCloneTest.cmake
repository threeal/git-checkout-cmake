list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})

include(Assertion)
include(GitCheckout)

function(incompletely_clone_a_Git_repository)
  if(EXISTS project-starter)
    file(REMOVE_RECURSE project-starter)
  endif()

  _git_incomplete_clone(https://github.com/threeal/project-starter)

  assert_git_incomplete_clone(project-starter)
endfunction()

function(incompletely_clone_a_git_repository_to_an_existing_path)
  if(EXISTS project-starter)
    file(REMOVE_RECURSE project-starter)
  endif()
  file(TOUCH project-starter)

  set(MOCK_MESSAGE ON)
  _git_incomplete_clone(https://github.com/threeal/project-starter)

  assert_message(FATAL_ERROR "Unable to clone 'https://github.com/threeal/project-starter' to 'project-starter' because the path already exists")
endfunction()

function(incompletely_clone_an_invalid_git_repository)
  set(MOCK_MESSAGE ON)
  _git_incomplete_clone(https://github.com/threeal/invalid-project)

  assert_message(FATAL_ERROR "Failed to clone 'https://github.com/threeal/invalid-project' (128)")
endfunction()

function(incompletely_clone_a_git_repository_to_a_specific_directory)
  if(EXISTS some-directory)
    file(REMOVE_RECURSE some-directory)
  endif()

  _git_incomplete_clone(https://github.com/threeal/project-starter DIRECTORY some-directory)

  assert_git_incomplete_clone(some-directory)
endfunction()

if(NOT DEFINED TEST_COMMAND)
  message(FATAL_ERROR "The 'TEST_COMMAND' variable should be defined")
elseif(NOT COMMAND ${TEST_COMMAND})
  message(FATAL_ERROR "Unable to find a command named '${TEST_COMMAND}'")
endif()

cmake_language(CALL ${TEST_COMMAND})
