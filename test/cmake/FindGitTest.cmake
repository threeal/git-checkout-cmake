list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})

include(GitCheckout)

function(find_the_git_executable)
  _find_git()

  if(NOT DEFINED GIT_EXECUTABLE)
    message(FATAL_ERROR "The 'GIT_EXECUTABLE' variable should be defined")
  elseif(NOT EXISTS ${GIT_EXECUTABLE})
    message(FATAL_ERROR "The Git executable should exist at '${GIT_EXECUTABLE}'")
  endif()
endfunction()

if(NOT DEFINED TEST_COMMAND)
  message(FATAL_ERROR "The 'TEST_COMMAND' variable should be defined")
elseif(NOT COMMAND ${TEST_COMMAND})
  message(FATAL_ERROR "Unable to find a command named '${TEST_COMMAND}'")
endif()

cmake_language(CALL ${TEST_COMMAND})
