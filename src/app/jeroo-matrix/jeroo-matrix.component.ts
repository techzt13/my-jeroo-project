import { Component, OnInit } from '@angular/core';
import { MatDialog, MatDialogConfig } from '@angular/material';
import { MatrixDialogComponent } from '../matrix-dialog/matrix-dialog.component';

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

  waterType = 'W';
  grassType = 'G';
  flowerType = 'F';
  netType = 'N';
  clearType = 'C';

  jerooBoard = [[]];

  constructor(private dialog: MatDialog) { }

  // create a board with a given size, and set it to the default values
  // (water on top/sides, grass everywhere else)
  generateBoard(xSize: number, ySize: number) {
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
  selectTile(tileType: string) {
    switch (tileType) {
      case this.waterType: {
        this.currentValue = this.waterType;
        break;
      }
      case this.grassType: {
        this.currentValue = this.grassType;
        break;
      }
      case this.netType: {
        this.currentValue = this.netType;
        break;
      }
      case this.flowerType: {
        this.currentValue = this.flowerType;
        break;
      }
      case this.clearType: {
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
      xValue: this.widthSize - 2,
      yValue: this.heightSize - 2
    };

    const dialogRef = this.dialog.open(MatrixDialogComponent, dialogConfig);

    dialogRef.afterClosed().subscribe(
      data => { this.widthSize = +data.xValue + +2, this.heightSize = +data.yValue + +2; this.ngOnInit();
                this.maxXSize = this.widthSize - 1; this.maxYSize = this.heightSize - 1; },
    );

  }

  ngOnInit() {
    this.jerooBoard = this.generateBoard(this.widthSize, this.heightSize);
  }

}
