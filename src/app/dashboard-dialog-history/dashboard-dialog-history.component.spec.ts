import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { DashboardDialogHistoryComponent } from './dashboard-dialog-history.component';

describe('DashboardDialogHistoryComponent', () => {
  let component: DashboardDialogHistoryComponent;
  let fixture: ComponentFixture<DashboardDialogHistoryComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ DashboardDialogHistoryComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(DashboardDialogHistoryComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
