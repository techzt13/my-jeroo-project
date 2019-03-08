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
    fileHolder: any;

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
        // if user saves board, then we can change boardSaved to true
        this.matrixService.boardSaved = true;
    }

    loadedBoard(boardFile: any) {
        // if the boardSaved is false then we need to run the dialog to ask the user what
        // they would like to do. Otherwise continue with loading of the board
        if (this.matrixService.boardSaved === false) {
            this.fileHolder = boardFile;
            this.openDialog(this.loadBoardPass);
        } else {
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
    }

    newBoard() {
        // if the board is not saved, ask the user what they would like to do. If it has
        // been saved, then draw a new board
        if (this.matrixService.boardSaved === false) {
            this.openDialog(this.newBoardPass);
        } else {
            this.matrixService.drawBoard();
            this.matrixService.boardSaved = true;
        }
    }

    // openDialog will be provoked if the user tries to do something that might clear the
    // board, but they haven't saved since they have updated the board. This dialog will
    // ask the user if they would like to save, cancel, or continue
    openDialog(passedArgument: string) {
        const dialogConfig = new MatDialogConfig();
        let finalComingFrom: string;
        dialogConfig.data = {
            id: 1,
            comingFrom: passedArgument,
        };
        dialogConfig.autoFocus = true;

        const dialogRef = this.dialog.open(ChangeDialogComponent, dialogConfig);

        // pull the data from the dialog and run checkData on it to see what was returned
        dialogRef.afterClosed().subscribe(
            data => { finalComingFrom = data.comingFrom;
                      this.checkData(finalComingFrom); },
        );

    }

    // checkData will take in the retured string from the dialog and see what operations need
    // to be ran next
    checkData(checkString: string) {
        if (checkString === this.newBoardPass + '-S') {
            // if the user chose to save the board on a newBoard call
            this.saveBoard();
            this.newBoard();
        } else if (checkString === this.newBoardPass) {
            // if the user chose to continue anyway on a newBoard call
            this.matrixService.boardSaved = true;
            this.newBoard();
        } else if (checkString === this.loadBoardPass + '-S') {
            // if the user chose to save the board on a loadBoard call
            this.saveBoard();
            this.loadedBoard(this.fileHolder);
        } else if (checkString === this.loadBoardPass) {
            // if the user chose to continue anyway on a loadBoard call
            this.matrixService.boardSaved = true;
            this.loadedBoard(this.fileHolder);
        }
    }
    // Island file functions

}
