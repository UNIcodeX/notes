# Programming => Nim => FFI

## References
  - [Nim vs Crystal - Part 1 - Performance & Interoperability [by Robin Percy]]( https://framework.embarklabs.io/news/2019/11/18/nim-vs-crystal-part-1-performance-interoperability/)
  - [Nim vs Crystal - Part 3 - Crypto, DApps & P2P [by Robin Percy]](https://framework.embarklabs.io/news/2019/11/28/nim-vs-crystal-part-3-cryto-dapps-p2p/)
  - [Nim Manual - User Defined Pragmas](https://nim-lang.org/docs/manual.html#userminusdefined-pragmas)
  - [Nim Manual - Compile Pragma](https://nim-lang.org/docs/manual.html#implementation-specific-pragmas-compile-pragma)

## Load a dynamic library (.so | .dll)

### Nim
```nim
import strutils

const SHA256Len = 32

when defined(windows):
  when defined(cpu64):
    {.pragma: rtl, importc, dynlib: "libcrypto-1_1-x64.dll", cdecl.}
  else:
    {.pragma: rtl, importc, dynlib: "libcrypto-1_1.dll", cdecl.}
elif hostOS == "macosx":
  {.pragma: rtl, importc, dynlib: "libssl(.3|.1|).dylib", cdecl.}
else:
  {.pragma: rtl, importc, dynlib: "libssl.so(.3|.1|)", cdecl.}


proc SHA256(d: cstring, n: culong, md: cstring = nil): cstring {.rtl.}

proc SHA256(s: string): string =
  result = ""
  let s = SHA256(s.cstring, s.len.culong)
  for i in 0 ..< SHA256Len:
    result.add s[i].BiggestInt.toHex(2).toLower

echo SHA256("Hash this!")  # 7c9041be1bfa7982c1bf2fc41be68610e80af231c5c8beb6cf9d6a23f01ecdf1

```


## Directly Compile C Code into Project

### C library
```c
// importcLogic.c
int add(int a, int b) {
  return a + b;
}
```

### Import it in Nim
```nim
{.compile: "path/to/importcLogic.c".}  # To show relative import

proc add(a, b: cint): cint {.importc.}

when isMainModule:
  echo add(3, 7)  # 10
```
