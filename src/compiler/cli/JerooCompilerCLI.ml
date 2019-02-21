open Lib

let str_of_instr op arg1 arg2 arg3 arg4 arg5 arg6 =
  Printf.sprintf "%s %d %d %d %d %d %d" op arg1 arg2 arg3 arg4 arg5 arg6

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
      | Bytecode.JUMP (n, line_num) -> str_of_instr "JUMP" n 0 0 0 0 line_num
      | Bytecode.JUMP_LBL (_, line_num) -> str_of_instr "JUMP" (-1) 0 0 0 0 line_num
      | Bytecode.BZ (n, line_num) -> str_of_instr "BZ" n 0 0 0 0 line_num
      | Bytecode.BZ_LBL (_, line_num) -> str_of_instr "BZ" (-1) 0 0 0 0 line_num
      | Bytecode.LABEL (_, line_num) -> str_of_instr "JUMP" (-1) 0 0 0 0 line_num
      | Bytecode.CALLBK line_num -> str_of_instr "CALLBK" 0 0 0 0 0 line_num
      | Bytecode.RETR line_num -> str_of_instr "RETR" 0 0 0 0 0 line_num
      | Bytecode.CSR (n, line_num) -> str_of_instr "CSR" n 0 0 0 0 line_num
      | Bytecode.NEW (id, x, y, num_flowers, direction, line_num) ->
        str_of_instr "NEW" id x y num_flowers (Bytecode.int_of_compass_direction direction) line_num
      | Bytecode.TURN (direction, line_num) ->
        str_of_instr "TURN" (Bytecode.int_of_relative_direction direction) 0 0 0 0 line_num
      | Bytecode.HOP (n, line_num) -> str_of_instr "HOP" n 0 0 0 0 line_num
      | Bytecode.TOSS line_num -> str_of_instr "TOSS" 0 0 0 0 0 line_num
      | Bytecode.PLANT line_num -> str_of_instr "PLANT" 0 0 0 0 0 line_num
      | Bytecode.GIVE (direction, line_num) ->
        str_of_instr "GIVE" (Bytecode.int_of_relative_direction direction) 0 0 0 0 line_num
      | Bytecode.PICK line_num -> str_of_instr "PICK" 0 0 0 0 0 line_num
      | Bytecode.TRUE line_num -> str_of_instr "TRUE" 0 0 0 0 0 line_num
      | Bytecode.FALSE line_num -> str_of_instr "FALSE" 0 0 0 0 0 line_num
      | Bytecode.HASFLWR line_num -> str_of_instr "HASFLWR" 0 0 0 0 0 line_num
      | Bytecode.ISNET (direction, line_num) ->
        str_of_instr "ISNET" (Bytecode.int_of_relative_direction direction) 0 0 0 0 line_num
      | Bytecode.ISWATER (direction, line_num) ->
        str_of_instr "ISWATER" (Bytecode.int_of_relative_direction direction) 0 0 0 0 line_num
      | Bytecode.ISJEROO (direction, line_num) ->
        str_of_instr "ISJEROO" (Bytecode.int_of_relative_direction direction) 0 0 0 0 line_num
      | Bytecode.ISFLWR (direction, line_num) ->
        str_of_instr "ISFLWR" (Bytecode.int_of_relative_direction direction) 0 0 0 0 line_num
      | Bytecode.FACING (direction, line_num) ->
        str_of_instr "FACING" (Bytecode.int_of_compass_direction direction) 0 0 0 0 line_num
      | Bytecode.AND line_num -> str_of_instr "AND" 0 0 0 0 0 line_num
      | Bytecode.OR line_num -> str_of_instr "OR" 0 0 0 0 0 line_num
      | Bytecode.NOT line_num -> str_of_instr "NOT" 0 0 0 0 0 line_num
    )
  |> Seq.iter (fun code_str -> print_endline code_str)
