#include "Tokens.ml"

type ('token, 'a) parser =
  (Lexing.lexbuf -> 'token) -> Lexing.lexbuf -> 'a

val parse : LexBuffer.t -> (token, 'a) parser -> 'a

val parse_string : ?pos_opt:Lexing.position -> string -> (token,'a) parser -> 'a
