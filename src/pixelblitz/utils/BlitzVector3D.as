/**
* PixelBlitz Engine - BlitzVector3D
* @link http://www.pixelblitz.org
* @author Richard Davey / Photon Storm
*/

package pixelblitz.utils 
{
	
	//	This whole class is experimental and work in progress
	
	public class BlitzVector3D extends Object
	{
		private var currentX:Number;
		private var currentY:Number;
		private var currentZ:Number;
		
		private var oldX:Number;
		private var oldY:Number;
		private var oldZ:Number;
		
		public function BlitzVector3D(x:Number, y:Number, z:Number):void
		{
			currentX = x;
			currentY = y;
			currentZ = z;
		}
		
		//	An easy way to set all the values of this vector at once
		public function reset(x:Number, y:Number, z:Number):void
		{
			currentX = x;
			currentY = y;
			currentZ = z;
			oldX = x;
			oldY = y;
			oldZ = z;
		}
		
		public function set x(value:Number):void
		{
			oldX = currentX;
			currentX = value;
		}
		
		public function set y(value:Number):void
		{
			oldY = currentY;
			currentY = value;
		}
		
		public function set z(value:Number):void
		{
			oldZ = currentZ;
			currentZ = value;
		}
		
		public function get x():Number
		{
			return currentX;
		}
		
		public function get y():Number
		{
			return currentY;
		}
		
		public function get z():Number
		{
			return currentZ;
		}
		
		public function zero():void
		{
			currentX = 0;
			currentY = 0;
			currentZ = 0;
			oldX = 0;
			oldY = 0;
			oldZ = 0;
		}
		
		public function normalise()
		{
			var magSq:Number = (currentX * currentX) + (currentY * currentY) + (currentZ * currentZ);
			
			if (magSq > 0)
			{
				var oneOverMag:Number = 1 / Math.sqrt(magSq);
				
				currentX *= oneOverMag;
				currentY *= oneOverMag;
				currentZ *= oneOverMag;
			}
		}
		
		public function dotProductFromVector(vector:BlitzVector3D):Number
		{
			return (currentX * vector.x) + (currentY * vector.y) + (currentZ * vector.z);
		}
		
		public function dotProductFromScalar(nx:Number, ny:Number, nz:Number):Number
		{
			return (currentX * nx) + (currentY * ny) + (currentZ * nz);
		}
		
		public function get magnitude():Number
		{
			return Math.sqrt((currentX * currentX) + (currentY * currentY) + (currentZ * currentZ));
		}
		
		public function getDistanceToVector(vector:BlitzVector3D):Number
		{
			var dx:Number = currentX - vector.x;
			var dy:Number = currentY - vector.y;
			var dz:Number = currentZ - vector.z;
			
			return Math.sqrt((dx * dx) + (dy * dy) + (dz * dz));
		}
		
	}
	
}