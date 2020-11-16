import nancy, termstyle, tables, strutils, json

var printTable: TerminalTable

var
  chr : char            = 'a'
  str : string          = "test"
  int : int             = 1
  flt : float           = 1.0
  seq : seq[int]        = @[0,1,2,3]
  ary : array[4, int]   = [0,1,2,3]
  tbl : Table[int, int] = {1: 1}.toTable
  jsn : JsonNode        = %*{"1": 1}

printTable.add bold "data type", bold "address",         bold "repr"                    , bold "stack / heap"
printTable.add bold "char",      $(cast[int](addr chr)), repr chr                       , "stack"
printTable.add bold "string",    $(cast[int](addr str)), repr str                       , "heap"
printTable.add bold "int",       $(cast[int](addr int)), repr int                       , "stack"
printTable.add bold "float",     $(cast[int](addr flt)), repr flt                       , "stack"
printTable.add bold "seq",       $(cast[int](addr seq)), repr seq                       , "heap"
printTable.add bold "array",     $(cast[int](addr ary)), repr ary                       , "stack"
printTable.add bold "table",     $(cast[int](addr tbl)), $(repr tbl).replace("\n", "")  , "heap"
printTable.add bold "json",      $(cast[int](addr jsn)), $(repr jsn).replace("\n", "")  , "heap"
printTable.echoTableSeps(seps=boxSeps)