import { Component, OnInit } from '@angular/core';

@Component({
    selector: 'app-display-error-message',
    templateUrl: './display-error-message.component.html',
    styleUrls: ['./display-error-message.component.scss']
})
export class DisplayErrorMessageComponent implements OnInit {
    errorMessage: string;

    ngOnInit() {
        this.errorMessage = '';
    }
    setErrorMessage(message: string) {
        this.errorMessage = '\t' + message;
    }
    getErrorMessage() {
        return this.errorMessage;
    }
    clearErrorMessage() {
        this.errorMessage = '';
    }
}
