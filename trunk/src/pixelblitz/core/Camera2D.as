package pixelblitz.core
{	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * The Camera2D class creates a virtual camera object.
	 * <p>
	 * The virtual camera calculates horizontal and vertical scrolling based on the camera target and the boundary.
	 * This class is the foundation for parallax scrolling, 
	 * the illusion that objects move slower the further away from the camera they are.
	 * </p>
	 */
	public class Camera2D
	{
		private static var instance:Camera2D;
		private static var allowInstance:Boolean;

		private var distX:int;
		private var distY:int;
		
		/**
		 * @private
		 * The amount of 'lag' that the camera uses.
		 * <p>
		 * Ideal values are between 0 and 1. A value greater than 1 will produce 
		 * the opposite effect and cause the camera to advance past the target point, which will result in abnormal scrolling.
		 * </p>
		 * @default .1
		 */
		public var ease:Number = .1;
		
		/**
		 * @private
		 * The camera target.
		 * <p>
		 * The target is the focal point that the camera follows to calculate scrolling.
		 *  This point could be mapped to the Mouse coordinates, or to a renderable object's <code>x, y</code> coordinates, or simply a Point object
		 * being manipulated in any number of ways.
		 * </p>
		 * <p>
		 * <b>Note:</b> if no target is specified scrolling will not occur.
		 * </p>
		 */
		public var target:Point;
		
		/**
		 * The resultant point of the scrolling calculation.
		 * <p>
		 * This is the global point that all renderable objects will be offset from. 
		 * The renderable object <code>x, y</code> values are not modified.
		 * </p>
		 */
		public var basePoint:Point = new Point();
		
		/**
		 * @private
		 * Defines the boundary limits for the camera.
		 * <p>
		 * The camera will not move outside of the boundary Rectangle.
		 * </p>
		 * @default a new Rectangle of the default size
		 */
		public var boundary:Rectangle = new Rectangle();
		
		/**
		 * @private
		 */
		public function Camera2D()
		{
			// singleton
			if ( !allowInstance )
			{
				throw new Error( "Camera2D is instantiated internally" );
			}
		}
		
		/**
		 * Creates the singleton Camera2D instance.
		 * 
		 * @return The singleton instance of Camera2D. 
		 */
		public static function getInstance():Camera2D
		{
			if ( !instance )
			{
				allowInstance = true;
				instance = new Camera2D();
				allowInstance = false;
			}
			return instance;
		}
		
		/**
		 * Scrolls the virtual camera based on the <code>target</code> point.
		 * <p>
		 * <b>Note:</b> if the <code>target</code> is <code>null</code> then no scrolling will occur.
		 * </p>
		 */
		public function scroll():void
		{
			if ( target )
			{
				scrollTarget();
			}
		}
		
		private function scrollTarget():void
		{	
			// horizontal
			if ( target.x < boundary.right && target.x > boundary.left )
			{
				distX = boundary.left - target.x - basePoint.x;
				basePoint.x += distX * ease;
			}
			else
			{
				if ( target.x > boundary.right )
				{
					distX = boundary.left - ( boundary.right + basePoint.x ); 
					basePoint.x += distX * ease;
				}
				 if ( target.x < boundary.left )
				{
					distX = boundary.left - ( boundary.left + basePoint.x ); 
					basePoint.x += distX * ease;
				}
			}
			// vertical
			if ( target.y < boundary.bottom && target.y > boundary.top )
			{
				distY = boundary.top - target.y - basePoint.y;
				basePoint.y += distY * ease;
			}
			else
			{
				if ( target.y > boundary.bottom )
				{
					distY = boundary.top - ( boundary.bottom + basePoint.y ); 
					basePoint.y += distY * ease;
				}
				if ( target.y < boundary.top )
				{
					distY = boundary.top - ( boundary.top + basePoint.y ); 
					basePoint.y += distY * ease;
				}
			}
		}
	}
}