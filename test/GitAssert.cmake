cmake_minimum_required(VERSION 3.3)

# Asserts whether the given path is a Git directory.
#
# It asserts whether the given path exists and is a directory.
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
endfunction()

# Asserts whether a Git repository is checked out completely.
#
# Arguments:
#   - DIRECTORY: The path of the directory to check out the Git repository.
function(assert_git_complete_checkout DIRECTORY)
  _assert_git_directory(${DIRECTORY})

  execute_process(
    COMMAND git -C ${DIRECTORY} diff --no-patch --exit-code HEAD
    RESULT_VARIABLE RES
  )
  if(NOT RES EQUAL 0)
    message(FATAL_ERROR "the repository should be checked out completely (${RES})")
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
