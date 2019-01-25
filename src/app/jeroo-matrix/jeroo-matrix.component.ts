import { Component, OnInit } from '@angular/core';
import { MatSlider } from '@angular/material/slider';

@Component({
  selector: 'app-jeroo-matrix',
  templateUrl: './jeroo-matrix.component.html',
  styleUrls: ['./jeroo-matrix.component.scss']
})
export class JerooMatrixComponent implements OnInit {

  boardSize = 25;
  i = 0;

  jerooBoard = [[]];

  constructor() { }

  generateBoard(number) {
      const arr = [];

      for (let row = 0; row < number; row++) {
        arr[row] = [];
        for (let column = 0; column < number; column++) {
          // if row == 0 or max use water OR if column == 0 or max
          if (row === 0 || row === (number - 1) || column === 0 || column === (number - 1)) {
            arr[row][column] = 'W';
          } else {
            arr[row][column] = 'G';
          }

        }
      }

      return arr;
  }

  ngOnInit() {
    this.jerooBoard = this.generateBoard(this.boardSize);
  }

}
