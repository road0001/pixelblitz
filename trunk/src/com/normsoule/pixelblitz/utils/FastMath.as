package com.normsoule.pixelblitz.utils 
{
	/**
	 * The FastMath utility class adds a set of extremely fast (or extended) math functions to AS3
	 * <p>
	 * This class adds a selection of extremely fast (or extended) math functions
	 * </p>
	 */
	public class FastMath 
	{
		
		public function FastMath() 
		{
		}

		/**
		 * A faster version of Math.sqrt
		 * <p>
		 * Computes and returns the square root of the specified number.
		 * </p>
		 * @link http://osflash.org/as3_speed_optimizations#as3_speed_tests
		 * @param val A number greater than or equal to 0
		 * @return If the parameter val is greater than or equal to zero, a number; otherwise NaN (not a number).
		 */
		public function sqrt(val:Number):Number
		{
			if (isNaN(val))
			{
				return NaN;
			}
			
			var thresh:Number = 0.002;
			var b:Number = val * 0.25;
			var a:Number;
			var c:Number;
			
			if (val == 0)
			{
				return 0;
			}
			
			do {
				c = val / b;
				b = (b + c) * 0.5;
				a = b - c;
				if (a < 0) a = -a;
			}
			while (a > thresh);
			
			return b;
		}
		
		
		
	}
}