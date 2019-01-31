import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { HelpActionComponent } from './help-action.component';

describe('HelpActionComponent', () => {
  let component: HelpActionComponent;
  let fixture: ComponentFixture<HelpActionComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ HelpActionComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(HelpActionComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
