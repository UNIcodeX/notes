# nim c -r --threads:on

## Reference:
## https://nim-lang.org/docs/threads.html#examples

import locks

var
  threadArray : array[4, Thread[int]]
  gInt        : int
  L           : Lock

proc worker(i:int) {.thread.} =
  sleep 1
  acquire L
  echo "adding ", $i, " to `gInt`"
  gInt += i
  release L

initLock(L)

for i in 0..threadArray.high:
  createThread(threadArray[i], worker, i)

joinThreads(threadArray)

echo ""
echo "Global `gInt` is ", $gInt