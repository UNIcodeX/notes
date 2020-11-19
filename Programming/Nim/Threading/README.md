## Threading

### Examples for using threads
  - [Mutate Global Variable](threadingMutateGlobal.nim)
  - [Mutate Using Pointer (Mutate String)](threadingMutatePointer.nim)
  - [No Variable Mutation](threadingNoMutate.nim)
  - [Spawn - Example 1](spawnExample1.nim)
  - [Spawn - Threadpool work queue](threadpoolWorkQueue.nim)
  - [Threaded Server with Prompt](threadedServerWithPrompt.nim)

### Things of Note

  - `spawn` requires `import threadpool`, but removes the need to manually setup the `var myThread : Thread[{type}]` target.
  - `spawn` allows retrieval of a value from a threaded process, by way of the carat (^) operator.
    - There may be a way to retrieve data from a manually created thread I am not aware of yet.
  - HOWEVER, manually setting up the `Thread[{type}]` and using `createThread({thread}, {proc}, {proc_args})` will afford ability to manually specify processor core pinning.
    - Unsure if one can specify processor pinning with `spawn`.
