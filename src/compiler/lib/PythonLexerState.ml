type t = {
  mutable curr_offset : int;
  offset_stack : int Stack.t;
  mutable nl_ignore : int;
  mutable is_at_end : bool;
}

let create () =
  let stack = Stack.create() in
  stack |> Stack.push 0;
  {
    curr_offset = 0;
    offset_stack = stack;
    nl_ignore = 0;
    is_at_end = false;
  }
