open OUnit2
open Lib

let parse_string s =
  let lexbuf = Lexing.from_string s in PythonParser.translation_unit (PythonLexer.token (PythonLexerState.create())) lexbuf

let suite =
  "Python Parsing">:: [
  ]
