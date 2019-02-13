open OUnit2
open Lib

let compile_java _test_ctxt =
  let code = "@Java\n\n method foo() { hop(3); }@@\n method main() { Jeroo j = new Jeroo(); j.foo(); }" in
  let bytecode = List.of_seq (Compiler.compile code) in
  assert_equal bytecode [
    Bytecode.JUMP 3;
    Bytecode.HOP 3;
    Bytecode.RETR;
    Bytecode.NEW (0, 0, 0, 0, Bytecode.North);
    Bytecode.CSR 0;
    Bytecode.CALLBK;
    Bytecode.JUMP 1;
    Bytecode.RETR;
  ]

let compile_VB _test_ctxt =
  let code = "@VB\n\n sub foo()\n hop(3)\n end sub\n @@\n sub main()\n dim j as Jeroo = new Jeroo()\n j.foo()\n end sub" in
  let bytecode = List.of_seq (Compiler.compile code) in
  assert_equal bytecode [
    Bytecode.JUMP 3;
    Bytecode.HOP 3;
    Bytecode.RETR;
    Bytecode.NEW (0, 0, 0, 0, Bytecode.North);
    Bytecode.CSR 0;
    Bytecode.CALLBK;
    Bytecode.JUMP 1;
    Bytecode.RETR;
  ]

let suite =
  "Integration Tests">::: [
    "Compile Java">:: compile_java;
    "Compile VB">:: compile_VB;
  ]
