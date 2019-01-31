import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { HelpTutorialPythonComponent } from './help-tutorial-python.component';

describe('HelpTutorialPythonComponent', () => {
  let component: HelpTutorialPythonComponent;
  let fixture: ComponentFixture<HelpTutorialPythonComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ HelpTutorialPythonComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(HelpTutorialPythonComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
