import { Component, OnInit } from '@angular/core';
import { MatDialog, MatDialogConfig } from '@angular/material';
import { MatrixDialogComponent } from '../matrix-dialog/matrix-dialog.component';
import { ChangeDialogComponent } from '../change-dialog/change-dialog.component';
import { MatrixService } from '../matrix.service';
import { FilesystemService } from '../filesystem.service';

@Component({
  selector: 'app-jeroo-matrix',
  templateUrl: './jeroo-matrix.component.html',
  styleUrls: ['./jeroo-matrix.component.scss']
})
export class JerooMatrixComponent implements OnInit {

  // variables for component
  currentXLocation = 0;
  currentYLocation = 0;
  mouseDown = false;
  changeSizePass = 'CS';

  constructor(private dialog: MatDialog, public matrixService: MatrixService,
              private changeDialog: MatDialog, private fileService: FilesystemService) { }

  // how to handle clicks from user
  onClick(event: any, row: number, column: number) {
      this.mouseDown = true;

      // make sure the user is not "off the island"
      if (this.currentXLocation !== this.matrixService.getMaxXSize() - 1 && this.currentYLocation !== this.matrixService.getMaxYSize() - 1
          && this.currentXLocation !== -1 && this.currentYLocation !== -1) {
            if (this.matrixService.getBoardValueAt(row, column) !== this.matrixService.getCurrentValue()) {
              this.matrixService.setBoardValueAt(row, column);
            }
      }
      // return false here will stop action of clicking and holding to drag an image around. Since we are dealing
      // with an array of images this will stop the browser from allowing the user to do that
      return false;
  }

  // when the mouse is released
  mouseUp() {
    this.mouseDown = false;
  }

  // each time a new matrix element is hovered over, check if the mouse is down
  // and report the current coordinates
  onMouseOver(event: any, row: number, column: number) {
    this.currentXLocation = column - 1;
    this.currentYLocation = row - 1;

    if (this.mouseDown === true) {
      this.onClick(event, row, column);
    }
  }

  // when the user selects a tile type at the top of the screen to edit tiles
  // on the matrix
  selectTile(tileType: string) {
    if (tileType === this.matrixService.getClearType()) {
      this.matrixService.drawBoard();
    } else {
      this.matrixService.setCurrentValue(tileType);
    }
    // returning false will prevent the user from clicking and holding a tile, while
    // being able to drag it around the screen
    return false;
  }

  // returns the percentage to scale each img to properly fit and scale to the div
  // it will be put into
  getPixel() {
    const percentValue = (90 / this.matrixService.getWidthSize());
    return (percentValue + '%');
  }

  // responsible for opening the dialogue and saving the information once it has been
  // closed
  openDialog() {
    // if the board has been changed, then changeDialog will be opened asking the user
    // how they would like to handle their changes before continuing. Otherwise, change
    // the size like normal
    if (this.matrixService.boardSaved === false) {
      this.openChangeDialog(this.changeSizePass);
    } else {
      const dialogConfig = new MatDialogConfig();

      dialogConfig.autoFocus = true;

      dialogConfig.data = {
        id: 1,
        xValue: this.matrixService.getWidthSize() - 2,
        yValue: this.matrixService.getHeightSize() - 2
      };

      const dialogRef = this.dialog.open(MatrixDialogComponent, dialogConfig);

      dialogRef.afterClosed().subscribe(
        data => { this.matrixService.setWidthSize(+data.xValue + +2), this.matrixService.setHeightSize(+data.yValue + +2); this.ngOnInit();
                  this.matrixService.setMaxXSize(); this.matrixService.setMaxYSize(); },
      );
    }
  }

  // openChangeDialog will only be provoked if the user decides to change the size, but
  // hasn't saved the board before hand. User will be presented with save, continue, or cancel
  openChangeDialog(passedArgument: string) {
    const dialogConfig = new MatDialogConfig();
    let finalComingFrom: string;
    dialogConfig.data = {
        id: 1,
        comingFrom: passedArgument,
      };
    dialogConfig.autoFocus = true;

    const dialogRef = this.dialog.open(ChangeDialogComponent, dialogConfig);

    dialogRef.afterClosed().subscribe(
        data => { finalComingFrom = data.comingFrom;
                  this.checkData(finalComingFrom); },
      );

  }

  // check data will take in the arguments returned from the changeDialog and see what
  // operations need to be ran next from what the user wanted
  checkData(checkString: string) {
    if (checkString === this.changeSizePass + '-S') {
        // if the user wants to save the board before changing the size, we need to save
        // the board and then change boardSaved to true. Finally open the changeSize dialog
        this.fileService.saveBoard('test');
        this.matrixService.boardSaved = true;
        this.openDialog();
    } else if (checkString === this.changeSizePass) {
        // if the user doesn't want to save the board, we mark boardSaved as true and
        // open the changeSize dialog
        this.matrixService.boardSaved = true;
        this.openDialog();
    }
  }

  ngOnInit() {
    this.matrixService.drawBoard();
  }

}
