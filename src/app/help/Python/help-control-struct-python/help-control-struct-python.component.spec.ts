import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { HelpControlStructPythonComponent } from './help-control-struct-python.component';

describe('HelpControlStructPythonComponent', () => {
  let component: HelpControlStructPythonComponent;
  let fixture: ComponentFixture<HelpControlStructPythonComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ HelpControlStructPythonComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(HelpControlStructPythonComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
