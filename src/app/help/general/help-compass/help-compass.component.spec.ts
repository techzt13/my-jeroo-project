import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { HelpCompassComponent } from './help-compass.component';

describe('HelpCompassComponent', () => {
  let component: HelpCompassComponent;
  let fixture: ComponentFixture<HelpCompassComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ HelpCompassComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(HelpCompassComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
