# Asserts whether a Git repository is checked out completely.
#
# Arguments:
#   - DIRECTORY: The path of the directory to check out the Git repository.
function(assert_git_complete_checkout DIRECTORY)
  if(NOT EXISTS ${DIRECTORY})
    message(FATAL_ERROR "the '${DIRECTORY}' directory should exist")
  endif()

  execute_process(
    COMMAND git -C ${DIRECTORY} diff --no-patch --exit-code HEAD
    RESULT_VARIABLE RES
  )
  if(NOT RES EQUAL 0)
    message(FATAL_ERROR "the repository should be checked out completely (${RES})")
  endif()
endfunction()
