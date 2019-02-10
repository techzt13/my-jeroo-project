exception SemanticException of string

val codegen : AST.translation_unit -> Bytecode.bytecode Seq.t
