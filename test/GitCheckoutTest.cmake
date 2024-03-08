# Matches everything if not defined
if(NOT TEST_MATCHES)
  set(TEST_MATCHES ".*")
endif()

set(TEST_COUNT 0)

# Add more test cases here.
if("Check out a Git repository" MATCHES ${TEST_MATCHES})
  math(EXPR TEST_COUNT "${TEST_COUNT} + 1")

  if(EXISTS project-starter)
    file(REMOVE_RECURSE project-starter)
  endif()

  include(GitCheckout)
  git_checkout(https://github.com/threeal/project-starter)

  if(NOT EXISTS project-starter)
    message(FATAL_ERROR "project-starter should exist")
  endif()
endif()

if(TEST_COUNT LESS_EQUAL 0)
  message(FATAL_ERROR "Nothing to test with: ${TEST_MATCHES}")
endif()
