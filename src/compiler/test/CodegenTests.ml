open OUnit2
open Lib

let codegen_jeroo_decl_no_args _test_ctxt =
  let ast : AST.translation_unit = {
    extension_fxns = [];
    main_fxn = ("main", [
        `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [])))
      ]);
  } in
  let bytecode = List.of_seq (Codegen.codegen ast) in
  assert_equal bytecode [
    Bytecode.JUMP 1;
    Bytecode.NEW (0, 0, 0, 0, Bytecode.North);
    Bytecode.RETR
  ]

let codegen_jeroo_decl_set_x_y _test_ctxt =
  let ast : AST.translation_unit = {
    extension_fxns = [];
    main_fxn = ("main", [
        `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [`IntExpr(2); `IntExpr(2)])))
      ]);
  } in
  let bytecode = List.of_seq (Codegen.codegen ast) in
  assert_equal bytecode [
    Bytecode.JUMP 1;
    Bytecode.NEW (0, 2, 2, 0, Bytecode.North);
    Bytecode.RETR
  ]

let codegen_jeroo_decl_set_x_y_flowers _test_ctxt =
  let ast : AST.translation_unit = {
    extension_fxns = [];
    main_fxn = ("main", [
        `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [`IntExpr(2); `IntExpr(2); `IntExpr(5)])))
      ]);
  } in
  let bytecode = List.of_seq (Codegen.codegen ast) in
  assert_equal bytecode [
    Bytecode.JUMP 1;
    Bytecode.NEW (0, 2, 2, 5, Bytecode.North);
    Bytecode.RETR
  ]

let codegen_jeroo_decl_set_x_y_flowers_direction _test_ctxt =
  let ast : AST.translation_unit = {
    extension_fxns = [];
    main_fxn = ("main", [
        `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [`IntExpr(2); `IntExpr(2); `IntExpr(5); `EastExpr])))
      ]);
  } in
  let bytecode = List.of_seq (Codegen.codegen ast) in
  assert_equal bytecode [
    Bytecode.JUMP 1;
    Bytecode.NEW (0, 2, 2, 5, Bytecode.East);
    Bytecode.RETR
  ]

let codegen_jeroo_decl_invalid_args _test_ctxt =
  let ast : AST.translation_unit = {
    extension_fxns = [];
    main_fxn = ("main", [
        `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [`IntExpr(2);])))
      ]);
  } in
  assert_raises (Codegen.SemanticException "Invalid Jeroo arguments") (fun () -> Codegen.codegen ast)

let codegen_jeroo_decl_no_new _test_ctxt =
  let ast : AST.translation_unit = {
    extension_fxns = [];
    main_fxn = ("main", [
        `DeclStmt("Jeroo", "j", `IntExpr(1))
      ]);
  } in
  assert_raises (Codegen.SemanticException "Invalid right hand side of declaration, must be a Jeroo constructor") (fun () -> Codegen.codegen ast)

let codegen_unknown_decl_type _test_ctxt =
  let ast : AST.translation_unit = {
    extension_fxns = [];
    main_fxn = ("main", [
        `DeclStmt("jer", "j", `IntExpr(1))
      ]);
  } in
  assert_raises (Codegen.SemanticException "Invalid type, Jeroo is the only valid type") (fun () -> Codegen.codegen ast)

let codegen_unknown_ctor _test_ctxt =
  let ast : AST.translation_unit = {
    extension_fxns = [];
    main_fxn = ("main", [
        `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("jer"), [])))
      ]);
  } in
  assert_raises (Codegen.SemanticException "Invalid constructor: jer, Jeroo is the only valid constructor") (fun () -> Codegen.codegen ast)

let codegen_jeroo_hop _test_ctxt =
  let ast : AST.translation_unit = {
    extension_fxns = [];
    main_fxn = ("main", [
        `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [])));
        `ExprStmt(`BinOpExpr(`IdExpr("j"), `Dot, `FxnAppExpr(`IdExpr("hop"), [`IntExpr(2)])))
      ]);
  } in
  let bytecode = List.of_seq (Codegen.codegen ast) in
  assert_equal bytecode [
    Bytecode.JUMP 1;
    Bytecode.NEW (0, 0, 0, 0, Bytecode.North);
    Bytecode.CSR 0;
    Bytecode.HOP 2;
    Bytecode.RETR
  ]

let codegen_multiple_jeroos_csr _test_ctxt =
  let ast : AST.translation_unit = {
    extension_fxns = [];
    main_fxn = ("main", [
        `DeclStmt("Jeroo", "j1", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [])));
        `DeclStmt("Jeroo", "j2", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [`IntExpr(2); `IntExpr(2)])));
        `ExprStmt(`BinOpExpr(`IdExpr("j1"), `Dot, `FxnAppExpr(`IdExpr("hop"), [])));
        `ExprStmt(`BinOpExpr(`IdExpr("j2"), `Dot, `FxnAppExpr(`IdExpr("hop"), [])))
      ]);
  } in
  let bytecode = List.of_seq (Codegen.codegen ast) in
  assert_equal bytecode [
    Bytecode.JUMP 1;
    Bytecode.NEW (0, 0, 0, 0, Bytecode.North);
    Bytecode.NEW (1, 2, 2, 0, Bytecode.North);
    Bytecode.CSR 0;
    Bytecode.HOP 1;
    Bytecode.CSR 1;
    Bytecode.HOP 1;
    Bytecode.RETR
  ]

let codegen_pick_flower _test_ctxt =
  let ast : AST.translation_unit = {
    extension_fxns = [];
    main_fxn = ("main", [
        `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [])));
        `ExprStmt(`BinOpExpr(`IdExpr("j"), `Dot, `FxnAppExpr(`IdExpr("pick"), [])))
      ]);
  } in
  let bytecode = List.of_seq (Codegen.codegen ast) in
  assert_equal bytecode [
    Bytecode.JUMP 1;
    Bytecode.NEW (0, 0, 0, 0, Bytecode.North);
    Bytecode.CSR 0;
    Bytecode.PICK;
    Bytecode.RETR
  ]

let codegen_plant_flower _test_ctxt =
  let ast : AST.translation_unit = {
    extension_fxns = [];
    main_fxn = ("main", [
        `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [])));
        `ExprStmt(`BinOpExpr(`IdExpr("j"), `Dot, `FxnAppExpr(`IdExpr("plant"), [])))
      ]);
  } in
  let bytecode = List.of_seq (Codegen.codegen ast) in
  assert_equal bytecode [
    Bytecode.JUMP 1;
    Bytecode.NEW (0, 0, 0, 0, Bytecode.North);
    Bytecode.CSR 0;
    Bytecode.PLANT;
    Bytecode.RETR
  ]

let codegen_toss_flower _test_ctxt =
  let ast : AST.translation_unit = {
    extension_fxns = [];
    main_fxn = ("main", [
        `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [])));
        `ExprStmt(`BinOpExpr(`IdExpr("j"), `Dot, `FxnAppExpr(`IdExpr("toss"), [])))
      ]);
  } in
  let bytecode = List.of_seq (Codegen.codegen ast) in
  assert_equal bytecode [
    Bytecode.JUMP 1;
    Bytecode.NEW (0, 0, 0, 0, Bytecode.North);
    Bytecode.CSR 0;
    Bytecode.TOSS;
    Bytecode.RETR
  ]

let codegen_give_default_args _test_ctxt =
  let ast : AST.translation_unit = {
    extension_fxns = [];
    main_fxn = ("main", [
        `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [])));
        `ExprStmt(`BinOpExpr(`IdExpr("j"), `Dot, `FxnAppExpr(`IdExpr("give"), [])))
      ]);
  } in
  let bytecode = List.of_seq (Codegen.codegen ast) in
  assert_equal bytecode [
    Bytecode.JUMP 1;
    Bytecode.NEW (0, 0, 0, 0, Bytecode.North);
    Bytecode.CSR 0;
    Bytecode.GIVE Bytecode.Ahead;
    Bytecode.RETR
  ]

let codegen_give_in_direction _test_ctxt =
  let ast : AST.translation_unit = {
    extension_fxns = [];
    main_fxn = ("main", [
        `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [])));
        `ExprStmt(`BinOpExpr(`IdExpr("j"), `Dot, `FxnAppExpr(`IdExpr("give"), [`LeftExpr])))
      ]);
  } in
  let bytecode = List.of_seq (Codegen.codegen ast) in
  assert_equal bytecode [
    Bytecode.JUMP 1;
    Bytecode.NEW (0, 0, 0, 0, Bytecode.North);
    Bytecode.CSR 0;
    Bytecode.GIVE Bytecode.Left;
    Bytecode.RETR
  ]

let codegen_turn _test_ctxt =
  let ast : AST.translation_unit = {
    extension_fxns = [];
    main_fxn = ("main", [
        `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [])));
        `ExprStmt(`BinOpExpr(`IdExpr("j"), `Dot, `FxnAppExpr(`IdExpr("turn"), [`RightExpr])))
      ]);
  } in
  let bytecode = List.of_seq (Codegen.codegen ast) in
  assert_equal bytecode [
    Bytecode.JUMP 1;
    Bytecode.NEW (0, 0, 0, 0, Bytecode.North);
    Bytecode.CSR 0;
    Bytecode.TURN Bytecode.Right;
    Bytecode.RETR
  ]

let codegen_has_flower _test_ctxt =
  let ast : AST.translation_unit = {
    extension_fxns = [];
    main_fxn = ("main", [
        `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [])));
        `ExprStmt(`BinOpExpr(`IdExpr("j"), `Dot, `FxnAppExpr(`IdExpr("hasFlower"), [])))
      ]);
  } in
  let bytecode = List.of_seq (Codegen.codegen ast) in
  assert_equal bytecode [
    Bytecode.JUMP 1;
    Bytecode.NEW (0, 0, 0, 0, Bytecode.North);
    Bytecode.CSR 0;
    Bytecode.HASFLWR;
    Bytecode.RETR
  ]

let codegen_is_jeroo _test_ctxt =
  let ast : AST.translation_unit = {
    extension_fxns = [];
    main_fxn = ("main", [
        `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [])));
        `ExprStmt(`BinOpExpr(`IdExpr("j"), `Dot, `FxnAppExpr(`IdExpr("isJeroo"), [`AheadExpr])))
      ]);
  } in
  let bytecode = List.of_seq (Codegen.codegen ast) in
  assert_equal bytecode [
    Bytecode.JUMP 1;
    Bytecode.NEW (0, 0, 0, 0, Bytecode.North);
    Bytecode.CSR 0;
    Bytecode.ISJEROO Bytecode.Ahead;
    Bytecode.RETR
  ]

let codegen_is_facing _test_ctxt =
  let ast : AST.translation_unit = {
    extension_fxns = [];
    main_fxn = ("main", [
        `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [])));
        `ExprStmt(`BinOpExpr(`IdExpr("j"), `Dot, `FxnAppExpr(`IdExpr("isFacing"), [`SouthExpr])))
      ]);
  } in
  let bytecode = List.of_seq (Codegen.codegen ast) in
  assert_equal bytecode [
    Bytecode.JUMP 1;
    Bytecode.NEW (0, 0, 0, 0, Bytecode.North);
    Bytecode.CSR 0;
    Bytecode.FACING Bytecode.South;
    Bytecode.RETR
  ]

let codegen_is_flower _test_ctxt =
  let ast : AST.translation_unit = {
    extension_fxns = [];
    main_fxn = ("main", [
        `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [])));
        `ExprStmt(`BinOpExpr(`IdExpr("j"), `Dot, `FxnAppExpr(`IdExpr("isFlower"), [`AheadExpr])))
      ]);
  } in
  let bytecode = List.of_seq (Codegen.codegen ast) in
  assert_equal bytecode [
    Bytecode.JUMP 1;
    Bytecode.NEW (0, 0, 0, 0, Bytecode.North);
    Bytecode.CSR 0;
    Bytecode.ISFLWR Bytecode.Ahead;
    Bytecode.RETR
  ]

let codegen_is_net _test_ctxt =
  let ast : AST.translation_unit = {
    extension_fxns = [];
    main_fxn = ("main", [
        `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [])));
        `ExprStmt(`BinOpExpr(`IdExpr("j"), `Dot, `FxnAppExpr(`IdExpr("isNet"), [`LeftExpr])))
      ]);
  } in
  let bytecode = List.of_seq (Codegen.codegen ast) in
  assert_equal bytecode [
    Bytecode.JUMP 1;
    Bytecode.NEW (0, 0, 0, 0, Bytecode.North);
    Bytecode.CSR 0;
    Bytecode.ISNET Bytecode.Left;
    Bytecode.RETR
  ]

let codegen_is_water _test_ctxt =
  let ast : AST.translation_unit = {
    extension_fxns = [];
    main_fxn = ("main", [
      `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [])));
      `ExprStmt(`BinOpExpr(`IdExpr("j"), `Dot, `FxnAppExpr(`IdExpr("isWater"), [`RightExpr])))
    ]);
  } in
  let bytecode = List.of_seq (Codegen.codegen ast) in
  assert_equal bytecode [
    Bytecode.JUMP 1;
    Bytecode.NEW (0, 0, 0, 0, Bytecode.North);
    Bytecode.CSR 0;
    Bytecode.ISWATER Bytecode.Right;
    Bytecode.RETR
  ]

let codegen_call_custom_fxn _test_ctxt =
  let ast : AST.translation_unit = {
    extension_fxns = [
      ("foo", [
          `ExprStmt(`FxnAppExpr(`IdExpr("hop"), []))
        ]);
    ];
    main_fxn = ("main", [
        `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [])));
        `ExprStmt(`BinOpExpr(`IdExpr("j"), `Dot, `FxnAppExpr(`IdExpr("foo"), [])))
      ]);
  } in
  let bytecode = List.of_seq (Codegen.codegen ast) in
  assert_equal bytecode [
    Bytecode.JUMP 3;
    Bytecode.HOP 1;
    Bytecode.RETR;
    Bytecode.NEW (0, 0, 0, 0, Bytecode.North);
    Bytecode.CSR 0;
    Bytecode.CALLBK;
    Bytecode.JUMP 1;
    Bytecode.RETR
  ]

let codegen_call_missing_fxn _test_ctxt =
  let ast : AST.translation_unit = {
    extension_fxns = [];
    main_fxn = ("main", [
        `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [])));
        `ExprStmt(`BinOpExpr(`IdExpr("j"), `Dot, `FxnAppExpr(`IdExpr("foo"), [])))
      ]);
  } in
  assert_raises (Codegen.SemanticException "Unknown function: foo") (fun () -> Codegen.codegen ast)

let codegen_if_stmt _test_ctxt =
  let ast : AST.translation_unit = {
    extension_fxns = [];
    main_fxn = ("main", [
        `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [])));
        `IfStmt(`TrueExpr, `ExprStmt(`BinOpExpr(`IdExpr("j"), `Dot, `FxnAppExpr(`IdExpr("hop"), []))));
        `ExprStmt(`BinOpExpr(`IdExpr("j"), `Dot, `FxnAppExpr(`IdExpr("turn"), [`RightExpr])))
      ]);
  } in
  let bytecode = List.of_seq (Codegen.codegen ast) in
  assert_equal bytecode [
    Bytecode.JUMP 1;
    Bytecode.NEW (0, 0, 0, 0, Bytecode.North);
    Bytecode.TRUE;
    Bytecode.BZ 6;
    Bytecode.CSR 0;
    Bytecode.HOP 1;
    Bytecode.CSR 0;
    Bytecode.TURN Bytecode.Right;
    Bytecode.RETR;]

let codegen_if_else _test_ctxt =
  let ast : AST.translation_unit = {
    extension_fxns = [];
    main_fxn = ("main", [
        `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [])));
        `IfElseStmt(`TrueExpr,
                    `ExprStmt(`BinOpExpr(`IdExpr("j"), `Dot, `FxnAppExpr(`IdExpr("hop"), []))),
                    `ExprStmt(`BinOpExpr(`IdExpr("j"), `Dot, `FxnAppExpr(`IdExpr("turn"), [`LeftExpr])))
                   );
        `ExprStmt(`BinOpExpr(`IdExpr("j"), `Dot, `FxnAppExpr(`IdExpr("turn"), [`RightExpr])))
      ]);
  } in
  let bytecode = List.of_seq (Codegen.codegen ast) in
  assert_equal bytecode [
    Bytecode.JUMP 1;
    Bytecode.NEW (0, 0, 0, 0, Bytecode.North);
    Bytecode.TRUE;
    Bytecode.BZ 7;
    Bytecode.CSR 0;
    Bytecode.HOP 1;
    Bytecode.JUMP 9;
    Bytecode.CSR 0;
    Bytecode.TURN Bytecode.Left;
    Bytecode.CSR 0;
    Bytecode.TURN Bytecode.Right;
    Bytecode.RETR;
  ]

let codegen_while _test_ctxt =
  let ast : AST.translation_unit = {
    extension_fxns = [];
    main_fxn = ("main", [
        `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [])));
        `WhileStmt(`TrueExpr,
                   `ExprStmt(`BinOpExpr(`IdExpr("j"), `Dot, `FxnAppExpr(`IdExpr("hop"), [])))
                  );
        `ExprStmt(`BinOpExpr(`IdExpr("j"), `Dot, `FxnAppExpr(`IdExpr("turn"), [`RightExpr])));
      ]);
  } in
  let bytecode = List.of_seq (Codegen.codegen ast) in
  assert_equal bytecode [
    Bytecode.JUMP 1;
    Bytecode.NEW (0, 0, 0, 0, Bytecode.North);
    Bytecode.TRUE;
    Bytecode.BZ 7;
    Bytecode.CSR 0;
    Bytecode.HOP 1;
    Bytecode.JUMP 2;
    Bytecode.CSR 0;
    Bytecode.TURN Bytecode.Right;
    Bytecode.RETR;
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
    "Generate calling custom methods">:: codegen_call_custom_fxn;
    "Calling missing function generates error">:: codegen_call_missing_fxn;
    "Generate if statement">:: codegen_if_stmt;
    "Generate if-else statement">:: codegen_if_else;
    "Generate while statement">:: codegen_while;
  ]
