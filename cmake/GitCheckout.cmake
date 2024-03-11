# This code is licensed under the terms of the MIT License.
# Copyright (c) 2024 Alfi Maulana

include_guard(GLOBAL)

# Set error with a specified message.
#
# If the `ERROR_VARIABLE` is specified, it will set the error message to that variable.
# Otherwise, it will print the error message and halt the execution.
#
# Arguments:
#   - MESSAGE: The error message.
macro(_set_error MESSAGE)
  cmake_parse_arguments(ARG "" "ERROR_VARIABLE" "" ${ARGN})
  if(ARG_ERROR_VARIABLE)
    set(${ARG_ERROR_VARIABLE} "${MESSAGE}" PARENT_SCOPE)
    return()
  else()
    message(FATAL_ERROR "${MESSAGE}")
  endif()
endmacro()

# Clones and checks out a Git repository from a remote location.
#
# If the `ERROR_VARIABLE` is specified, it will set the error message to that variable.
# Otherwise, it will print the error message and halt the execution.
#
# Arguments:
#   - URL: The URL of the remote Git repository.
#
# Optional arguments:
#   - DIRECTORY: The path of the directory to check out the Git repository.
#   - REF: The reference (branch, tag, or commit) to check out the Git repository.
function(git_checkout URL)
  cmake_parse_arguments(ARG "" "DIRECTORY;REF;ERROR_VARIABLE" "" ${ARGN})

  # Clones the Git repository.
  execute_process(
    COMMAND git clone --no-checkout ${URL} ${ARG_DIRECTORY}
    RESULT_VARIABLE RES
  )
  if(NOT RES EQUAL 0)
    _set_error(
      "Failed to clone '${URL}' (${RES})"
      ERROR_VARIABLE ${ARG_ERROR_VARIABLE}
    )
  endif()

  if(NOT DEFINED ARG_DIRECTORY)
    # Determines the directory of the cloned Git repository if it is not specified.
    string(REGEX REPLACE ".*/" "" ARG_DIRECTORY ${URL})
  endif()

  # Checks out the Git repository.
  execute_process(
    COMMAND git -C ${ARG_DIRECTORY} checkout ${ARG_REF}
    RESULT_VARIABLE RES
  )
  if(NOT RES EQUAL 0)
    _set_error(
      "Failed to check out '${ARG_DIRECTORY}' to '${ARG_REF}' (${RES})"
      ERROR_VARIABLE ${ARG_ERROR_VARIABLE}
    )
  endif()
endfunction()
