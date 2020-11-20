import threadpool, pylib


proc testObject() = 
  type
    MyType = object
      i: int

  var 
    mt = MyType()

  proc test(mt:MyType): MyType =
    var mt = mt                   # Work-around for -- Error: 'spawn'ed function cannot have a 'var' parameter
    inc mt.i
    mt                            # Implicit `result = mt`. Could also `return mt`.

  assert mt.i == 0

  let res = spawn test(mt)
  sync()

  mt = ^res                       # Copy spawned MyType object into global
  assert mt.i == 1

echo "\nTesting 100_000 iterations of regular object with copy"
timeit 100_000:
  testObject()


proc testPointer() = 
  type
    MyType = object
      i: int

  var 
    rt = MyType()
    mt : ptr MyType
  
  mt = addr rt

  proc test(mt:ptr MyType) =
    inc mt[].i

  assert mt.i == 0

  spawn test(mt)
  sync()

  assert mt.i == 1, "=> mt.i is != 1"   
  # As expected, this fails assertion with GCs refc, markAndSweep
  # Works flawlessly with ARC/ORC. :+1:

echo "\nTesting 100_000 iterations of direct mutation using pointer."
timeit 100_000:
  testPointer()


when compileOption("gc", "arc") or compileOption("gc", "orc"):
  proc testRefObject() = 
    type
      MyType = object
        i: int

      RMyType = ref MyType

    var 
      mt = new RMyType

    proc test(mt:RMyType) =
      inc mt.i

    assert mt.i == 0

    spawn test(mt)
    sync()

    assert mt.i == 1, "=> mt.i is != 1"   
    # As expected, this fails assertion with GCs refc, markAndSweep
    # Works flawlessly with ARC/ORC. :+1:

  echo "\nTesting 100_000 iterations of direct mutation using reference object."
  timeit 100_000:
    testRefObject()

else:
  echo "\nSkipping reference object test (will fail without ARC/ORC)."

