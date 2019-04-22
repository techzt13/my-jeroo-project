import { Component, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';

@Component({
    selector: 'app-dashboard-dialog-awards',
    templateUrl: './dashboard-dialog-awards.component.html'
})
export class DashboardDialogAwardsComponent {
    constructor(
        public dialogRef: MatDialogRef<DashboardDialogAwardsComponent>,
        @Inject(MAT_DIALOG_DATA) public data: string) {}

    onCloseClick(): void {
        this.dialogRef.close();
    }
}
