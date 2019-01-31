import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { HelpDirectionsComponent } from './help-directions.component';

describe('HelpDirectionsComponent', () => {
  let component: HelpDirectionsComponent;
  let fixture: ComponentFixture<HelpDirectionsComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ HelpDirectionsComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(HelpDirectionsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
