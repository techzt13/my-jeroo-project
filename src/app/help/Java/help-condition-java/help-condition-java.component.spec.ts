import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { HelpConditionJavaComponent } from './help-condition-java.component';

describe('HelpConditionJavaComponent', () => {
  let component: HelpConditionJavaComponent;
  let fixture: ComponentFixture<HelpConditionJavaComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ HelpConditionJavaComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(HelpConditionJavaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
