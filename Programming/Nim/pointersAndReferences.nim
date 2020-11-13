## Reference:
## http://ssalewski.de/nimprogramming.html#_value_objects_and_references

echo "\nmanual pointer assignment"
var 
  number: int = 7 
  p1: pointer 
  ip1: ptr int 
echo cast[int](p1)                                                # 0
echo cast[int](ip1)                                               # 0
p1 = addr(number)                                   
ip1 = addr(number)                                    
echo cast[int](p1)                                                # {some address}
echo cast[int](ip1)                                               # {some address}
# echo p1[]                                                       # error - untyped pointers cannot be dereferenced
echo ip1[]                                                        # 7

proc main = 
  echo "\nmain => each int in array is 8 bytes long"
  var
    a: array[8, int] = [0, 1, 2, 3, 4, 5, 6, 7]
    sum = 0
  var p: ptr int = addr(a[0])
  for i in a.low .. a.high:
    sum += p[]
    echo cast[int](p), " = ", p[]                                 # {some address} = {value at address}
    var h = cast[int](p)
    h +=  sizeof(a[0])
    p = cast[ptr int](h)

  echo sum                                                        # 28
  echo typeof(sizeof(a[0]))                                       # int

main()

echo "\nmanual alloc / dealloc"
var ip: ptr int
ip = create(int)
ip[] = 13
echo ip[] * 3                                                     # 39
var ip2: ptr int
ip2 = ip
echo ip2[] * 3                                                    # 39
dealloc(ip)
echo cast[int](ip)                                                # {some address}
echo cast[int](ip2)                                               # {^ SAME address}

echo "\nsame but using ref"
var ir: ref int
new(ir)
ir[] = 13
echo ir[] * 3                                                     # 39
var ir2: ref int
ir2 = ir
echo ir2[] * 3                                                    # 39
ir2[] = 7                                                         # sets ir to 7, because it's a reference (traced pointer)
echo ir[]                                                         # 7
echo ir2[]                                                        # 7
echo cast[int](ir)                                                # {some address}
echo cast[int](ir2)                                               # {^ SAME address}


echo "\ncustom ref type"
type
  MyObj = ref object
    a: int
    b: string

var m : MyObj

if m.isNil: echo "it's nil" else: echo "it's not nil"             # it's nil
# echo repr m.a
# echo repr m.b

# Intantiate object with:
new(m)
# OR this way (not initializing any values)
m = MyObj()
# OR initialize default values
m = MyObj(a:0, b:"")
# OR just initialize some value(s)
m = MyObj(b:"")

if m.isNil: echo "it's nil" else: echo "it's not nil"             # it's not nil
echo repr m                                                       # ref {some heap address} --> [a = 0,
                                                                  # b = ""]

# Access / change values with:
m.a = 2
m.b = "some string"
echo m.a                                                          # 2
echo m.b                                                          # some string
echo repr m                                                       # ref {some heap address} --> [a = 2, 
                                                                  # b = {some heap address}"some string"]