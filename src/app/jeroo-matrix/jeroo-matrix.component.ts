import { Component, OnInit } from '@angular/core';
import { MatSlider } from '@angular/material';

@Component({
  selector: 'app-jeroo-matrix',
  templateUrl: './jeroo-matrix.component.html',
  styleUrls: ['./jeroo-matrix.component.scss']
})
export class JerooMatrixComponent implements OnInit {

  // variables for component
  boardSize = 26;
  i = 0;
  currentValue = 'W';
  currentXLocation = 0;
  currentYLocation = 0;
  maxXSize = this.boardSize - 1;
  maxYSize = this.boardSize - 1;
  mouseDown = false;

  jerooBoard = [[]];

  constructor() { }

  // create a board with a given size, and set it to the default values
  // (water on top/sides, grass everywhere else)
  generateBoard(size) {
      const arr = [];

      for (let row = 0; row < size; row++) {
        arr[row] = [];
        for (let column = 0; column < size; column++) {
          // if row == 0 or max use water OR if column == 0 or max
          if (row === 0 || row === (size - 1) || column === 0 || column === (size - 1)) {
            arr[row][column] = 'W';
          } else {
            arr[row][column] = 'G';
          }

        }
      }

      return arr;
  }

  // when the mat slider has changed, will pull the value from it and assign that
  // value to the board size and re-render the matrix
  onInputChange(event: any) {
    this.boardSize = event.value;
    this.maxXSize = this.boardSize - 1;
    this.maxYSize = this.boardSize - 1;
    this.ngOnInit();
  }

  // how to handle clicks from user
  onClick(event: any, row: number, column: number) {
      this.mouseDown = true;

      this.jerooBoard[row][column] = 'W';
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

  ngOnInit() {
    this.jerooBoard = this.generateBoard(this.boardSize);
  }

}
