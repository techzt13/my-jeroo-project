import { Component } from '@angular/core';
import { FilesystemService } from './filesystem.service';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {
  title = 'jeroo';
  constructor(public fileSystemService: FilesystemService) { }

  saveBoard() {
    this.fileSystemService.saveBoard();
  }

  loadedBoard(boardFile: any) {
    this.fileSystemService.fileSelected(boardFile);
  }

}
