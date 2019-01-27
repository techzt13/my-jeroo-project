%token <int> INT
%token <string> ID
%token SUB IF ELSE WHILE END
%token AND OR NOT EQ NEW DOT
%token LEFT RIGHT AHEAD HERE TRUE FALSE
%token NORTH SOUTH EAST WEST
%token LPAREN RPAREN COMMA THEN DIM AS NEWLINE
%token EOF

%right EQ
%left OR
%left AND
%right NEW
%right NOT
%left DOT

%start <AST.fxn list> translation_unit
%%

translation_unit:
| fs = fxn+ EOF { fs }

fxn:
| SUB id = ID LPAREN RPAREN b = block END SUB { (id, b) }

block:
| NEWLINE stmts = stmt* { stmts }

stmt:
| IF LPAREN e = expr RPAREN THEN b = block END IF NEWLINE { `IfStmt(e, `BlockStmt(b)) }
| IF e = expr THEN b = block END IF NEWLINE { `IfStmt(e, `BlockStmt(b)) }
| IF LPAREN e = expr RPAREN THEN b1 = block ELSE b2 = block END IF NEWLINE { `IfElseStmt(e, `BlockStmt(b1), `BlockStmt(b2)) }
| IF e = expr THEN b1 = block ELSE b2 = block END IF NEWLINE { `IfElseStmt(e, `BlockStmt(b1), `BlockStmt(b2)) }
| WHILE LPAREN e = expr RPAREN b = block END WHILE NEWLINE { `WhileStmt(e, `BlockStmt(b)) }
| WHILE e = expr b = block END WHILE NEWLINE { `WhileStmt(e, `BlockStmt(b)) }
| DIM id = ID AS ty = ID EQ e = expr NEWLINE { `DeclStmt(ty, id, e) }
| e = expr NEWLINE { `ExprStmt(e) }

expr:
| e = arith_expr { e }
| e = arith_expr LPAREN args = arguments RPAREN { `FxnAppExpr(e, args) }

arith_expr:
| e = primary_expr { e }
| e1 = expr AND e2 = expr { `BinOpExpr(e1, `And, e2) }
| e1 = expr OR e2 = expr { `BinOpExpr(e1, `Or, e2) }
| e1 = expr DOT e2 = expr { `BinOpExpr(e1, `Dot, e2) }
| e1 = expr EQ e2 = expr { `BinOpExpr(e1, `Eq, e2) }
| NOT e = expr { `UnOpExpr(`Not, e) }
| NEW e = expr { `UnOpExpr(`New, e) }

primary_expr:
| id = ID { `IdExpr(id) }
| i = INT { `IntExpr(i) }
| TRUE { `TrueExpr }
| FALSE { `FalseExpr }
| LEFT { `LeftExpr }
| RIGHT { `RightExpr }
| AHEAD { `AheadExpr }
| HERE { `HereExpr }
| NORTH { `NorthExpr }
| SOUTH { `SouthExpr }
| EAST { `EastExpr }
| WEST { `WestExpr }
| LPAREN e = expr RPAREN { e }

arguments:
| args = separated_list(COMMA, expr) { args }
