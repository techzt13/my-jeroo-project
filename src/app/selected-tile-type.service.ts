import { Injectable } from '@angular/core';
import { TileType } from './jerooTileType';

@Injectable({
  providedIn: 'root'
})
export class SelectedTileTypeService {
  selectedTileType: TileType = null;

  constructor() { }
}
