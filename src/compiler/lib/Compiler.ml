exception HeaderException of string

let compile code =
  let lexbuf = Lexing.from_string code in

  let regex = Str.regexp "\\(Java\\)" in
  let _ =
    try Str.search_forward regex code 0
    with Not_found -> raise (HeaderException "Malformed Header")
  in
  let language_id =
    try Str.matched_group 1 code
    with Not_found -> raise (HeaderException "Missing Language ID in Header")
  in
  let ast = match language_id with
    | "Java" -> JavaParser.translation_unit JavaLexer.token lexbuf
    | "VB" -> JavaParser.translation_unit JavaLexer.token lexbuf
    | _ -> raise (HeaderException "Unknown Language")
  in

  Codegen.codegen ast
