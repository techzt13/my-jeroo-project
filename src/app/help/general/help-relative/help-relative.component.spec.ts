import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { HelpRelativeComponent } from './help-relative.component';

describe('HelpRelativeComponent', () => {
  let component: HelpRelativeComponent;
  let fixture: ComponentFixture<HelpRelativeComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ HelpRelativeComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(HelpRelativeComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
