/**
 * uDOS Grid System Variables
 * Implements TILE and MAP system based on uDOS Display System legacy core
 * Provides 16×16 pixel uCELL grid coordinates and tile management
 */

export interface UCellCoordinate {
  x: number; // Column position (0-indexed)
  y: number; // Row position (0-indexed)
}

export interface UTile {
  id: string;
  coordinate: UCellCoordinate;
  content: string;
  type: 'static' | 'interactive' | 'dynamic';
  size: UCellSize;
}

export interface UCellSize {
  width: number;  // Width in uCELL units (default: 1)
  height: number; // Height in uCELL units (default: 1)
}

export interface UMapGrid {
  cols: number; // Number of columns
  rows: number; // Number of rows
  tiles: UTile[];
  mode: 'CLI' | 'DESKTOP' | 'WEB';
}

export interface PanelSystemVariables {
  // uDOS Grid System
  UCELL_SIZE: number;         // 16px base unit
  UCELL_BUFFER: number;       // 2px buffer
  UTILE_SPACING: number;      // 16px spacing
  UMAP_GRID_COLS: number;     // Grid columns
  UMAP_GRID_ROWS: number;     // Grid rows
  
  // Panel Layout
  PANEL_WIDTH_CELLS: number;  // Panel width in uCELLs
  PANEL_MIN_HEIGHT: number;   // Minimum panel height
  PANEL_SPACING: number;      // Spacing between panels
  
  // Display Mode
  DISPLAY_MODE: 'CLI' | 'DESKTOP' | 'WEB';
  GRID_CONTEXT: 'MAIN_SCREEN' | 'SETTINGS_SCREEN' | 'DEBUG_SCREEN';
  
  // Theme Integration
  THEME_MODE: 'tinycore' | 'modern' | 'classic';
  COLOR_PALETTE: string;
}

class UDOSGridSystem {
  private variables: PanelSystemVariables;
  private currentGrid: UMapGrid;

  constructor() {
    this.variables = this.initializeVariables();
    this.currentGrid = this.initializeGrid();
  }

  private initializeVariables(): PanelSystemVariables {
    return {
      // uDOS Grid System - Based on 16×16 pixel uCELL
      UCELL_SIZE: 16,
      UCELL_BUFFER: 2,
      UTILE_SPACING: 16,
      UMAP_GRID_COLS: 20,  // 320px width for panels
      UMAP_GRID_ROWS: 30,  // 480px height for desktop
      
      // Panel Layout - Aligned to uDOS Display System
      PANEL_WIDTH_CELLS: 20,   // 20 uCELLs = 320px
      PANEL_MIN_HEIGHT: 300,   // Minimum panel height
      PANEL_SPACING: 16,       // 1 uCELL spacing
      
      // Display Context
      DISPLAY_MODE: 'DESKTOP',
      GRID_CONTEXT: 'MAIN_SCREEN',
      
      // Theme
      THEME_MODE: 'tinycore',
      COLOR_PALETTE: 'polaroid'
    };
  }

  private initializeGrid(): UMapGrid {
    return {
      cols: this.variables.UMAP_GRID_COLS,
      rows: this.variables.UMAP_GRID_ROWS,
      tiles: [],
      mode: this.variables.DISPLAY_MODE
    };
  }

  // Grid Coordinate System (uMAP)
  coordinateToPixels(coord: UCellCoordinate): { x: number; y: number } {
    return {
      x: coord.x * this.variables.UCELL_SIZE,
      y: coord.y * this.variables.UCELL_SIZE
    };
  }

  pixelsToCoordinate(x: number, y: number): UCellCoordinate {
    return {
      x: Math.floor(x / this.variables.UCELL_SIZE),
      y: Math.floor(y / this.variables.UCELL_SIZE)
    };
  }

  // Tile Management System (uTILE)
  createTile(
    id: string,
    coord: UCellCoordinate,
    content: string,
    type: UTile['type'] = 'static',
    size: UCellSize = { width: 1, height: 1 }
  ): UTile {
    return {
      id,
      coordinate: coord,
      content,
      type,
      size
    };
  }

  addTileToGrid(tile: UTile): boolean {
    // Check if position is available
    if (this.isTilePositionAvailable(tile.coordinate, tile.size)) {
      this.currentGrid.tiles.push(tile);
      return true;
    }
    return false;
  }

  private isTilePositionAvailable(coord: UCellCoordinate, size: UCellSize): boolean {
    // Check if tile fits within grid bounds
    if (coord.x + size.width > this.currentGrid.cols || 
        coord.y + size.height > this.currentGrid.rows) {
      return false;
    }

    // Check for tile conflicts
    return !this.currentGrid.tiles.some(existingTile => 
      this.tilesOverlap(coord, size, existingTile.coordinate, existingTile.size)
    );
  }

  private tilesOverlap(
    coord1: UCellCoordinate, size1: UCellSize,
    coord2: UCellCoordinate, size2: UCellSize
  ): boolean {
    return !(
      coord1.x + size1.width <= coord2.x ||
      coord2.x + size2.width <= coord1.x ||
      coord1.y + size1.height <= coord2.y ||
      coord2.y + size2.height <= coord1.y
    );
  }

  // Panel Layout System
  calculatePanelLayout(panelCount: number): UCellCoordinate[] {
    const positions: UCellCoordinate[] = [];
    const panelsPerRow = Math.floor(this.currentGrid.cols / this.variables.PANEL_WIDTH_CELLS);
    
    for (let i = 0; i < panelCount; i++) {
      const row = Math.floor(i / panelsPerRow);
      const col = i % panelsPerRow;
      
      positions.push({
        x: col * this.variables.PANEL_WIDTH_CELLS,
        y: row * Math.ceil(this.variables.PANEL_MIN_HEIGHT / this.variables.UCELL_SIZE)
      });
    }
    
    return positions;
  }

  // CSS Variable Generation for React Components
  generateCSSVariables(): Record<string, string> {
    return {
      '--ucell-size': `${this.variables.UCELL_SIZE}px`,
      '--ucell-buffer': `${this.variables.UCELL_BUFFER}px`,
      '--utile-spacing': `${this.variables.UTILE_SPACING}px`,
      '--umap-grid-cols': this.variables.UMAP_GRID_COLS.toString(),
      '--umap-grid-rows': this.variables.UMAP_GRID_ROWS.toString(),
      '--panel-width-cells': this.variables.PANEL_WIDTH_CELLS.toString(),
      '--panel-min-height': `${this.variables.PANEL_MIN_HEIGHT}px`,
      '--panel-spacing': `${this.variables.PANEL_SPACING}px`,
    };
  }

  // Grid Operations
  getTileAt(coord: UCellCoordinate): UTile | null {
    return this.currentGrid.tiles.find(tile => 
      tile.coordinate.x === coord.x && tile.coordinate.y === coord.y
    ) || null;
  }

  removeTile(tileId: string): boolean {
    const index = this.currentGrid.tiles.findIndex(tile => tile.id === tileId);
    if (index !== -1) {
      this.currentGrid.tiles.splice(index, 1);
      return true;
    }
    return false;
  }

  clearGrid(): void {
    this.currentGrid.tiles = [];
  }

  // Display Mode Management
  setDisplayMode(mode: UMapGrid['mode']): void {
    this.currentGrid.mode = mode;
    this.variables.DISPLAY_MODE = mode;
    
    // Adjust grid size based on display mode
    switch (mode) {
      case 'CLI':
        this.variables.UMAP_GRID_COLS = 80;
        this.variables.UMAP_GRID_ROWS = 30;
        break;
      case 'DESKTOP':
        this.variables.UMAP_GRID_COLS = 40;
        this.variables.UMAP_GRID_ROWS = 30;
        break;
      case 'WEB':
        this.variables.UMAP_GRID_COLS = 60;
        this.variables.UMAP_GRID_ROWS = 40;
        break;
    }
    
    this.currentGrid.cols = this.variables.UMAP_GRID_COLS;
    this.currentGrid.rows = this.variables.UMAP_GRID_ROWS;
  }

  // Get current system state
  getSystemVariables(): PanelSystemVariables {
    return { ...this.variables };
  }

  getCurrentGrid(): UMapGrid {
    return { ...this.currentGrid, tiles: [...this.currentGrid.tiles] };
  }

  // Panel-specific helpers
  createPanelTile(
    panelId: string,
    coord: UCellCoordinate,
    panelType: 'todo' | 'progress' | 'workflow' | 'system'
  ): UTile {
    const content = this.generatePanelContent(panelType);
    const size: UCellSize = {
      width: this.variables.PANEL_WIDTH_CELLS,
      height: Math.ceil(this.variables.PANEL_MIN_HEIGHT / this.variables.UCELL_SIZE)
    };

    return this.createTile(panelId, coord, content, 'interactive', size);
  }

  private generatePanelContent(panelType: string): string {
    const contentMap: Record<string, string> = {
      todo: '📝 TODO Panel',
      progress: '📊 Progress Panel', 
      workflow: '⚙️ Workflow Panel',
      system: '⚡ System Panel'
    };
    return contentMap[panelType] || `${panelType} Panel`;
  }

  // ASCII Grid Rendering (for debugging/CLI mode)
  renderGridASCII(): string {
    const grid: string[][] = Array(this.currentGrid.rows)
      .fill(null)
      .map(() => Array(this.currentGrid.cols).fill('░'));

    // Place tiles
    this.currentGrid.tiles.forEach(tile => {
      for (let y = 0; y < tile.size.height; y++) {
        for (let x = 0; x < tile.size.width; x++) {
          const posX = tile.coordinate.x + x;
          const posY = tile.coordinate.y + y;
          if (posX < this.currentGrid.cols && posY < this.currentGrid.rows) {
            grid[posY][posX] = tile.type === 'interactive' ? '█' : '▓';
          }
        }
      }
    });

    return grid.map(row => row.join('')).join('\n');
  }
}

// Export singleton instance
export const udosGridSystem = new UDOSGridSystem();
export default udosGridSystem;
