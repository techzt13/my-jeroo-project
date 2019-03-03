import { TestBed } from '@angular/core/testing';
import { TileType } from './matrixConstants';

import { MatrixService } from './matrix.service';

describe('MatrixService', () => {

    beforeEach(() => TestBed.configureTestingModule({}));

    it('should be created', () => {
        const service: MatrixService = TestBed.get(MatrixService);
        expect(service).toBeTruthy();
    });

    it('get and set correctly find entities', () => {
        const service: MatrixService = TestBed.get(MatrixService);
        service.setTile(1, 1, TileType.Water);
    })
});
