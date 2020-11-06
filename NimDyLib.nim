## References:
## https://framework.embarklabs.io/news/2019/11/28/nim-vs-crystal-part-3-cryto-dapps-p2p/
## https://nim-lang.org/docs/manual.html#userminusdefined-pragmas

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
