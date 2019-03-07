import { Component } from '@angular/core';
import { FilesystemService } from './filesystem.service';

@Component({
    selector: 'app-root',
    templateUrl: './app.component.html',
    styleUrls: ['./app.component.scss']
})
export class AppComponent {
  title = 'jeroo';
  constructor() { }

}
