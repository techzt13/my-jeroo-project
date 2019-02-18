type bin_op = [
  | `And
  | `Or
  | `Dot
  | `Eq
]

type un_op = [
  | `Not
  | `New
]

type 'a meta = {
  a: 'a;
  lnum: int;
}

(* expressions all have an integer attached to them *)
(* this integer is for the line number *)
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
  | `BinOpExpr of expr meta * bin_op * expr meta
  | `UnOpExpr of un_op * expr meta
  | `FxnAppExpr of expr meta * expr meta list
  (* object, method, arguments list *)
  | `ObjFxnAppExpr of string * string * expr meta list
]

type stmt = [
  | `BlockStmt of stmt list
  (* condition, positive body, line num *)
  | `IfStmt of expr meta * stmt * int
  (* condition, positive branch body, negative branch body, line num *)
  | `IfElseStmt of expr meta * stmt * stmt * int
  (* loop condition, loop body, line num *)
  | `WhileStmt of expr meta * stmt * int
  (* type, identifier, initialization expression *)
  | `DeclStmt of string * string * expr meta
  | `ExprStmt of expr meta
]

(* function name, function body *)
type fxn = {
  id : string;
  stmts : stmt list;
  start_lnum: int;
  end_lnum: int;
}

type translation_unit = {
  extension_fxns: fxn list;
  main_fxn: fxn;
}
