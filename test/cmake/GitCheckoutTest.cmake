cmake_minimum_required(VERSION 3.5)

file(
  DOWNLOAD https://threeal.github.io/assertion-cmake/main ${CMAKE_CURRENT_BINARY_DIR}/Assertion.cmake
  EXPECTED_MD5 3c9c0dd5e971bde719d7151c673e08b4
)
include(${CMAKE_CURRENT_BINARY_DIR}/Assertion.cmake)

include(${CMAKE_CURRENT_LIST_DIR}/Assertion.cmake)
include(GitCheckout)

function(test_check_out_a_git_repository)
  if(EXISTS project-starter)
    file(REMOVE_RECURSE project-starter)
  endif()

  git_checkout(https://github.com/threeal/project-starter)

  assert_git_complete_checkout(project-starter)
endfunction()

function(test_check_out_a_git_repository_into_an_existing_git_directory)
  test_check_out_a_git_repository()

  git_checkout(https://github.com/threeal/project-starter)

  assert_git_complete_checkout(project-starter)
endfunction()

function(test_check_out_a_git_repository_to_a_specific_directory)
  if(EXISTS some-directory)
    file(REMOVE_RECURSE some-directory)
  endif()

  git_checkout(https://github.com/threeal/project-starter DIRECTORY some-directory)

  assert_git_complete_checkout(some-directory)
endfunction()

function(test_check_out_a_git_repository_on_a_specific_ref)
  if(EXISTS project-starter)
    file(REMOVE_RECURSE project-starter)
  endif()

  git_checkout(https://github.com/threeal/project-starter REF 5a80d20)

  assert_git_complete_checkout(project-starter EXPECTED_COMMIT_SHA 5a80d20)
endfunction()

function(test_check_out_a_git_repository_on_a_specific_invalid_ref)
  if(EXISTS project-starter)
    file(REMOVE_RECURSE project-starter)
  endif()

  mock_message()
    git_checkout(https://github.com/threeal/project-starter REF invalid-ref)
  end_mock_message()

  assert_message(FATAL_ERROR "Failed to check out '${CMAKE_CURRENT_BINARY_DIR}/project-starter' to 'invalid-ref' (1)")
endfunction()

function(test_check_out_a_git_repository_into_an_existing_git_directory_on_a_specific_ref)
  test_check_out_a_git_repository_on_a_specific_ref()

  git_checkout(https://github.com/threeal/project-starter REF 316dec5)

  assert_git_complete_checkout(project-starter EXPECTED_COMMIT_SHA 316dec5)
endfunction()

function(test_check_out_a_git_repository_sparsely)
  if(EXISTS opencv)
    file(REMOVE_RECURSE opencv)
  endif()

  git_checkout(https://github.com/opencv/opencv SPARSE_CHECKOUT modules/core samples/gpu)

  assert_git_sparse_checkout(opencv FILES modules/core samples/gpu)
endfunction()

function(test_check_out_a_git_repository_into_an_existing_git_directory_sparsely)
  test_check_out_a_git_repository_sparsely()

  git_checkout(https://github.com/opencv/opencv SPARSE_CHECKOUT modules/core modules/imgproc)

  assert_git_sparse_checkout(opencv FILES modules/core modules/imgproc)
endfunction()

if(NOT DEFINED TEST_COMMAND)
  message(FATAL_ERROR "The 'TEST_COMMAND' variable should be defined")
elseif(NOT COMMAND test_${TEST_COMMAND})
  message(FATAL_ERROR "Unable to find a command named 'test_${TEST_COMMAND}'")
endif()

cmake_language(CALL test_${TEST_COMMAND})
