# nim c -r --threads:on --gc:[arc|orc]

## Reference:
## https://nim-lang.org/docs/threads.html#examples

import locks

var
  threadArray : array[4, Thread[int]]
  gInt        : int
  s           : string
  ps          : ptr string
  L           : Lock

ps = addr s

proc worker(i:int) {.thread.} =
  sleep 1000
  echo "adding ", $i, " to `gInt`"
  acquire L
  gInt += i
  ps[].add $i
  release L

initLock(L)

for i in 0..threadArray.high:
  createThread(threadArray[i], worker, i)

joinThreads(threadArray)

echo ""
echo "Global `gInt` is ", $gInt
echo "String `s` is ", s