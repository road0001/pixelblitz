﻿package pixelblitz.elements{	import pixelblitz.PixelBlitz;	import pixelblitz.layers.RenderLayer;	import pixelblitz.utils.BlitzMath;	import flash.display.Bitmap;	import flash.display.BitmapData;	import flash.display.BitmapDataChannel;	import flash.display.DisplayObject;	import flash.events.EventDispatcher;	import flash.geom.Point;	import flash.geom.Rectangle;	import flash.utils.getQualifiedClassName;	/**	 * A PixelBullet is a PixelBullet object with all the features removed (such as alpha, scaling and autoscroll).	 * Use a PixelBullet when you need a really fast light-weight object that doesn't need to scale/rotate/animate (for example use it for bullets!)	 */	public dynamic class PixelBullet extends EventDispatcher	{		/**		 * @private		 */		protected const ZERO_POINT:Point = new Point();				/**		 * @private		 * The FastMath helper class instance		 */		private var bMath:BlitzMath = new BlitzMath();				/**		 * @private		 * The RenderLayer that this PixelBullet belongs to		 */		protected var _layer:RenderLayer;				/**		 * This PixelBullet instances collisiton rectangle		 */		protected var collisionRect:Rectangle = new Rectangle();				/**		 * @private		 * The horizontal position in pixels of the PixelBullet instance.		 */		private var _x:int;				/**		 * @private		 * The vertical position in pixels of the PixelBullet instance.		 */		private var _y:int;				/**		 * The width in pixels of the PixelBullet instance.		 */		public var width:int;				/**		 * The height in pixels of the PixelBullet instance.		 */		public var height:int;				/**		 * The top (Y pixel coordinate) of the PixelBullet instance.		 */		protected var top:int;				/**		 * The bottom (Y + Height pixel coordinate) of the PixelBullet instance.		 */		protected var bottom:int;				/**		 * The left (X pixel coordinate) of the PixelBullet instance.		 */		protected var left:int;				/**		 * The right (X + Width pixel coordinate) of the PixelBullet instance.		 */		protected var right:int;				/**		 * The visibility of this object (invisible objects are not processed by the renderer)		 */		public var visible:Boolean = true;				/**		 * The X coordinate of this PixelBullet instance registration point (hotspot)		 */		public var hotspotX:int = 0;				/**		 * The Y coordinate of this PixelBullet instance registration point (hotspot)		 */		public var hotspotY:int = 0;				/**		 * @private		 * The type of alignment this instance is using (default is HOTSPOT_CENTER)		 */		private var hotspotType:String;				/**		 * The BitmapData object that will be rendered to the RenderLayer		 */		public var bitmapData:BitmapData;				/**		 * The BitmapData object rect property.		 */		public var rect:Rectangle;				/**		 * @private		 * A flag holding if a region limit is in place or not		 */		private var limitEnabled:Boolean = false;				/**		 * @private		 * The x coordinate of the top-left limit region		 */		private var limitX1:int;				/**		 * @private		 * The y coordinate of the top-left limit region		 */		private var limitY1:int;				/**		 * @private		 * The x coordinate of the bottom-right limit region		 */		private var limitX2:int;				/**		 * @private		 * The y coordinate of the bottom-right limit region		 */		private var limitY2:int;				/**		 * The Hot Spot registration point constants		 */		public static const HOTSPOT_CUSTOM:String = "hotspotCustom";		public static const HOTSPOT_TOP_LEFT:String = "hotspotTopLeft";		public static const HOTSPOT_TOP_CENTER:String = "hotspotTopCenter";		public static const HOTSPOT_TOP_RIGHT:String = "hotspotTopRight";		public static const HOTSPOT_LEFT_MIDDLE:String = "hotspotLeftMiddle";		public static const HOTSPOT_CENTER:String = "hotspotCenter";		public static const HOTSPOT_RIGHT_MIDDLE:String = "hotspotRightMiddle";		public static const HOTSPOT_BOTTOM_LEFT:String = "hotspotBottomLeft";		public static const HOTSPOT_BOTTOM_CENTER:String = "hotspotBottomCenter";		public static const HOTSPOT_BOTTOM_RIGHT:String = "hotspotBottomRight";				/**		 * Creates a PixelBullet instance.		 * <p>		 * Parses the supplied DisplayObject and converts the first frame of animation to a virtual frame.		 * The DisplayObject is drawn to a bitmapData object with the width and height of the 		 * DisplayObject defining the width and height of the BitmapData object.		 * </p>		 * @param displayObject The DisplayObject instance to convert into a PixelBullet object.		 */		public function PixelBullet( displayObject:DisplayObject )		{  			parseClip( displayObject );						rect 	= bitmapData.rect;			width 	= bitmapData.width;			height 	= bitmapData.height;			x		= displayObject.x;			y		= displayObject.y;			top 	= y;			bottom 	= top + height;			left 	= x;			right 	= left + width;						hotspot(PixelBullet.HOTSPOT_CENTER);		}				/**		 * @private		 * Parses the supplied DisplayObject and converts it to a virtual frame.		 * @param displayObject The Display Object to convert.		 */		protected function parseClip( displayObject:DisplayObject ):void		{			var id:String = getQualifiedClassName( displayObject ) + "_" + 1;						//	Check if it is already in the collection (except for Bitmaps)			if ( PixelBlitz.bmdCollection.search( id ) && !displayObject is Bitmap )			{				bitmapData = PixelBlitz.bmdCollection.collection[ id ];			}			else			{				// Create a new bitmapData object to draw on				var bmd:BitmapData = new BitmapData( displayObject.width, displayObject.height, true, 0x0 );								bmd.draw( displayObject );										// Add the bitmapData to the collection				bitmapData = PixelBlitz.bmdCollection.addBitmapData( id, bmd );			}		}				/**		 * Confines this PixelBullet instance to the specified area. Direct x/y placement that would		 * force it outside of this area has no effect.		 * @param x1 The x coordinate of the top-left area corner of the limit region		 * @param y1 The y coordinate of the top-left area corner of the limit region		 * @param x2 The x coordinate of the bottom-right area corner of the limit region		 * @param y2 The y coordinate of the bottom-right area corner of the limit region		 * @return True if the limit was successfully created and enabled		 * @see removeLimit		 */		public function addLimit(x1:int, y1:int, x2:int, y2:int):Boolean		{			//	Sanity checks			if (x1 == x2 || y1 == y2)			{				return false;			}						//	Check the values			if (x1 > x2)			{				limitX1 = x2;				limitX2 = x1;			}			else			{				limitX1 = x1;				limitX2 = x2;			}						if (y1 > y2)			{				limitY1 = y2;				limitY2 = y1;			}			else			{				limitY1 = y1;				limitY2 = y2;			}						limitEnabled = true;						return true;		}				/**		 * Removes a previously set region limit. If no limit was set it has no effect.		 * @see addLimit		 */		public function removeLimit():void		{			limitEnabled = false;		}				/**		 * Returns the x coordinate of this PixelBullet instance		 * @return The x coordinate in pixels		 */		public function get x():int		{			return _x;		}				/**		 * Sets the x coordinate of this PixelBullet instance.		 * Has no effect if addLimit is enabled and the x coordinate is outside that region.		 * @param pos The x coordinate location (an int representing whole pixels)		 */		public function set x(pos:int):void		{			if (limitEnabled == false || (limitEnabled == true && pos >= limitX1 && pos <= limitX2))			{				_x = pos;			}		}				/**		 * Returns the y coordinate of this PixelBullet instance		 * @return The y coordinate in pixels		 */		public function get y():int		{			return _y;		}				/**		 * Sets the y coordinate of this PixelBullet instance.		 * Has no effect if addLimit is enabled and the y coordinate is outside that region.		 * @param pos The y coordinate location (an int representing whole pixels)		 */		public function set y(pos:int):void		{			if (limitEnabled == false || (limitEnabled == true && pos >= limitY1 && pos <= limitY2))			{				_y = pos;			}		}				/**		 * Sets the Hot Spot for this PixelBullet to one of 9 pre-defined locations		 * <p> 		 * The Hot Spot is an x-y offset measured from the top left-hand corner of the object, 		 * and is added to the real x-y coordinates prior to rendering. It is akin to the 		 * registration point of a MovieClip in the Flash IDE, and enables easy centering or aligning		 * of the object.		 * </p>		 * @param location The string representing the alignment of this object		 * @example 		 * <code>		 * // Set the registration point of this object to center top		 * player.hotspot(PixelBullet.HOTSPOT_TOP_CENTER);		 * </code>		 */		public function hotspot(location:String):void		{			hotspotType = location;						switch (location)			{				case HOTSPOT_TOP_LEFT:					hotspotX = left;					hotspotY = top;					break;									case HOTSPOT_TOP_CENTER:					hotspotX = left + (width / 2);					hotspotY = top;					break;									case HOTSPOT_TOP_RIGHT:					hotspotX = right;					hotspotY = top;					break;									case HOTSPOT_LEFT_MIDDLE:					hotspotX = left;					hotspotY = top + (height / 2);					break;									case HOTSPOT_CENTER:					hotspotX = -(left + (width / 2));					hotspotY = -(top + (height / 2));					break;									case HOTSPOT_RIGHT_MIDDLE:					hotspotX = right;					hotspotY = top + (height / 2);					break;									case HOTSPOT_BOTTOM_LEFT:					hotspotX = left;					hotspotY = bottom;					break;									case HOTSPOT_BOTTOM_CENTER:					hotspotX = left + (width / 2);					hotspotY = bottom;					break;									case HOTSPOT_BOTTOM_RIGHT:					hotspotX = right;					hotspotY = bottom;					break;									default:					hotspotType = HOTSPOT_CUSTOM;			}		}				/**		 * The true x value after the hotspot has been taken into account		 */		public function get globalX():int		{			if (hotspotX >= 0)			{				return x + hotspotX;			}			else			{				return x - Math.abs(hotspotX);			}		}				/**		 * The true y value after the hotspot has been taken into account		 */		public function get globalY():int		{			if (hotspotY >= 0)			{				return y + hotspotY;			}			else			{				return y - Math.abs(hotspotY);			}		}				/**		 * @private		 */		public function set layer( value:RenderLayer ):void		{			_layer = value;		}				/**		 * The depth or z-order of the PixelBullet instance.		 */		public function get depth():int		{			return _layer.getDepth( this );			}		/**		 * Performs a fast box based collision check against the supplied PixelBullet object.		 * <p> 		 * This is a fast bounding box collision test that will always catch the rectangular collision of 2 PixelBullet objects,		 * no matter what size or placement they have		 * </p>		 * @param object The PixelBullet instance to test against.		 * @return Returns a boolean value indicating if a collision occured.		 * @example 		 * <code>		 * if ( obj1.getBoxCollision( obj2 ) )		 * {		 * 		trace("collision occured");		 * }		 * </code>		 */		public function getBoxCollision( object:PixelBullet ):Boolean		{			if ( !( top > object.bottom || bottom < object.top || left > object.right || right < object.left ) )			{				return true;			}			else			{				return false;			}		}				/**		 * Performs a pixel-level collision check against the supplied PixelBullet object.		 * <p> 		 * This is a shape based collision test versus the standard DisplayObject bounding box <code>hitTestObject</code>.		 * The collision check compares the alpha value of each pixel. 		 * </p>		 * @param object The PixelBullet instance to test against.		 * @return Returns a boolean value indicating if a collision occured.		 * @example 		 * <code>		 * if ( obj1.getCollision( obj2 ) )		 * {		 * 		trace("collision occured");		 * }		 * </code>		 */		public function getCollision( object:PixelBullet ):Boolean		{			if ( bitmapData.hitTest( new Point(x, y), 1, object.bitmapData, new Point( object.x, object.y), 1 ) )			{				return true;			}			return false;		}				/**		 * Checks if the supplied point is inside of the PixelBullet object.		 * <p>		 * This method is useful for mouse detection where the point is the mouse x and y properties.		 * </p>		 * @param point The Point to test against.		 * @return A boolean value indicating if a collision occured.		 */		public function getCollisionPoint( point:Point ):Boolean		{			collisionRect.x = (x + PixelBlitz.camera2D.basePoint.x) * _layer.parallax;			collisionRect.y = (y + PixelBlitz.camera2D.basePoint.y) * _layer.parallax;			collisionRect.width = width;			collisionRect.height = height;						if ( collisionRect.containsPoint( point ) )			{				return true;			}						return false;		}				/**		 * Removes the PixelBullet from the RenderLayer it is registered to.		 * The dispose method also clears the internal data making it available for Garbage Collection.		 * All external references should be set to null as well to ensure it will be available for Garbage Collection.		 */		public function dispose():void		{			bitmapData = null;			_layer.removeItem( this );		}				/**		 * @private		 */		public function update():void 		{			rect 	= bitmapData.rect;			width 	= bitmapData.width;			height 	= bitmapData.height;			top 	= y;			bottom 	= y + height;			left 	= x;			right 	= x + width;		}	}}