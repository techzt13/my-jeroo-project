import { Component } from '@angular/core';

@Component({
    selector: 'app-root',
    templateUrl: './app.component.html',
    styleUrls: ['./app.component.scss']
})
export class AppComponent {
    title = 'jeroo';
    thing = JerooCompiler.compile('@Java\n@@\nmethod main() { Jeroo j = new Jeroo(); }');
}
