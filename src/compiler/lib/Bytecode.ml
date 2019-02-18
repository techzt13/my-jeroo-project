type compass_direction =
  | North
  | East
  | South
  | West

type relative_direction =
  | Left
  | Right
  | Here
  | Ahead

type bytecode =
  | CSR of int * int
  (* the actual Jeroo bytecode doesn't have labels, so we convert labels to memory locations in a separate step *)
  | JUMP_LBL of string * int
  | JUMP of int * int
  | BZ_LBL of string * int
  | BZ of int * int
  | LABEL of string * int
  | NEW of int * int * int * int * compass_direction * int
  | TURN of relative_direction * int
  | HOP of int * int
  | PICK of int
  | TOSS of int
  | PLANT of int
  | GIVE of relative_direction * int
  | TRUE of int
  | FALSE of int
  | HASFLWR of int
  | ISNET of relative_direction * int
  | ISWATER of relative_direction * int
  | ISJEROO of relative_direction * int
  | ISFLWR of relative_direction * int
  | FACING of compass_direction * int
  | NOT of int
  | AND of int
  | OR of int
  | RETR of int
  | CALLBK of int
