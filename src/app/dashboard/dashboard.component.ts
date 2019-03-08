import { Component, OnInit } from '@angular/core';
import { MatrixService } from '../matrix.service';
import { FilesystemService } from '../filesystem.service';
import { MatDialog, MatDialogConfig } from '@angular/material';
import { ChangeDialogComponent } from '../change-dialog/change-dialog.component';

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

    // checking board compared to recently saved functions
    newBoardPass = 'NB';
    loadBoardPass = 'LB';

    languages: Language[] = [
        { viewValue: 'JAVA/C++/C#', value: SelectedLanguage.Java },
        { viewValue: 'VB.NET', value: SelectedLanguage.Vb },
        { viewValue: 'PYTHON', value: SelectedLanguage.Python }
    ];

    constructor(public matrixService: MatrixService, private fileService: FilesystemService,
                private dialog: MatDialog) { }

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
    changeCurrentSelection(newSelection: String) {
        switch (newSelection) {
            case 'F': {
                this.matrixService.setCurrentValue(this.matrixService.getFlowerType());
                break;
            }
            case 'N': {
                this.matrixService.setCurrentValue(this.matrixService.getNetType());
                break;
            }
            case 'W': {
                this.matrixService.setCurrentValue(this.matrixService.getWaterType());
                break;
            }
            case 'G': {
                this.matrixService.setCurrentValue(this.matrixService.getGrassType());
                break;
            }
        }
    }

    clearIsland() {
        this.matrixService.drawBoard();
    }
    // Island edit functions

    // Island file functions
    saveBoard() {
        this.fileService.saveBoard('test');
        this.matrixService.boardSaved = true;
    }

    loadedBoard(boardFile: any) {
        // prompt user to save if board has been changed

        // grab the file name from the file that was input
        const uploadedFile = boardFile.target.files[0];
        const fileName = uploadedFile.name;

        // pass the value into checkName to see if the extension is the correct one (.jev)
        // and pass 1 to distinguish between source file (0) and board file (1)
        if (this.fileService.checkName(fileName, 1) === true) {
            // if the file extension is correct we can load the board, otherwise we don't
            // do anything
            this.fileService.fileSelected(boardFile);
            this.matrixService.boardSaved = true;
        }
    }

    newBoard() {
        if (this.matrixService.boardSaved === false) {
            this.openDialog(this.newBoardPass);
        } else {
            this.matrixService.drawBoard();
            this.matrixService.boardSaved = true;
        }
    }

    openDialog(passedArgument: string) {
        const dialogConfig = new MatDialogConfig();
        let finalComingFrom: string;
        let finalReturnArgument: boolean;
        dialogConfig.data = {
            id: 1,
            comingFrom: passedArgument,
            returnArgument: false
          };
        dialogConfig.autoFocus = true;

        const dialogRef = this.dialog.open(ChangeDialogComponent, dialogConfig);

        dialogRef.afterClosed().subscribe(
            data => { finalComingFrom = data.comingFrom, finalReturnArgument = data.returnArgument;
                      this.checkData(finalComingFrom, finalReturnArgument); },
          );

      }

    checkData(checkString: string, checkBoolean: boolean) {
        if (checkString === 'NB-S' && checkBoolean === true) {
            this.saveBoard();
            this.newBoard();
        } else if (checkString === 'NB' && checkBoolean === true) {
            this.matrixService.boardSaved = true;
            this.newBoard();
        } else if (checkString === 'LB-S' && checkBoolean === true) {
            this.saveBoard();
            this.loadedBoard();
        } else if (checkString === 'LB' && checkBoolean === true) {
            this.loadedBoard();
        }
    }
    // Island file functions

}
