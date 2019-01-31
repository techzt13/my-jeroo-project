import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { HelpMethodVbComponent } from './help-method-vb.component';

describe('HelpMethodVbComponent', () => {
  let component: HelpMethodVbComponent;
  let fixture: ComponentFixture<HelpMethodVbComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ HelpMethodVbComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(HelpMethodVbComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
