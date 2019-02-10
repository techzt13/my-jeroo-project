open OUnit2
open Lib

let compile_java _test_ctxt =
  let code = "@Java\n\n method foo() { hop(3); }@@\n method main() { Jeroo j = new Jeroo(); j.foo(); }" in
  let bytecode = List.of_seq (Compiler.compile code) in
  assert_equal bytecode [
    Bytecode.JUMP 3;
    Bytecode.HOP 3;
    Bytecode.RETR;
    Bytecode.NEW (0, 1, 1, 0, Bytecode.North);
    Bytecode.CSR 0;
    Bytecode.CALLBK;
    Bytecode.JUMP 1;
    Bytecode.RETR;
  ]

let suite =
  "Integration Tests">::: [
    "Compile Java">:: compile_java
  ]
