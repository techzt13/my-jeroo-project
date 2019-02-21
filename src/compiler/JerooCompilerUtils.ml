open Js_of_ocaml
open Lib

let new_instruction op_init arg1 arg2 arg3 arg4 arg5 arg6 =
  (object%js
    val op = Js.string op_init
    val a = arg1
    val b = arg2
    val c = arg3
    val d = arg4
    val e = arg5
    val f = arg6
  end)

let json_of_bytecode bytecode =
  bytecode
  |> Seq.map (fun code -> match code with
      | Bytecode.JUMP (n, lnum) -> new_instruction "JUMP" n 0 0 0 0 lnum
      | Bytecode.JUMP_LBL (_, lnum) -> new_instruction "JUMP" (-1) 0 0 0 0 lnum
      | Bytecode.BZ (n, lnum) -> new_instruction "BZ" n 0 0 0 0 lnum
      | Bytecode.BZ_LBL (_, lnum) -> new_instruction "BZ" (-1) 0 0 0 0 lnum
      | Bytecode.LABEL (_, lnum) -> new_instruction "JUMP" (-1) 0 0 0 0 lnum
      | Bytecode.CALLBK lnum -> new_instruction "CALLBK" 0 0 0 0 0 lnum
      | Bytecode.RETR lnum -> new_instruction "RETR" 0 0 0 0 0 lnum
      | Bytecode.CSR (n, lnum) -> new_instruction "CSR" n 0 0 0 0 lnum
      | Bytecode.NEW (id, x, y, num_flowers, direction, lnum) ->
        new_instruction "NEW" id x y num_flowers (Bytecode.int_of_compass_direction direction) lnum
      | Bytecode.TURN (direction, lnum) ->
        new_instruction "TURN" (Bytecode.int_of_relative_direction direction) 0 0 0 0 lnum
      | Bytecode.HOP (n, lnum) -> new_instruction "HOP" n 0 0 0 0 lnum
      | Bytecode.TOSS lnum -> new_instruction "TOSS" 0 0 0 0 0 lnum
      | Bytecode.PLANT lnum -> new_instruction "PLANT" 0 0 0 0 0 lnum
      | Bytecode.GIVE (direction, lnum) ->
        new_instruction "GIVE" (Bytecode.int_of_relative_direction direction) 0 0 0 0 lnum
      | Bytecode.PICK lnum -> new_instruction "PICK" 0 0 0 0 0 lnum
      | Bytecode.TRUE lnum -> new_instruction "TRUE" 0 0 0 0 0 lnum
      | Bytecode.FALSE lnum -> new_instruction "FALSE" 0 0 0 0 0 lnum
      | Bytecode.HASFLWR lnum -> new_instruction "HASFLWR" 0 0 0 0 0 lnum
      | Bytecode.ISNET (direction, lnum) ->
        new_instruction "ISNET" (Bytecode.int_of_relative_direction direction) 0 0 0 0 lnum
      | Bytecode.ISWATER (direction, lnum) ->
        new_instruction "ISWATER" (Bytecode.int_of_relative_direction direction) 0 0 0 0 lnum
      | Bytecode.ISJEROO (direction, lnum) ->
        new_instruction "ISJEROO" (Bytecode.int_of_relative_direction direction) 0 0 0 0 lnum
      | Bytecode.ISFLWR (direction, lnum) ->
        new_instruction "ISFLWR" (Bytecode.int_of_relative_direction direction) 0 0 0 0 lnum
      | Bytecode.FACING (direction, lnum) ->
        new_instruction "FACING" (Bytecode.int_of_compass_direction direction) 0 0 0 0 lnum
      | Bytecode.AND lnum -> new_instruction "AND" 0 0 0 0 0 lnum
      | Bytecode.OR lnum -> new_instruction "OR" 0 0 0 0 0 lnum
      | Bytecode.NOT lnum -> new_instruction "NOT" 0 0 0 0 0 lnum
    )
  |> Array.of_seq
  |> Js.array
