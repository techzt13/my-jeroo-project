import { Component, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';

@Component({
    selector: 'app-dashboard-dialog-about',
    templateUrl: './dashboard-dialog-about.component.html',
})
export class DashboardDialogAboutComponent {
    constructor(
        public dialogRef: MatDialogRef<DashboardDialogAboutComponent>,
        @Inject(MAT_DIALOG_DATA) public data: string) {}

    onCloseClick(): void {
        this.dialogRef.close();
    }
}
