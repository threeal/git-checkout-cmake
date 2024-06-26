include_guard(GLOBAL)

file(
  DOWNLOAD https://threeal.github.io/assertion-cmake/v0.2.0
    ${CMAKE_BINARY_DIR}/Assertion.cmake
  EXPECTED_MD5 4ee0e5217b07442d1a31c46e78bb5fac
)
include(${CMAKE_BINARY_DIR}/Assertion.cmake)

find_package(GitCheckout REQUIRED PATHS ${CMAKE_CURRENT_LIST_DIR}/../../cmake)
include(GitCheckout)

# Asserts whether the given path is a Git directory.
#
# It asserts whether the given path exists, is a directory, and contains a Git repository.
#
# Arguments:
#   - PATH: The path to check.
function(_assert_git_directory PATH)
  assert(EXISTS "${PATH}")
  assert(IS_DIRECTORY "${PATH}")

  _find_git()

  execute_process(
    COMMAND "${GIT_EXECUTABLE}" -C "${PATH}" status
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
  _assert_git_directory("${PATH}")

  _find_git()

  execute_process(
    COMMAND "${GIT_EXECUTABLE}" -C "${PATH}" diff --no-patch --exit-code HEAD
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
  cmake_parse_arguments(PARSE_ARGV 1 ARG "" EXPECTED_COMMIT_SHA "")

  _assert_git_directory("${DIRECTORY}")

  _find_git()

  execute_process(
    COMMAND "${GIT_EXECUTABLE}" -C "${DIRECTORY}" diff --no-patch --exit-code HEAD
    RESULT_VARIABLE RES
  )
  if(NOT RES EQUAL 0)
    message(FATAL_ERROR "the repository should be checked out completely (${RES})")
  endif()

  if(DEFINED ARG_EXPECTED_COMMIT_SHA)
    execute_process(
      COMMAND "${GIT_EXECUTABLE}" -C "${DIRECTORY}" rev-parse --short HEAD
      OUTPUT_VARIABLE COMMIT_SHA
    )
    string(STRIP "${COMMIT_SHA}" COMMIT_SHA)
    assert(COMMIT_SHA STREQUAL ARG_EXPECTED_COMMIT_SHA)
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
  cmake_parse_arguments(PARSE_ARGV 1 ARG "" "" "FILES")

  assert_git_complete_checkout("${DIRECTORY}")

  file(GLOB FILES RELATIVE "${DIRECTORY}" "${DIRECTORY}/**/*")
  list(FILTER FILES EXCLUDE REGEX ${DIRECTORY}/.git)
  foreach(FILE ${FILES})
    if(NOT FILE IN_LIST ARG_FILES)
      message(FATAL_ERROR "the '${FILE}' should not exist")
    endif()
  endforeach()
endfunction()
