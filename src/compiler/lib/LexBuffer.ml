open Lexing

type t = {
  buf : Sedlexing.lexbuf;
  mutable pos : Lexing.position;
  mutable pos_mark : Lexing.position;
  mutable last_char : int option;
  mutable last_char_mark : int option;
}

let of_sedlex ?(file="<n/a>") ?pos_opt buf =
  let pos = match pos_opt with
    | Some p -> p
    | None -> Lexing.{
        pos_fname = file;
        pos_lnum = 1;
        pos_bol = 0;
        pos_cnum = 0;
      }
  in
  {
    buf;
    pos;
    pos_mark = pos;
    last_char = None;
    last_char_mark = None;
  }

let of_ascii_string ?pos_opt s =
  of_sedlex ?pos_opt Sedlexing.(Latin1.from_string s)

let mark lexbuf p =
  lexbuf.pos_mark <- lexbuf.pos;
  lexbuf.last_char_mark <- lexbuf.last_char;
  Sedlexing.mark lexbuf.buf p

let backtrack lexbuf =
  lexbuf.pos_mark <- lexbuf.pos;
  lexbuf.last_char <- lexbuf.last_char_mark;
  Sedlexing.backtrack lexbuf.buf

let start lexbuf =
  lexbuf.pos_mark <- lexbuf.pos;
  lexbuf.last_char_mark <- lexbuf.last_char;
  Sedlexing.start lexbuf.buf

let next_loc lexbuf =
  { lexbuf.pos with pos_cnum = lexbuf.pos.pos_cnum + 1 }

let cr = int_of_char '\r'

let int_opt_eq int1_opt int2_opt =
  match (int1_opt, int2_opt) with
  | (None, None) -> true
  | (None, Some _) | (Some _, None) -> false
  | (Some a, Some b) -> a = b

let char_opt_of_uchar_opt uchar_opt =
  match uchar_opt with
  | Some uchar -> Some (Uchar.to_char uchar)
  | None -> None

let next lexbuf =
  let c = Sedlexing.next lexbuf.buf in
  let pos = next_loc lexbuf in
  begin match (char_opt_of_uchar_opt c) with
    | Some '\r' ->
      lexbuf.pos <- { pos with
                      pos_bol = pos.pos_cnum - 1;
                      pos_lnum = pos.pos_lnum + 1; }
    | Some '\n' when int_opt_eq lexbuf.last_char (Some cr) ->
      lexbuf.pos <- { pos with
                      pos_bol = pos.pos_cnum - 1;
                      pos_lnum = pos.pos_lnum + 1; }
    | Some '\n' -> ()
    | _ ->
      lexbuf.pos <- pos
  end;
  begin match c with
    | Some c -> lexbuf.last_char <- Some (Uchar.to_int c)
    | None -> lexbuf.last_char <- None
  end;
  c

let lexeme lexbuf =
  Sedlexing.lexeme lexbuf.buf
