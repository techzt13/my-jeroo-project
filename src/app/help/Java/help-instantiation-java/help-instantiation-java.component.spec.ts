import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { HelpInstantiationJavaComponent } from './help-instantiation-java.component';

describe('HelpInstantiationJavaComponent', () => {
  let component: HelpInstantiationJavaComponent;
  let fixture: ComponentFixture<HelpInstantiationJavaComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ HelpInstantiationJavaComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(HelpInstantiationJavaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
