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
    set(GIT_EXECUTABLE ${GIT_EXECUTABLE} PARENT_SCOPE)
  endif()
endfunction()

# Incompletely clones a Git repository from a remote location.
#
# It incompletely clones the Git repository to a specified directory without
# checking out any files from the repository.
#
# Arguments:
#   - URL: The URL of the remote Git repository.
#
# Optional arguments:
#   - DIRECTORY: The path of the directory to check out the Git repository.
function(_git_incomplete_clone URL)
  cmake_parse_arguments(ARG "" "DIRECTORY" "" ${ARGN})

  if(NOT DEFINED ARG_DIRECTORY)
    # Determines the directory of the cloned Git repository if it is not specified.
    string(REGEX REPLACE ".*/" "" ARG_DIRECTORY ${URL})
  endif()

  _find_git()

  if(EXISTS ${ARG_DIRECTORY})
    execute_process(
      COMMAND ${GIT_EXECUTABLE} -C ${ARG_DIRECTORY} rev-parse --is-inside-work-tree
      RESULT_VARIABLE RES
    )
    if(NOT RES EQUAL 0)
      message(FATAL_ERROR "Unable to clone '${URL}' to '${ARG_DIRECTORY}' because the path already exists and is not a Git repository")
    endif()
  else()
    execute_process(
      COMMAND ${GIT_EXECUTABLE} clone --filter=blob:none --no-checkout ${URL} ${ARG_DIRECTORY}
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

  _git_incomplete_clone(${URL} DIRECTORY ${ARG_DIRECTORY})

  if(NOT DEFINED ARG_DIRECTORY)
    # Determines the directory of the cloned Git repository if it is not specified.
    string(REGEX REPLACE ".*/" "" ARG_DIRECTORY ${URL})
  endif()

  _find_git()

  if(ARG_SPARSE_CHECKOUT)
    execute_process(
      COMMAND ${GIT_EXECUTABLE} -C ${ARG_DIRECTORY} sparse-checkout set ${ARG_SPARSE_CHECKOUT}
      RESULT_VARIABLE RES
    )
    if(NOT RES EQUAL 0)
      message(FATAL_ERROR "Failed to sparse checkout '${ARG_DIRECTORY}' (${RES})")
    endif()
  endif()

  # Checks out the Git repository.
  execute_process(
    COMMAND ${GIT_EXECUTABLE} -C ${ARG_DIRECTORY} checkout ${ARG_REF}
    RESULT_VARIABLE RES
  )
  if(NOT RES EQUAL 0)
    message(FATAL_ERROR "Failed to check out '${ARG_DIRECTORY}' to '${ARG_REF}' (${RES})")
  endif()
endfunction()
