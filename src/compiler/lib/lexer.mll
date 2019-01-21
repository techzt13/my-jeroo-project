{
  open Parser
  exception Error of string
}

let digit = ['0'-'9']
let letter = ['a'-'z''A'-'Z''_']

let id = letter (letter | digit)*
let int_constant = digit+

let whitespace = ['\n''\r'' ' '\t']+

rule token = parse
| whitespace
    { token lexbuf }
| "true"
    { TRUE }
| "false"
  { FALSE }
| "LEFT"
    { LEFT }
| "RIGHT"
    { RIGHT }
| "AHEAD"
    { AHEAD }
| "HERE"
    { HERE }
| "NORTH"
    { NORTH }
| "EAST"
    { EAST }
| "SOUTH"
    { SOUTH }
| "WEST"
  { WEST }
| "method"
  { METHOD }
| "if"
    { IF }
| "else"
  { ELSE }
| "new"
  { NEW }
| id as i
  { ID (i) }
| int_constant as i
    { INT (int_of_string i) }
| "&&"
    { AND }
| "||"
    { OR }
| "!"
  { NOT }
| "="
  { EQ }
| ";"
  { SEMICOLON }
| ","
  { COMMA }
| "."
  { DOT }
| '('
    { LPAREN }
| ')'
    { RPAREN }
| '{'
    { LBRACKET }
| '}'
    { RBRACKET }
| _
    { raise (Error (Printf.sprintf "At offset %d: unexpected character.\n" (Lexing.lexeme_start lexbuf))) }
