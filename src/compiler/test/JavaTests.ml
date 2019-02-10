open OUnit2
open Lib

let parse_string s =
  let lexbuf = Lexing.from_string s in
  JavaParser.translation_unit JavaLexer.token lexbuf

let parse_method _test_ctxt =
  let code = "@Java\n @@\n method main() { }" in
  let ast = parse_string code in
  let expected : AST.translation_unit = {
    extension_fxns = [];
    main_fxn = ("main", []);
  } in
  assert_equal ast expected

let parse_decl _test_ctxt =
  let code = "@Java\n @@\n method main() { Jeroo j = new Jeroo(1, 2); }" in
  let ast = parse_string code in
  let expected : AST.translation_unit = {
    extension_fxns = [];
    main_fxn = ("main", [
        `DeclStmt("Jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("Jeroo"), [`IntExpr(1); `IntExpr(2)])))
      ]);
  } in
  assert_equal ast expected

let parse_if_stmt _test_ctxt =
  let code = "@Java\n @@\n method main() { if (true) { } }" in
  let ast = parse_string code in
  let expected : AST.translation_unit = {
    extension_fxns = [];
    main_fxn = ("main", [
        `IfStmt(`TrueExpr, `BlockStmt [])
      ]);
  } in
  assert_equal ast expected

let parse_if_else_stmt _test_ctxt =
  let code = "@Java\n @@\n method main() { if (true) { } else { }}" in
  let ast = parse_string code in
  let expected : AST.translation_unit = {
    extension_fxns = [];
    main_fxn = ("main", [
        `IfElseStmt(`TrueExpr, `BlockStmt([]), `BlockStmt([]))
      ]);
  } in
  assert_equal ast expected

let parse_dangling_if _test_ctxt =
  let code = "@Java\n @@\n method main() { if (true) if (false) {} else { }}" in
  let ast = parse_string code in
  let expected : AST.translation_unit = {
    extension_fxns = [];
    main_fxn = ("main", [
        `IfStmt(`TrueExpr, `IfElseStmt(`FalseExpr, `BlockStmt([]), `BlockStmt([])))
      ]);
  } in
  assert_equal ast expected

let parse_while_stmt _test_ctxt =
  let code = "@Java\n @@\n method main() { while(true) { }}" in
  let ast = parse_string code in
  let expected : AST.translation_unit = {
    extension_fxns = [];
    main_fxn = ("main", [
        `WhileStmt(`TrueExpr, `BlockStmt([]))
      ]);
  } in
  assert_equal ast expected

let parse_and _test_ctxt =
  let code = "@Java\n @@\n method main() { if (true && true) { }}" in
  let ast = parse_string code in
  let expected : AST.translation_unit = {
    extension_fxns = [];
    main_fxn = ("main", [
        `IfStmt(`BinOpExpr(`TrueExpr, `And, `TrueExpr), `BlockStmt([]))
      ]);
  } in
  assert_equal ast expected

let parse_or _test_ctxt =
  let code = "@Java\n @@\n method main() { if (true || true) { }}" in
  let ast = parse_string code in
  let expected : AST.translation_unit = {
    extension_fxns = [];
    main_fxn = ("main", [
        `IfStmt(`BinOpExpr(`TrueExpr, `Or, `TrueExpr), `BlockStmt([]))
      ]);
  } in
  assert_equal ast expected

let parse_not _test_ctxt =
  let code = "@Java\n @@\n method main() { if (!true) {} }" in
  let ast = parse_string code in
  let expected : AST.translation_unit = {
    extension_fxns = [];
    main_fxn = ("main", [
        `IfStmt(`UnOpExpr(`Not, `TrueExpr), `BlockStmt([]))
      ]);
  } in
  assert_equal ast expected

let parse_not_precedence _test_ctxt =
  let code = "@Java\n @@\n method main() { if (!true && false) {}}" in
  let ast = parse_string code in
  let expected : AST.translation_unit = {
    extension_fxns = [];
    main_fxn = ("main", [
        `IfStmt(`BinOpExpr(`UnOpExpr(`Not, `TrueExpr), `And, `FalseExpr), `BlockStmt([]))
      ]);
  } in
  assert_equal ast expected

let parse_paren_precedence _test_ctxt =
  let code = "@Java\n @@\n method main() { if (true && (false && false)) {} }" in
  let ast = parse_string code in
  let expected : AST.translation_unit = {
    extension_fxns = [];
    main_fxn = ("main"), [
      `IfStmt(`BinOpExpr(`TrueExpr, `And, `BinOpExpr(`FalseExpr, `And, `FalseExpr)), `BlockStmt([]))
    ];
  } in
  assert_equal ast expected

let parse_comment _test_ctxt =
  let code = "// this is a comment\n @Java\n @@\n method main() { }" in
  let ast = parse_string code in
  let expected : AST.translation_unit = {
    extension_fxns = [];
    main_fxn = ("main", []);
  } in
  assert_equal ast expected

let parse_ml_comment _test_ctxt =
  let code = "/* this is a *\n\n\n* multi line comment */@Java\n @@\n method main() {}" in
  let ast = parse_string code in
  let expected : AST.translation_unit = {
    extension_fxns = [];
    main_fxn = ("main", []);
  } in
  assert_equal ast expected

let parse_fxn_app _test_ctxt =
  let code = "@Java\n @@\n method main() { foo(); }" in
  let ast = parse_string code in
  let expected : AST.translation_unit = {
    extension_fxns = [];
    main_fxn = ("main", [
        `ExprStmt(`FxnAppExpr(`IdExpr("foo"), []))
      ]);
  } in
  assert_equal ast expected

let parse_obj_call _test_ctxt =
  let code = "@Java\n @@\n method main() { j.someFxn(1, NORTH);  }" in
  let ast = parse_string code in
  let expected : AST.translation_unit = {
    extension_fxns = [];
    main_fxn = ("main", [
        `ExprStmt(`BinOpExpr(`IdExpr("j"), `Dot, `FxnAppExpr(`IdExpr("someFxn"), [`IntExpr(1); `NorthExpr])))
      ]);
  } in
  assert_equal ast expected

let parse_negative_int _test_ctxt =
  let code = "@Java\n @@\n method main() { foo(-1); }" in
  let ast = parse_string code in
  let expected : AST.translation_unit = {
    extension_fxns = [];
    main_fxn = ("main"), [
        `ExprStmt(`FxnAppExpr(`IdExpr("foo"), [`IntExpr(-1)]))
      ];
  } in
  assert_equal ast expected

let parse_stmt_list _test_ctxt =
  let code = "@Java\n @@\n method main() { a.b(); c(); }" in
  let ast = parse_string code in
  let expected : AST.translation_unit = {
    extension_fxns = [];
    main_fxn = ("main"), [
        `ExprStmt(`BinOpExpr(`IdExpr("a"), `Dot, `FxnAppExpr(`IdExpr("b"), [])));
        `ExprStmt(`FxnAppExpr(`IdExpr("c"), []))
      ];
  } in
  assert_equal ast expected

let suite =
  "Java Parsing">::: [
    "Parse Method">:: parse_method;
    "Parse Decl">:: parse_decl;
    "Parse If Stmt">:: parse_if_stmt;
    "Parse If Else Stmt">:: parse_if_else_stmt;
    "Parse Dangling Else">:: parse_dangling_if;
    "Parse While Stmt">:: parse_while_stmt;
    "Parse And">:: parse_and;
    "Parse Or">:: parse_or;
    "Parse Not">:: parse_not;
    "Parse Not Precedence">:: parse_not_precedence;
    "Parse Paren Precedence">:: parse_paren_precedence;
    "Parse comments">:: parse_comment;
    "Parse ml-comment">:: parse_ml_comment;
    "Parse Function Application">:: parse_fxn_app;
    "Parse obj call">:: parse_obj_call;
    "Parse Negative Int">:: parse_negative_int;
    "Parse Stmt List">:: parse_stmt_list;
  ]
