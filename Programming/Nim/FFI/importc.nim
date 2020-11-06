## References:
## https://framework.embarklabs.io/news/2019/11/18/nim-vs-crystal-part-1-performance-interoperability/
## https://nim-lang.org/docs/manual.html#implementation-specific-pragmas-compile-pragma

{.compile: "../../C/importcLogic.c".}  # To show relative import

proc add(a, b: cint): cint {.importc.}

when isMainModule:
  echo add(3, 7)  # 10