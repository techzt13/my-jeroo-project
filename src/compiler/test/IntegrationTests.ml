open OUnit2
open Lib

let compile_java _test_ctxt =
  let code = "@Java\n\n method foo() { hop(3); }\n@@\n method main() { Jeroo j = new Jeroo(); j.foo(); }" in
  let bytecode = List.of_seq (Compiler.compile code) in
  assert_equal bytecode [
    Bytecode.JUMP (3, 0);
    Bytecode.HOP (3, 2);
    Bytecode.RETR 2;
    Bytecode.NEW (0, 0, 0, 0, Bytecode.North, 0);
    Bytecode.CSR (0, 0);
    Bytecode.CALLBK 0;
    Bytecode.JUMP (1, 0);
    Bytecode.RETR 0;
  ]

let compile_VB _test_ctxt =
  let code = "@VB\n\n sub foo()\n hop(3)\n end sub\n @@\n sub main()\n dim j as Jeroo = new Jeroo()\n j.foo()\n end sub" in
  let bytecode = List.of_seq (Compiler.compile code) in
  assert_equal bytecode [
    Bytecode.JUMP (3, 0);
    Bytecode.HOP (3, 3);
    Bytecode.RETR 4;
    Bytecode.NEW (0, 0, 0, 0, Bytecode.North, 1);
    Bytecode.CSR (0, 2);
    Bytecode.CALLBK 2;
    Bytecode.JUMP (1, 2);
    Bytecode.RETR 3;
  ]

let suite =
  "Integration Tests">::: [
    "Compile Java">:: compile_java;
    "Compile VB">:: compile_VB;
  ]
