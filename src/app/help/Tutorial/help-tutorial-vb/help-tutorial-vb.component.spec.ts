import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { HelpTutorialVbComponent } from './help-tutorial-vb.component';

describe('HelpTutorialVbComponent', () => {
  let component: HelpTutorialVbComponent;
  let fixture: ComponentFixture<HelpTutorialVbComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ HelpTutorialVbComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(HelpTutorialVbComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
