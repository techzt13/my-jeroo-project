import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { DashboardDialogCopyrightComponent } from './dashboard-dialog-copyright.component';

describe('DashboardDialogCopyrightComponent', () => {
  let component: DashboardDialogCopyrightComponent;
  let fixture: ComponentFixture<DashboardDialogCopyrightComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ DashboardDialogCopyrightComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(DashboardDialogCopyrightComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
