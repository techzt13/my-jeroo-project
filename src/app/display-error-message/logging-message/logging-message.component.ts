import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-logging-message',
  templateUrl: './logging-message.component.html'
})
export class LoggingMessageComponent {

  @Input()
  message: string;

  constructor() { }
}
