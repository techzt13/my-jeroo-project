open OUnit2
open Lib

let codegen_jeroo_decl_no_args _test_ctxt =
  let ast = [("main", [
      `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [])))
    ])] in
  let bytecode = Codegen.codegen ast in
  assert_equal bytecode [
    Bytecode.NEW (0, 1, 1, 0, Bytecode.North)
  ]

let codegen_jeroo_decl_set_x_y _test_ctxt =
  let ast = [("main", [
      `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [`IntExpr(2); `IntExpr(2)])))
    ])] in
  let bytecode = Codegen.codegen ast in
  assert_equal bytecode [
    Bytecode.NEW (0, 2, 2, 0, Bytecode.North)
  ]

let codegen_jeroo_decl_set_x_y_flowers _test_ctxt =
  let ast = [("main", [
      `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [`IntExpr(2); `IntExpr(2); `IntExpr(5)])))
    ])] in
  let bytecode = Codegen.codegen ast in
  assert_equal bytecode [
    Bytecode.NEW (0, 2, 2, 5, Bytecode.North)
  ]

let codegen_jeroo_decl_set_x_y_flowers_direction _test_ctxt =
  let ast = [("main", [
      `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [`IntExpr(2); `IntExpr(2); `IntExpr(5); `EastExpr])))
    ])] in
  let bytecode = Codegen.codegen ast in
  assert_equal bytecode [
    Bytecode.NEW (0, 2, 2, 5, Bytecode.East)
  ]

let codegen_jeroo_decl_invalid_args _test_ctxt =
  let ast = [("main", [
      `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [`IntExpr(2);])))
    ])] in
  assert_raises (Codegen.SemanticException "Invalid Jeroo arguments") (fun () -> Codegen.codegen ast)

let codegen_jeroo_decl_no_new _test_ctxt =
  let ast = [("main", [
      `DeclStmt("Jeroo", "j", `IntExpr(1))
    ])] in
  assert_raises (Codegen.SemanticException "Invalid right hand side of declaration, must be a Jeroo constructor") (fun () -> Codegen.codegen ast)

let codegen_unknown_decl_type _test_ctxt =
  let ast = ["main", [
      `DeclStmt("jer", "j", `IntExpr(1))
    ]] in
  assert_raises (Codegen.SemanticException "Invalid type, Jeroo is the only valid type") (fun () -> Codegen.codegen ast)

let codegen_unknown_ctor _test_ctxt =
  let ast = ["main", [
      `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("jer"), [])))
    ]] in
  assert_raises (Codegen.SemanticException "Invalid constructor: jer, Jeroo is the only valid constructor") (fun () -> Codegen.codegen ast)

let suite =
  "Codegen">::: [
    "Generate jeroo decl with default args">:: codegen_jeroo_decl_no_args;
    "Generate jeroo decl with custom x and y">:: codegen_jeroo_decl_set_x_y;
    "Generate jeroo decl with custom x, y, and flowers">:: codegen_jeroo_decl_set_x_y_flowers;
    "Generate jeroo decl with custom x, y, flowers, and direction">:: codegen_jeroo_decl_set_x_y_flowers_direction;
    "Generate jeroo decl invalid args throws exception">:: codegen_jeroo_decl_invalid_args;
    "Generate jeroo decl no new expr">:: codegen_jeroo_decl_no_new;
    "Generate unknown type throws exception">:: codegen_unknown_decl_type;
    "Generate unknown constructor throws exception">:: codegen_unknown_ctor;
  ]
