proc add*(a,b:int): int {.exportc, dynlib, cdecl.} =
  a + b

#[
import with:
```
# import.nim
proc add(a,b:int): int {.importc, dynlib: "./libexport.so", importc: "add", cdecl.}

when isMainModule:
  echo add(1,3)
```
]#
