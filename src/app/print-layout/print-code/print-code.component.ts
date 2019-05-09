import { AfterViewInit, Component, ViewChild, ElementRef } from '@angular/core';
import { CodeService } from 'src/app/code.service';
import { PrintService } from 'src/app/print.service';
import { CodemirrorService } from 'src/app/codemirror/codemirror.service';

@Component({
    selector: 'app-print-code',
    templateUrl: './print-code.component.html',
    styleUrls: ['./print-code.component.scss']
})
export class PrintCodeComponent implements AfterViewInit {
    @ViewChild('mainMethodTextArea') mainMethodTextAreaRef: ElementRef;
    @ViewChild('extensionMethodTextArea') extensionMethodTextAreaRef: ElementRef;

    constructor(private printService: PrintService, private codeMirrorService: CodemirrorService, public codeService: CodeService) { }

    ngAfterViewInit() {
        const codemirror = this.codeMirrorService.getCodemirror();
        const editorOptions: CodeMirror.EditorConfiguration = {
            mode: 'jeroo-java',
            theme: 'default',
            viewportMargin: Infinity
        };
        const mainMethodEditor = codemirror.fromTextArea(this.mainMethodTextAreaRef.nativeElement, editorOptions);
        mainMethodEditor.setValue(this.codeService.mainMethodCode);

        const extensionMethodEditor = codemirror.fromTextArea(this.extensionMethodTextAreaRef.nativeElement, editorOptions);
        extensionMethodEditor.setValue(this.codeService.extensionMethodCode);

        setTimeout(() => this.printService.onDataReady());
    }
}
