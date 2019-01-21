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

%start <unit> translation_unit

%%

translation_unit:
| fxn+ EOF {}

fxn:
| METHOD ID LPAREN RPAREN block {}

block:
| LBRACKET stmt* RBRACKET {}

stmt:
| if_stmt {}
| while_stmt {}
| decl_stmt {}
| expr_stmt {}

if_stmt:
| IF LPAREN expr RPAREN block {}
| IF LPAREN expr RPAREN block ELSE block {}

while_stmt:
| WHILE LPAREN expr RPAREN block {}

decl_stmt:
| ID ID EQ NEW ID LPAREN arguments RPAREN SEMICOLON {}

arguments:
| separated_list(COMMA, expr) {}

expr_stmt:
| expr SEMICOLON {}

expr:
| primary_expr {}
| expr AND expr {}
| expr OR expr {}
| NOT expr {}

primary_expr:
| INT {}
| TRUE {}
| FALSE {}
| LEFT {}
| RIGHT {}
| AHEAD {}
| HERE {}
| NORTH {}
| EAST {}
| SOUTH {}
| WEST {}
| ID DOT fxn_call {}
| fxn_call {}
| LPAREN expr RPAREN {}

fxn_call:
| ID LPAREN separated_list(COMMA, expr) RPAREN {}
