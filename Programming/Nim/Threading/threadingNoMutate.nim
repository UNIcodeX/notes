# nim c -r --threads:on

## Reference:
## https://nim-lang.org/docs/threads.html#examples

import os

var threadArray : array[4, Thread[int]]

proc worker(i:int) {.thread.} =
  sleep 1000
  echo i

for i in 0..threadArray.high:
  createThread(threadArray[i], worker, i)

joinThreads(threadArray)