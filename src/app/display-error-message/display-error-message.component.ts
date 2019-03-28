import { Component, OnInit, ErrorHandler } from '@angular/core';

@Component({
  selector: 'app-display-error-message',
  templateUrl: './display-error-message.component.html',
  styleUrls: ['./display-error-message.component.scss']
})


export class DisplayErrorMessageComponent extends ErrorHandler implements OnInit {
  errorMessage: string;
  constructor() { 
    super();
  }
  ngOnInit() {
    this.errorMessage = '';
  }
  setErrorMessage(message: string) {
    this.errorMessage = "\t" + message;
  }
  getErrorMessage() {
    return this.errorMessage;
  }
  clearErrorMessage() {
    this.errorMessage = '';
  } 
}
