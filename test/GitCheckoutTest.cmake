# Matches everything if not defined
if(NOT TEST_MATCHES)
  set(TEST_MATCHES ".*")
endif()

set(TEST_COUNT 0)

if("Check out a Git repository" MATCHES ${TEST_MATCHES})
  math(EXPR TEST_COUNT "${TEST_COUNT} + 1")

  if(EXISTS project-starter)
    file(REMOVE_RECURSE project-starter)
  endif()

  include(GitCheckout)
  git_checkout(https://github.com/threeal/project-starter)

  if(NOT EXISTS project-starter)
    message(FATAL_ERROR "The 'project-starter' directory should exist")
  endif()
endif()

if("Check out an invalid Git repository" MATCHES ${TEST_MATCHES})
  math(EXPR TEST_COUNT "${TEST_COUNT} + 1")

  include(GitCheckout)
  git_checkout(
    https://github.com/threeal/invalid-project
    ERROR_VARIABLE ERR
  )

  set(EXPECTED_ERR "Failed to clone https://github.com/threeal/invalid-project (128)")
  if(NOT ${ERR} STREQUAL EXPECTED_ERR)
    message(FATAL_ERROR "It should fail to check out because of '${EXPECTED_ERR}' but instead got '${ERR}'")
  endif()
endif()

if("Check out a Git repository on a specific ref" MATCHES ${TEST_MATCHES})
  math(EXPR TEST_COUNT "${TEST_COUNT} + 1")

  if(EXISTS project-starter)
    file(REMOVE_RECURSE project-starter)
  endif()

  include(GitCheckout)
  git_checkout(https://github.com/threeal/project-starter REF 5a80d20)

  if(NOT EXISTS project-starter)
    message(FATAL_ERROR "The 'project-starter' directory should exist")
  endif()

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

  include(GitCheckout)
  git_checkout(
    https://github.com/threeal/project-starter
    REF invalid-ref
    ERROR_VARIABLE ERR
  )

  set(EXPECTED_ERR "Failed to clone https://github.com/threeal/project-starter (128)")
  if(NOT ${ERR} STREQUAL EXPECTED_ERR)
    message(FATAL_ERROR "It should fail to check out because of '${EXPECTED_ERR}' but instead got '${ERR}'")
  endif()
endif()

if(TEST_COUNT LESS_EQUAL 0)
  message(FATAL_ERROR "Nothing to test with: ${TEST_MATCHES}")
endif()
