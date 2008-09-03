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

        public function colorToHSL(color:uint):Array
        {
			var rgb:Array = getRGB(color);
			
			return toHSL(rgb[0], rgb[1], rgb[2]);
        }
		
        public function RGBToHSL(red:uint, green:uint, blue:uint):Array
        {
			return toHSL(red, green, blue);
        }
		
		private function toHSL(r:uint, g:uint, b:uint):Array
		{
			var red:Number = r / 255;
			var green:Number = g / 255;
			var blue:Number = b / 255;
			
			var min:Number = Math.min(red, green, blue);
            var max:Number = Math.max(red, green, blue);
            var delta:Number = max - min;
            var lightness:Number = (max + min) / 2;
			var hue:Number;
			var saturation:Number;
			
            //  Grey colour, no chroma
            if (delta == 0)
            {
                hue = 0;
                saturation = 0;
            }
            else
            {
                if (lightness < 0.5)
                {
                    saturation = delta / (max + min);
                }
                else
                {
                    saturation = delta / (2 - max - min);
                }
                
                var delta_r:Number = (((max - red) / 6) + (delta / 2)) / delta;
                var delta_g:Number = (((max - green) / 6) + (delta / 2)) / delta;
                var delta_b:Number = (((max - blue) / 6) + (delta / 2)) / delta;
                
                if (red == max)
                {
                    hue = delta_b - delta_g;
                }
                else if (green == max)
                {
                    hue = (1 / 3) + delta_r - delta_b;
                }
                else if (blue == max)
                {
                    hue = (2 / 3) + delta_g - delta_r;
                }
                
                if (hue < 0)
                {
                    hue += 1;
                }
                
                if (hue > 1)
                {
                    hue -= 1;
                }
            }
            
            return [hue, saturation, lightness];
		}
		
        public function interpolateColor(color:uint, r2:uint, g2:uint, b2:uint, steps:uint, currentStep:uint):uint
        {
			var src:Array = getRGB(color);
			
            var r:uint = (((r2 - src[0]) * currentStep) / steps) + src[0];
            var g:uint = (((g2 - src[1]) * currentStep) / steps) + src[1];
            var b:uint = (((b2 - src[2]) * currentStep) / steps) + src[2];
        
			return getColor24(r, g, b);
        }
		
        public function interpolateRGB(r1:uint, g1:uint, b1:uint, r2:uint, g2:uint, b2:uint, steps:uint, currentStep:uint):uint
        {
            var r:uint = (((r2 - r1) * currentStep) / steps) + r1;
            var g:uint = (((g2 - g1) * currentStep) / steps) + g1;
            var b:uint = (((b2 - b1) * currentStep) / steps) + b1;
        
			return getColor24(r, g, b);
        }
		
		public function getColor32(alpha:uint, red:uint, green:uint, blue:uint):uint
		{
			return alpha << 24 | red << 16 | green << 8 | blue;
		}
		
		public function getColor24(red:uint, green:uint, blue:uint):uint
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