open OUnit2
open Lib

let parse_string s =
  let lexbuf = Lexing.from_string s in
  VBParser.translation_unit VBLexer.token lexbuf

let parse_method _test_ctxt =
  let code = "sub main() \n end sub" in
  let ast = parse_string code in
  assert_equal ast [("main", [])]

let parse_decl _test_ctxt =
  let code = "sub main() \n dim j as jeroo = new jeroo(1, 2) \n end sub" in
  let ast = parse_string code in
  assert_equal ast [("main", [
      `DeclStmt("jeroo", "j", `UnOpExpr(`New, `FxnAppExpr(`IdExpr("jeroo"), [`IntExpr(1); `IntExpr(2)])))
    ])]

let parse_if_stmt _test_ctxt =
  let code = "sub main() \n if (true) then \n end if \n end sub" in
  let ast = parse_string code in
  assert_equal ast [("main", [
      `IfStmt(`TrueExpr, `BlockStmt [])
    ])]

let parse_if_stmt_no_paren _test_ctxt =
  let code = "sub main() \n if true then \n end if \n end sub" in
  let ast = parse_string code in
  assert_equal ast [("main", [
      `IfStmt(`TrueExpr, `BlockStmt [])
    ])]

(* TODO: add test for else if stmts *)

let parse_while_stmt _test_ctxt =
  let code = "sub main() \n while (true) \n end while \n end sub" in
  let ast = parse_string code in
  assert_equal ast [("main", [
      `WhileStmt(`TrueExpr, `BlockStmt [])
    ])]

let parse_while_no_paren _test_ctxt =
  let code = "sub main() \n while true \n end while \n end sub" in
  let ast = parse_string code in
  assert_equal ast [("main", [
      `WhileStmt(`TrueExpr, `BlockStmt [])
    ])]

let parse_and _test_ctxt =
  let code = "sub main() \n if true and true then \n end if \n end sub" in
  let ast = parse_string code in
  assert_equal ast [("main", [
      `IfStmt(`BinOpExpr(`TrueExpr, `And, `TrueExpr), `BlockStmt [])
    ])]

let parse_or _test_ctxt =
  let code = "sub main() \n if true or true then \n end if \n end sub" in
  let ast = parse_string code in
  assert_equal ast [("main", [
      `IfStmt(`BinOpExpr(`TrueExpr, `Or, `TrueExpr), `BlockStmt [])
    ])]

let parse_not _test_ctxt =
  let code = "sub main() \n if not false then \n end if \n end sub" in
  let ast = parse_string code in
  assert_equal ast [("main", [
      `IfStmt(`UnOpExpr(`Not, `FalseExpr), `BlockStmt [])
    ])]

let parse_comment _test_ctxt =
  let code = "'asdfasdf \n sub main() \n end sub" in
  let ast = parse_string code in
  assert_equal ast [("main", [])]

let parse_fxn_call _test_ctxt =
  let code = "sub main() \n foobar(20, five, north) \n end sub" in
  let ast = parse_string code in
  assert_equal ast [("main", [
      `ExprStmt(`FxnAppExpr(`IdExpr("foobar"), [`IntExpr(20); `IdExpr("five"); `NorthExpr])
      )])]

let parse_obj_fxn_call _test_ctxt =
  let code = "sub main() \n foo.bar(AHEAD) \n end sub" in
  let ast = parse_string code in
  assert_equal ast [("main", [
      `ExprStmt(`BinOpExpr(`IdExpr("foo"), `Dot, `FxnAppExpr(`IdExpr("bar"), [`AheadExpr])))
    ])]

let suite =
  "Visual Basic Parsing">::: [
    "Parse Method">:: parse_method;
    "Parse Decl">:: parse_decl;
    "Parse If">:: parse_if_stmt;
    "Parse If No Paren">:: parse_if_stmt_no_paren;
    "Parse While">:: parse_while_stmt;
    "Parse While No Paren">:: parse_while_no_paren;
    "Parse And">:: parse_and;
    "Parse Or">:: parse_or;
    "Parse Not">:: parse_not;
    "Parse Comment">:: parse_comment;
    "Parse Function Call">:: parse_fxn_call;
    "Parse Object Function Call">:: parse_obj_fxn_call;
  ]
