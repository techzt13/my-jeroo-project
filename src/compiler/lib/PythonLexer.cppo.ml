#include "Tokens.ml"

module Sedlexing = LexBuffer
open LexBuffer
open PythonLexerState

exception LexError of (Lexing.position * string)

(* exception ParseError of (token * Lexing.position * Lexing.position) *)

let e = [%sedlex.regexp? '"']

let newline = [%sedlex.regexp? '\r' | '\n' | "\r\n"]
let whitespace = [%sedlex.regexp? ' ' | '\t']
let comment = [%sedlex.regexp? '#', Star (Compl ('\n' | '\r'))]

let digit = [%sedlex.regexp? '0'..'9']
let nonzerodigit = [%sedlex.regexp? '1'..'9']
let decimalinteger = [%sedlex.regexp? nonzerodigit, Star digit]

let identifier = [%sedlex.regexp? ('a'..'z' | 'A'..'Z' | '_'), Star ('a'..'z' | 'A'..'Z' | '0'..'9' | '_')]

let string_of_uchar_arr uchar_arr =
  let bytes = Bytes.create (Array.length uchar_arr) in
  uchar_arr
  |> Array.map Uchar.to_char
  |> Array.iteri (Bytes.set bytes)
  ;
  Bytes.to_string bytes

let rec offset state buf =
  begin
    match%sedlex buf with
    | e -> ()
    | ' ' -> state.curr_offset <- state.curr_offset + 1; offset state buf
    | '\t' -> state.curr_offset <- state.curr_offset + 8; offset state buf
    | _ -> ()
  end

let rec _token state buf =
  begin
    match%sedlex buf with
    | (Star (Star whitespace, Opt comment, newline), Star whitespace, Opt comment), newline ->
      if state.nl_ignore <= 0 then begin
        let lnum = buf.pos.pos_lnum in
        state.curr_offset <- 0;
        offset state buf;
        NEWLINE lnum
      end else
        _token state buf
    | Plus whitespace -> _token state buf
    | "@PYTHON\n" ->
      state.curr_offset <- 0;
      state.nl_ignore <- 0;
      Stack.clear state.offset_stack;
      Stack.push 0 state.offset_stack;
      HEADER
    | "@@\n" ->
      state.curr_offset <- 0;
      state.nl_ignore <- 0;
      Stack.clear state.offset_stack;
      Stack.push 0 state.offset_stack;
      MAIN_METH_SEP
    | "def" -> DEF (buf.pos.pos_lnum)
    | "and" -> AND (buf.pos.pos_lnum)
    | "or" -> OR (buf.pos.pos_lnum)
    | "not" -> NOT (buf.pos.pos_lnum)
    | "if" -> IF (buf.pos.pos_lnum)
    | "elif" -> ELIF (buf.pos.pos_lnum)
    | "else" -> ELSE (buf.pos.pos_lnum)
    | "while" -> WHILE (buf.pos.pos_lnum)
    | "True" -> TRUE (buf.pos.pos_lnum)
    | "False" -> FALSE (buf.pos.pos_lnum)
    | "NORTH" -> NORTH (buf.pos.pos_lnum)
    | "SOUTH" -> SOUTH (buf.pos.pos_lnum)
    | "EAST" -> EAST (buf.pos.pos_lnum)
    | "WEST" -> WEST (buf.pos.pos_lnum)
    | "LEFT" -> LEFT (buf.pos.pos_lnum)
    | "RIGHT" -> RIGHT (buf.pos.pos_lnum)
    | "AHEAD" -> AHEAD (buf.pos.pos_lnum)
    | "HERE" -> HERE (buf.pos.pos_lnum)
    | identifier -> let id = (lexeme buf) |> string_of_uchar_arr in ID (id, buf.pos.pos_lnum)
    | "(" -> LPAREN (buf.pos.pos_lnum)
    | ")" -> RPAREN (buf.pos.pos_lnum)
    | ":" -> COLON (buf.pos.pos_lnum)
    | "." -> DOT (buf.pos.pos_lnum)
    | "," -> COMMA (buf.pos.pos_lnum)
    | "=" -> EQ (buf.pos.pos_lnum)
    | eof -> EOF (buf.pos.pos_lnum)
    | _ -> raise (LexError (buf.pos, "Unknown character"))
  end

let token state buf =
  begin
    match%sedlex buf with
    | _ ->
      let lnum = buf.pos.pos_lnum in
      let curr_offset = state.curr_offset in
      let last_offset = Stack.top state.offset_stack in
      if curr_offset < last_offset
      then (ignore (Stack.pop state.offset_stack); DEDENT lnum)
      else if curr_offset > last_offset
      then (Stack.push curr_offset state.offset_stack; INDENT lnum)
      else (_token state buf)
  end

let loc_token state buf =
  let loc_start = next_loc buf in
  let t = token state buf in
  let loc_end = next_loc buf in
  (t, loc_start, loc_end)

type ('token, 'a) parser = ('token, 'a) MenhirLib.Convert.traditional

let parse buf p =
  let state = PythonLexerState.create() in
  let last_token = ref Lexing.(EOF 1, dummy_pos, dummy_pos) in
  let next_token () = last_token := loc_token state buf; !last_token in
  try MenhirLib.Convert.Simplified.traditional2revised p next_token with
  | LexError (pos, s) -> raise (LexError (pos, s))
  (* | _ -> raise (ParseError (!last_token)) *)

let parse_string ?pos_opt s p =
  parse (LexBuffer.of_ascii_string ?pos_opt s) p
