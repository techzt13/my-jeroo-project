open OUnit2
open Lib
open AST

let parse_string s =
  let lexbuf = Lexing.from_string s in JavaParser.translation_unit JavaLexer.token lexbuf

let parse_method _test_ctxt =
  let code = "@Java\n @@\n method main() { }" in
  let ast = parse_string code in
  let expected = {
    extension_fxns = [];
    main_fxn = {
      id = "main";
      stmts = [];
      start_lnum = 0;
      end_lnum = 0;
    };
  } in
  assert_equal ast expected

let parse_decl _test_ctxt =
  let code = "@Java\n @@\n method main() { Jeroo j = new Jeroo(1, 2); }" in
  let ast = parse_string code in
  let expected = {
    extension_fxns = [];
    main_fxn = {
      id = "main";
      stmts = [
        `DeclStmt("Jeroo", "j", {
            a = `UnOpExpr(`New, {
                a = `FxnAppExpr({
                    a = `IdExpr("Jeroo");
                    lnum = 0;
                  },
                    [
                      {
                        a = `IntExpr(1);
                        lnum = 0;
                      };
                      {
                        a = `IntExpr(2);
                        lnum = 0;
                      }
                    ]);
                lnum = 0;
              });
            lnum = 0;
          })
      ];
      start_lnum = 0;
      end_lnum = 0;
    };
  } in
  assert_equal ast expected

let parse_if_stmt _test_ctxt =
  let code = "@Java\n @@\n method main() { if (true) { } }" in
  let ast = parse_string code in
  let expected = {
    extension_fxns = [];
    main_fxn = {
      id = "main";
      stmts = [
        `IfStmt({
            a = `TrueExpr;
            lnum = 0;
          }, `BlockStmt [], 0)
      ];
      start_lnum = 0;
      end_lnum = 0;
    };
  } in
  assert_equal ast expected

let parse_if_else_stmt _test_ctxt =
  let code = "@Java\n @@\n method main() { if (true) { } else { }}" in
  let ast = parse_string code in
  let expected = {
    extension_fxns = [];
    main_fxn = {
      id = "main";
      stmts = [
        `IfElseStmt({
            a = `TrueExpr;
            lnum = 0;
          }, `BlockStmt [], `BlockStmt [], 0);
      ];
      start_lnum = 0;
      end_lnum = 0;
    }
  } in
  assert_equal ast expected

let parse_dangling_if _test_ctxt =
  let code = "@Java\n @@\n method main() { if (true) if (false) {} else { }}" in
  let ast = parse_string code in
  let expected = {
    extension_fxns = [];
    main_fxn = {
      id = "main";
      stmts = [
        `IfStmt({
            a = `TrueExpr;
            lnum = 0;
          }, `IfElseStmt({
            a =`FalseExpr;
            lnum = 0;
          }, `BlockStmt [], `BlockStmt [], 0), 0);
      ];
      start_lnum = 0;
      end_lnum = 0;
    };
  } in
  assert_equal ast expected

let parse_while_stmt _test_ctxt =
  let code = "@Java\n @@\n method main() { while(true) { }}" in
  let ast = parse_string code in
  let expected = {
    extension_fxns = [];
    main_fxn = {
      id = "main";
      stmts = [
        `WhileStmt({
            a = `TrueExpr;
            lnum = 0;
          }, `BlockStmt [], 0)
      ];
      start_lnum = 0;
      end_lnum = 0;
    };
  } in
  assert_equal ast expected

let parse_and _test_ctxt =
  let code = "@Java\n @@\n method main() { if (true && true) { }}" in
  let ast = parse_string code in
  let expected = {
    extension_fxns = [];
    main_fxn = {
      id = "main";
      stmts = [`IfStmt({
          a = `BinOpExpr({
              a = `TrueExpr;
              lnum = 0;
            }, `And, {
                a = `TrueExpr;
                lnum = 0;
              });
          lnum = 0;
        }, `BlockStmt [], 0)];
      start_lnum = 0;
      end_lnum = 0;
    };
  } in
  assert_equal ast expected

let parse_or _test_ctxt =
  let code = "@Java\n @@\n method main() { if (true || true) { }}" in
  let ast = parse_string code in
  let expected = {
    extension_fxns = [];
    main_fxn = {
      id = "main";
      stmts = [
        `IfStmt({
            a = `BinOpExpr({
                a = `TrueExpr;
                lnum = 0;
              }, `Or, {
                  a = `TrueExpr;
                  lnum = 0;
                });
            lnum = 0;
          }, `BlockStmt [], 0);
      ];
      start_lnum = 0;
      end_lnum = 0;
    }
  } in
  assert_equal ast expected

let parse_not _test_ctxt =
  let code = "@Java\n @@\n method main() { if (!true) {} }" in
  let ast = parse_string code in
  let expected = {
    extension_fxns = [];
    main_fxn = {
      id = "main";
      stmts = [
        `IfStmt({
            a = `UnOpExpr(`Not, {
                a = `TrueExpr;
                lnum = 0;
              });
            lnum = 0;
          }, `BlockStmt [], 0);
      ];
      start_lnum = 0;
      end_lnum = 0;
    }
  } in
  assert_equal ast expected

let parse_not_precedence _test_ctxt =
  let code = "@Java\n @@\n method main() { if (!true && false) {}}" in
  let ast = parse_string code in
  let expected = {
    extension_fxns = [];
    main_fxn = {
      id = "main";
      stmts = [
        `IfStmt({
            a = `BinOpExpr({
                a = `UnOpExpr(`Not, {
                    a = `TrueExpr;
                    lnum = 0;
                  });
                lnum = 0;
              }, `And, {
                  a = `FalseExpr;
                  lnum = 0;
                });
            lnum = 0;
          }, `BlockStmt [], 0);
      ];
      start_lnum = 0;
      end_lnum = 0;
    }
  } in
  assert_equal ast expected

let parse_paren_precedence _test_ctxt =
  let code = "@Java\n @@\n method main() { if (true && (false && false)) {} }" in
  let ast = parse_string code in
  let expected = {
    extension_fxns = [];
    main_fxn = {
      id = "main";
      stmts = [
        `IfStmt({
            a = `BinOpExpr({
                a = `TrueExpr;
                lnum = 0;
              }, `And, {
                  a = `BinOpExpr({
                      a = `FalseExpr;
                      lnum = 0;
                    }, `And, {
                        a = `FalseExpr;
                        lnum = 0;
                      });
                  lnum = 0;
                });
            lnum = 0;
          }, `BlockStmt [], 0)
      ];
      start_lnum = 0;
      end_lnum = 0;
    }
  } in
  assert_equal ast expected

let parse_comment _test_ctxt =
  let code = "// this is a comment\n @Java\n @@\n method main() { }" in
  let ast = parse_string code in
  let expected = {
    extension_fxns = [];
    main_fxn = {
      id = "main";
      stmts = [];
      start_lnum = 0;
      end_lnum = 0;
    }
  } in
  assert_equal ast expected

let parse_ml_comment _test_ctxt =
  let code = "@Java\n @@\n /* this is a *\n\n\n* multi line comment */method main() {}" in
  let ast = parse_string code in
  let expected = {
    extension_fxns = [];
    main_fxn = {
      id = "main";
      stmts = [];
      start_lnum = 3;
      end_lnum = 3;
    }
  } in
  assert_equal ast expected

let parse_fxn_app _test_ctxt =
  let code = "@Java\n @@\n method main() { foo(); }" in
  let ast = parse_string code in
  let expected = {
    extension_fxns = [];
    main_fxn = {
      id = "main";
      stmts = [
        `ExprStmt({
            a = `FxnAppExpr({
                a = `IdExpr("foo");
                lnum = 0;
              }, []);
            lnum = 0;
          });
      ];
      start_lnum = 0;
      end_lnum = 0;
    }
  } in
  assert_equal ast expected

let parse_obj_call _test_ctxt =
  let code = "@Java\n @@\n method main() { j.someFxn(1, NORTH);  }" in
  let ast = parse_string code in
  let expected = {
    extension_fxns = [];
    main_fxn = {
      id = "main";
      stmts = [
        `ExprStmt({
            a = `BinOpExpr({
                a = `IdExpr("j");
                lnum = 0;
              }, `Dot, {
                  a = `FxnAppExpr({
                      a = `IdExpr("someFxn");
                      lnum = 0;
                    }, [
                        {
                          a = `IntExpr(1);
                          lnum = 0;
                        };
                        {
                          a = `NorthExpr;
                          lnum = 0;
                        }
                      ]);
                  lnum = 0;
                });
            lnum = 0;
          })
      ];
      start_lnum = 0;
      end_lnum = 0;
    }
  } in
  assert_equal ast expected

let parse_negative_int _test_ctxt =
  let code = "@Java\n @@\n method main() { foo(-1); }" in
  let ast = parse_string code in
  let expected = {
    extension_fxns = [];
    main_fxn = {
      id = "main";
      stmts = [
        `ExprStmt({
            a = `FxnAppExpr({
                a = `IdExpr("foo");
                lnum = 0;
              }, [{
                a = `IntExpr(-1);
                lnum = 0;
              }]);
            lnum = 0;
          })
      ];
      start_lnum = 0;
      end_lnum = 0;
    }
  } in
  assert_equal ast expected

let parse_stmt_list _test_ctxt =
  let code = "@Java\n @@\n method main() { a.b(); c(); }" in
  let ast = parse_string code in
  let expected = {
    extension_fxns = [];
    main_fxn = {
      id = "main";
      stmts = [
        `ExprStmt({
            a = `BinOpExpr({
                a = `IdExpr("a");
                lnum = 0;
              }, `Dot, {
                  a = `FxnAppExpr({
                      a = `IdExpr("b");
                      lnum = 0;
                    }, []);
                  lnum = 0;
                });
            lnum = 0;
          });
        `ExprStmt({
            a = `FxnAppExpr({
                a = `IdExpr("c");
                lnum = 0;
              }, []);
            lnum = 0;
          })
      ];
      start_lnum = 0;
      end_lnum = 0;
    }
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
