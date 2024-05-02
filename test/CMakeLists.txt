function(add_cmake_test FILE)
  foreach(NAME ${ARGN})
    string(TOLOWER ${NAME} TEST_COMMAND)
    string(REPLACE " " "_" TEST_COMMAND ${TEST_COMMAND})
    add_test(
      NAME ${NAME}
      COMMAND ${CMAKE_COMMAND}
        -D CMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}
        -D TEST_COMMAND=${TEST_COMMAND}
        -P ${CMAKE_CURRENT_SOURCE_DIR}/${FILE}
    )
  endforeach()
endfunction()

add_cmake_test(
  cmake/GitOtherTest.cmake
  "Find the Git executable"
  "Get the Git check out directory with a directory provided"
  "Get the Git check out directory without any directory provided"
)

add_cmake_test(
  cmake/GitCloneTest.cmake
  "Incompletely clone a Git repository"
  "Incompletely clone a Git repository into an existing Git directory"
  "Incompletely clone a Git repository into an existing path"
  "Incompletely clone an invalid Git repository"
)

add_cmake_test(
  cmake/GitCheckoutTest.cmake
  "Check out a Git repository"
  "Check out a Git repository into an existing Git directory"
  "Check out a Git repository to a specific directory"
  "Check out a Git repository on a specific ref"
  "Check out a Git repository on a specific invalid ref"
  "Check out a Git repository into an existing Git directory on a specific ref"
  "Check out a Git repository sparsely"
  "Check out a Git repository into an existing Git directory sparsely"
)
