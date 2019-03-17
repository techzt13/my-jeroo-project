import { Component, ViewChild, ElementRef, AfterViewInit } from '@angular/core';
import 'codemirror/lib/codemirror';
import 'codemirror/addon/mode/simple';
import 'codemirror/addon/edit/matchbrackets';
import 'codemirror/addon/edit/closebrackets';
import * as CodeMirror from 'codemirror';
import { javaMode } from './javaMode';
import { SelectedLanguage } from '../dashboard/SelectedLanguage';
import { VBMode } from './VBMode';
import { pythonMode } from './pythonMode';

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
        (CodeMirror as any).defineSimpleMode('jeroo-python', pythonMode);
        this.editor = CodeMirror.fromTextArea(editorTextArea, {
            mode: 'jeroo-java',
            theme: 'default',
            lineNumbers: true
        });
        this.editor.setOption('matchBrackets', true);
        this.editor.setOption('autoCloseBrackets', '{}()');
        this.editor.refresh();
        this.editor.setSize(null, 500);
    }

    setMode(language: SelectedLanguage) {
        if (language === SelectedLanguage.Java) {
            this.editor.setOption('mode', 'jeroo-java');
            this.editor.setOption('autoCloseBrackets', '{}()');
        } else if (language === SelectedLanguage.Vb) {
            this.editor.setOption('mode', 'jeroo-vb');
            this.editor.setOption('autoCloseBrackets', '()');
        } else if (language === SelectedLanguage.Python) {
            this.editor.setOption('mode', 'jeroo-python');
            this.editor.setOption('autoCloseBrackets', '()');
        }
    }

    getText() {
        return this.editor.getValue();
    }

    focus() {
        console.log('focusing the editor');
        this.editor.focus();
        (this.editorTextArea.nativeElement as HTMLTextAreaElement).select();
        (this.editorTextArea.nativeElement as HTMLTextAreaElement).click();
    }

    undo() {
        this.editor.getDoc().undo();
    }

    redo() {
        this.editor.getDoc().redo();
    }
}
