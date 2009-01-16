/**
* PixelBlitz Engine - BlitzGrid
* @link http://www.pixelblitz.org
* @author Richard Davey / Photon Storm
*/

package pixelblitz.core
{
	
	public class BlitzGrid 
	{
		private var isAbstract:Boolean;
		private var gridWidth:uint;
		private var gridHeight:uint;
		private var gridSize:uint;
		private var gridData:Array;
		private var rowWidth:uint;
		private var columnHeight:uint;
		
		private var gridPixelWidth:uint;
		private var gridPixelHeight:uint;
		private var cellPixelWidth:uint;
		private var cellPixelHeight:uint;
		private var finalCellPixelWidth:uint;
		private var finalCellPixelHeight:uint;
		
		/*
		 * I want people to be able to create a grid for either abstract use (non related to the stage display) or from stage values
		 * i.e. they say the stage is 550x400 and they want it split into 32x32 pixel sized chunks, it will create a grid accordingly.
		 * Or they say the stage is 550x400 and they want it split into a grid 10x10 in size.
		 * Then we can detect exact pixel placement within grid cells / rows and columns quickly.
		 * Try to sort the data properly - binary search maybe? because dividing ints is expensive.
		 * We also want to let the coder store whatever values they want inside of the grid (references to) + dispose of them too.
		 * Also quick grid fill system and other handy functions like finding out which row/col is the longest/tallest,
		 * Swap two grid cells with each other
		 * Inverse a whole row/column, inverse the whole grid
		 * Splice the grid (remove rows/cols)
		 * Resize the grid (either pixel data resize, or actual grid data resize)
		 * Allow cell items to receive events when they are moved to a new grid location?
		 * Grid Debug - generate a bitmap showing grid occupancy + trace out a neat grid plan in ASCII + maybe return in string form for quake console?
		*/
		
		public function BlitzGrid() 
		{
		}
		
		//	Create an abstract grid based on the given width and height
		public function createGrid(width:uint, height:uint)
		{
			gridWidth = width;
			gridHeight = height;
			
			gridSize = gridWidth * gridHeight;
			
			isAbstract = true;
			
			gridData = new Array();
		}
		
		//	Create grid from pixel dimensions, you supply the size in pixels and if it should over-run or fit to that
		public function createPixelGrid(pixelWidth:uint, pixelHeight:uint, cellWidth:uint, cellHeight:uint, overflow:Boolean = false):Boolean
		{
			//	Sanity checks
			if (pixelWidth == 0 || pixelHeight == 0 || cellWidth == 0 || cellHeight == 0 || cellWidth >= pixelWidth || cellHeight >= pixelHeight)
			{
				return false;
			}
			
			isAbstract = false;
			
			//	Width
			cellPixelWidth = cellWidth;
			finalCellPixelWidth = pixelWidth % cellWidth;
			gridWidth = pixelWidth / cellWidth;
			gridPixelWidth = gridWidth * cellPixelWidth;
			
			//	If "overflow" is false it means if the cell width doesn't fit equally into the grid width the final cell will be truncated, true = grid will expand
			
			//	We have a remainder, which means the total width and cell width didn't divide evenly
			if (finalCellPixelWidth > 0)
			{
				if (overflow)
				{
					//	We extend the size of the grid, the final cell is the same size as all the other cells
					gridWidth++;
					gridPixelWidth += cellPixelWidth;
				}
				else
				{
					//	The final cell is truncated and is smaller than the rest of the cells in the grid, overall grid width isn't affected
					
				}
			}
			
			//	Height
			cellPixelHeight = cellHeight;
			
		}
		
		//	Create grid from pixel dimensions, you supply the size in pixels and if it should over-run or fit to the stage
		public function createPixelGrid(pixelWidth:uint, pixelHeight:uint, rows:uint, columns:uint):Boolean
		{
			//	Sanity checks
			if (pixelWidth == 0 || pixelHeight == 0 || rows == 0 || columns == 0)
			{
				return false;
			}
		}
		
		public function storeByLocation(item:*, location:uint, overwrite:Boolean = true):Boolean
		{
			if (location > gridSize)
			{
				return false;
			}
			
			if (overwrite)
			{
				gridData[location] = item;
				return true;
			}
			else
			{
				if (gridData[location] == null)
				{
					gridData[location] = item;
					return true;
				}
				else
				{
					return false;
				}
			}
		}
		
		public function storeByCoords(item:*, x:uint, y:uint):Boolean
		{
		}
		
		public function getRowFromLocation()
		{
		}
		
		public function getColumnFromLocation()
		{
		}
		
		public function getLocationFromCoordinate(row:uint, column:uint)
		{
		}
		
		
	}
	
}