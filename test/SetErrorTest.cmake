# Matches everything if not defined
if(NOT TEST_MATCHES)
  set(TEST_MATCHES ".*")
endif()

set(TEST_COUNT 0)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})

include(Assertion)
include(GitCheckout)

if("Set error" MATCHES ${TEST_MATCHES})
  math(EXPR TEST_COUNT "${TEST_COUNT} + 1")

  set(MOCK_MESSAGE ON)

  function(foo)
    _set_error("Unknown error")
  endfunction()

  foo()

  if(NOT FATAL_ERROR_MESSAGE STREQUAL "Unknown error")
    set(MOCK_MESSAGE OFF)
    message(FATAL_ERROR "It should have set the error to 'Unknown error' but instead got '${FATAL_ERROR_MESSAGE}'")
  endif()
endif()

if("Set error with variable specified" MATCHES ${TEST_MATCHES})
  math(EXPR TEST_COUNT "${TEST_COUNT} + 1")

  function(foo)
    _set_error("Unknown error" ERROR_VARIABLE ERR)
  endfunction()

  foo()

  if(NOT ERR STREQUAL "Unknown error")
    message(FATAL_ERROR "It should have set the error to 'Unknown error' but instead got '${ERR}'")
  endif()
endif()

if(TEST_COUNT LESS_EQUAL 0)
  message(FATAL_ERROR "Nothing to test with: ${TEST_MATCHES}")
endif()
