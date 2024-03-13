# Matches everything if not defined
if(NOT TEST_MATCHES)
  set(TEST_MATCHES ".*")
endif()

set(TEST_COUNT 0)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})

include(Assertion)
include(GitCheckout)

if("Check out a Git repository" MATCHES ${TEST_MATCHES})
  math(EXPR TEST_COUNT "${TEST_COUNT} + 1")

  if(EXISTS project-starter)
    file(REMOVE_RECURSE project-starter)
  endif()

  git_checkout(https://github.com/threeal/project-starter)

  assert_git_complete_checkout(project-starter)
endif()

if("Check out a Git repository to a specific directory" MATCHES ${TEST_MATCHES})
  math(EXPR TEST_COUNT "${TEST_COUNT} + 1")

  if(EXISTS some-directory)
    file(REMOVE_RECURSE some-directory)
  endif()

  git_checkout(https://github.com/threeal/project-starter DIRECTORY some-directory)

  assert_git_complete_checkout(some-directory)
endif()

if("Check out a Git repository on a specific ref" MATCHES ${TEST_MATCHES})
  math(EXPR TEST_COUNT "${TEST_COUNT} + 1")

  if(EXISTS project-starter)
    file(REMOVE_RECURSE project-starter)
  endif()

  git_checkout(https://github.com/threeal/project-starter REF 5a80d20)

  assert_git_complete_checkout(project-starter)

  execute_process(
    COMMAND git -C project-starter rev-parse --short HEAD
    OUTPUT_VARIABLE COMMIT_SHA
  )
  string(STRIP ${COMMIT_SHA} COMMIT_SHA)
  if(NOT COMMIT_SHA STREQUAL 5a80d20)
    message(FATAL_ERROR "The commit SHA should be '5a80d20' but instead got '${COMMIT_SHA}'")
  endif()
endif()

if("Check out a Git repository on a specific invalid ref" MATCHES ${TEST_MATCHES})
  math(EXPR TEST_COUNT "${TEST_COUNT} + 1")

  if(EXISTS project-starter)
    file(REMOVE_RECURSE project-starter)
  endif()

  git_checkout(
    https://github.com/threeal/project-starter
    REF invalid-ref
    ERROR_VARIABLE ERR
  )

  set(EXPECTED_ERR "Failed to check out 'project-starter' to 'invalid-ref' (1)")
  if(NOT ${ERR} STREQUAL EXPECTED_ERR)
    message(FATAL_ERROR "It should fail to check out because of '${EXPECTED_ERR}' but instead got '${ERR}'")
  endif()
endif()

if("Check out a Git repository sparsely" MATCHES ${TEST_MATCHES})
  math(EXPR TEST_COUNT "${TEST_COUNT} + 1")

  if(EXISTS opencv)
    file(REMOVE_RECURSE opencv)
  endif()

  git_checkout(
    https://github.com/opencv/opencv
    SPARSE_CHECKOUT modules/core samples/gpu
  )

  assert_git_sparse_checkout(
    opencv
    FILES modules/core samples/gpu
  )
endif()

if(TEST_COUNT LESS_EQUAL 0)
  message(FATAL_ERROR "Nothing to test with: ${TEST_MATCHES}")
endif()
