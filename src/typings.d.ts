declare interface Instruction {
    op: string;
    a: number;
    b: number;
    c: number;
    d: number;
    e: number;
    f: number;
}

declare interface JerooCompilerModule {
    compile: (code: string) => Instruction[];
}

declare var JerooCompiler: JerooCompilerModule;
