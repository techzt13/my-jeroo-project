let codegen fxns =
  let fxn_tbl = Hashtbl.create 30 in
  let _jeroo_tbl = Hashtbl.create 30 in

  let gen_code code fxn =
    let (id, _stmts) = fxn in
    fxn_tbl |> Hashtbl.add id (List.length code);
    code
  in
  fxns
  |> List.fold_left (fun code fxn -> gen_code code fxn) []
