import { Component, Inject } from '@angular/core';
import {MatDialog, MatDialogRef, MAT_DIALOG_DATA} from '@angular/material';
import { FormGroup } from '@angular/forms';
@Component({
  selector: 'app-dashboard-dialog-history',
  templateUrl: './dashboard-dialog-history.component.html'
})
export class DashboardDialogHistoryComponent {

  constructor(
    public dialogRef: MatDialogRef<DashboardDialogHistoryComponent>,
    @Inject(MAT_DIALOG_DATA) public data: string) {}

  onNoClick(): void {
    this.dialogRef.close();
  }
}
