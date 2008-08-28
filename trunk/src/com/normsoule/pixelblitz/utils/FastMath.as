﻿package com.normsoule.pixelblitz.utils 
{
	/**
	 * The FastMath utility class adds a set of extremely fast (or extended) math functions to AS3
	 * <p>
	 * This class adds a selection of extremely fast (or extended) math functions
	 * </p>
	 */
	public class FastMath 
	{
		private static const RADTODEG:Number = 180 / Math.PI;
		private static const DEGTORAD:Number = Math.PI / 180;
		
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
		
		/**
		 * Converts a Radian value into a Degree
		 * <p>
		 * Converts the radians value into degrees and returns
		 * </p>
		 * @param radians The value in radians
		 * @return Number Degrees
		 */
		public function asDegrees( radians:Number ):Number
		{
			return radians * RADTODEG;
		}
		
		/**
		 * Converts a Degrees value into a Radian
		 * <p>
		 * Converts the degrees value into radians and returns
		 * </p>
		 * @param degrees The value in degrees
		 * @return Number Radians
		 */
		public function asRadians( degrees:Number ):Number
		{
			return degrees * DEGTORAD;
		}
		
		
	}
}