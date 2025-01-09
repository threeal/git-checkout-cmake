# GitCheckout.cmake

Clone and check out a [Git](https://git-scm.com/) repository from a [CMake](https://cmake.org/) project.

This module contains a `git_checkout` function for cloning a Git repository from a remote location and checking out the files based on the given reference, which can be a commit hash, branch, or tag.
It also supports sparse checkout for checking out specific files from a large repository.

## Key Features

- Cloning a Git repository from a remote location.
- Checking out a Git repository on a specific reference.
- Support for sparse checkout.

## Integration

This module can be integrated into a CMake project in the following ways:

- Manually download the [`GitCheckout.cmake`](./cmake/GitCheckout.cmake) file and include it in the CMake project:
  ```cmake
  include(path/to/GitCheckout.cmake)
  ```
- Use [`file(DOWNLOAD)`](https://cmake.org/cmake/help/latest/command/file.html#download) to automatically download the `GitCheckout.cmake` file:
  ```cmake
  file(
    DOWNLOAD https://threeal.github.io/git-checkout-cmake/v1.1.0
    ${CMAKE_BINARY_DIR}/GitCheckout.cmake
  )
  include(${CMAKE_BINARY_DIR}/GitCheckout.cmake)
  ```
- Use [CPM.cmake](https://github.com/cpm-cmake/CPM.cmake) to add this package to the CMake project:
  ```cmake
  cpmaddpackage(gh:threeal/git-checkout-cmake@1.1.0)
  ```

## Example Usages

This example demonstrates how to clone and check out a Git repository hosted on GitHub:

```cmake
git_checkout("https://github.com/user/project")
```

### Specify Output Directory

Use the `DIRECTORY` option to specify the output directory for cloning the Git repository:

```cmake
git_checkout(
  "https://github.com/user/project"
  DIRECTORY path/to/output
)
```

### Specify Checkout Reference

By default, a Git repository will be checked out on the default branch. To check out on a specific commit hash, branch, or tag, use the `REF` option:

```cmake
git_checkout(
  "https://github.com/user/project"
  REF latest
)
```

### Use Sparse Checkout

To save bandwidth, it is recommended to use a sparse checkout to check out only specific files from the Git repository, especially on a large repository.
To do this, use the `SPARSE_CHECKOUT` option to list patterns of files to be checked out sparsely:

```cmake
git_checkout(
  "https://github.com/user/project"
  SPARSE_CHECKOUT src test
)
```

## License

This project is licensed under the terms of the [MIT License](./LICENSE).

Copyright © 2024-2025 [Alfi Maulana](https://github.com/threeal)
