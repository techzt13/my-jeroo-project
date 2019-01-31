import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { HelpControlStructVBComponent } from './help-control-struct-vb.component';

describe('HelpControlStructVBComponent', () => {
  let component: HelpControlStructVBComponent;
  let fixture: ComponentFixture<HelpControlStructVBComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ HelpControlStructVBComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(HelpControlStructVBComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
