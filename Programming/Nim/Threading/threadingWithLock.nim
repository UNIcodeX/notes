# nim c -r --threads:on

## Reference:
## https://nim-lang.org/docs/threads.html#examples

import os, locks

var
  threadArray : array[4, Thread[int]]
  global = 0
  L: Lock

proc worker(i:int) {.thread.} =
  sleep 1
  acquire L
  echo "adding ", $i, " to `global`"
  global += i
  release L


initLock(L)

for i in 0..threadArray.high:
  createThread(threadArray[i], worker, i)

joinThreads(threadArray)

echo "total is ", $global