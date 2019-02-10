open Js_of_ocaml

let ocaml_str_of_js_str (s : Js.js_string Js.t) =
  let length = s##.length in
  let ocaml_str = Bytes.create length in
  for i = 0 to length - 1 do
    let code = int_of_float (s##charCodeAt i) in
    let char = Char.chr code in
    Bytes.set ocaml_str i char;
  done;
  Bytes.to_string ocaml_str
