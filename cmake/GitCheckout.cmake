include_guard(GLOBAL)

# Clones and checks out a Git repository from a remote location.
#
# Arguments:
#   - URL: The URL of the remote Git repository.
function(git_checkout URL)
  execute_process(
    COMMAND git clone ${URL}
    RESULT_VARIABLE RES
  )
  if(NOT RES EQUAL 0)
    message(FATAL_ERROR "Failed to clone ${URL} (${RES})")
  endif()
endfunction()
