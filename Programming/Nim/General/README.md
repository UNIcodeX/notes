## Memory Structure
  - [See This](memoryStructure.nim)
  - **NOTE:** Heap variables require pointers to be mutated when using threads.
```
┌───────────┬─────────┬─────────────────────────────────────────┬──────────────┐
│ data type │ address │ repr                                    │ stack / heap │
├───────────┼─────────┼─────────────────────────────────────────┼──────────────┤
│ char      │ 4411560 │ 'a'                                     │ stack        │
├───────────┼─────────┼─────────────────────────────────────────┼──────────────┤
│ string    │ 4538960 │ 000000000036F060"test"                  │ heap         │
├───────────┼─────────┼─────────────────────────────────────────┼──────────────┤
│ int       │ 4411568 │ 1                                       │ stack        │
├───────────┼─────────┼─────────────────────────────────────────┼──────────────┤
│ float     │ 4411576 │ 1.0                                     │ stack        │
├───────────┼─────────┼─────────────────────────────────────────┼──────────────┤
│ seq       │ 4538944 │ 0000000000370050@[0, 1, 2, 3]           │ heap         │
├───────────┼─────────┼─────────────────────────────────────────┼──────────────┤
│ array     │ 4411584 │ [0, 1, 2, 3]                            │ stack        │
├───────────┼─────────┼─────────────────────────────────────────┼──────────────┤
│ table     │ 4538976 │ [data = 0000000000371050@[[Field0 =     │ heap         │
│           │         │ 0,Field1 = 0,Field2 = 0], [Field0 =     │              │
│           │         │ 0,Field1 = 0,Field2 = 0], [Field0 =     │              │
│           │         │ 0,Field1 = 0,Field2 = 0], [Field0 =     │              │
│           │         │ 0,Field1 = 0,Field2 = 0], [Field0 =     │              │
│           │         │ 0,Field1 = 0,Field2 = 0], [Field0 =     │              │
│           │         │ 8641844181895329213,Field1 = 1,Field2 = │              │
│           │         │ 1], [Field0 = 0,Field1 = 0,Field2 = 0], │              │
│           │         │ [Field0 = 0,Field1 = 0,Field2 =         │              │
│           │         │ 0]],counter = 1]                        │              │
├───────────┼─────────┼─────────────────────────────────────────┼──────────────┤
│ json      │ 4538848 │ ref 00000000003700D0 --> [JObjectfields │ heap         │
│           │         │ = [data = 0000000000372050@[[Field0 =   │              │
│           │         │ 0,Field1 = 0,Field2 = "",Field3 = nil], │              │
│           │         │ [Field0 = 0,Field1 = 0,Field2 =         │              │
│           │         │ "",Field3 = nil], [Field0 = 0,Field1 =  │              │
│           │         │ 0,Field2 = "",Field3 = nil], [Field0 =  │              │
│           │         │ 2484513939,Field1 = -1,Field2 =         │              │
│           │         │ 000000000036F0C0"1",Field3 = ref        │              │
│           │         │ 0000000000370090 --> [JIntnum = 1]],    │              │
│           │         │ [Field0 = 0,Field1 = 0,Field2 =         │              │
│           │         │ "",Field3 = nil], [Field0 = 0,Field1 =  │              │
│           │         │ 0,Field2 = "",Field3 = nil], [Field0 =  │              │
│           │         │ 0,Field1 = 0,Field2 = "",Field3 = nil], │              │
│           │         │ [Field0 = 0,Field1 = 0,Field2 =         │              │
│           │         │ "",Field3 = nil]],counter = 1,first =   │              │
│           │         │ 3,last = 3]]                            │              │
└───────────┴─────────┴─────────────────────────────────────────┴──────────────┘

```

## Performance / Size optimization

### Several Flags can be passed to tweak performance and / or size

  ```
  -d:release              => Use for release builds. Disables run-time checks.

  -d:lto | --passL:-flto  => perform link time optimizations

  -d:useMalloc            => Disable Nims own memory allocator, reducing executable size. Enable use of Valgrind to detect memory leaks

  -d:passC:-march=native  => Instruct the compiler to use the best optimizations for your CPU (may not be compatible with other CPUs)
  ```