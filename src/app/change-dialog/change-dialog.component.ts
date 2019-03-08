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
  changeSizePassed = 'CS';
  newBoardPassed = 'NB';
  loadBoardPassed = 'LB';

  constructor(private dialogRef: MatDialogRef<ChangeDialogComponent>,
              @Inject(MAT_DIALOG_DATA) public data) {
                this.comingFrom = data.comingFrom;
              }

  // will close the dialog without continuing
  close() {
    this.dialogRef.close();
  }

  // if the user chooses to save the board within the dialog this function will run. It will
  // change the data.comingFrom value to append a '-S' to the end to mark that it needs to be
  // saved once it's returned to the correct component. It will then run the continueOperation()
  // function to send the data back to the component
  saveBoard() {
    if (this.comingFrom === this.newBoardPassed) {
      this.data.comingFrom = this.newBoardPassed + '-S';
    } else if (this.comingFrom === this.loadBoardPassed) {
      this.data.comingFrom = this.loadBoardPassed + '-S';
    } else if (this.comingFrom === this.changeSizePassed) {
      this.data.comingFrom = this.changeSizePassed + '-S';
    }
    this.continueOperation();
  }

  // If the user selects continue or save this function will run and will just send the data
  // back the the component for looking at and verifying
  continueOperation() {
    this.dialogRef.close(this.data);
  }

  ngOnInit() {
  }

}
