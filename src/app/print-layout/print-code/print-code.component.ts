import { AfterViewInit, Component, ViewChild, ElementRef } from '@angular/core';
import { CodeService } from 'src/app/code.service';
import { PrintService } from 'src/app/print.service';
import { CodemirrorService } from 'src/app/codemirror/codemirror.service';
import { MatDialog } from '@angular/material';
import { PrintCodeDialogComponent, PrintCodeDialogResult } from './print-code-dialog/print-code-dialog.component';
import { Router } from '@angular/router';

@Component({
    selector: 'app-print-code',
    templateUrl: './print-code.component.html',
    styleUrls: ['./print-code.component.scss']
})
export class PrintCodeComponent implements AfterViewInit {
    @ViewChild('mainMethodTextArea') mainMethodTextAreaRef: ElementRef;
    @ViewChild('extensionMethodTextArea') extensionMethodTextAreaRef: ElementRef;
    displayMainMethod = false;
    displayExtensionMethods = false;

    constructor(private printService: PrintService,
                private codeMirrorService: CodemirrorService,
                public codeService: CodeService,
                public dialog: MatDialog,
                private router: Router) { }

    ngAfterViewInit() {
        setTimeout(() => {
            const dialogRef = this.dialog.open(PrintCodeDialogComponent);
            dialogRef.afterClosed().subscribe((result: PrintCodeDialogResult) => {
                if (result !== null) {
                    if (result === PrintCodeDialogResult.PrintMainMethod) {
                        this.displayMainMethod = true;
                    } else if (result === PrintCodeDialogResult.PrintExtensionMethods) {
                        this.displayExtensionMethods = true;
                    } else if (result === PrintCodeDialogResult.PrintAll) {
                        this.displayMainMethod = true;
                        this.displayExtensionMethods = true;
                    }

                    setTimeout(() => this.printEditors());
                } else {
                    this.router.navigate([{ outlets: { print: null }}]);
                }
            });
        });
    }

    private printEditors() {
        const codemirror = this.codeMirrorService.getCodemirror();
        const editorOptions: CodeMirror.EditorConfiguration = {
            mode: 'jeroo-java',
            theme: 'default',
            viewportMargin: Infinity
        };

        if (this.displayMainMethod) {
            const mainMethodEditor = codemirror.fromTextArea(this.mainMethodTextAreaRef.nativeElement, editorOptions);
            mainMethodEditor.setValue(this.codeService.mainMethodCode);
        }

        if (this.displayExtensionMethods) {
            const extensionMethodEditor = codemirror.fromTextArea(this.extensionMethodTextAreaRef.nativeElement, editorOptions);
            extensionMethodEditor.setValue(this.codeService.extensionMethodCode);
        }

        setTimeout(() => this.printService.onDataReady());
    }
}
