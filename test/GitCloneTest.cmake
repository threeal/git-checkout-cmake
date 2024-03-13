# Matches everything if not defined
if(NOT TEST_MATCHES)
  set(TEST_MATCHES ".*")
endif()

set(TEST_COUNT 0)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})

include(Assertion)
include(GitCheckout)

if("Incompletely clone a Git repository" MATCHES ${TEST_MATCHES})
  math(EXPR TEST_COUNT "${TEST_COUNT} + 1")

  if(EXISTS project-starter)
    file(REMOVE_RECURSE project-starter)
  endif()

  _git_incomplete_clone(https://github.com/threeal/project-starter)

  assert_git_incomplete_clone(project-starter)
endif()

if("Incompletely clone an invalid Git repository" MATCHES ${TEST_MATCHES})
  math(EXPR TEST_COUNT "${TEST_COUNT} + 1")

  _git_incomplete_clone(
    https://github.com/threeal/invalid-project
    ERROR_VARIABLE ERR
  )

  set(EXPECTED_ERR "Failed to clone 'https://github.com/threeal/invalid-project' (128)")
  if(NOT ${ERR} STREQUAL EXPECTED_ERR)
    message(FATAL_ERROR "It should fail to check out because of '${EXPECTED_ERR}' but instead got '${ERR}'")
  endif()
endif()

if("Incompletely clone a Git repository to a specific directory" MATCHES ${TEST_MATCHES})
  math(EXPR TEST_COUNT "${TEST_COUNT} + 1")

  if(EXISTS some-directory)
    file(REMOVE_RECURSE some-directory)
  endif()

  _git_incomplete_clone(https://github.com/threeal/project-starter DIRECTORY some-directory)

  assert_git_incomplete_clone(some-directory)
endif()

if(TEST_COUNT LESS_EQUAL 0)
  message(FATAL_ERROR "Nothing to test with: ${TEST_MATCHES}")
endif()
