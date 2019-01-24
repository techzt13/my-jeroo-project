import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-jeroo-matrix',
  templateUrl: './jeroo-matrix.component.html',
  styleUrls: ['./jeroo-matrix.component.scss']
})
export class JerooMatrixComponent implements OnInit {

  jerooBoard = [['W', 'W', 'W', 'W', 'W'],
                ['W', 'G', 'G', 'G', 'W'],
                ['W', 'G', 'G', 'G', 'W'],
                ['W', 'G', 'G', 'G', 'W'],
                ['W', 'W', 'W', 'W', 'W']];

  constructor() { }

  ngOnInit() {
  }

}
