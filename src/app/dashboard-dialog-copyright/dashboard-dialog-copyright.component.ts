import { Component, Inject } from '@angular/core';
import {MatDialog, MatDialogRef, MAT_DIALOG_DATA} from '@angular/material';
import { FormGroup } from '@angular/forms';
@Component({
  selector: 'app-dashboard-dialog-copyright',
  templateUrl: './dashboard-dialog-copyright.component.html',
  styleUrls: ['./dashboard-dialog-copyright.component.scss']
})
export class DashboardDialogCopyrightComponent {

  constructor(
    public dialogRef: MatDialogRef<DashboardDialogCopyrightComponent>,
    @Inject(MAT_DIALOG_DATA) public data: string) {}

  onNoClick(): void {
    this.dialogRef.close();
  }
}
