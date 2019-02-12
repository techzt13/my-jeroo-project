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

let int_of_relative_direction direction = match direction with
  | Bytecode.Ahead -> 0
  | Bytecode.Here-> -1
  | Bytecode.Right -> 1
  | Bytecode.Left -> 3

let int_of_compass_direction direction = match direction with
  | Bytecode.North -> 0
  | Bytecode.East -> 1
  | Bytecode.South -> 2
  | Bytecode.West -> 3

let json_of_bytecode bytecode =
  bytecode
  |> Seq.map (fun code -> match code with
      | Bytecode.JUMP n -> new_instruction "JUMP" n 0 0 0 0 0
      | Bytecode.JUMP_LBL _ -> new_instruction "JUMP" (-1) 0 0 0 0 0
      | Bytecode.BZ n -> new_instruction "BZ" n 0 0 0 0 0
      | Bytecode.BZ_LBL _ -> new_instruction "BZ" (-1) 0 0 0 0 0
      | Bytecode.LABEL _ -> new_instruction "JUMP" (-1) 0 0 0 0 0
      | Bytecode.CALLBK -> new_instruction "CALLBK" 0 0 0 0 0 0
      | Bytecode.RETR -> new_instruction "RETR" 0 0 0 0 0 0
      | Bytecode.CSR n -> new_instruction "CSR" n 0 0 0 0 0
      | Bytecode.NEW (id, x, y, num_flowers, direction) ->
        new_instruction "NEW" id x y num_flowers (int_of_compass_direction direction) 0
      | Bytecode.TURN direction ->
        new_instruction "TURN" (int_of_relative_direction direction) 0 0 0 0 0
      | Bytecode.HOP n -> new_instruction "HOP" n 0 0 0 0 0
      | Bytecode.TOSS -> new_instruction "TOSS" 0 0 0 0 0 0
      | Bytecode.PLANT -> new_instruction "PLANT" 0 0 0 0 0 0
      | Bytecode.GIVE direction ->
        new_instruction "GIVE" (int_of_relative_direction direction) 0 0 0 0 0
      | Bytecode.PICK -> new_instruction "PICK" 0 0 0 0 0 0
      | Bytecode.TRUE -> new_instruction "TRUE" 0 0 0 0 0 0
      | Bytecode.FALSE -> new_instruction "FALSE" 0 0 0 0 0 0
      | Bytecode.HASFLWR -> new_instruction "HASFLWR" 0 0 0 0 0 0
      | Bytecode.ISNET direction ->
        new_instruction "ISNET" (int_of_relative_direction direction) 0 0 0 0 0
      | Bytecode.ISWATER direction ->
        new_instruction "ISWATER" (int_of_relative_direction direction) 0 0 0 0 0
      | Bytecode.ISJEROO direction ->
        new_instruction "ISJEROO" (int_of_relative_direction direction) 0 0 0 0 0
      | Bytecode.ISFLWR direction ->
        new_instruction "ISFLWR" (int_of_relative_direction direction) 0 0 0 0 0
      | Bytecode.FACING direction ->
        new_instruction "FACING" (int_of_compass_direction direction) 0 0 0 0 0
      | Bytecode.AND -> new_instruction "AND" 0 0 0 0 0 0
      | Bytecode.OR -> new_instruction "OR" 0 0 0 0 0 0
      | Bytecode.NOT -> new_instruction "NOT" 0 0 0 0 0 0
    )
  |> Array.of_seq
  |> Js.array
