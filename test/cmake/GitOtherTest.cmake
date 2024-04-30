list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})

include(GitCheckout)

function(test_find_the_git_executable)
  _find_git()

  if(NOT DEFINED GIT_EXECUTABLE)
    message(FATAL_ERROR "The 'GIT_EXECUTABLE' variable should be defined")
  elseif(NOT EXISTS ${GIT_EXECUTABLE})
    message(FATAL_ERROR "The Git executable should exist at '${GIT_EXECUTABLE}'")
  endif()
endfunction()

function(test_get_the_git_check_out_directory_with_a_directory_provided)
  _get_git_checkout_directory(https://github.com/threeal/project-starter some-directory DIRECTORY)

  if(NOT DEFINED DIRECTORY)
    message(FATAL_ERROR "The 'DIRECTORY' variable should be defined")
  elseif(NOT DIRECTORY STREQUAL some-directory)
    message(FATAL_ERROR "The Git check out directory should be set to 'some-directory' but instead got '${DIRECTORY}'")
  endif()
endfunction()

function(test_get_the_git_check_out_directory_without_any_directory_provided)
  _get_git_checkout_directory(https://github.com/threeal/project-starter "" DIRECTORY)

  if(NOT DEFINED DIRECTORY)
    message(FATAL_ERROR "The 'DIRECTORY' variable should be defined")
  elseif(NOT DIRECTORY STREQUAL project-starter)
    message(FATAL_ERROR "The Git check out directory should be set to 'project-starter' but instead got '${DIRECTORY}'")
  endif()
endfunction()

if(NOT DEFINED TEST_COMMAND)
  message(FATAL_ERROR "The 'TEST_COMMAND' variable should be defined")
elseif(NOT COMMAND test_${TEST_COMMAND})
  message(FATAL_ERROR "Unable to find a command named 'test_${TEST_COMMAND}'")
endif()

cmake_language(CALL test_${TEST_COMMAND})
