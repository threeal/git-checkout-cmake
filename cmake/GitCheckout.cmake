include_guard(GLOBAL)

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
    if(ARG_ERROR_VARIABLE)
      set(${ARG_ERROR_VARIABLE} "Failed to clone ${URL} (${RES})" PARENT_SCOPE)
    else()
      message(FATAL_ERROR "Failed to clone ${URL} (${RES})")
    endif()
  endif()
endfunction()
