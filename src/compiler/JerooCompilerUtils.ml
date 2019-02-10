open Js_of_ocaml
open Lib

let ocaml_str_of_js_str (s : Js.js_string Js.t) =
  let length = s##.length in
  let ocaml_str = Bytes.create length in
  for i = 0 to length - 1 do
    let code = int_of_float (s##charCodeAt i) in
    let char = Char.chr code in
    Bytes.set ocaml_str i char;
  done;
  Bytes.to_string ocaml_str

let new_instruction op_init arg1 arg2 arg3 arg4 arg5 arg6 =
  (object%js
    val op = op_init
    val a = arg1
    val b = arg2
    val c = arg3
    val d = arg4
    val e = arg5
    val f = arg6
  end)

let int_of_direction direction = 1

let json_of_bytecode bytecode =
  bytecode
  |> Seq.map (fun code -> match code with
      | Bytecode.AND -> new_instruction "AND" 0 0 0 0 0 0
      | Bytecode.OR -> new_instruction "OR" 0 0 0 0 0 0
      | Bytecode.NOT -> new_instruction "NOT" 0 0 0 0 0 0
      | Bytecode.JUMP n -> new_instruction "JUMP" n 0 0 0 0 0
      | Bytecode.BZ n -> new_instruction "BZ" n 0 0 0 0 0
      | Bytecode.CALLBK -> new_instruction "CALLBK" 0 0 0 0 0 0
      | Bytecode.RETR -> new_instruction "RETR" 0 0 0 0 0 0
      | Bytecode.CSR n -> new_instruction "CSR" n 0 0 0 0 0
      | Bytecode.NEW (id, x, y, num_flowers, direction) -> new_instruction "NEW" id x y num_flowers (int_of_direction direction) 0
    )
  |> List.of_seq
