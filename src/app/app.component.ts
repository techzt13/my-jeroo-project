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

  // calls the save board function within the fileSystem service
  saveBoard() {
    this.fileSystemService.saveBoard();
  }

  // calls the load board functions within the filesystem service
  loadedBoard(boardFile: any) {
    this.fileSystemService.fileSelected(boardFile);
  }

}
