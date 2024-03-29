# This code is licensed under the terms of the MIT License.
# Copyright (c) 2024 Alfi Maulana

include_guard(GLOBAL)

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

  if(EXISTS ${ARG_DIRECTORY})
    message(FATAL_ERROR "Unable to clone '${URL}' to '${ARG_DIRECTORY}' because the path already exists")
  endif()

  execute_process(
    COMMAND git clone --filter=blob:none --no-checkout ${URL} ${ARG_DIRECTORY}
    RESULT_VARIABLE RES
  )
  if(NOT RES EQUAL 0)
    message(FATAL_ERROR "Failed to clone '${URL}' (${RES})")
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

  if(ARG_SPARSE_CHECKOUT)
    execute_process(
      COMMAND git -C ${ARG_DIRECTORY} sparse-checkout set ${ARG_SPARSE_CHECKOUT}
      RESULT_VARIABLE RES
    )
    if(NOT RES EQUAL 0)
      message(FATAL_ERROR "Failed to sparse checkout '${ARG_DIRECTORY}' (${RES})")
    endif()
  endif()

  # Checks out the Git repository.
  execute_process(
    COMMAND git -C ${ARG_DIRECTORY} checkout ${ARG_REF}
    RESULT_VARIABLE RES
  )
  if(NOT RES EQUAL 0)
    message(FATAL_ERROR "Failed to check out '${ARG_DIRECTORY}' to '${ARG_REF}' (${RES})")
  endif()
endfunction()
