import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-display-error-message',
  templateUrl: './display-error-message.component.html',
  styleUrls: ['./display-error-message.component.scss']
})
export class DisplayErrorMessageComponent implements OnInit {
  errorMessage: string;
  constructor() { }
  ngOnInit() {
    this.errorMessage = 'Error messages will show up here.';
  }
  setErrorMessage(message: string) {
    this.errorMessage = message;
  }
  getErrorMessage() {
    return this.errorMessage;
  }
}
