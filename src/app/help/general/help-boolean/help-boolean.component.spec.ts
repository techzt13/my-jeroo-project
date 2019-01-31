import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { HelpBooleanComponent } from './help-boolean.component';

describe('HelpBooleanComponent', () => {
  let component: HelpBooleanComponent;
  let fixture: ComponentFixture<HelpBooleanComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ HelpBooleanComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(HelpBooleanComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
