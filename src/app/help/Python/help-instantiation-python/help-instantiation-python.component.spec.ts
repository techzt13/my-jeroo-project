import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { HelpInstantiationPythonComponent } from './help-instantiation-python.component';

describe('HelpInstantiationPythonComponent', () => {
  let component: HelpInstantiationPythonComponent;
  let fixture: ComponentFixture<HelpInstantiationPythonComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ HelpInstantiationPythonComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(HelpInstantiationPythonComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
