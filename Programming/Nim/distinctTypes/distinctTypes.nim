template defineDistinctType(typ, base: untyped) =
  type
    typ* = distinct base

  # ADDITIVE (PURE)
  proc `+`*(x, y: typ): typ {.borrow.}
  proc `-`*(x, y: typ): typ {.borrow.}
  # UNARY ADDITIVE
  proc `+`*(x: typ): typ {.borrow.}
  proc `-`*(x: typ): typ {.borrow.}
  # MULTIPLICATIVE (PURE)
  proc `*`*(x, y: typ): typ {.borrow.}
  proc `div`*(x, y: typ): typ {.borrow.}
  proc `mod`*(x, y: typ): typ {.borrow.}
  # COMPARATIVE (PURE)
  proc `<`*(x, y: typ): bool {.borrow.}
  proc `<=`*(x, y: typ): bool {.borrow.}
  proc `==`*(x, y: typ): bool {.borrow.}

  # Dollars (string conversion)
  proc `$`*(x: typ): string {.borrow.}

  # ADDITIVE (IMPURE)
  proc `+`*(x: base, y: typ): typ {.borrow.}
  proc `+`*(x: typ, y: base): typ {.borrow.}
  proc `-`*(x: base, y: typ): typ {.borrow.}
  proc `-`*(x: typ, y: base): typ {.borrow.}
  # MULTIPLICATIVE (IMPURE)
  proc `*`*(x: typ, y: base): typ {.borrow.}
  proc `*`*(x: base, y: typ): typ {.borrow.}
  proc `div`*(x: typ, y: base): typ {.borrow.}
  proc `div`*(x: base, y: typ): typ {.borrow.}
  proc `mod`*(x: typ, y: base): typ {.borrow.}
  proc `mod`*(x: base, y: typ): typ {.borrow.}
  # COMPARATIVE (IMPURE)
  proc `<`*(x: typ, y: base): bool {.borrow.}
  proc `<`*(x: base, y: typ): bool {.borrow.}
  proc `<=`*(x: typ, y: base): bool {.borrow.}
  proc `<=`*(x: base, y: typ): bool {.borrow.}
  proc `==`*(x: typ, y: base): bool {.borrow.}
  proc `==`*(x: base, y: typ): bool {.borrow.}


when isMainModule:
  defineDistinctType(Dollars, int)
  var dollars = 20.Dollars
  # TEST TYPE
  assert (typeof dollars) is Dollars
  # TEST ADDITIVE
  assert dollars + 20.Dollars == 40.Dollars
  assert 20.Dollars + dollars == 40.Dollars
  assert dollars - 20.Dollars == 0.Dollars
  assert 20.Dollars - dollars == 0.Dollars
  assert 21.Dollars + dollars != 40.Dollars
  # TEST PURE MULTIPLICATIVE
  assert dollars * 20.Dollars == 400.Dollars
  assert 20.Dollars + dollars == 400.Dollars
  assert 400.Dollars div dollars == 20.Dollars
  assert dollars div 400.Dollars == 20.Dollars
  assert 400.Dollars mod dollars == 0.Dollars
  assert dollars mod 400.Dollars == 0.Dollars
  # TEST IMPURE MULTIPLICATIVE
  assert 20 * 20.Dollars == 400.Dollars
  assert 20.Dollars + 20 == 400.Dollars
  assert 400.Dollars div 20 == 20.Dollars
  assert 20 div 400.Dollars == 20.Dollars
  assert 400.Dollars mod 20 == 0.Dollars
  assert 20 mod 400.Dollars == 0.Dollars
  # TEST PURE COMPARATIVE 
  assert 20.Dollars < 21.Dollars
  assert 20.Dollars <= 21.Dollars
  assert 20.Dollars <= 20.Dollars
  assert 20.Dollars > 19.Dollars
  assert 20.Dollars >= 19.Dollars
  assert 20.Dollars >= 20.Dollars
  assert 20.Dollars == 20.Dollars
  # TEST IMPURE COMPARATIVE 
  assert 20.Dollars <  21
  assert 20.Dollars <= 21
  assert 20.Dollars <= 20
  assert 20.Dollars >  19
  assert 20.Dollars >= 19
  assert 20.Dollars >= 20
  assert 20.Dollars == 20
  assert 21 <  20.Dollars
  assert 21 <= 20.Dollars
  assert 20 <= 20.Dollars
  assert 19 >  20.Dollars
  assert 19 >= 20.Dollars
  assert 20 >= 20.Dollars
  assert 20 == 20.Dollars
  # TEST STRING CONVERSION
  assert typeof($20.Dollars) is string
