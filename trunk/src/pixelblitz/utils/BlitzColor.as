/**
* PixelBlitz Engine - BlitzColor
* @link http://www.pixelblitz.org
* @author Richard Davey / Photon Storm
*/

package pixelblitz.utils 
{
	
	/**
	 * The BlitzColor utility class adds a set of fast color manipulation specific functions
	 */
	public class BlitzColor 
	{
		
		public function BlitzColor():void
		{
		}

		public function getColor32(var alpha:uint, var red:uint, var green:uint, var blue:uint):uint
		{
			return alpha << 24 | red << 16 | green << 8 | blue;
		}
		
		public function getColor24(var red:uint, var green:uint, var blue:uint):uint
		{
			return red << 16 | green << 8 | blue;
		}
		
		public function getARGB(color:uint):Array
		{
			var alpha:uint = color >>> 24;
			var red:uint = color >> 16;
			var green:uint = color >> 8 & 0xFF;
			var blue:uint = color & 0xFF;
			
			return [ alpha, red, green, blue ];
		}
		
		public function getRGB(color:uint):Array
		{
			var red:uint = color >> 16;
			var green:uint = color >> 8 & 0xFF;
			var blue:uint = color & 0xFF;
			
			return [ red, green, blue ];
		}
		
		public function getAlpha(color:uint):uint
		{
			return color >>> 24;
		}
		
		public function getRed(color:uint):uint
		{
			return color >> 16;
		}
		
		public function getGreen(color:uint):uint
		{
			return color >> 8 & 0xFF;
		}
		
		public function getBlue(color:uint):uint
		{
			return color & 0xFF;
		}
	}
	
}