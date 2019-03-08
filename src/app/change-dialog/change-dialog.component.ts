import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';

@Component({
  selector: 'app-change-dialog',
  templateUrl: './change-dialog.component.html',
  styleUrls: ['./change-dialog.component.scss']
})
export class ChangeDialogComponent implements OnInit {

  // variables for the comingFrom arguments. These will tell the function continueOperation
  // what to do after the board has either been saved, or the user chose to continue without
  // saving
  comingFrom: string;

  constructor(private dialogRef: MatDialogRef<ChangeDialogComponent>,
              @Inject(MAT_DIALOG_DATA) public data) {
                this.comingFrom = data.comingFrom;
              }

  // will close the dialog without continuing
  close() {
    this.dialogRef.close();
  }

  // saves the board, and then continues with what was going on
  saveBoard() {
    if (this.comingFrom === 'NB') {
      this.data.comingFrom = 'NB-S';
    } else if (this.comingFrom === 'LB') {
      this.data.comingFrom = 'LB-S';
    }
    this.continueOperation();
  }

  // will continue with what was happening without saving the board
  continueOperation() {
    this.data.returnArgument = true;
    this.dialogRef.close(this.data);
  }

  ngOnInit() {
  }

}
