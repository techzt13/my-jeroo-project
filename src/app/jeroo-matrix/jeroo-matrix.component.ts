import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-jeroo-matrix',
  templateUrl: './jeroo-matrix.component.html',
  styleUrls: ['./jeroo-matrix.component.scss']
})
export class JerooMatrixComponent implements OnInit {

  boardSize = 25;
  i = 0;
  currentValue = 'W';
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
    this.ngOnInit();
  }

  // how to handle clicks from user
  onClick(event: any, row: number, column: number) {
      if (event.button === 2) {
        this.jerooBoard[row][column] = 'W';
      } else if (event.button === 0) {
        this.jerooBoard[row][column] = 'G';
      }
      return false;
  }

  // right click needs to get rid of right click menu (return false)
  onRightClick(event: any, row: number, column: number) {
    if (this.mouseDown === true) {
      this.jerooBoard[row][column] = 'G';
      this.onClick(event, row, column);
    }
    return false;
  }

  ngOnInit() {
    this.jerooBoard = this.generateBoard(this.boardSize);
  }

}
