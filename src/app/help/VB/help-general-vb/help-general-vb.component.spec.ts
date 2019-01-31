import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { HelpGeneralVbComponent } from './help-general-vb.component';

describe('HelpGeneralVbComponent', () => {
  let component: HelpGeneralVbComponent;
  let fixture: ComponentFixture<HelpGeneralVbComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ HelpGeneralVbComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(HelpGeneralVbComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
