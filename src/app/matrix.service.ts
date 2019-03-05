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
    private imageAtlas: HTMLImageElement;

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

    /**
     * @returns The number of rows in the matrix.
     */
    getRows() {
        return this.rows;
    }

    /**
     * @param rows The new number of rows in the matrix.
     */
    setRows(rows: number) {
        this.rows = rows;
    }

    /**
      * @returns The number of columns in the matrix.
      */
    getCols() {
        return this.cols;
    }

    /**
      * @param cols The number of columns in the matrix.
      */
    setCols(cols: number) {
        this.cols = cols;
    }

    /**
      * @param col The column of the tile.
      * @param row The row of the tile.
      * @returns the tile at the specified column and row.
      */
    getTile(col: number, row: number) {
        return this.tiles[row * this.cols + col];
    }

    /**
      * @param col The column of the tile.
      * @param row The row of the tile.
      * @param tile The tile type of the tile.
      */
    setTile(col: number, row: number, tile: TileType) {
        this.tiles[row * this.cols + col] = tile;
    }

    /**
      * @returns the size of a tile sprite in pixels.
      */
    getTsize() {
        return this.tsize;
    }

    /**
      * Renders the tilemap to a 2D rendering context.
      * @param context 2D rendering context.
      */
    render(context: CanvasRenderingContext2D) {
        if (this.imageAtlas == null) {
            this.getTileAtlasObs().subscribe(imageAtlas => {
                this.renderTiles(context, imageAtlas);
                this.imageAtlas = imageAtlas;
            });
        } else {
            this.renderTiles(context, this.imageAtlas);
        }
    }

    private renderTiles(context: CanvasRenderingContext2D, imageAtlas: HTMLImageElement) {
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
