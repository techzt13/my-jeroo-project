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
    this.errorMessage = 'This should change';
  }
  setErrorMessage(message: string) {
    this.errorMessage = message;
  }
  getErrorMessage() {
    return this.errorMessage;
  }
  clearErrorMessage() {
    this.errorMessage = '';
  } 
  testErrorMessage(){
    this.errorMessage = 'Changed to new'
  }
}
