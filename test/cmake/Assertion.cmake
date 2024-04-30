include_guard(GLOBAL)

include(GitCheckout)

# Mocks the implementation of the `message` function.
#
# If `MOCK_MESSAGE` is enabled, it will set `${MODE}_MESSAGE` to the given message instead of
# displaying the message in the log.
macro(message MODE MESSAGE)
  if(MOCK_MESSAGE)
    set(${MODE}_MESSAGE "${MESSAGE}" PARENT_SCOPE)
    if(${MODE} STREQUAL FATAL_ERROR)
      return()
    endif()
  else()
    _message(${MODE} ${MESSAGE})
  endif()
endmacro()

# Asserts whether the latest message is equal to the expected message.
#
# It asserts whether the `${MODE}_MESSAGE` variable set by the `message` function mock
# is equal to the given expected message.
#
# Arguments:
#   - MODE: The message mode.
#   - EXPECTED_MESSAGE: The expected message.
function(assert_message MODE EXPECTED_MESSAGE)
  if(NOT "${${MODE}_MESSAGE}" STREQUAL "${EXPECTED_MESSAGE}")
    set(MOCK_MESSAGE OFF)
    message(FATAL_ERROR "it should receive a ${MODE} message containing '${EXPECTED_MESSAGE}' but instead got '${${MODE}_MESSAGE}'")
  endif()
endfunction()

# Asserts whether the given path is a Git directory.
#
# It asserts whether the given path exists, is a directory, and contains a Git repository.
#
# Arguments:
#   - PATH: The path to check.
function(_assert_git_directory PATH)
  if(NOT EXISTS ${PATH})
    message(FATAL_ERROR "the '${PATH}' path should exist")
  endif()

  if(NOT IS_DIRECTORY ${PATH})
    message(FATAL_ERROR "the '${PATH}' path should be a directory")
  endif()

  _find_git()

  execute_process(
    COMMAND ${GIT_EXECUTABLE} -C ${PATH} status
    RESULT_VARIABLE RES
  )
  if(RES EQUAL 128)
    message(FATAL_ERROR "the '${PATH}' directory should contains a Git repository")
  elseif(NOT RES EQUAL 0)
    message(FATAL_ERROR "failed to get the Git status of the '${PATH}' directory (${RES})")
  endif()
endfunction()

# Asserts whether a Git repository is cloned incompletely.
#
# Arguments:
#   - PATH: The path of the cloned Git repository.
function(assert_git_incomplete_clone PATH)
  _assert_git_directory(${PATH})

  _find_git()

  execute_process(
    COMMAND ${GIT_EXECUTABLE} -C ${PATH} diff --no-patch --exit-code HEAD
    RESULT_VARIABLE RES
  )
  if(RES EQUAL 0)
    message(FATAL_ERROR "the Git repository in '${PATH}' should be cloned incompletely")
  elseif(NOT RES EQUAL 1)
    message(FATAL_ERROR "failed to get the diff of the repository in '${PATH}' (${RES})")
  endif()
endfunction()

# Asserts whether a Git repository is checked out completely.
#
# Arguments:
#   - DIRECTORY: The path of the directory to check out the Git repository.
#
# Optional arguments:
#   - EXPECTED_COMMIT_SHA: The expected commit SHA of the checked out Git repository.
function(assert_git_complete_checkout DIRECTORY)
  cmake_parse_arguments(ARG "" EXPECTED_COMMIT_SHA "" ${ARGN})

  _assert_git_directory(${DIRECTORY})

  _find_git()

  execute_process(
    COMMAND ${GIT_EXECUTABLE} -C ${DIRECTORY} diff --no-patch --exit-code HEAD
    RESULT_VARIABLE RES
  )
  if(NOT RES EQUAL 0)
    message(FATAL_ERROR "the repository should be checked out completely (${RES})")
  endif()

  if(DEFINED ARG_EXPECTED_COMMIT_SHA)
    execute_process(
      COMMAND ${GIT_EXECUTABLE} -C ${DIRECTORY} rev-parse --short HEAD
      OUTPUT_VARIABLE COMMIT_SHA
    )
    string(STRIP ${COMMIT_SHA} COMMIT_SHA)
    if(NOT COMMIT_SHA STREQUAL ${ARG_EXPECTED_COMMIT_SHA})
      message(FATAL_ERROR "The commit SHA should be '${ARG_EXPECTED_COMMIT_SHA}' but instead got '${COMMIT_SHA}'")
    endif()
  endif()
endfunction()

# Asserts whether a Git repository is checked out sparsely.
#
# Arguments:
#   - DIRECTORY: The path of the directory to check out the Git repository.
#
# Optional arguments:
#   - FILES: A list of files that should be checked out sparsely.
function(assert_git_sparse_checkout DIRECTORY)
  cmake_parse_arguments(ARG "" "" "FILES" ${ARGN})

  assert_git_complete_checkout(${DIRECTORY})

  file(GLOB FILES RELATIVE ${DIRECTORY} "${DIRECTORY}/**/*")
  list(FILTER FILES EXCLUDE REGEX ${DIRECTORY}/.git)
  foreach(FILE ${FILES})
    if(NOT FILE IN_LIST ARG_FILES)
      message(FATAL_ERROR "the '${FILE}' should not exist")
    endif()
  endforeach()
endfunction()
