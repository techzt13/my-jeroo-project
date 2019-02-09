exception SemanticException of string

val codegen : AST.fxn list -> Bytecode.bytecode Seq.t
