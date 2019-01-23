type bin_op = [
  | `And
  | `Or
]

type un_op = [
  | `Not
]

type expr = [
  | `IdExpr of string
  | `IntExpr of int
  | `TrueExpr
  | `FalseExpr
  | `LeftExpr
  | `RightExpr
  | `AheadExpr
  | `HereExpr
  | `NorthExpr
  | `EastExpr
  | `SouthExpr
  | `WestExpr
  | `BinOpExpr of expr * bin_op * expr
  | `UnOpExpr of un_op * expr
  (* method, optional list *)
  | `FxnAppExpr of string * expr list
  (* object, method, arguments list *)
  | `ObjFxnAppExpr of string * string * expr list
]

(* type, identifier, constructor, arguments list *)
type decl = string * string * string * expr list

type stmt = [
  | `ExprStmt of expr
  (* condition, positive body *)
  | `IfStmt of expr * (decl list * stmt list)
  (* condition, positive branch body, negative branch body *)
  | `IfElseStmt of expr * (decl list * stmt list) * (decl list * stmt list)
  (* loop condition, loop body *)
  | `WhileStmt of expr * (decl list * stmt list)
]

(* function name, function body *)
type fxn = string * (decl list * stmt list)
