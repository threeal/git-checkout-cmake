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
  GitCheckoutTest.cmake
  "Check out a Git repository"
)
