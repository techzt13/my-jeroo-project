/* **********************************************************************
Jeroo is a programming language learning tool for students and teachers.
Copyright (C) <2019> <Benjamin Konz>
********************************************************************** */

import { Component, ViewChild, ElementRef, AfterViewInit, Output, EventEmitter, Input } from '@angular/core';
import { CodemirrorService } from '../codemirror/codemirror.service';
import { SelectedLanguage, EditorPreferences, Themes } from '../code.service';
// THIS IS THE NEW IMPORT
import { VariableEngine } from '../variable-engine';

@Component({
  selector: 'app-editor',
  templateUrl: './editor.component.html'
})
export class EditorComponent implements AfterViewInit {
  @ViewChild('editorTextarea', { static: true }) editorTextArea: ElementRef | null = null;
  private editor: CodeMirror.Editor | null = null;

  @Output()
  codeChange = new EventEmitter<string>();

  private preferencesVal: EditorPreferences = {
    fontSize: 12,
    colorTheme: Themes.Default
  };
  @Input()
  get preferences() {
    return this.preferencesVal;
  }
  set preferences(val) {
    this.preferencesVal = val;
    if (this.editor) {
      this.editor.setOption('theme', this.preferencesVal.colorTheme);
      this.editor.getWrapperElement().style.fontSize = `${this.preferencesVal.fontSize}px`;
      this.editor.refresh();
    }
  }

  private langVal: SelectedLanguage = SelectedLanguage.Java;
  @Input()
  get lang() {
    return this.langVal;
  }
  set lang(val) {
    this.langVal = val;
    if (this.editor) {
      this.setMode(this.langVal);
    }
  }

  constructor(private codemirrorService: CodemirrorService) { }

  ngAfterViewInit() {
    const editorTextArea = this.editorTextArea?.nativeElement as HTMLTextAreaElement;
    this.editor = this.codemirrorService.getCodemirror().fromTextArea(editorTextArea, {
      mode: 'jeroo-java',
      theme: 'default',
      lineNumbers: true,
      extraKeys: {
        Tab: 'defaultTab',
        'Shift-Tab': 'indentLess',
        'Shift-Ctrl-F': (editor) => (editor as any).autoIndentAll(),
        'Ctrl-/': 'toggleComment',
        'Ctrl-z': 'undo',
        'Shift-Ctrl-Z': 'redo'
      }
    });
    this.editor.setOption('matchBrackets', true);
    this.editor.setOption('autoCloseBrackets', '{}()');
    this.editor.setOption('theme', this.preferences.colorTheme);
    this.editor.getWrapperElement().style.fontSize = `${this.preferences.fontSize}px`;
    this.editor.setSize(null, 500);
    this.editor.refresh();

    this.editor.on('change', (editor) => {
      this.codeChange.emit(editor.getValue());
    });
  }

  private setMode(language: SelectedLanguage) {
    if (language === SelectedLanguage.Java) {
      this.editor?.setOption('mode', 'jeroo-java');
      this.editor?.setOption('autoCloseBrackets', '{}()');
    } else if (language === SelectedLanguage.Vb) {
      this.editor?.setOption('mode', 'jeroo-vb');
      this.editor?.setOption('autoCloseBrackets', '()');
    } else if (language === SelectedLanguage.Python) {
      this.editor?.setOption('mode', 'jeroo-python');
      this.editor?.setOption('autoCloseBrackets', '()');
    }
  }

  // THIS IS THE MODIFIED GETTEXT FUNCTION
  getText() {
    if (this.editor) {
      const rawCode = this.editor.getValue();
      const processedCode = VariableEngine.process(rawCode);
      console.log("Jeroo Mod - Processed Code:", processedCode);
      return processedCode;
    } else {
      return '';
    }
  }

  setText(incomingString: string) {
    this.editor?.setValue(incomingString);
  }

  undo() {
    this.editor?.undo();
  }

  redo() {
    this.editor?.redo();
  }

  toggleComment() {
    this.editor?.toggleComment();
  }

  indentSelection() {
    this.editor?.execCommand('defaultTab');
  }

  unindentSelection() {
    this.editor?.execCommand('indentLess');
  }

  format() {
    (this.editor as any)?.autoIndentAll();
  }

  highlightLine(lineNum: number) {
    const line = this.editor?.getLineHandle(lineNum - 1);
    if (line) {
      this.editor?.addLineClass(line, 'background', 'activeline-highlight');
    }
  }

  highlightErrorLine(lineNum: number) {
    const line = this.editor?.getLineHandle(lineNum - 1);
    if (line) {
      this.editor?.addLineClass(line, 'background', 'errorline-highlight');
    }
  }

  unhighlightLine(lineNum: number) {
    const line = this.editor?.getLineHandle(lineNum - 1);
    if (line) {
      this.editor?.removeLineClass(line, 'background', 'activeline-highlight');
      this.editor?.removeLineClass(line, 'background', 'errorline-highlight');
    }
  }

  isReadOnly() {
    if (this.editor) {
      return this.editor.getOption('readOnly') as boolean;
    } else {
      return false;
    }
  }

  setReadOnly(readOnly: boolean) {
    this.editor?.setOption('readOnly', readOnly);
  }

  refresh() {
    this.editor?.refresh();
  }

  focus() {
    this.editor?.focus();
  }

  getCursor() {
    return this.editor?.getCursor();
  }

  setCursor(newPosition: CodeMirror.Position) {
    return this.editor?.setCursor(newPosition);
  }
}