import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { HelpGeneralJavaComponent } from './help-general-java.component';

describe('HelpGeneralJavaComponent', () => {
  let component: HelpGeneralJavaComponent;
  let fixture: ComponentFixture<HelpGeneralJavaComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ HelpGeneralJavaComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(HelpGeneralJavaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
