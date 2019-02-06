exception SemanticException of string

let codegen fxns =
  let fxn_tbl = Hashtbl.create 30 in
  let jeroo_tbl = Hashtbl.create 30 in
  let code_queue = Queue.create() in

  let relative_dir_of_expr e =
    match e with
    | `LeftExpr -> Bytecode.Left
    | `RightExpr -> Bytecode.Right
    | `HereExpr -> Bytecode.Here
    | `AheadExpr -> Bytecode.Ahead
    | _ -> raise (SemanticException "type error: expression must be LEFT, RIGHT, AHEAD, or HERE")
  in

  let rec gen_code_expr expr =
    match expr with
    | `TrueExpr ->
      Queue.add Bytecode.TRUE code_queue
    | `FalseExpr ->
      Queue.add Bytecode.FALSE code_queue
    | `BinOpExpr (e1, `And, e2) ->
      gen_code_expr e1;
      gen_code_expr e2;
      Queue.add Bytecode.AND code_queue
    | `BinOpExpr (e1, `Or, e2) ->
      gen_code_expr e1;
      gen_code_expr e2;
      Queue.add Bytecode.OR code_queue
    | `UnOpExpr (`Not, e) ->
      gen_code_expr e;
      Queue.add Bytecode.NOT code_queue
    | `BinOpExpr (`IdExpr(id), `Dot, e) ->
      let id_loc = Hashtbl.find jeroo_tbl id in
      Queue.add (Bytecode.CSR id_loc) code_queue;
      gen_code_expr e
    | `FxnAppExpr (`IdExpr(id), args) ->
      begin match id with
        | "hop" -> begin match args with
            | [] ->  Queue.add (Bytecode.HOP 1) code_queue
            | `IntExpr(n) :: [] -> Queue.add (Bytecode.HOP n) code_queue
            | _ -> raise (SemanticException "Invalid arguments, hop requires an integer as it's only parameter")
          end
        | "pick" -> begin match args with
            | [] -> Queue.add (Bytecode.PICK) code_queue
            | _ -> raise (SemanticException "Invalid arguments, pick requires no arguments")
          end
        | "plant" -> begin match args with
            | [] -> Queue.add (Bytecode.PLANT) code_queue
            | _ -> raise (SemanticException "Invalid arguments, plant requires no arguments")
          end
        | "toss" -> begin match args with
            | [] -> Queue.add (Bytecode.TOSS) code_queue
            | _ -> raise (SemanticException "Invalid arguments, toss requires no arguments")
          end
        | "give" -> begin match args with
            | [] -> Queue.add (Bytecode.GIVE Bytecode.Ahead) code_queue
            | e :: [] -> Queue.add (Bytecode.GIVE (relative_dir_of_expr e)) code_queue
            | _ -> raise (SemanticException "Invalid arguments, toss requires either a relative direction or no arguments")
          end
        | "turn" -> begin match args with
            | e :: [] -> Queue.add (Bytecode.TURN (relative_dir_of_expr e)) code_queue
            | _ -> raise (SemanticException "Invalid arguments, turn requires one relative direction argument")
          end
        | _ -> failwith "TODO"
      end
    | _ -> failwith "TODO"
  in

  let direction_of_expr expr =
    match expr with
    | `NorthExpr -> Bytecode.North
    | `SouthExpr -> Bytecode.South
    | `EastExpr -> Bytecode.East
    | `WestExpr -> Bytecode.West
    | _ -> raise (SemanticException "Invalid type, expression must be NORTH, SOUTH, EAST, or WEST")
  in

  let gen_code_decl id args =
    let id_loc = Hashtbl.find jeroo_tbl id in
    match args with
    | [] -> Bytecode.NEW (id_loc, 1, 1, 0, Bytecode.North)
    | [`IntExpr(x); `IntExpr(y)] -> Bytecode.NEW (id_loc, x, y, 0, Bytecode.North)
    | [`IntExpr(x); `IntExpr(y); `IntExpr(num_flowers)] -> Bytecode.NEW (id_loc, x, y, num_flowers, Bytecode.North)
    | [`IntExpr(x); `IntExpr(y); `IntExpr(num_flowers); direction] -> Bytecode.NEW (id_loc, x, y, num_flowers, (direction_of_expr direction))
    | _ -> raise (SemanticException ("Invalid Jeroo arguments"))
  in

  let rec gen_code_stmt stmt =
    match stmt with
    | `BlockStmt stmts ->
      stmts
      |> List.iter (fun stmt -> gen_code_stmt stmt)
    | `ExprStmt expr ->
      gen_code_expr expr
    | `DeclStmt (ty, id, expr) ->
      if not (String.equal ty "Jeroo") then
        raise (SemanticException "Invalid type, Jeroo is the only valid type")
      else begin
        Hashtbl.add jeroo_tbl id (Hashtbl.length jeroo_tbl);
        begin match expr with
          | `UnOpExpr (`New, `FxnAppExpr (`IdExpr(ctor), args)) ->
            if not (String.equal ctor "Jeroo") then
              raise (SemanticException ("Invalid constructor: " ^ ctor ^ ", Jeroo is the only valid constructor"))
            else
              Queue.add (gen_code_decl id args) code_queue
          | _ -> raise (SemanticException "Invalid right hand side of declaration, must be a Jeroo constructor")
        end
      end
    | _ -> failwith "TODO"
  in

  let gen_code fxn =
    let (id, stmts) = fxn in
    Hashtbl.add fxn_tbl id (Queue.length code_queue);
    stmts
    |> List.iter (fun stmt -> gen_code_stmt stmt)
  in

  fxns
  |> List.iter (fun fxn -> gen_code fxn);
  Queue.to_seq code_queue
