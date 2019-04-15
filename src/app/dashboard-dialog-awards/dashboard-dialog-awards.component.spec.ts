import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { DashboardDialogAwardsComponent } from './dashboard-dialog-awards.component';

describe('DashboardDialogAwardsComponent', () => {
  let component: DashboardDialogAwardsComponent;
  let fixture: ComponentFixture<DashboardDialogAwardsComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [DashboardDialogAwardsComponent]
    })
      .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(DashboardDialogAwardsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
