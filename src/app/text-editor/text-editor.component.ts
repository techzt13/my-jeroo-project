import { Component, ViewChild, ElementRef, AfterViewInit } from '@angular/core';
import 'codemirror/lib/codemirror';
import 'codemirror/addon/mode/simple';
import 'codemirror/addon/edit/matchbrackets';
import 'codemirror/addon/edit/closebrackets';
import * as CodeMirror from 'codemirror';
import { javaMode } from './javaMode';

@Component({
    selector: 'app-text-editor',
    templateUrl: './text-editor.component.html'
})
export class TextEditorComponent implements AfterViewInit {
    @ViewChild('editorTextarea') editorTextArea: ElementRef;
    private editor: CodeMirror.Editor = null;

    constructor() { }

    ngAfterViewInit() {
        const editorTextArea = this.editorTextArea.nativeElement as HTMLTextAreaElement;
        // for some reason defineSimpleMode isn't part of the CodeMirror type
        (CodeMirror as any).defineSimpleMode('jeroo-java', javaMode);
        this.editor = CodeMirror.fromTextArea(editorTextArea, {
            mode: 'jeroo-java',
            theme: 'default',
            lineNumbers: true,
            // not technically part of the type, but is allowed in CodeMirror
            // because of the addons that are imported
            matchBrackets: true,
            autoCloseBrackets: true
        } as CodeMirror.EditorConfiguration);
        this.editor.refresh();
    }
}
