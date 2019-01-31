import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { HelpMethodJavaComponent } from './help-method-java.component';

describe('HelpMethodJavaComponent', () => {
  let component: HelpMethodJavaComponent;
  let fixture: ComponentFixture<HelpMethodJavaComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ HelpMethodJavaComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(HelpMethodJavaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
