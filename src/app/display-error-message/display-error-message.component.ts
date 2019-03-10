import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-display-error-message',
  templateUrl: './display-error-message.component.html',
  styleUrls: ['./display-error-message.component.scss']
})
export class DisplayErrorMessageComponent implements OnInit {
  message: string;
  constructor() { }
  ngOnInit() {
    this.message = 'TESTING Error message';
  }
  reportMessage(errorStr: string){
    this.message = errorStr;
  }
  
}
