{
open VBParser
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

let reset_lnum lexbuf =
  let pos = lexbuf.lex_curr_p in
  lexbuf.lex_curr_p <-
    { pos with pos_bol = lexbuf.lex_curr_pos;
               pos_lnum = 0
    }
}

let whitespace = [' ' '\t' '\r']+
let newline = '\n'
let comment = "'" [^'\n']* '\n'

let digit = '-'? ['0'-'9']
let letter = ['a'-'z' 'A'-'Z' '_']

(* VB is case insensitive *)
let a = 'a' | 'A'
let b = 'b' | 'B'
let c = 'c' | 'C'
let d = 'd' | 'D'
let e = 'e' | 'E'
let f = 'f' | 'F'
let g = 'g' | 'G'
let h = 'h' | 'H'
let i = 'i' | 'I'
let j = 'j' | 'J'
let k = 'k' | 'K'
let l = 'l' | 'L'
let m = 'm' | 'M'
let n = 'n' | 'N'
let o = 'o' | 'O'
let p = 'p' | 'P'
let q = 'q' | 'Q'
let r = 'r' | 'R'
let s = 's' | 'S'
let t = 't' | 'T'
let u = 'u' | 'U'
let v = 'v' | 'V'
let w = 'w' | 'W'
let x = 'x' | 'X'
let y = 'y' | 'Y'
let z = 'z' | 'Z'

let identifier = letter (letter | digit)*
let int_constant = '-'? digit+

rule token = parse
| whitespace
  { token lexbuf }
| comment
  { next_line lexbuf; token lexbuf }
| "@VB\n"
  { HEADER }
| "@@\n"
  { reset_lnum lexbuf; MAIN_METH_SEP }
| int_constant as i
  { INT ((int_of_string i), (get_lnum lexbuf)) }
| d i m
  { DIM (get_lnum lexbuf) }
| a s
  { AS (get_lnum lexbuf) }
| n e w
  { NEW (get_lnum lexbuf) }
| s u b
  { SUB (get_lnum lexbuf) }
| w h i l e
  { WHILE (get_lnum lexbuf) }
| i f
  { IF (get_lnum lexbuf) }
| t h e n
  { THEN (get_lnum lexbuf) }
| e l s e i f
  { ELSEIF (get_lnum lexbuf) }
| e l s e
  { ELSE (get_lnum lexbuf) }
| e n d
  { END (get_lnum lexbuf) }
| l e f t
  { LEFT (get_lnum lexbuf) }
| r i g h t
  { RIGHT (get_lnum lexbuf) }
| a h e a d
  { AHEAD (get_lnum lexbuf) }
| h e r e
  { HERE (get_lnum lexbuf) }
| n o r t h
  { NORTH (get_lnum lexbuf) }
| e a s t
  { EAST (get_lnum lexbuf) }
| s o u t h
  { SOUTH (get_lnum lexbuf) }
| w e s t
  { WEST (get_lnum lexbuf) }
| t r u e
  { TRUE (get_lnum lexbuf) }
| f a l s e
  { FALSE (get_lnum lexbuf) }
| a n d
  { AND (get_lnum lexbuf) }
| o r
  { OR (get_lnum lexbuf) }
| n o t
  { NOT (get_lnum lexbuf) }
| j e r o o
  { ID ("Jeroo", (get_lnum lexbuf)) }
| h a s f l o w e r
  { ID ("hasFlower", (get_lnum lexbuf)) }
| i s f a c i n g
  { ID ("isFacing", (get_lnum lexbuf)) }
| i s f l o w e r
  { ID ("isFlower", (get_lnum lexbuf)) }
| i s j e r o o
  { ID ("isJeroo", (get_lnum lexbuf)) }
| i s n e t
  { ID ("isNet", (get_lnum lexbuf)) }
| i s w a t e r
  {ID ("isWater", (get_lnum lexbuf)) }
| i s c l e a r
  {ID ("isClear", (get_lnum lexbuf)) }
| identifier as id
  { ID ((String.lowercase_ascii id), (get_lnum lexbuf)) }
| '='
  { EQ (get_lnum lexbuf)}
| '('
  { LPAREN (get_lnum lexbuf)}
| ')'
  { RPAREN (get_lnum lexbuf)}
| ','
  { COMMA (get_lnum lexbuf)}
| '.'
  { DOT (get_lnum lexbuf) }
| newline
  { next_line lexbuf; NEWLINE }
| eof
  { EOF }
