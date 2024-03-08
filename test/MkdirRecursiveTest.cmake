# Matches everything if not defined
if(NOT TEST_MATCHES)
  set(TEST_MATCHES ".*")
endif()

set(TEST_COUNT 0)

if("Create directory recursively" MATCHES ${TEST_MATCHES})
  math(EXPR TEST_COUNT "${TEST_COUNT} + 1")

  if(EXISTS parent)
    message(STATUS "Removing test directory")
    file(REMOVE_RECURSE parent)
  endif()

  include(MkdirRecursive)

  message(STATUS "Creating test directory recursively")
  mkdir_recursive(parent/child)

  if(NOT EXISTS parent/child)
    message(FATAL_ERROR "Directory `parent/child` should exist!")
  endif()

  message(STATUS "Removing test directory")
  file(REMOVE_RECURSE parent)
endif()

# Add more test cases here.
if("Test name" MATCHES ${TEST_MATCHES})
  math(EXPR TEST_COUNT "${TEST_COUNT} + 1")

  # Do something.
endif()

if(TEST_COUNT LESS_EQUAL 0)
  message(FATAL_ERROR "Nothing to test with: ${TEST_MATCHES}")
endif()
