import { Injectable } from '@angular/core';
import { MatrixService } from './matrix.service';
import { saveAs } from 'file-saver';
import { text } from '@angular/core/src/render3';
import { callbackify } from 'util';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class FilesystemService {

  loadBoardFile: any;

  constructor(public matrixService: MatrixService) { }

  // allows the users to save the board to their local system, and maintains the same
  // style as the old version of Jeroo when saving for legacy use if needed
  saveBoard(fileName: String) {
    const FileSaver = require('file-saver');
    let myBlob = new Blob([]);
    let blobHolder = new Blob([]);

    // go through every character within the matrix and write it out to the blob for angular-file-saver
    for (let retrieveLine = 0; retrieveLine < this.matrixService.maxYSize + 1; retrieveLine++) {
      for (let lengthValue = 0; lengthValue < this.matrixService.maxXSize + 1; lengthValue++) {
        // if the values are at the edges of the board then it is water, and since water is always assumed
        // to be around the very edges of the board it isn't written to the file
        if (lengthValue !== 0 && lengthValue !== this.matrixService.maxXSize &&
            retrieveLine !== 0 && retrieveLine !== this.matrixService.maxYSize) {
          // in order to match the legacy version of Jeroo, all grass tiles will need to be written as
          // a singular period (.)
          if (this.matrixService.getBoardValueAt(retrieveLine, lengthValue) === 'G') {
            myBlob = new Blob([blobHolder, '.']);
          } else {
            myBlob = new Blob([blobHolder, this.matrixService.getBoardValueAt(retrieveLine, lengthValue)]);
          }
          blobHolder = myBlob;
        }
      }
      // if the retrieveLine is at the very top or very bottom it will need a new line added to it in order
      // to add a new line in the file
      if (retrieveLine !== 0 && retrieveLine !== this.matrixService.maxYSize) {
        myBlob = new Blob([blobHolder, '\n'], {type: 'ANSI'});
        blobHolder = myBlob;
      }
    }
    // finally prompt the user to save the board
    FileSaver.saveAs(myBlob, fileName + '.jev');
  }

  // when a file has been selected by the user this function will be ran and will
  // call onto the load board function
  fileSelected(boardFile: any) {
    this.loadBoardFile = boardFile.target.files[0];
    this.loadBoard(this.loadBoardFile);
  }

  loadBoard(matrixFile: any) {
    let tempFileHolder: String | ArrayBuffer;
    const fileReader = new FileReader();
    fileReader.onload = (e) => {
      tempFileHolder = fileReader.result;
    };
    fileReader.onloadend = (e) => {
      this.boardManipulation(tempFileHolder);
    };
    fileReader.readAsText(matrixFile);
  }

  // boardManipulation gets the board ready to be sent to the matrix service to replace
  // the board that is already there
  boardManipulation(loadedBoard: String | ArrayBuffer) {
    const x = loadedBoard.toString();
    let tempRow: Array<String> = ['W'];
    const waterRow: Array<String> = [];
    const tempMatrix: Array<Array<String>> = [];
    let counter = 0;
    // while our counter is less then the total length of the string that was loaded from
    // the file
    while (counter < x.length) {
      // if we come across a newline we have hit the end of a row and need to add it onto
      // the matrix and clear the tempRow holder
      if (x[counter] === '\n') {
        // if the waterRow is empty then we need to figure out how long the rows are in
        // order to know how many elements to add to our water row
        if (waterRow.length === 0) {
          let waterCounter = 0;
          // populating the waterRow with the correct amount of 'W' characters
          while (waterCounter < tempRow.length + 1) {
            waterRow.push('W');
            waterCounter++;
          }
          // if the tempMatrix length is 0 then we are at the first row and can add a water
          // row, since the board is always surround by water at least 1
          if (tempMatrix.length === 0) {
            tempMatrix.push(waterRow);
          }
        }
        // at the end of a row we will push 'W' to it and then add it to the tempMatrix, we
        // will then set the tempRow to ['W'] to start again
        tempRow.push('W');
        tempMatrix.push(tempRow);
        tempRow = ['W'];
        counter++;
      // if we aren't at a newline we are in the same row and can push elements into the
      // tempRow
      } else {
        // due to legacy jeroo we convert the '.' back into 'G' to work with out matrix service
        // if the value is '.' otherwise, we can just push the value onto the row
        if (x[counter] === '.') {
          tempRow.push('G');
        } else {
          tempRow.push(x[counter]);
        }
        counter++;
      }
    }
    // once we have gone through the loaded data we need to add one more waterRow to the bottom
    // and then call the matrixService writeBoard function
    tempMatrix.push(waterRow);
    this.matrixService.writeBoard(tempMatrix);
  }

}
