import { Component, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';

@Component({
    selector: 'app-dashboard-dialog-copyright',
    templateUrl: './dashboard-dialog-copyright.component.html'
})
export class DashboardDialogCopyrightComponent {

    constructor(
        public dialogRef: MatDialogRef<DashboardDialogCopyrightComponent>,
        @Inject(MAT_DIALOG_DATA) public data: string) {}

    onCloseClick(): void {
        this.dialogRef.close();
    }
}
