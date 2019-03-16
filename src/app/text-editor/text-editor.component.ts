import { Component, ViewChild, ElementRef, AfterViewInit } from '@angular/core';
import 'codemirror/lib/codemirror';
import 'codemirror/addon/mode/simple';
import 'codemirror/addon/edit/matchbrackets';
import 'codemirror/addon/edit/closebrackets';
import * as CodeMirror from 'codemirror';
import { javaMode } from './javaMode';
import { SelectedLanguage } from '../dashboard/SelectedLanguage';
import { VBMode } from './VBMode';

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
        (CodeMirror as any).defineSimpleMode('jeroo-vb', VBMode);
        this.editor = CodeMirror.fromTextArea(editorTextArea, {
            mode: 'jeroo-java',
            theme: 'default',
            lineNumbers: true
        });
        this.editor.setOption('matchBrackets', true);
        this.editor.setOption('autoCloseBrackets', '{}()');
        this.editor.refresh();
    }

    setMode(language: SelectedLanguage) {
        if (language === SelectedLanguage.Java) {
            this.editor.setOption('mode', 'jeroo-java');
            this.editor.setOption('autoCloseBrackets', '{}()');
        } else if (language === SelectedLanguage.Vb) {
            this.editor.setOption('mode', 'jeroo-vb');
            this.editor.setOption('autoCloseBrackets', '()');
        }
    }

    getText() {
        return this.editor.getValue();
    }
}
