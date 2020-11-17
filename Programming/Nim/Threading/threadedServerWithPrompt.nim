import os
import strutils

type
  ServerStates = enum
    stopped = (0, "stopped")
    running = (1, "running")

var
  t : Thread[void]
  g = "stopped"
  serverState : ServerStates

serverState = running

proc serviceProc() {.thread.} =
  while true:
    sleep(500)
    case serverState
    of stopped:
      # do something
      discard
    of running:
      # do something else
      discard
    else:
      # do something else
      discard

proc printHelp() =
  echo """
help  => This message
stop  => Stop service
start => Start service
exit  => exit program
"""

createThread(t, serviceProc)

printHelp()

while true:
  stdout.write(serverState, " > ")
  let i = readLine(stdin)
  case i.normalize:
  of "help":
    printHelp()
  of "stop":
    serverState = stopped
  of "start":
    serverState = running
  of "exit":
    echo "exiting."
    quit()