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
#   - REF: The reference (branch, tag, or commit) to check out the Git repository.
function(git_checkout URL)
  cmake_parse_arguments(ARG "" "REF;ERROR_VARIABLE" "" ${ARGN})

  # Clones the Git repository.
  execute_process(
    COMMAND git clone ${URL}
    RESULT_VARIABLE RES
  )
  if(NOT RES EQUAL 0)
    _set_error(
      "Failed to clone '${URL}' (${RES})"
      ERROR_VARIABLE ${ARG_ERROR_VARIABLE}
    )
  endif()

  # Determines the directory of the cloned Git repository.
  string(REGEX REPLACE ".*/" "" GIT_DIR ${URL})

  if(ARG_REF)
    # Checks out the Git repository to a specific reference.
    execute_process(
      COMMAND git -C ${GIT_DIR} checkout ${ARG_REF}
      RESULT_VARIABLE RES
    )
    if(NOT RES EQUAL 0)
      _set_error(
        "Failed to check out '${GIT_DIR}' to '${ARG_REF}' (${RES})"
        ERROR_VARIABLE ${ARG_ERROR_VARIABLE}
      )
    endif()
  endif()
endfunction()
