exception SemanticException of string

let codegen fxns =
  let fxn_tbl = Hashtbl.create 30 in
  let jeroo_tbl = Hashtbl.create 30 in

  let rec gen_code_expr expr =
    match expr with
    | `TrueExpr -> [Bytecode.TRUE]
    | `FalseExpr -> [Bytecode.FALSE]
    | `BinOpExpr (e1, `And, e2) ->
      Bytecode.AND :: (gen_code_expr e1) @ (gen_code_expr e2)
    | `BinOpExpr (e1, `Or, e2) ->
      Bytecode.OR :: (gen_code_expr e1) @ (gen_code_expr e2)
    | `UnOpExpr (`Not, e) ->
      Bytecode.NOT :: (gen_code_expr e)
    | _ -> []
  in

  let direction_of_expr expr =
    match expr with
    | `NorthExpr -> Bytecode.North
    | `SouthExpr -> Bytecode.South
    | `EastExpr -> Bytecode.East
    | `WestExpr -> Bytecode.West
    | _ -> raise (SemanticException "Invalid type, expression must be NORTH, SOUTH, EAST, or WEST")
  in

  let rec gen_code_stmt code stmt =
    match stmt with
    | `BlockStmt stmts ->
      stmts
      |> List.fold_left (fun code stmt -> gen_code_stmt code stmt) code
    | `ExprStmt expr ->
      gen_code_expr expr
    | `DeclStmt (ty, id, expr) ->
      if not (String.equal ty "Jeroo") then
        raise (SemanticException "Invalid type, Jeroo is the only valid type")
      else begin
        Hashtbl.add jeroo_tbl id (Hashtbl.length jeroo_tbl);
        begin match expr with
          | `UnOpExpr (`New, e) ->
            begin match e with
              | `FxnAppExpr (`IdExpr(ctor), args) ->
                if not (String.equal ctor "Jeroo") then
                  raise (SemanticException ("Invalid constructor: " ^ ctor ^ ", Jeroo is the only valid constructor"))
                else
                  let id_loc = Hashtbl.find jeroo_tbl id in
                  begin match args with
                    | [] -> [Bytecode.NEW (id_loc, 1, 1, 0, Bytecode.North)]
                    | [`IntExpr(x); `IntExpr(y)] -> [Bytecode.NEW (id_loc, x, y, 0, Bytecode.North)]
                    | [`IntExpr(x); `IntExpr(y); `IntExpr(num_flowers)] -> [Bytecode.NEW (id_loc, x, y, num_flowers, Bytecode.North)]
                    | [`IntExpr(x); `IntExpr(y); `IntExpr(num_flowers); direction] -> [Bytecode.NEW (id_loc, x, y, num_flowers, (direction_of_expr direction))]
                    | _ -> raise (SemanticException ("Invalid Jeroo arguments"))
                  end
              | _ -> raise (SemanticException ("Invalid right hand side of declaration, must be a Jeroo constructor"))
            end
        end
      end
    | _ -> code
  in

  let gen_code code fxn =
    let (id, stmts) = fxn in
    fxn_tbl |> Hashtbl.add id (List.length code);
    stmts
    |> List.fold_left (fun code stmt -> gen_code_stmt code stmt) code
  in

  fxns
  |> List.fold_left (fun code fxn -> gen_code code fxn) []
  |> List.rev
