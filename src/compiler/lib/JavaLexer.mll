{
open JavaParser
open Lexing

exception Error of string

let get_lnum lexbuf =
  let pos = lexbuf.lex_curr_p in
  pos.pos_lnum

let next_line lexbuf =
  let pos = lexbuf.lex_curr_p in
  lexbuf.lex_curr_p <-
    { pos with pos_bol = lexbuf.lex_curr_pos;
               pos_lnum = pos.pos_lnum + 1
    }

let next_n_lines n lexbuf =
  let pos = lexbuf.lex_curr_p in
  lexbuf.lex_curr_p <-
    { pos with pos_bol = lexbuf.lex_curr_pos;
               pos_lnum = pos.pos_lnum + n
    }

let reset_lnum lexbuf =
  let pos = lexbuf.lex_curr_p in
  lexbuf.lex_curr_p <-
    { pos with pos_bol = lexbuf.lex_curr_pos;
               pos_lnum = 0
    }
}

let digit = ['0'-'9']
let letter = ['a'-'z' 'A'-'Z' '_']

let id = letter (letter | digit)*
let int_constant = '-'? digit+

let comment = "//" [^'\n']* '\n'
let ml_comment = "/*" [^'*']* [^'/']* "*/"

let whitespace = ['\r' ' ' '\t']+
let newline = '\n'

rule token = parse
| whitespace
  { token lexbuf }
| newline
  { next_line lexbuf; token lexbuf }
| comment
  { next_line lexbuf; token lexbuf }
| ml_comment as text
  { let num_lines =
      text
      |> String.to_seq
      |> Seq.fold_left (fun accum ele -> if ele = '\n' then 1 + accum else accum) 0
    in next_n_lines num_lines lexbuf; token lexbuf }
| "@Java\n"
  { HEADER }
| "@@\n"
  { reset_lnum lexbuf; MAIN_METH_SEP }
| int_constant as i
  { INT ((int_of_string i), (get_lnum lexbuf)) }
| "true"
  { TRUE (get_lnum lexbuf) }
| "false"
  { FALSE (get_lnum lexbuf) }
| "LEFT"
  { LEFT (get_lnum lexbuf) }
| "RIGHT"
  { RIGHT (get_lnum lexbuf) }
| "AHEAD"
  { AHEAD (get_lnum lexbuf) }
| "HERE"
  { HERE (get_lnum lexbuf) }
| "NORTH"
  { NORTH (get_lnum lexbuf) }
| "SOUTH"
  { SOUTH (get_lnum lexbuf) }
| "EAST"
  { EAST (get_lnum lexbuf) }
| "WEST"
  { WEST (get_lnum lexbuf) }
| "if"
  { IF (get_lnum lexbuf) }
| "else"
  { ELSE (get_lnum lexbuf) }
| "while"
  { WHILE (get_lnum lexbuf) }
| "new"
  { NEW (get_lnum lexbuf) }
| "method"
  { METHOD (get_lnum lexbuf) }
| id as i
  { ID (i, (get_lnum lexbuf)) }
| "&&"
  { AND (get_lnum lexbuf) }
| "||"
  { OR (get_lnum lexbuf) }
| "!"
  { NOT (get_lnum lexbuf) }
| "="
  { EQ (get_lnum lexbuf) }
| ";"
  { SEMICOLON (get_lnum lexbuf) }
| ","
  { COMMA (get_lnum lexbuf) }
| "."
  { DOT (get_lnum lexbuf) }
| '('
  { LPAREN (get_lnum lexbuf) }
| ')'
  { RPAREN (get_lnum lexbuf) }
| '{'
  { LBRACKET (get_lnum lexbuf) }
| '}'
  { RBRACKET (get_lnum lexbuf) }
| eof
  { EOF }
| _
  { raise (Error (Printf.sprintf "At offset %d: unexpected character.\n" (Lexing.lexeme_start lexbuf))) }
