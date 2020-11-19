import threadpool

type
  MyType = object
    i: int

var mt = MyType()

proc test(mt:MyType): MyType =
  var mt = mt                   # Work-around for -- Error: 'spawn'ed function cannot have a 'var' parameter
  mt.i = 1
  mt                            # Implicit `result = mt`. Could also `return mt`.

echo "main mt : ", repr mt

let res = spawn test(mt)
sync()

echo "spawned : ", repr ^res    # Retrieve spawned proc result with carat (^). Getting a sub-field would require `(^result).sub`

echo "main mt : ", repr mt      # The global `mt` has not been changed

mt = ^res                       # Copy spawned MyType object into global
echo "main mt : ", repr mt      # It's changed now

#[ OUTPUT:
main mt : [i = 0]
spawned : [i = 1]
main mt : [i = 0]
main mt : [i = 1]
]#
