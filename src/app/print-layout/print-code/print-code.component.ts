import { Component, OnInit } from '@angular/core';
import { PrintService } from 'src/app/print.service';

@Component({
    selector: 'app-print-code',
    templateUrl: './print-code.component.html',
    styleUrls: ['./print-code.component.scss']
})
export class PrintCodeComponent implements OnInit {

    constructor(private printService: PrintService) { }

    ngOnInit() {
        setTimeout(() => this.printService.onDataReady());
    }

}
