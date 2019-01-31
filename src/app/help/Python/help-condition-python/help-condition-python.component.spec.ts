import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { HelpConditionPythonComponent } from './help-condition-python.component';

describe('HelpConditionPythonComponent', () => {
  let component: HelpConditionPythonComponent;
  let fixture: ComponentFixture<HelpConditionPythonComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ HelpConditionPythonComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(HelpConditionPythonComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
