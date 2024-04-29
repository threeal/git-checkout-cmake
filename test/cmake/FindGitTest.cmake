# Matches everything if not defined
if(NOT TEST_MATCHES)
  set(TEST_MATCHES ".*")
endif()

set(TEST_COUNT 0)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})

include(GitCheckout)

if("Find the Git executable" MATCHES ${TEST_MATCHES})
  math(EXPR TEST_COUNT "${TEST_COUNT} + 1")

  _find_git()

  if(NOT DEFINED GIT_EXECUTABLE)
    message(FATAL_ERROR "The 'GIT_EXECUTABLE' variable should be defined")
  elseif(NOT EXISTS ${GIT_EXECUTABLE})
    message(FATAL_ERROR "The Git executable should exist at '${GIT_EXECUTABLE}'")
  endif()
endif()

if(TEST_COUNT LESS_EQUAL 0)
  message(FATAL_ERROR "Nothing to test with: ${TEST_MATCHES}")
endif()
