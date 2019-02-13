open Lib

let str_of_instr op arg1 arg2 arg3 arg4 arg5 arg6 =
  Printf.sprintf "%s %d %d %d %d %d %d" op arg1 arg2 arg3 arg4 arg5 arg6

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

(* simple utility program to compile jeroo code and print the bytecode to stdout *)
let _ =
  let args = Sys.argv in
  let args_length = args |> Array.length in
  if args_length != 2 then failwith "Must have one arg, filename";
  let filename = args.(1) in
  let code = Core.In_channel.read_all filename in
  let bytecode = Compiler.compile code in

  bytecode
  |> Seq.map (fun code -> match code with
      | Bytecode.JUMP n -> str_of_instr "JUMP" n 0 0 0 0 0
      | Bytecode.JUMP_LBL _ -> str_of_instr "JUMP" (-1) 0 0 0 0 0
      | Bytecode.BZ n -> str_of_instr "BZ" n 0 0 0 0 0
      | Bytecode.BZ_LBL _ -> str_of_instr "BZ" (-1) 0 0 0 0 0
      | Bytecode.LABEL _ -> str_of_instr "JUMP" (-1) 0 0 0 0 0
      | Bytecode.CALLBK -> str_of_instr "CALLBK" 0 0 0 0 0 0
      | Bytecode.RETR -> str_of_instr "RETR" 0 0 0 0 0 0
      | Bytecode.CSR n -> str_of_instr "CSR" n 0 0 0 0 0
      | Bytecode.NEW (id, x, y, num_flowers, direction) ->
        str_of_instr "NEW" id x y num_flowers (int_of_compass_direction direction) 0
      | Bytecode.TURN direction ->
        str_of_instr "TURN" (int_of_relative_direction direction) 0 0 0 0 0
      | Bytecode.HOP n -> str_of_instr "HOP" n 0 0 0 0 0
      | Bytecode.TOSS -> str_of_instr "TOSS" 0 0 0 0 0 0
      | Bytecode.PLANT -> str_of_instr "PLANT" 0 0 0 0 0 0
      | Bytecode.GIVE direction ->
        str_of_instr "GIVE" (int_of_relative_direction direction) 0 0 0 0 0
      | Bytecode.PICK -> str_of_instr "PICK" 0 0 0 0 0 0
      | Bytecode.TRUE -> str_of_instr "TRUE" 0 0 0 0 0 0
      | Bytecode.FALSE -> str_of_instr "FALSE" 0 0 0 0 0 0
      | Bytecode.HASFLWR -> str_of_instr "HASFLWR" 0 0 0 0 0 0
      | Bytecode.ISNET direction ->
        str_of_instr "ISNET" (int_of_relative_direction direction) 0 0 0 0 0
      | Bytecode.ISWATER direction ->
        str_of_instr "ISWATER" (int_of_relative_direction direction) 0 0 0 0 0
      | Bytecode.ISJEROO direction ->
        str_of_instr "ISJEROO" (int_of_relative_direction direction) 0 0 0 0 0
      | Bytecode.ISFLWR direction ->
        str_of_instr "ISFLWR" (int_of_relative_direction direction) 0 0 0 0 0
      | Bytecode.FACING direction ->
        str_of_instr "FACING" (int_of_compass_direction direction) 0 0 0 0 0
      | Bytecode.AND -> str_of_instr "AND" 0 0 0 0 0 0
      | Bytecode.OR -> str_of_instr "OR" 0 0 0 0 0 0
      | Bytecode.NOT -> str_of_instr "NOT" 0 0 0 0 0 0
    )
  |> Seq.iter (fun code_str -> print_endline code_str)
