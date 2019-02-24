import { Injectable } from '@angular/core';
import { MatrixService } from './matrix.service';
import { saveAs } from 'file-saver';
import { text } from '@angular/core/src/render3';

@Injectable({
  providedIn: 'root'
})
export class FilesystemService {

  loadBoardFile: any;

  constructor(public matrixService: MatrixService) { }

  // allows the users to save the board to their local system, and maintains the same
  // style as the old version of Jeroo when saving for legacy use if needed
  saveBoard() {
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
        myBlob = new Blob([blobHolder, '\r\n'], {type: 'ANSI'});
        blobHolder = myBlob;
      }
    }
    // finally prompt the user to save the board
    FileSaver.saveAs(myBlob, 'jerooboard.jev');
  }

  fileSelected(boardFile: any) {
    this.loadBoardFile = boardFile.target.files[0];
    this.loadBoard(this.loadBoardFile);
  }

  loadBoard(matrixFile: any) {
    const fileReader = new FileReader();
    let aaaaa: String | ArrayBuffer;
    fileReader.onload = (e) => {
      aaaaa = fileReader.result;
      console.log(aaaaa);
    };
    console.log(fileReader.readAsText(matrixFile));
    console.log(aaaaa);
  }
}
