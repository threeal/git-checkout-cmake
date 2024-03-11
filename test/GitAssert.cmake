# Asserts whether a Git repository is checked out completely.
#
# Arguments:
#   - DIRECTORY: The path of the directory to check out the Git repository.
function(assert_git_complete_checkout DIRECTORY)
  if(NOT EXISTS ${DIRECTORY})
    message(FATAL_ERROR "the '${DIRECTORY}' directory should exist")
  endif()
endfunction()
