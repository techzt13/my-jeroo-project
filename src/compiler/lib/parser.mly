%token <int> INT
%token <string> ID
%token TRUE FALSE
%token NOT AND OR
%token EQ
%token METHOD IF ELSE WHILE NEW
%token LPAREN RPAREN
%token LBRACKET RBRACKET
%token COMMA DOT SEMICOLON
%token LEFT RIGHT AHEAD HERE
%token NORTH EAST SOUTH WEST
%token EOF

%start <AST.fxn list> translation_unit

%%

translation_unit:
| fs = fxn+ EOF { fs }

fxn:
| METHOD id = ID LPAREN RPAREN b = block { (id, b) }

block:
| LBRACKET decls = decl* stmts = stmt* RBRACKET { (decls, stmts) }

decl:
| ty = ID id = ID EQ NEW ctor = ID LPAREN args = arguments RPAREN SEMICOLON { (ty, id, ctor, args) }

stmt:
| s = if_stmt { s }
| s = while_stmt { s }
| s = expr_stmt { s }

if_stmt:
| IF LPAREN e = expr RPAREN b = block { `IfStmt(e, b) }
| IF LPAREN e = expr RPAREN b1 = block ELSE b2 = block { `IfElseStmt(e, b1, b2) }

while_stmt:
| WHILE LPAREN e = expr RPAREN b = block { `WhileStmt(e, b) }

arguments:
| args = separated_list(COMMA, expr) { args }

expr_stmt:
| e = expr SEMICOLON { `ExprStmt(e) }

expr:
| e = primary_expr { e }
| e1 = expr AND e2 = expr { `BinOpExpr(e1, `And, e2) }
| e1 = expr OR e2 = expr { `BinOpExpr(e1, `Or, e2) }
| NOT e = expr { `UnOpExpr(`Not, e) }

primary_expr:
| i = INT { `IntExpr(i) }
| TRUE { `TrueExpr }
| FALSE { `FalseExpr }
| LEFT { `LeftExpr }
| RIGHT { `RightExpr }
| AHEAD { `AheadExpr }
| HERE { `HereExpr }
| NORTH { `NorthExpr }
| EAST { `EastExpr }
| SOUTH { `SouthExpr }
| WEST { `WestExpr }
| f = ID LPAREN args = separated_list(COMMA, expr) RPAREN { `FxnAppExpr(f, args) }
| obj = ID DOT f = ID LPAREN args = separated_list(COMMA, expr) RPAREN { `ObjFxnAppExpr(obj, f, args) }
| LPAREN e = expr RPAREN { e }
