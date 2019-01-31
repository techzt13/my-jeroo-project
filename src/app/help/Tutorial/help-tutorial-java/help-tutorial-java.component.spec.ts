import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { HelpTutorialJavaComponent } from './help-tutorial-java.component';

describe('HelpTutorialJavaComponent', () => {
  let component: HelpTutorialJavaComponent;
  let fixture: ComponentFixture<HelpTutorialJavaComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ HelpTutorialJavaComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(HelpTutorialJavaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
