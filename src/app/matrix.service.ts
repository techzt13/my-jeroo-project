import { Injectable } from '@angular/core';
import { TileType } from './matrixConstants';
import { fromEvent } from 'rxjs';
import { map } from 'rxjs/operators';

@Injectable({
    providedIn: 'root'
})
export class MatrixService {

    private rows = 26;
    private cols = 26;
    private tsize = 28;
    private tiles: TileType[] = [];

    constructor() {
        this.resetMap();
    }

    /**
     * Resets the tile map to all grass
     */
    resetMap() {
        this.tiles = [];
        for (let row = 0; row < this.rows; row++) {
            for (let col = 0; col < this.cols; col++) {
                this.tiles.push(TileType.Grass);
            }
        }
    }

    getRows() {
        return this.rows;
    }

    setRows(rows: number) {
        this.rows = rows;
    }

    getCols() {
        return this.cols;
    }

    setCols(cols: number) {
        this.cols = cols;
    }

    getTile(col: number, row: number) {
        return this.tiles[row * this.cols + col];
    }

    setTile(col: number, row: number, tile: TileType) {
        this.tiles[row * this.cols + col] = tile;
    }

    getTsize() {
        return this.tsize;
    }

    render(context: CanvasRenderingContext2D) {
        this.getTileAtlasObs().subscribe(imageAtlas => {
            // fill the top row with water
            for (let col = 0; col < this.cols + 2; col++) {
                this.renderTile(context, imageAtlas, TileType.Water, col, 0);
            }
            for (let row = 0; row < this.rows; row++) {
                // fill in the left water tile
                this.renderTile(context, imageAtlas, TileType.Water, 0, row + 1);
                for (let col = 0; col < this.cols; col++) {
                    const tile = this.getTile(col, row);
                    this.renderTile(context, imageAtlas, tile, col + 1, row + 1);
                }
                // fill in the right water tile
                this.renderTile(context, imageAtlas, TileType.Water, this.cols + 1, row + 1);
            }
            // fill the bottom row with water
            for (let col = 0; col < this.cols + 2; col++) {
                this.renderTile(context, imageAtlas, TileType.Water, col, this.rows + 1);
            }
        });
    }

    private renderTile(context: CanvasRenderingContext2D, imageAtlas: HTMLImageElement, tileType: TileType, col: number, row: number) {
        const offset = this.tileTypeToNumber(tileType);
        context.drawImage(
            imageAtlas,
            offset * this.tsize,
            0,
            this.tsize,
            this.tsize,
            col * this.tsize,
            row * this.tsize,
            this.tsize,
            this.tsize
        );
    }

    private tileTypeToNumber(tileType: TileType) {
        if (tileType === TileType.Grass) {
            return 0;
        } else if (tileType === TileType.Water) {
            return 1;
        } else if (tileType === TileType.Flower) {
            return 2;
        } else if (tileType === TileType.Net) {
            return 3;
        } else {
            throw new Error('Unknown TileType');
        }
    }

    private getTileAtlasObs() {
        const image = new Image();
        const imageObservable = fromEvent(image, 'load');
        image.src = 'assets/images/JerooTilesSpritesheet.png';
        return imageObservable.pipe(map(() => image));
    }
}
