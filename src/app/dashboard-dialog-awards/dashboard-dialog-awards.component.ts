import { Component, Inject } from '@angular/core';
import {MatDialog, MatDialogRef, MAT_DIALOG_DATA} from '@angular/material';
import { FormGroup } from '@angular/forms';
@Component({
  selector: 'app-dashboard-dialog-awards',
  templateUrl: './dashboard-dialog-awards.component.html'
})
export class DashboardDialogAwardsComponent {

  constructor(
    public dialogRef: MatDialogRef<DashboardDialogAwardsComponent>,
    @Inject(MAT_DIALOG_DATA) public data: string) {}

  onNoClick(): void {
    this.dialogRef.close();
  }


}
