import { Component, OnInit } from '@angular/core';
import { FormGroup, FormBuilder } from '@angular/forms';

@Component({
  selector: 'app-dashboard-dialog',
  templateUrl: './dashboard-dialog.component.html',
})
export class DashboardDialogComponent implements OnInit {
  form: FormGroup;
  constructor(private fb: FormBuilder) {
    
  }
  
  ngOnInit() {
    this.form = this.fb.group({});
  }

}
