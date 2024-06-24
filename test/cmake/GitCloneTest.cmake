cmake_minimum_required(VERSION 3.5)

include(${CMAKE_CURRENT_LIST_DIR}/Assertion.cmake)
include(GitCheckout)

function("Incompletely clone a Git repository")
  if(EXISTS project-starter)
    file(REMOVE_RECURSE project-starter)
  endif()

  _git_incomplete_clone(https://github.com/threeal/project-starter project-starter)

  assert_git_incomplete_clone(project-starter)
endfunction()

function("Incompletely clone a Git repository into an existing Git directory")
  cmake_language(CALL "Incompletely clone a Git repository")

  _git_incomplete_clone(https://github.com/threeal/project-starter project-starter)
  assert_git_incomplete_clone(project-starter)
endfunction()

function("Incompletely clone a Git repository into an existing path")
  if(EXISTS project-starter)
    file(REMOVE_RECURSE project-starter)
  endif()
  file(TOUCH project-starter)

  assert_fatal_error(
    CALL _git_incomplete_clone https://github.com/threeal/project-starter project-starter
    MESSAGE "Unable to clone 'https://github.com/threeal/project-starter' to 'project-starter' because the path already exists and is not a Git repository")
endfunction()

function("Incompletely clone an invalid Git repository")
  assert_fatal_error(
    CALL _git_incomplete_clone https://github.com/threeal/invalid-project invalid-project
    MESSAGE "Failed to clone 'https://github.com/threeal/invalid-project' (128)")
endfunction()

cmake_language(CALL "${TEST_COMMAND}")
