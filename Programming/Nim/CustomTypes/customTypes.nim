## Reference:
## http://ssalewski.de/nimprogramming.html#_references_to_objects

type
  Friend = ref object
    name: string
    next: Friend

var
  f: Friend # the head of our list
  n: string # name or "quit" to terminate the input process

while true:
  write(stdout, "Name of friend: ")
  n = readline(stdin)
  if n == "" or n == "quit":
    break
  var node: Friend 
  new(node)
  node.name = n
  node.next = f
  f = node

while f != nil:
  echo f.name
  f = f.next