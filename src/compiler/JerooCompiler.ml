open Js_of_ocaml
open Lib

let _ =
  Js.export "JerooCompiler"
    (object%js
      method compile (code : Js.js_string Js.t) =
        Js.to_bytestring code
        |> Compiler.compile
        |> JerooCompilerUtils.json_of_bytecode
    end)
