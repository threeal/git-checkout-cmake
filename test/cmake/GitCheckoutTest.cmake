cmake_minimum_required(VERSION 3.5)

include(${CMAKE_CURRENT_LIST_DIR}/Assertion.cmake)

find_package(GitCheckout REQUIRED PATHS ${CMAKE_CURRENT_LIST_DIR}/../../cmake)

section("it should check out a Git repository")
  if(EXISTS project-starter)
    file(REMOVE_RECURSE project-starter)
  endif()

  git_checkout(https://github.com/threeal/project-starter)

  assert_git_complete_checkout(project-starter)
endsection()

function("Check out a Git repository into an existing Git directory")
  cmake_language(CALL "Check out a Git repository")

  git_checkout(https://github.com/threeal/project-starter)

  assert_git_complete_checkout(project-starter)
endfunction()

function("Check out a Git repository to a specific directory")
  if(EXISTS some-directory)
    file(REMOVE_RECURSE some-directory)
  endif()

  git_checkout(https://github.com/threeal/project-starter DIRECTORY some-directory)

  assert_git_complete_checkout(some-directory)
endfunction()

function("Check out a Git repository on a specific ref")
  if(EXISTS project-starter)
    file(REMOVE_RECURSE project-starter)
  endif()

  git_checkout(https://github.com/threeal/project-starter REF 5a80d20)

  assert_git_complete_checkout(project-starter EXPECTED_COMMIT_SHA 5a80d20)
endfunction()

function("Check out a Git repository on a specific invalid ref")
  if(EXISTS project-starter)
    file(REMOVE_RECURSE project-starter)
  endif()

  assert_fatal_error(
    CALL git_checkout https://github.com/threeal/project-starter REF invalid-ref
    MESSAGE "Failed to check out '${CMAKE_CURRENT_BINARY_DIR}/project-starter' to 'invalid-ref'")
endfunction()

function("Check out a Git repository into an existing Git directory on a specific ref")
  cmake_language(CALL "Check out a Git repository on a specific invalid ref")

  git_checkout(https://github.com/threeal/project-starter REF 316dec5)

  assert_git_complete_checkout(project-starter EXPECTED_COMMIT_SHA 316dec5)
endfunction()

function("Check out a Git repository sparsely")
  if(EXISTS opencv)
    file(REMOVE_RECURSE opencv)
  endif()

  git_checkout(https://github.com/opencv/opencv SPARSE_CHECKOUT modules/core samples/gpu)

  assert_git_sparse_checkout(opencv FILES modules/core samples/gpu)
endfunction()

function("Check out a Git repository into an existing Git directory sparsely")
  cmake_language(CALL "Check out a Git repository sparsely")

  git_checkout(https://github.com/opencv/opencv SPARSE_CHECKOUT modules/core modules/imgproc)

  assert_git_sparse_checkout(opencv FILES modules/core modules/imgproc)
endfunction()

cmake_language(CALL "${TEST_COMMAND}")
