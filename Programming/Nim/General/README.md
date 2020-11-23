# Programming => Nim => Pointers and References

## Memory Structure
  - [General Example](pointersAndReferences.nim)
  - [Performance Comparison (Non-ARC vs ARC)](performanceNonARCvsARC.nim)
    - [Results](#results-of-performance-comparison)
      - Pointers and ref objects have similar performance, but ref objects are safer.
  - [See This](memoryStructure.nim)
    - **NOTE:** Heap variables require pointers to be mutated when using threads (or ref objects when using ARC/ORC).
```
┌───────────┬─────────┬─────────────────────────────────────────┬─────────────────────────────────────────┬──────────────┐
│ data type │ address │ repr                                    │ repr with ARC / ORC                     │ stack / heap │
├───────────┼─────────┼─────────────────────────────────────────┼─────────────────────────────────────────┼──────────────┤
│ char      │ 4411560 │ 'a'                                     │ 'a'                                     │ stack        │
├───────────┼─────────┼─────────────────────────────────────────┼─────────────────────────────────────────┼──────────────┤
│ string    │ 4538960 │ 000000000036F060"test"                  │ "test"                                  │ heap         │
├───────────┼─────────┼─────────────────────────────────────────┼─────────────────────────────────────────┼──────────────┤
│ int       │ 4411568 │ 1                                       │ 1                                       │ stack        │
├───────────┼─────────┼─────────────────────────────────────────┼─────────────────────────────────────────┼──────────────┤
│ float     │ 4411576 │ 1.0                                     │ 1.0                                     │ stack        │
├───────────┼─────────┼─────────────────────────────────────────┼─────────────────────────────────────────┼──────────────┤
│ seq       │ 4538944 │ 0000000000370050@[0, 1, 2, 3]           │ @[0, 1, 2, 3]                           │ heap         │
├───────────┼─────────┼─────────────────────────────────────────┼─────────────────────────────────────────┼──────────────┤
│ array     │ 4411584 │ [0, 1, 2, 3]                            │ [0, 1, 2, 3]                            │ stack        │
├───────────┼─────────┼─────────────────────────────────────────┼─────────────────────────────────────────┼──────────────┤
│ table     │ 4538976 │ [data = 0000000000371050@[[Field0 =     │ Table[system.int, system.int](data:     │ heap         │
│           │         │ 0,Field1 = 0,Field2 = 0], [Field0 =     │ @[(hcode: 0, key: 0, val: 0), (hcode:   │              │
│           │         │ 0,Field1 = 0,Field2 = 0], [Field0 =     │ 0, key: 0, val: 0), (hcode: 0, key: 0,  │              │
│           │         │ 0,Field1 = 0,Field2 = 0], [Field0 =     │ val: 0), (hcode: 0, key: 0, val: 0),    │              │
│           │         │ 0,Field1 = 0,Field2 = 0], [Field0 =     │ (hcode: 0, key: 0, val: 0), (hcode:     │              │
│           │         │ 0,Field1 = 0,Field2 = 0], [Field0 =     │ 8641844181895329213, key: 1, val: 1),   │              │
│           │         │ 8641844181895329213,Field1 = 1,Field2 = │ (hcode: 0, key: 0, val: 0), (hcode: 0,  │              │
│           │         │ 1], [Field0 = 0,Field1 = 0,Field2 = 0], │ key: 0, val: 0)], counter: 1)           │              │
│           │         │ [Field0 = 0,Field1 = 0,Field2 =         │                                         │              │
│           │         │ 0]],counter = 1]                        │                                         │              │
├───────────┼─────────┼─────────────────────────────────────────┼─────────────────────────────────────────┼──────────────┤
│ json      │ 4538848 │ ref 00000000003700D0 --> [JObjectfields │ JsonNode(isUnquoted: false, kind:       │ heap         │
│           │         │ = [data = 0000000000372050@[[Field0 =   │ JObject, fields:                        │              │
│           │         │ 0,Field1 = 0,Field2 = "",Field3 = nil], │ OrderedTable[system.string,             │              │
│           │         │ [Field0 = 0,Field1 = 0,Field2 =         │ json.JsonNode](data: @[(hcode: 0, next: │              │
│           │         │ "",Field3 = nil], [Field0 = 0,Field1 =  │ 0, key: "", val: nil), (hcode: 0, next: │              │
│           │         │ 0,Field2 = "",Field3 = nil], [Field0 =  │ 0, key: "", val: nil), (hcode: 0, next: │              │
│           │         │ 2484513939,Field1 = -1,Field2 =         │ 0, key: "", val: nil), (hcode:          │              │
│           │         │ 000000000036F0C0"1",Field3 = ref        │ 2484513939, next: -1, key: "1", val:    │              │
│           │         │ 0000000000370090 --> [JIntnum = 1]],    │ JsonNode(isUnquoted: false, kind: JInt, │              │
│           │         │ [Field0 = 0,Field1 = 0,Field2 =         │ num: 1)), (hcode: 0, next: 0, key: "",  │              │
│           │         │ "",Field3 = nil], [Field0 = 0,Field1 =  │ val: nil), (hcode: 0, next: 0, key: "", │              │
│           │         │ 0,Field2 = "",Field3 = nil], [Field0 =  │ val: nil), (hcode: 0, next: 0, key: "", │              │
│           │         │ 0,Field1 = 0,Field2 = "",Field3 = nil], │ val: nil), (hcode: 0, next: 0, key: "", │              │
│           │         │ [Field0 = 0,Field1 = 0,Field2 =         │ val: nil)], counter: 1, first: 3, last: │              │
│           │         │ "",Field3 = nil]],counter = 1,first =   │ 3))                                     │              │
│           │         │ 3,last = 3]]                            │                                         │              │
└───────────┴─────────┴─────────────────────────────────────────┴─────────────────────────────────────────┴──────────────┘
```

## Performance / Size optimization

### Several Flags can be passed to tweak performance and / or size

  ```
  -d:release              => Use for release builds. Disables run-time checks.

  -d:lto | --passL:-flto  => perform link time optimizations

  -d:useMalloc            => Disable Nims own memory allocator, reducing executable size. Enable use of Valgrind to detect memory leaks

  -d:passC:-march=native  => Instruct the compiler to use the best optimizations for your CPU (may not be compatible with other CPUs)
  ```

## Results of Performance Comparison

### ARC

```
$ nim c -r --threads:on -d:release -d:lto --gc:arc

Testing 100_000 iterations of regular object with copy
2020-11-20T17:05:45-06:00 TimeIt: 100000 Repetitions on 6 seconds, 119 milliseconds, 967 microseconds, and 600 nanoseconds, CPU Time 6.119.

Testing 100_000 iterations of direct mutation using pointer.
2020-11-20T17:05:50-06:00 TimeIt: 100000 Repetitions on 4 seconds, 977 milliseconds, 301 microseconds, and 400 nanoseconds, CPU Time 4.978.

Testing 100_000 iterations of direct mutation using reference object.
2020-11-20T17:05:53-06:00 TimeIt: 100000 Repetitions on 3 seconds, 606 milliseconds, 399 microseconds, and 700 nanoseconds, CPU Time 3.606.

100 - ((3.871 / 5.156) * 100) = 24.92242048
```

> ARC w/ptr => 18.64 % faster

> ARC w/ref => 41.06 % faster

### ORC
```
$ nim c -r --threads:on -d:release -d:lto --gc:orc

Testing 100_000 iterations of regular object with copy
2020-11-20T17:03:42-06:00 TimeIt: 100000 Repetitions on 3 seconds, 86 milliseconds, 220 microseconds, and 500 nanoseconds, CPU Time 3.086.

Testing 100_000 iterations of direct mutation using pointer.
2020-11-20T17:03:45-06:00 TimeIt: 100000 Repetitions on 2 seconds, 592 milliseconds, 353 microseconds, and 300 nanoseconds, CPU Time 2.592.

Testing 100_000 iterations of direct mutation using reference object.
2020-11-20T17:03:47-06:00 TimeIt: 100000 Repetitions on 2 seconds, 643 milliseconds, 999 microseconds, and 200 nanoseconds, CPU Time 2.644.

100 - ((2.837 / 4.809) * 100) = 41.00644625
```

> ORC w/ptr => 16.01 % faster

> ORC w/ref => 14.32 % faster