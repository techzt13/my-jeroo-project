exception SemanticException of string

let relative_dir_of_expr e =
  match e with
  | `LeftExpr -> Bytecode.Left
  | `RightExpr -> Bytecode.Right
  | `HereExpr -> Bytecode.Here
  | `AheadExpr -> Bytecode.Ahead
  | _ -> raise (SemanticException "type error: expression must be LEFT, RIGHT, AHEAD, or HERE")

let compass_dir_of_expr expr =
  match expr with
  | `NorthExpr -> Bytecode.North
  | `SouthExpr -> Bytecode.South
  | `EastExpr -> Bytecode.East
  | `WestExpr -> Bytecode.West
  | _ -> raise (SemanticException "Invalid type, expression must be NORTH, SOUTH, EAST, or WEST")

(* convert labels to memory locations*)
let remove_labels bytecode =
  (* create table from labels to memory locations *)
  let label_tbl = Hashtbl.create 30 in
  (* counter to keep track of the memory location *)
  let mem_loc = ref 0 in
  bytecode
  |> Seq.iter (fun intruction ->
      begin match intruction with
        | Bytecode.LABEL s -> Hashtbl.add label_tbl s (!mem_loc)
        | _ ->
          (* only increment the counter on non-labels *)
          (* since they get removed in the instruction set *)
          mem_loc := !mem_loc + 1
      end;
    );

  (* swap out the jump to labels to jump to memory locations *)
  bytecode
  |> Seq.filter_map (fun instruction -> match instruction with
      | Bytecode.JUMP_LBL lbl -> Some (Bytecode.JUMP (Hashtbl.find label_tbl lbl))
      | Bytecode.BZ_LBL lbl -> Some (Bytecode.BZ (Hashtbl.find label_tbl lbl))
      | Bytecode.LABEL _ -> None
      | _ -> Some (instruction)
    )

let codegen fxns =
  let fxn_tbl = Hashtbl.create 30 in
  let jeroo_tbl = Hashtbl.create 30 in
  let code_queue = Queue.create() in

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
        | "hasFlower" -> begin match args with
            | [] -> Queue.add Bytecode.HASFLWR code_queue
            | _ -> raise (SemanticException "Invalid arguments, hasFlower requires no arguments")
          end
        | "isJeroo" -> begin match args with
            | e :: [] -> Queue.add (Bytecode.ISJEROO (relative_dir_of_expr e)) code_queue
            | _ -> raise (SemanticException "Invalid arguments, isJeroo requires a relative direction")
          end
        | "isFacing" -> begin match args with
            | e :: [] -> Queue.add (Bytecode.FACING (compass_dir_of_expr e)) code_queue
            | _ -> raise (SemanticException "Invalid arguments, isFacing requires a compass direction")
          end
        | "isFlower" -> begin match args with
            | e :: [] -> Queue.add (Bytecode.ISFLWR (relative_dir_of_expr e)) code_queue
            | _ -> raise (SemanticException "Invalid arguments, isFlower requires a relative direction")
          end
        | "isNet" -> begin match args with
            | e :: [] -> Queue.add (Bytecode.ISNET (relative_dir_of_expr e)) code_queue
            | _ -> raise (SemanticException "Invalid arguments, isNet requires a relative direction")
          end
        | "isWater" -> begin match args with
            | e :: [] -> Queue.add (Bytecode.ISWATER (relative_dir_of_expr e)) code_queue
            | _ -> raise (SemanticException "Invalid arguments, isWater requires a relative direction")
          end
        | _ ->
          if Hashtbl.mem fxn_tbl id then
            let loc = Hashtbl.find fxn_tbl id in
            Queue.add Bytecode.CALLBK code_queue;
            Queue.add (Bytecode.JUMP_LBL loc) code_queue
          else
            raise (SemanticException ("Unknown function: " ^ id))
      end
    | _ ->
      raise (SemanticException "Unknown expression")
  in

  let gen_code_decl id args =
    let id_loc = Hashtbl.find jeroo_tbl id in
    match args with
    | [] -> Bytecode.NEW (id_loc, 1, 1, 0, Bytecode.North)
    | [`IntExpr(x); `IntExpr(y)] -> Bytecode.NEW (id_loc, x, y, 0, Bytecode.North)
    | [`IntExpr(x); `IntExpr(y); `IntExpr(num_flowers)] -> Bytecode.NEW (id_loc, x, y, num_flowers, Bytecode.North)
    | [`IntExpr(x); `IntExpr(y); `IntExpr(num_flowers); direction] -> Bytecode.NEW (id_loc, x, y, num_flowers, (compass_dir_of_expr direction))
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
    | `IfStmt(e, stmt) ->
      gen_code_expr e;
      let jmp_lbl = "if_lbl_" ^ (string_of_int (Queue.length code_queue)) in
      let jmp = (Bytecode.BZ_LBL jmp_lbl) in
      Queue.add jmp code_queue;
      gen_code_stmt stmt;
      Queue.add (Bytecode.LABEL jmp_lbl) code_queue;
    | `IfElseStmt(e, s1, s2) ->
      (* generate code for the condition *)
      gen_code_expr e;
      (* if the condition is false, jump to the else block, else execute the true block *)
      let else_lbl = "else_lbl_" ^ (string_of_int (Queue.length code_queue)) in
      let else_jmp = (Bytecode.BZ_LBL else_lbl) in
      Queue.add else_jmp code_queue;
      (* generate the code for the if-block *)
      gen_code_stmt s1;
      (* at the end of the true block, jump to the end of the if-else block *)
      let done_lbl = "done_lbl_" ^ (string_of_int (Queue.length code_queue)) in
      let done_jmp = (Bytecode.JUMP_LBL done_lbl) in
      Queue.add done_jmp code_queue;
      Queue.add (Bytecode.LABEL else_lbl) code_queue;
      (* generate the code for the else-block *)
      gen_code_stmt s2;
      Queue.add (Bytecode.LABEL done_lbl) code_queue;
    | `WhileStmt(e, s) ->
      let loop_lbl = "loop_lbl_" ^ (string_of_int (Queue.length code_queue)) in
      Queue.add (Bytecode.LABEL loop_lbl) code_queue;
      gen_code_expr e;
      let done_lbl = "done_lbl_" ^ (string_of_int (Queue.length code_queue)) in
      Queue.add (Bytecode.BZ_LBL done_lbl) code_queue;
      gen_code_stmt s;
      Queue.add (Bytecode.JUMP_LBL loop_lbl) code_queue;
      Queue.add (Bytecode.LABEL done_lbl) code_queue;
  in

  let gen_code fxn =
    let (id, stmts) = fxn in
    let fxn_lbl = id ^ "_" ^ (string_of_int (Queue.length code_queue)) in
    Hashtbl.add fxn_tbl id fxn_lbl;
    Queue.add (Bytecode.LABEL fxn_lbl) code_queue;
    stmts
    |> List.iter (fun stmt -> gen_code_stmt stmt);
    Queue.add Bytecode.RETR code_queue
  in

  fxns
  |> List.iter (fun fxn -> gen_code fxn);
  let code_with_labels = Queue.to_seq code_queue in
  remove_labels code_with_labels
