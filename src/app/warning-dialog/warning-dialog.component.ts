import { Component, Output, EventEmitter } from '@angular/core';
import { MatDialogRef } from '@angular/material';


@Component({
  selector: 'app-warning-dialog',
  templateUrl: './warning-dialog.component.html',
  styleUrls: ['./warning-dialog.component.scss']
})
export class WarningDialogComponent {
  @Output() continueEvent = new EventEmitter<boolean>();
  
  constructor(public dialogRef: MatDialogRef<WarningDialogComponent>) {

  }

  onCloseClick(): void {
    this.dialogRef.close(false);
  }

  onContinueClick(): void {
    this.dialogRef.close(true);
  }
  
}
