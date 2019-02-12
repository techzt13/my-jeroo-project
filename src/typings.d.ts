declare interface Instruction {
    op: string;
    a: number;
    b: number;
    c: number;
    d: number;
    e: number;
    f: number;
}

declare interface JerooCompiler_t {
    compile: (code: string) => Instruction[];
}

declare var JerooCompiler: JerooCompiler_t;
