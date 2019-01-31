import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { HelpGeneralPythonComponent } from './help-general-python.component';

describe('HelpGeneralPythonComponent', () => {
  let component: HelpGeneralPythonComponent;
  let fixture: ComponentFixture<HelpGeneralPythonComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ HelpGeneralPythonComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(HelpGeneralPythonComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
