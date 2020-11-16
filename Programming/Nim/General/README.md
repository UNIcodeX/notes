## Performance / Size optimization

### Several Flags can be passed to tweak performance and / or size

  ```
  -d:release              => Use for release builds. Disables run-time checks.

  -d:lto | --passL:-flto  => perform link time optimizations

  -d:useMalloc            => Disable Nims own memory allocator, reducing executable size. Enable use of Valgrind to detect memory leaks

  -d:passC:-march=native  => Instruct the compiler to use the best optimizations for your CPU (may not be compatible with other CPUs)
  ```