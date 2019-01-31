import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { HelpMethodPythonComponent } from './help-method-python.component';

describe('HelpMethodPythonComponent', () => {
  let component: HelpMethodPythonComponent;
  let fixture: ComponentFixture<HelpMethodPythonComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ HelpMethodPythonComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(HelpMethodPythonComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
