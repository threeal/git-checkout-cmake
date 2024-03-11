# Matches everything if not defined
if(NOT TEST_MATCHES)
  set(TEST_MATCHES ".*")
endif()

set(TEST_COUNT 0)

if("Set error" MATCHES ${TEST_MATCHES})
  math(EXPR TEST_COUNT "${TEST_COUNT} + 1")

  set(MOCK_MESSAGE on)
  macro(message MODE MESSAGE)
    if(MOCK_MESSAGE)
      set(${MODE}_MESSAGE "${MESSAGE}" PARENT_SCOPE)
    else()
      _message(${MODE} ${MESSAGE})
    endif()
  endmacro()

  include(GitCheckout)

  function(foo)
    _set_error("Unknown error")
  endfunction()

  foo()

  set(MOCK_MESSAGE off)
  if(NOT FATAL_ERROR_MESSAGE STREQUAL "Unknown error")
    message(FATAL_ERROR "It should have set the error to 'Unknown error' but instead got '${FATAL_ERROR_MESSAGE}'")
  endif()
endif()

if("Set error with variable specified" MATCHES ${TEST_MATCHES})
  math(EXPR TEST_COUNT "${TEST_COUNT} + 1")

  include(GitCheckout)

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
