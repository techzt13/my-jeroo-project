import { Component, OnInit, Inject } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material';
import { FormGroup, FormBuilder } from '@angular/forms';

@Component({
  selector: 'app-matrix-dialog',
  templateUrl: './matrix-dialog.component.html',
  styleUrls: ['./matrix-dialog.component.scss']
})
export class MatrixDialogComponent implements OnInit {

  form: FormGroup;
  widthValue: number;
  heightValue: number;

  constructor(private fb: FormBuilder,
              private dialogRef: MatDialogRef<MatrixDialogComponent>,
              @Inject(MAT_DIALOG_DATA) data) {
      this.widthValue = data.xValue;
      this.heightValue = data.yValue;
    }

  save() {
    this.dialogRef.close(this.form.value);
  }

  close() {
    this.dialogRef.close();
  }

  ngOnInit() {
    this.form = this.fb.group({
      xValue: [this.widthValue, []],
      yValue: [this.heightValue, []]
    });
  }

}
