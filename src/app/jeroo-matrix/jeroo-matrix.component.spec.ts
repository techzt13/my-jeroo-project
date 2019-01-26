import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { JerooMatrixComponent } from './jeroo-matrix.component';

import { MaterialModule } from '../material.module';

describe('JerooMatrixComponent', () => {
  let component: JerooMatrixComponent;
  let fixture: ComponentFixture<JerooMatrixComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      imports: [
        MaterialModule
      ],
      declarations: [ JerooMatrixComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(JerooMatrixComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
