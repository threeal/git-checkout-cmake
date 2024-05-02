# This code is licensed under the terms of the MIT License.
# Copyright (c) 2024 Alfi Maulana

include_guard(GLOBAL)

# Find the Git executable.
#
# It will set the 'GIT_EXECUTABLE' variable to the location of the Git executable.
function(_find_git)
  if(NOT DEFINED GIT_EXECUTABLE)
    find_package(Git)
    if(NOT Git_FOUND OR NOT DEFINED GIT_EXECUTABLE)
      message(FATAL_ERROR "Git could not be found")
    endif()
    set(GIT_EXECUTABLE "${GIT_EXECUTABLE}" PARENT_SCOPE)
  endif()
endfunction()

# Gets the path of the directory to check out the Git repository.
#
# If the 'DIRECTORY' argument is empty, it will set the 'OUTPUT' argument based on the location of the remote Git
# repository. Otherwise, it will set the 'OUTPUT' argument with the same value as the 'DIRECTORY' argument.
#
# If the output path of the directory is not an absolute path, it will convert it to an absolute path relative to the
# current CMake binary directory.
#
# Arguments:
#   - URL: The URL of the remote Git repository.
#   - DIRECTORY: The path of the directory to check out the Git repository.
#   - OUTPUT: The output variable that will be set with the path of the directory to check out the Git repository.
function(_get_git_checkout_directory URL DIRECTORY OUTPUT)
  if(DIRECTORY STREQUAL "")
    string(REGEX REPLACE ".*/" "" DIRECTORY "${URL}")
  endif()

  if(NOT IS_ABSOLUTE "${DIRECTORY}")
    set(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${DIRECTORY})
  endif()

  set("${OUTPUT}" "${DIRECTORY}" PARENT_SCOPE)
endfunction()

# Incompletely clones a Git repository from a remote location.
#
# It incompletely clones a Git repository to a specified directory without checking out any files.
#
# Arguments:
#   - URL: The URL of the remote Git repository.
#   - DIRECTORY: The path of the directory to check out the Git repository.
function(_git_incomplete_clone URL DIRECTORY)
  _find_git()

  if(EXISTS "${DIRECTORY}")
    execute_process(
      COMMAND "${GIT_EXECUTABLE}" -C "${DIRECTORY}" rev-parse --is-inside-work-tree
      RESULT_VARIABLE RES
    )
    if(NOT RES EQUAL 0)
      message(FATAL_ERROR "Unable to clone '${URL}' to '${DIRECTORY}' because the path already exists and is not a Git repository")
    endif()
  else()
    execute_process(
      COMMAND "${GIT_EXECUTABLE}" clone --filter=blob:none --no-checkout "${URL}" "${DIRECTORY}"
      RESULT_VARIABLE RES
    )
    if(NOT RES EQUAL 0)
      message(FATAL_ERROR "Failed to clone '${URL}' (${RES})")
    endif()
  endif()
endfunction()

# Clones and checks out a Git repository from a remote location.
#
# Arguments:
#   - URL: The URL of the remote Git repository.
#
# Optional arguments:
#   - DIRECTORY: The path of the directory to check out the Git repository.
#   - REF: The reference (branch, tag, or commit) to check out the Git repository.
#   - SPARSE_CHECKOUT: A list of files to check out sparsely.
function(git_checkout URL)
  cmake_parse_arguments(ARG "" "DIRECTORY;REF" "SPARSE_CHECKOUT" ${ARGN})

  _get_git_checkout_directory("${URL}" "${ARG_DIRECTORY}" ARG_DIRECTORY)

  _git_incomplete_clone("${URL}" "${ARG_DIRECTORY}")

  _find_git()

  if(ARG_SPARSE_CHECKOUT)
    execute_process(
      COMMAND "${GIT_EXECUTABLE}" -C "${ARG_DIRECTORY}" sparse-checkout set ${ARG_SPARSE_CHECKOUT}
      RESULT_VARIABLE RES
    )
    if(NOT RES EQUAL 0)
      message(FATAL_ERROR "Failed to sparse checkout '${ARG_DIRECTORY}' (${RES})")
    endif()
  endif()

  # Checks out the Git repository.
  execute_process(
    COMMAND "${GIT_EXECUTABLE}" -C "${ARG_DIRECTORY}" checkout ${ARG_REF}
    RESULT_VARIABLE RES
  )
  if(NOT RES EQUAL 0)
    message(FATAL_ERROR "Failed to check out '${ARG_DIRECTORY}' to '${ARG_REF}' (${RES})")
  endif()
endfunction()
