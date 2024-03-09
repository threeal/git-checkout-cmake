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
function(git_checkout URL)
  cmake_parse_arguments(ARG "" "ERROR_VARIABLE" "" ${ARGN})
  execute_process(
    COMMAND git clone ${URL}
    RESULT_VARIABLE RES
  )
  if(NOT RES EQUAL 0)
    _set_error(
      "Failed to clone ${URL} (${RES})"
      ERROR_VARIABLE ${ARG_ERROR_VARIABLE}
    )
  endif()
endfunction()
