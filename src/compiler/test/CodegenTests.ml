open OUnit2
open Lib

let codegen_jeroo_decl_no_args _test_ctxt =
  let ast = [("main", [
      `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [])))
    ])] in
  let bytecode = List.of_seq (Codegen.codegen ast) in
  assert_equal bytecode [
    Bytecode.NEW (0, 1, 1, 0, Bytecode.North)
  ]

let codegen_jeroo_decl_set_x_y _test_ctxt =
  let ast = [("main", [
      `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [`IntExpr(2); `IntExpr(2)])))
    ])] in
  let bytecode = List.of_seq (Codegen.codegen ast) in
  assert_equal bytecode [
    Bytecode.NEW (0, 2, 2, 0, Bytecode.North)
  ]

let codegen_jeroo_decl_set_x_y_flowers _test_ctxt =
  let ast = [("main", [
      `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [`IntExpr(2); `IntExpr(2); `IntExpr(5)])))
    ])] in
  let bytecode = List.of_seq (Codegen.codegen ast) in
  assert_equal bytecode [
    Bytecode.NEW (0, 2, 2, 5, Bytecode.North)
  ]

let codegen_jeroo_decl_set_x_y_flowers_direction _test_ctxt =
  let ast = [("main", [
      `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [`IntExpr(2); `IntExpr(2); `IntExpr(5); `EastExpr])))
    ])] in
  let bytecode = List.of_seq (Codegen.codegen ast) in
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

let codegen_jeroo_hop _test_ctxt =
  let ast = [("main", [
      `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [])));
      `ExprStmt(`BinOpExpr(`IdExpr("j"), `Dot, `FxnAppExpr(`IdExpr("hop"), [`IntExpr(2)])))
    ])] in
  let bytecode = List.of_seq (Codegen.codegen ast) in
  assert_equal bytecode [
    Bytecode.NEW (0, 1, 1, 0, Bytecode.North);
    Bytecode.CSR 0;
    Bytecode.HOP 2;
  ]

(* let str_of_dir dir =
 *   match dir with
 *   | Bytecode.North -> "north"
 *   | Bytecode.South -> "south"
 *   | Bytecode.East -> "east"
 *   | Bytecode.West -> "west"
 * 
 * let dbg_bytecode codes =
 *   codes
 *   |> List.iter (fun bytecode ->
 *       let str = match bytecode with
 *         | Bytecode.CSR n -> "CSR " ^ string_of_int n
 *         | Bytecode.NEW (id, x, y, num_flowers, dir) -> Printf.sprintf "NEW %d %d %d %d %s" id x y num_flowers (str_of_dir dir)
 *         | Bytecode.HOP n -> "HOP " ^ string_of_int n
 *         | _ -> ""
 *       in
 *       print_endline str
 *     ) *)

let codegen_multiple_jeroos_csr _test_ctxt =
  let ast = [("main", [
      `DeclStmt("Jeroo", "j1", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [])));
      `DeclStmt("Jeroo", "j2", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [`IntExpr(2); `IntExpr(2)])));
      `ExprStmt(`BinOpExpr(`IdExpr("j1"), `Dot, `FxnAppExpr(`IdExpr("hop"), [])));
      `ExprStmt(`BinOpExpr(`IdExpr("j2"), `Dot, `FxnAppExpr(`IdExpr("hop"), [])))
    ])] in
  let bytecode = List.of_seq (Codegen.codegen ast) in
  assert_equal bytecode [
    Bytecode.NEW (0, 1, 1, 0, Bytecode.North);
    Bytecode.NEW (1, 2, 2, 0, Bytecode.North);
    Bytecode.CSR 0;
    Bytecode.HOP 1;
    Bytecode.CSR 1;
    Bytecode.HOP 1;
  ]

let codegen_pick_flower _test_ctxt =
  let ast = [("main", [
      `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [])));
      `ExprStmt(`BinOpExpr(`IdExpr("j"), `Dot, `FxnAppExpr(`IdExpr("pick"), [])))
    ])] in
  let bytecode = List.of_seq (Codegen.codegen ast) in
  assert_equal bytecode [
    Bytecode.NEW (0, 1, 1, 0, Bytecode.North);
    Bytecode.CSR 0;
    Bytecode.PICK;
  ]

let codegen_plant_flower _test_ctxt =
  let ast = [("main", [
      `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [])));
      `ExprStmt(`BinOpExpr(`IdExpr("j"), `Dot, `FxnAppExpr(`IdExpr("plant"), [])))
    ])] in
  let bytecode = List.of_seq (Codegen.codegen ast) in
  assert_equal bytecode [
    Bytecode.NEW (0, 1, 1, 0, Bytecode.North);
    Bytecode.CSR 0;
    Bytecode.PLANT;
  ]

let codegen_toss_flower _test_ctxt =
  let ast = [("main", [
      `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [])));
      `ExprStmt(`BinOpExpr(`IdExpr("j"), `Dot, `FxnAppExpr(`IdExpr("toss"), [])))
    ])] in
  let bytecode = List.of_seq (Codegen.codegen ast) in
  assert_equal bytecode [
    Bytecode.NEW (0, 1, 1, 0, Bytecode.North);
    Bytecode.CSR 0;
    Bytecode.TOSS;
  ]

let codegen_give_default_args _test_ctxt =
  let ast = [("main", [
      `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [])));
      `ExprStmt(`BinOpExpr(`IdExpr("j"), `Dot, `FxnAppExpr(`IdExpr("give"), [])))
    ])] in
  let bytecode = List.of_seq (Codegen.codegen ast) in
  assert_equal bytecode [
    Bytecode.NEW (0, 1, 1, 0, Bytecode.North);
    Bytecode.CSR 0;
    Bytecode.GIVE Bytecode.Ahead;
  ]

let codegen_give_in_direction _test_ctxt =
  let ast = [("main", [
      `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [])));
      `ExprStmt(`BinOpExpr(`IdExpr("j"), `Dot, `FxnAppExpr(`IdExpr("give"), [`LeftExpr])))
    ])] in
  let bytecode = List.of_seq (Codegen.codegen ast) in
  assert_equal bytecode [
    Bytecode.NEW (0, 1, 1, 0, Bytecode.North);
    Bytecode.CSR 0;
    Bytecode.GIVE Bytecode.Left;
  ]

let codegen_turn _test_ctxt =
  let ast = [("main", [
      `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [])));
      `ExprStmt(`BinOpExpr(`IdExpr("j"), `Dot, `FxnAppExpr(`IdExpr("turn"), [`RightExpr])))
    ])] in
  let bytecode = List.of_seq (Codegen.codegen ast) in
  assert_equal bytecode [
    Bytecode.NEW (0, 1, 1, 0, Bytecode.North);
    Bytecode.CSR 0;
    Bytecode.TURN Bytecode.Right;
  ]

let codegen_has_flower _test_ctxt =
  let ast = [("main", [
      `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [])));
      `ExprStmt(`BinOpExpr(`IdExpr("j"), `Dot, `FxnAppExpr(`IdExpr("hasFlower"), [])))
    ])] in
  let bytecode = List.of_seq (Codegen.codegen ast) in
  assert_equal bytecode [
    Bytecode.NEW (0, 1, 1, 0, Bytecode.North);
    Bytecode.CSR 0;
    Bytecode.HASFLWR;
  ]

let codegen_is_jeroo _test_ctxt =
  let ast = [("main", [
      `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [])));
      `ExprStmt(`BinOpExpr(`IdExpr("j"), `Dot, `FxnAppExpr(`IdExpr("isJeroo"), [`AheadExpr])))
    ])] in
  let bytecode = List.of_seq (Codegen.codegen ast) in
  assert_equal bytecode [
    Bytecode.NEW (0, 1, 1, 0, Bytecode.North);
    Bytecode.CSR 0;
    Bytecode.ISJEROO Bytecode.Ahead;
  ]

let codegen_is_facing _test_ctxt =
  let ast = [("main", [
      `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [])));
      `ExprStmt(`BinOpExpr(`IdExpr("j"), `Dot, `FxnAppExpr(`IdExpr("isFacing"), [`SouthExpr])))
    ])] in
  let bytecode = List.of_seq (Codegen.codegen ast) in
  assert_equal bytecode [
    Bytecode.NEW (0, 1, 1, 0, Bytecode.North);
    Bytecode.CSR 0;
    Bytecode.FACING Bytecode.South;
  ]

let codegen_is_flower _test_ctxt =
  let ast = [("main", [
      `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [])));
      `ExprStmt(`BinOpExpr(`IdExpr("j"), `Dot, `FxnAppExpr(`IdExpr("isFlower"), [`AheadExpr])))
    ])] in
  let bytecode = List.of_seq (Codegen.codegen ast) in
  assert_equal bytecode [
    Bytecode.NEW (0, 1, 1, 0, Bytecode.North);
    Bytecode.CSR 0;
    Bytecode.ISFLWR Bytecode.Ahead;
  ]

let codegen_is_net _test_ctxt =
  let ast = [("main", [
      `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [])));
      `ExprStmt(`BinOpExpr(`IdExpr("j"), `Dot, `FxnAppExpr(`IdExpr("isNet"), [`LeftExpr])))
    ])] in
  let bytecode = List.of_seq (Codegen.codegen ast) in
  assert_equal bytecode [
    Bytecode.NEW (0, 1, 1, 0, Bytecode.North);
    Bytecode.CSR 0;
    Bytecode.ISNET Bytecode.Left;
  ]

let codegen_is_water _test_ctxt =
  let ast = [("main", [
      `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [])));
      `ExprStmt(`BinOpExpr(`IdExpr("j"), `Dot, `FxnAppExpr(`IdExpr("isWater"), [`RightExpr])))
    ])] in
  let bytecode = List.of_seq (Codegen.codegen ast) in
  assert_equal bytecode [
    Bytecode.NEW (0, 1, 1, 0, Bytecode.North);
    Bytecode.CSR 0;
    Bytecode.ISWATER Bytecode.Right;
  ]

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
    "Generate Jeroo hop">:: codegen_jeroo_hop;
    "Generate CSR for multiple Jeroos">:: codegen_multiple_jeroos_csr;
    "Generate pick instruction">:: codegen_pick_flower;
    "Generate plant instruction">:: codegen_plant_flower;
    "Generate toss instruction">:: codegen_toss_flower;
    "Generate give default args">:: codegen_give_default_args;
    "Generate give in a direction">:: codegen_give_in_direction;
    "Generate turn instruction">:: codegen_turn;
    "Generate hasFlower">:: codegen_has_flower;
    "Generate isJeroo">:: codegen_is_jeroo;
    "Generate isFacing">:: codegen_is_facing;
    "Generate isFlower">:: codegen_is_flower;
    "Generate isNet">:: codegen_is_net;
    "Generate isWater">:: codegen_is_water;
  ]
