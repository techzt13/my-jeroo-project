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
  | CSR of int
  | JUMP of int
  | BZ of int
  | NEW of int * int * int * int * compass_direction
  | TURN of relative_direction
  | HOP of int
  | PICK
  | TOSS
  | PLANT
  | GIVE of relative_direction
  | TRUE
  | FALSE
  | HASFLWR
  | ISNET of relative_direction
  | ISWATER of relative_direction
  | ISJEROO of relative_direction
  | ISFLWR of relative_direction
  | FACING of compass_direction
  | NOT
  | AND
  | OR
  | RETR
  | CALLBK
