## Threaded pool work queue
## nim c -r --d:threads
## 
## Type [c][Enter] => create a thread worker
## Type [a][Enter] => add work to the pool
## Type [q][Enter] => quit
## 
## Instead of starting workers manually (done for interactive illustrative purposes) the following could be done
## 
## ```
## import cpuinfo
## for i in 0 .. countProcessors():
##   spawn worker()
## ```

import os, locks, strutils, threadpool, strformat

var
  aQueue    : seq[int]
  pQueue    : ptr seq[int]
  queueLock : Lock
  sleepTime = 100  # Time for thread to sleep in ms so we don't peg the CPU while waiting. Defaulted to 100ms (1/10 second).

initLock(queueLock)

pQueue = addr aQueue

proc worker() =
  let thrID = getThreadID()
  echo &"Thread# {thrID:5}: Started."
  while true:
    sleep sleepTime
    var 
      workItem : int
      workToDo : bool
    withLock queueLock:
      if pQueue[].len > 0:
        echo &"Thread# {thrID:5}: Work found. Taking one off the stack."
        workItem = pQueue[].pop
        workToDo = true
      else:
        discard
        # echo thrID, ": waiting for work."
    if workToDo:
      echo &"Thread# {thrID:5}: Processing work item with value => {workItem:2}"
      workToDo = false
      # Do something here

echo """
[c][Enter] => create a thread worker
[a][Enter] => add work to the pool
[q][Enter] => quit
"""

while true:
  let a = readLine(stdin)
  case a.normalize
  of "c":
    spawn worker()
  of "a":
    withLock queueLock:
      pQueue[].add @[0,1,2,3,4,5,6,7,8,9,10]
  of "q":
    echo "Exiting."
    quit()


# import cpuinfo
# for i in 0 .. countProcessors():
#   spawn worker()

# withLock queueLock:
#   for i in 0 .. 100:
#     pQueue[].add @[0,1,2,3,4,5,6,7,8,9,10]

sync()

#[ 
EXAMPLE OUTPUT:
[c][Enter] => create a thread worker
[a][Enter] => add work to the pool
[q][Enter] => quit

a
a
a
a
c
Thread# 14484: Started.
c
Thread#  5232: Started.
Thread# 14484: Work found. Taking one off the stack.
Thread# 14484: Processing work item with value => 7
c
Thread# 14944: Started.
Thread#  5232: Work found. Taking one off the stack.
Thread#  5232: Processing work item with value => 6
Thread# 14484: Work found. Taking one off the stack.
Thread# 14484: Processing work item with value => 5
Thread# 14944: Work found. Taking one off the stack.
Thread# 14944: Processing work item with value => 4
Thread#  5232: Work found. Taking one off the stack.
Thread#  5232: Processing work item with value => 3
Thread# 14484: Work found. Taking one off the stack.
Thread# 14484: Processing work item with value => 2
Thread# 14944: Work found. Taking one off the stack.
Thread# 14944: Processing work item with value => 1
Thread#  5232: Work found. Taking one off the stack.
Thread#  5232: Processing work item with value => 7
Thread# 14484: Work found. Taking one off the stack.
Thread# 14484: Processing work item with value => 6
Thread# 14944: Work found. Taking one off the stack.
Thread# 14944: Processing work item with value => 5
Thread#  5232: Work found. Taking one off the stack.
Thread#  5232: Processing work item with value => 4
Thread# 14484: Work found. Taking one off the stack.
Thread# 14484: Processing work item with value => 3
Thread# 14944: Work found. Taking one off the stack.
Thread# 14944: Processing work item with value => 2
Thread#  5232: Work found. Taking one off the stack.
Thread#  5232: Processing work item with value => 1
Thread# 14484: Work found. Taking one off the stack.
Thread# 14484: Processing work item with value => 7
Thread# 14944: Work found. Taking one off the stack.
Thread# 14944: Processing work item with value => 6
Thread#  5232: Work found. Taking one off the stack.
Thread#  5232: Processing work item with value => 5
Thread# 14484: Work found. Taking one off the stack.
Thread# 14484: Processing work item with value => 4
Thread# 14944: Work found. Taking one off the stack.
Thread# 14944: Processing work item with value => 3
Thread#  5232: Work found. Taking one off the stack.
Thread#  5232: Processing work item with value => 2
Thread# 14484: Work found. Taking one off the stack.
Thread# 14484: Processing work item with value => 1
Thread# 14944: Work found. Taking one off the stack.
Thread# 14944: Processing work item with value => 7
Thread#  5232: Work found. Taking one off the stack.
Thread#  5232: Processing work item with value => 6
Thread# 14484: Work found. Taking one off the stack.
Thread# 14484: Processing work item with value => 5
Thread# 14944: Work found. Taking one off the stack.
Thread# 14944: Processing work item with value => 4
Thread#  5232: Work found. Taking one off the stack.
Thread#  5232: Processing work item with value => 3
Thread# 14484: Work found. Taking one off the stack.
Thread# 14484: Processing work item with value => 2
Thread# 14944: Work found. Taking one off the stack.
Thread# 14944: Processing work item with value => 1

Add some more work
A
Thread#  5512: Work found. Taking one off the stack.
Thread#  5512: Processing work item with value => 7
Thread#  8520: Work found. Taking one off the stack.
Thread#  8520: Processing work item with value => 6
Thread# 15420: Work found. Taking one off the stack.
Thread# 15420: Processing work item with value => 5
Thread# 15532: Work found. Taking one off the stack.
Thread# 15532: Processing work item with value => 4
Thread# 14788: Work found. Taking one off the stack.
Thread# 14788: Processing work item with value => 3
Thread#  5512: Work found. Taking one off the stack.
Thread#  5512: Processing work item with value => 2
Thread#  8520: Work found. Taking one off the stack.
Thread#  8520: Processing work item with value => 1
]#
