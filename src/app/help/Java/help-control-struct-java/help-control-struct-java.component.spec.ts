import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { HelpControlStructJavaComponent } from './help-control-struct-java.component';

describe('HelpControlStructJavaComponent', () => {
  let component: HelpControlStructJavaComponent;
  let fixture: ComponentFixture<HelpControlStructJavaComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ HelpControlStructJavaComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(HelpControlStructJavaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
