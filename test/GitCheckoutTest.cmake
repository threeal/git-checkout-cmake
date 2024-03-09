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

if("Check out an invalid Git repository" MATCHES ${TEST_MATCHES})
  math(EXPR TEST_COUNT "${TEST_COUNT} + 1")

  set(MOCK_MESSAGE on)
  macro(message MODE MESSAGE)
    if(MOCK_MESSAGE)
      if(${MODE} STREQUAL FATAL_ERROR)
        set(FATAL_ERROR_MESSAGE "${MESSAGE}" PARENT_SCOPE)
      endif()
    else()
      _message(${MODE} ${MESSAGE})
    endif()
  endmacro()

  include(GitCheckout)
  git_checkout(https://github.com/threeal/invalid-project)

  set(MOCK_MESSAGE off)

  set(EXPECTED_FATAL_ERROR_MESSAGE "Failed to clone https://github.com/threeal/invalid-project (128)")
  if(NOT FATAL_ERROR_MESSAGE STREQUAL EXPECTED_FATAL_ERROR_MESSAGE)
    message(FATAL_ERROR "It should fail to check out because of `${EXPECTED_FATAL_ERROR_MESSAGE}`, but got `${FATAL_ERROR_MESSAGE}` instead")
  endif()
endif()

if("Check out an invalid Git repository with error variable specified" MATCHES ${TEST_MATCHES})
  math(EXPR TEST_COUNT "${TEST_COUNT} + 1")

  include(GitCheckout)
  git_checkout(
    https://github.com/threeal/invalid-project
    ERROR_VARIABLE ERR
  )

  set(EXPECTED_FATAL_ERROR_MESSAGE "Failed to clone https://github.com/threeal/invalid-project (128)")
  if(NOT ${ERR} STREQUAL EXPECTED_FATAL_ERROR_MESSAGE)
    message(FATAL_ERROR "It should fail to check out because of `${EXPECTED_FATAL_ERROR_MESSAGE}`, but got `${ERR}` instead")
  endif()
endif()

if(TEST_COUNT LESS_EQUAL 0)
  message(FATAL_ERROR "Nothing to test with: ${TEST_MATCHES}")
endif()
