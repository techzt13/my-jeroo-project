%{
open AST
%}
%token <int * int> INT
%token <string * int> ID
%token <int> TRUE FALSE
%token <int> NOT AND OR EQ
%token <int> DEF IF ELIF ELSE WHILE
%token <int> LPAREN RPAREN
%token <int> INDENT DEDENT
%token <int> COLON COMMA DOT NEWLINE /*SEMICOLON*/
%token <int> LEFT RIGHT AHEAD HERE
%token <int> NORTH EAST SOUTH WEST
%token HEADER MAIN_METH_SEP
%token <int> EOF

%left OR
%left AND
%right NOT
%left DOT

%start <AST.translation_unit> translation_unit
%%

translation_unit:
  | HEADER fs = newline_or_fxn_list MAIN_METH_SEP stmts = newline_or_stmt_list end_lnum = EOF
    {
      {
        extension_fxns = fs;
        main_fxn = {
            id = "main";
            stmts = stmts;
            start_lnum = 1;
            end_lnum = end_lnum
          }
      }
    }

fxn:
  | start_lnum = DEF id_lnum = ID LPAREN RPAREN COLON b = suite end_lnum = NEWLINE
    {
      let (id, _) = id_lnum in
      {
        id = id;
        stmts = b;
        start_lnum = start_lnum;
        end_lnum = end_lnum
      }
    }

newline_or_stmt_list:
  | NEWLINE stmts = newline_or_stmt_list { stmts }
  | s = stmt stmts = newline_or_stmt_list { s :: stmts }
  | { [] }

newline_or_fxn_list:
  | NEWLINE fxns = newline_or_fxn_list { fxns }
  | fxn = fxn fxns = newline_or_fxn_list { fxn :: fxns }
  | { [] }

compound_stmt:
  | s = if_stmt { s }
  | s = while_stmt { s }

stmt:
  | s = simple_stmt { AST.BlockStmt([s]) }
  | s = compound_stmt { s }

/* stmt_list: */
/*   | stmts = separated_nonempty_list(SEMICOLON, simple_stmt) { stmts } */

suite:
  | /*stmts = stmt_list NEWLINE*/ stmts = simple_stmt { [stmts] }
  | NEWLINE INDENT stmts = stmt+ DEDENT { stmts }

if_stmt:
  | ln = IF e = expr COLON s = suite { AST.IfStmt(e, AST.BlockStmt(s), ln) }
  | ln = IF e = expr COLON s1 = suite s2 = else_stmt { AST.IfElseStmt(e, AST.BlockStmt(s1), s2, ln) }
  | ln = IF e = expr COLON s1 = suite s2 = elseif_stmts { AST.IfElseStmt(e, AST.BlockStmt(s1), s2, ln) }

elseif_stmts:
  | ln = ELIF e = expr COLON s1 = suite s2 = elseif_stmts { AST.IfElseStmt(e, AST.BlockStmt(s1), s2, ln) }
  | ln = ELIF e = expr COLON s = suite { AST.IfStmt(e, AST.BlockStmt(s), ln) }
  | ln = ELIF e = expr COLON s1 = suite s2 = else_stmt { AST.IfElseStmt(e, AST.BlockStmt(s1), s2, ln) }

else_stmt:
  | ELSE COLON s = suite { AST.BlockStmt(s) }

while_stmt:
  | ln = WHILE e = expr COLON s = suite { AST.WhileStmt(e, AST.BlockStmt(s), ln) }

simple_stmt:
  | s = expression_stmt { s }
  | s = assignment_stmt { s }

expression_stmt:
  | e = expr ln = NEWLINE { AST.ExprStmt({ a = Some e; lnum = ln }) }

assignment_stmt:
  | id_ln = ID EQ e = expr NEWLINE { let (id, ln) = id_ln in AST.DeclStmt("Jeroo", id, { a = AST.UnOpExpr(AST.New, e); lnum = ln}) }

expr:
  | e = arith_expr { e }
  | id_ln = ID LPAREN args = arguments RPAREN { let (id, ln) = id_ln in { a = AST.FxnAppExpr({ a = IdExpr id; lnum = ln }, args); lnum = ln } }

arith_expr:
  | e = primary_expr { e }
  | e1 = expr ln = AND e2 = expr { { a = AST.BinOpExpr(e1, AST.And, e2); lnum = ln } }
  | e1 = expr ln = OR e2 = expr { { a = AST.BinOpExpr(e1, AST.Or, e2); lnum = ln } }
  | e1 = expr ln = DOT e2 = expr { { a = AST.BinOpExpr(e1, AST.Dot, e2); lnum = ln } }
  | ln = NOT e = expr { { a = AST.UnOpExpr(AST.Not, e); lnum = ln } }

primary_expr:
  | id_ln = ID {  let (id, ln) = id_ln in { a = AST.IdExpr(id); lnum = ln } }
  | i_ln = INT { let (i, ln) = i_ln in { a = AST.IntExpr(i); lnum = ln} }
  | ln = TRUE { { a = AST.TrueExpr; lnum = ln } }
  | ln = FALSE { { a = AST.FalseExpr; lnum = ln } }
  | ln = LEFT { { a = AST.LeftExpr; lnum = ln } }
  | ln = RIGHT { { a = AST.RightExpr; lnum = ln } }
  | ln = AHEAD { { a = AST.AheadExpr; lnum = ln } }
  | ln = HERE { { a = AST.HereExpr; lnum = ln } }
  | ln = NORTH { { a = AST.NorthExpr; lnum = ln } }
  | ln = SOUTH { { a = AST.SouthExpr; lnum = ln } }
  | ln = EAST { { a = AST.EastExpr; lnum = ln } }
  | ln = WEST { { a = AST.WestExpr; lnum = ln } }
  | LPAREN e = expr RPAREN { e }

arguments:
  | args = separated_list(COMMA, expr) { args }
