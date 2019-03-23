import { Component, ViewChild, AfterViewInit, ElementRef } from '@angular/core';
import { MatrixService } from '../matrix.service';
import { SelectedLanguage } from './SelectedLanguage';
import { JerooMatrixComponent } from '../jeroo-matrix/jeroo-matrix.component';
import { TextEditorComponent } from '../text-editor/text-editor.component';
import { BytecodeInterpreterService } from '../bytecode-interpreter.service';

interface Language {
    value: SelectedLanguage;
    viewValue: string;
}

interface Speed {
    name: string;
    value: number;
}

@Component({
    selector: 'app-dashboard',
    templateUrl: './dashboard.component.html',
    styleUrls: ['./dashboard.component.scss']
})
export class DashboardComponent implements AfterViewInit {
    @ViewChild('mapFileInput') mapFileInput: ElementRef;
    @ViewChild('jerooMatrix') jerooMatrix: JerooMatrixComponent;
    @ViewChild('mapSaver') mapSaver: ElementRef;
    @ViewChild('mainMethodTextEditor') mainMethodTextEditor: TextEditorComponent;
    @ViewChild('extensionMethodsTextEditor') extensionMethodsTextEditor: TextEditorComponent;

    selectedLanguage = SelectedLanguage.Java;
    languages: Language[] = [
        { viewValue: 'JAVA/C++/C#', value: SelectedLanguage.Java },
        { viewValue: 'VB.NET', value: SelectedLanguage.Vb },
        { viewValue: 'PYTHON', value: SelectedLanguage.Python }
    ];
    private speeds = [475, 350, 225, 125, 25, 2];
    speedIndex = 3;
    speedsRadio: Speed[] = [
        { name: '1 - Slow', value: 1 },
        { name: '2', value: 2 },
        { name: '3 - Medium', value: 3 },
        { name: '4', value: 4 },
        { name: '5 - Fast', value: 5 },
        { name: '6 - Max', value: 6 }
    ];
    selectedSpeedRadio = this.speedsRadio[2].value;
    selectedEditor: TextEditorComponent = null;
    reset = true;
    executing = false;
    paused = false;
    stopped = false;

    constructor(private bytecodeService: BytecodeInterpreterService, private matrixService: MatrixService) { }

    ngAfterViewInit() {
        this.selectedEditor = this.mainMethodTextEditor;
        const instructionSpeed = this.speeds[this.speedIndex - 1];
        this.bytecodeService.setInstructionSpeed(instructionSpeed);
    }

    onUndoClick() {
        this.selectedEditor.undo();
    }

    onRedoClick() {
        this.selectedEditor.redo();
    }

    onToggleCommentLines() {
        this.selectedEditor.toggleComment();
    }

    onIndentSelectionClick() {
        this.selectedEditor.indentSelection();
    }

    onUnindentSelectionClick() {
        this.selectedEditor.unindentSelection();
    }

    onFormatSelectionClick() {
        this.selectedEditor.formatSelection();
    }

    onRunStepwiseClick() {
        if (!this.executing) {
            const context = this.jerooMatrix.getContext();
            if (this.reset) {
                const jerooCode = this.createJerooCode();
                const result = JerooCompiler.compile(jerooCode);
                if (result.successful) {
                    const instructions = result.bytecode;
                    this.bytecodeService.executeInstructionsStepwise(instructions, this.matrixService, context, () => this.pause());
                }
            } else {
                this.bytecodeService.resumeExecutionStepwise(this.matrixService, context, () => this.pause());
            }
            this.execute();
        }
    }

    onRunContiniousClick() {
        if (!this.executing) {
            const context = this.jerooMatrix.getContext();
            if (this.reset) {
                const jerooCode = this.createJerooCode();
                const result = JerooCompiler.compile(jerooCode);
                if (result.successful) {
                    const instructions = result.bytecode;
                    this.bytecodeService.executeInstructionsContinous(instructions, this.matrixService, context);
                }
            } else {
                this.bytecodeService.resumeExecutionContinuous(this.matrixService, context);
            }
            this.execute();
        }
    }

    private createJerooCode() {
        let jerooCode = '';
        if (this.selectedLanguage === SelectedLanguage.Java) {
            jerooCode += '@Java\n';
        } else if (this.selectedLanguage === SelectedLanguage.Vb) {
            jerooCode += '@VB\n';
        } else {
            throw new Error('Unsupported Language');
        }
        jerooCode += this.extensionMethodsTextEditor.getText();
        jerooCode += '\n@@\n';
        jerooCode += this.mainMethodTextEditor.getText();
        return jerooCode;
    }

    onResetClick() {
        this.resetState();
        const context = this.jerooMatrix.getCanvas().getContext('2d');
        this.bytecodeService.reset(this.matrixService, context);
    }

    onPauseClick() {
        this.pause();
        this.bytecodeService.pauseExecution();
    }

    onStopClick() {
        this.stop();
        this.bytecodeService.stopExecution();
    }

    private stop() {
        this.stopped = true;
        this.executing = false;
        this.reset = false;
        this.paused = false;
        this.jerooMatrix.disableEditing();
    }

    private execute() {
        this.executing = true;
        this.reset = false;
        this.paused = false;
        this.stopped = false;
        this.jerooMatrix.disableEditing();
    }

    private resetState() {
        this.reset = true;
        this.executing = false;
        this.paused = false;
        this.stopped = false;
        this.jerooMatrix.enableEditing();
    }

    private pause() {
        this.paused = true;
        this.executing = false;
        this.stopped = false;
        this.reset = false;
        this.jerooMatrix.disableEditing();
    }

    onSpeedRadioClick(speedValue: number) {
        this.speedIndex = speedValue;
        this.onSpeedIndexChange();
    }

    onSpeedIndexChange() {
        const instructionSpeed = this.speeds[this.speedIndex - 1];
        this.bytecodeService.setInstructionSpeed(instructionSpeed);
    }

    clearMap() {
        this.matrixService.resetMap();
        this.jerooMatrix.redraw();
    }

    openMapFile() {
        (this.mapFileInput.nativeElement as HTMLInputElement).click();
    }

    mapFileSelected(file: File) {
        const reader = new FileReader();
        reader.readAsText(file, 'UTF-8');
        reader.onload = (readerEvent: any) => {
            const content: string = readerEvent.target.result;
            this.matrixService.genMapFromString(content);
            this.jerooMatrix.redraw();
        };
    }

    saveMapFile() {
        const mapSaver = (this.mapSaver.nativeElement as HTMLAnchorElement);
        // kind of a hack to get the browser to save the map data to a file
        const saveBlob = (function() {
            return function(b: Blob, fileName: string) {
                const url = window.URL.createObjectURL(b);
                mapSaver.href = url;
                mapSaver.download = fileName;
                mapSaver.click();
                window.URL.revokeObjectURL(url);
            };
        }());

        const jerooMapString = this.matrixService.toString();
        const blob = new Blob([jerooMapString], {
            type: 'text/plain'
        });
        saveBlob(blob, 'map.jev');
    }

    printMap() {
        const dataUrl = this.jerooMatrix.getCanvas().toDataURL();
        const windowContent = `
<!DOCTYPE html>
<html>
<head><title>Jeroo Map</title></head>
<body>
<img src="${dataUrl}">
</body>
</html>
`;
        const printWindow = window.open('', '', 'width=340,height=260');
        printWindow.document.open();
        printWindow.document.write(windowContent);
        printWindow.document.close();
        printWindow.print();
        printWindow.close();
    }

    onSelectedLanguageChange() {
        this.mainMethodTextEditor.setMode(this.selectedLanguage);
        this.extensionMethodsTextEditor.setMode(this.selectedLanguage);
    }

    getHelpUrl() {
        return `/help/${this.selectedLanguageToString(this.selectedLanguage)}`;
    }

    getTutorialUrl() {
        return `/help/${this.selectedLanguageToString(this.selectedLanguage)}/tutorial`;
    }

    private selectedLanguageToString(lang: SelectedLanguage) {
        if (lang === SelectedLanguage.Java) {
            return 'java';
        } else if (lang === SelectedLanguage.Vb) {
            return 'vb';
        } else if (lang === SelectedLanguage.Python) {
            return 'python';
        } else {
            throw new Error('Invalid Language');
        }
    }

    onEditorTabIndexChange(index: number) {
        if (index === 0) {
            this.selectedEditor = this.mainMethodTextEditor;
        } else if (index === 1) {
            this.selectedEditor = this.extensionMethodsTextEditor;
        }
    }
}
