import { Component, ViewChild, ElementRef, AfterViewInit } from '@angular/core';
import 'codemirror/lib/codemirror';
import 'codemirror/mode/javascript/javascript';
import * as CodeMirror from 'codemirror';

@Component({
    selector: 'app-text-editor',
    templateUrl: './text-editor.component.html'
})
export class TextEditorComponent implements AfterViewInit {
    @ViewChild('editorTextarea') editorTextarea: ElementRef;
    private editor: CodeMirror.Editor = null;

    constructor() { }

    ngAfterViewInit() {
        const editorTextArea = this.editorTextarea.nativeElement as HTMLTextAreaElement;
        this.editor = CodeMirror.fromTextArea(editorTextArea, {
            mode: 'javascript',
            theme: 'default',
            lineNumbers: true
        });
        this.editor.refresh();
    }
}
