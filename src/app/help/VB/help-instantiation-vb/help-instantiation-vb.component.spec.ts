import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { HelpInstantiationVbComponent } from './help-instantiation-vb.component';

describe('HelpInstantiationVbComponent', () => {
  let component: HelpInstantiationVbComponent;
  let fixture: ComponentFixture<HelpInstantiationVbComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ HelpInstantiationVbComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(HelpInstantiationVbComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
