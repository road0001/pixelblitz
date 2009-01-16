/**
* PixelBlitz Engine - World Manager
* @author Richard Davey / Photon Storm
*/

package pixelblitz.core 
{
	import flash.events.EventDispatcher;
	
	public class World 
	{
		public var id:String;
		public var name:String;
		private var worldWidth:uint;
		private var worldHeight:uint;
		private var viewportX:uint;
		private var viewportY:uint;
		private var viewportWidth:uint;
		private var viewportHeight:uint;
		private var worldObjects:Array;
		
		public function World() extends EventDispatcher
		{
		}
		
		public function init(width:uint, height:uint):void
		{
			worldObjects = new Array();
			
			if (width > 0)
			{
				worldWidth = width;
			}
			
			if (height > 0)
			{
				worldHeight = height;
			}
		}
		
		public function addObject():void
		{
			
		}
		
		public function get width():uint
		{
			return worldWidth;
		}
		
		public function get height():uint
		{
			return worldHeight;
		}
	}
}