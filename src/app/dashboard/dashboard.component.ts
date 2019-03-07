import { Component, OnInit } from '@angular/core';
import { MatrixService } from '../matrix.service';
import { FilesystemService } from '../filesystem.service';

enum SelectedLanguage {
    Java,
    Vb,
    Python
}

function selectedLanguageToString(lang: SelectedLanguage) {
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

interface Language {
    value: SelectedLanguage;
    viewValue: string;
}

@Component({
    selector: 'app-dashboard',
    templateUrl: './dashboard.component.html',
    styleUrls: ['./dashboard.component.scss']
})
export class DashboardComponent implements OnInit {

    selectedLanguage = SelectedLanguage.Java;
    languages: Language[] = [
        { viewValue: 'JAVA/C++/C#', value: SelectedLanguage.Java },
        { viewValue: 'VB.NET', value: SelectedLanguage.Vb },
        { viewValue: 'PYTHON', value: SelectedLanguage.Python }
    ];

    constructor(private matrixService: MatrixService, private fileService: FilesystemService) { }

    ngOnInit() {
    }

    setSelectedLanguage(selectedLanguage: SelectedLanguage) {
        this.selectedLanguage = selectedLanguage;
    }

    getHelpUrl() {
        return `/help/${selectedLanguageToString(this.selectedLanguage)}`;
    }

    getTutorialUrl() {
        return `/help/${selectedLanguageToString(this.selectedLanguage)}/tutorial`;
    }

    // Island edit functions
    plantFlowers() {
        this.matrixService.setCurrentValue(this.matrixService.getFlowerType());
    }

    setNets() {
        this.matrixService.setCurrentValue(this.matrixService.getNetType());
    }

    addWater() {
        this.matrixService.setCurrentValue(this.matrixService.getWaterType());
    }

    addGrass() {
        this.matrixService.setCurrentValue(this.matrixService.getGrassType());
    }

    clearIsland() {
        this.matrixService.drawBoard();
    }
    // Island edit functions

    // Island file functions
    saveBoard() {
        // save vs saveAs?
        // pass filename from somewhere on ui?
        this.fileService.saveBoard('test');
    }

    loadedBoard(boardFile: any) {
        // prompt user to save if board has been changed
        this.fileService.fileSelected(boardFile);
    }

    newBoard() {
        // prompt user to save if board has been changed
        this.matrixService.drawBoard();
    }
    // Island file functions

}
