import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { HelpConditionVBComponent } from './help-condition-vb.component';

describe('HelpConditionVBComponent', () => {
  let component: HelpConditionVBComponent;
  let fixture: ComponentFixture<HelpConditionVBComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ HelpConditionVBComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(HelpConditionVBComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
