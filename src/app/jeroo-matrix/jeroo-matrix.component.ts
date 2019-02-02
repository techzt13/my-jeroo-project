import { Component, OnInit, Input, SimpleChanges } from '@angular/core';
import { MatDialog, MatDialogConfig } from '@angular/material';
import { MatrixDialogComponent } from '../matrix-dialog/matrix-dialog.component';
import { Form } from '@angular/forms';

@Component({
  selector: 'app-jeroo-matrix',
  templateUrl: './jeroo-matrix.component.html',
  styleUrls: ['./jeroo-matrix.component.scss']
})
export class JerooMatrixComponent implements OnInit {

  // variables for component
  widthSize = 26;
  heightSize = 26;
  currentValue = 'W';
  currentXLocation = 0;
  currentYLocation = 0;
  maxXSize = this.widthSize - 1;
  maxYSize = this.heightSize - 1;
  mouseDown = false;

  jerooBoard = [[]];

  constructor(private dialog: MatDialog) { }

  // create a board with a given size, and set it to the default values
  // (water on top/sides, grass everywhere else)
  generateBoard(xSize, ySize) {
      const arr = [];

      for (let row = 0; row < ySize; row++) {
        arr[row] = [];
        for (let column = 0; column < xSize; column++) {
          // if row == 0 or max use water OR if column == 0 or max
          if (row === 0 || row === (ySize - 1) || column === 0 || column === (xSize - 1)) {
            arr[row][column] = 'W';
          } else {
            arr[row][column] = 'G';
          }
        }
      }

      return arr;

  }

  // how to handle clicks from user
  onClick(event: any, row: number, column: number) {
      this.mouseDown = true;

      // make sure the user is not "off the island"
      if (this.currentXLocation !== this.maxXSize - 1 && this.currentYLocation !== this.maxYSize - 1
          && this.currentXLocation !== -1 && this.currentYLocation !== -1) {
            if (this.jerooBoard[row][column] !== this.currentValue) {
              this.jerooBoard[row][column] = this.currentValue;
            }
      }
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

  // used when a user clicks one of the block selection images on the page to tell
  // what type of block they would like to place, or clear the screen
  selectTile(type: string) {
    switch (type) {
      case 'W': {
        this.currentValue = 'W';
        break;
      }
      case 'G': {
        this.currentValue = 'G';
        break;
      }
      case 'N': {
        this.currentValue = 'N';
        break;
      }
      case 'F': {
        this.currentValue = 'F';
        break;
      }
      case 'C': {
        this.jerooBoard = this.generateBoard(this.widthSize, this.heightSize);
        break;
      }
    }
  }

  getPixel() {
    const percentValue = (90 / this.widthSize);
    return (percentValue + '%');
  }

  openDialog() {
    const dialogConfig = new MatDialogConfig();

    dialogConfig.autoFocus = true;

    dialogConfig.data = {
      id: 1,
      xValue: this.widthSize,
      yValue: this.heightSize
    };

    const dialogRef = this.dialog.open(MatrixDialogComponent, dialogConfig);

    dialogRef.afterClosed().subscribe(
      data => { this.widthSize = data.xValue, this.heightSize = data.yValue; this.ngOnInit();
                this.maxXSize = this.widthSize - 1; this.maxYSize = this.heightSize - 1; },
    );

  }

  ngOnInit() {
    this.jerooBoard = this.generateBoard(this.widthSize, this.heightSize);
  }

}
