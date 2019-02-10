open Js_of_ocaml
open Lib

let _ =
  Js.export "compiler"
    (object%js
      method compile (code : Js.js_string Js.t) = Compiler.compile (JerooCompilerUtils.ocaml_str_of_js_str code)
    end)
