import { Injectable } from '@angular/core';

@Injectable({
    providedIn: 'root'
})
export class CodeService {
    mainMethodCode = '';
    extensionMethodCode = '';

    constructor() { }

    genCodeStr() {}

    loadCodeFromStr() {}

}
