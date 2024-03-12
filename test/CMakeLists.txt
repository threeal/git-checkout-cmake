function(add_cmake_test FILE)
  foreach(NAME ${ARGN})
    add_test(
      NAME ${NAME}
      COMMAND ${CMAKE_COMMAND}
        -D CMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}
        -D TEST_MATCHES=^${NAME}$
        -P ${CMAKE_CURRENT_SOURCE_DIR}/${FILE}
    )
  endforeach()
endfunction()

add_cmake_test(
  SetErrorTest.cmake
  "Set error"
  "Set error with variable specified"
)

add_cmake_test(
  GitCloneTest.cmake
  "Incompletely clone a Git repository"
  "Incompletely clone an invalid Git repository"
  "Incompletely clone a Git repository to a specific directory"
)

add_cmake_test(
  GitCheckoutTest.cmake
  "Check out a Git repository"
  "Check out a Git repository to a specific directory"
  "Check out a Git repository on a specific ref"
  "Check out a Git repository on a specific invalid ref"
  "Check out a Git repository sparsely"
)
