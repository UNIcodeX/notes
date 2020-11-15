# nim c -r --threads:on

## Reference:
## https://nim-lang.org/docs/threads.html#examples

import os, locks

var
  threadArray : array[4, Thread[int]]
  global = 0
  s : string
  ps : ptr string
  L: Lock

ps = addr s

proc worker(i:int) {.thread.} =
  sleep 1000
  echo "adding ", $i, " to `global`"
  acquire L
  global += i
  ps[].add $i
  release L


initLock(L)

for i in 0..threadArray.high:
  createThread(threadArray[i], worker, i)

joinThreads(threadArray)

echo "total is ", $global
echo s