import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { MatrixDialogComponent } from './matrix-dialog.component';

describe('MatrixDialogComponent', () => {
  let component: MatrixDialogComponent;
  let fixture: ComponentFixture<MatrixDialogComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ MatrixDialogComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(MatrixDialogComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
