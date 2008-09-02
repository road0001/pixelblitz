﻿package pixelblitz.elements{	import pixelblitz.PixelBlitz;	import pixelblitz.layers.RenderLayer;	import pixelblitz.utils.BlitzMath;	import flash.display.Bitmap;	import flash.display.BitmapData;	import flash.display.BitmapDataChannel;	import flash.display.DisplayObject;	import flash.events.EventDispatcher;	import flash.geom.ColorTransform;	import flash.geom.Point;	import flash.geom.Rectangle;	import flash.geom.Matrix;	import flash.filters.ColorMatrixFilter;	import flash.utils.getQualifiedClassName;	/**	 * The PixelSprite class is the base class for all classes that	 *  can be added to a render layer and be rendered.	 * <p>	 * The PixelSprite class is very similar to the Sprite class but, in bitmap form.	 * Rotation is not currently supported.	 * </p>	 */	public dynamic class PixelSprite extends EventDispatcher	{		/**		 * @private		 */		protected const ZERO_POINT:Point = new Point();				/**		 * @private		 * The FastMath helper class instance		 */		private var bMath:BlitzMath = new BlitzMath();				/**		 * @private		 * The RenderLayer that this PixelSprite belongs to		 */		protected var _layer:RenderLayer;				/**		 * This PixelSprite instances collisiton rectangle		 */		protected var collisionRect:Rectangle = new Rectangle();				/**		 * @private		 * The horizontal position in pixels of the PixelSprite instance.		 */		private var _x:int;				/**		 * @private		 * The vertical position in pixels of the PixelSprite instance.		 */		private var _y:int;				/**		 * The width in pixels of the PixelSprite instance.		 */		public var width:int;				/**		 * The height in pixels of the PixelSprite instance.		 */		public var height:int;				/**		 * The top (Y pixel coordinate) of the PixelSprite instance.		 */		protected var top:int;				/**		 * The bottom (Y + Height pixel coordinate) of the PixelSprite instance.		 */		protected var bottom:int;				/**		 * The left (X pixel coordinate) of the PixelSprite instance.		 */		protected var left:int;				/**		 * The right (X + Width pixel coordinate) of the PixelSprite instance.		 */		protected var right:int;				/**		 * Is smoothing applied when this PixelSprite is scaled or rotated?		 */		public var smoothing:Boolean = false;				/**		 * @private		 * The horizontal scale applied to this PixelSprite instance		 */		private var _scaleX:Number = 0;				/**		 * @private		 * The vertical scale applied to this PixelSprite instance		 */		private var _scaleY:Number = 0;				/**		 * The visibility of this object (invisible objects are not processed by the renderer)		 */		public var visible:Boolean = true;				/**		 * @private		 * The alpha level of this object (objects at alpha level zero are not processed by the renderer)		 */		private var _alpha:Number = 1;				/**		 * The X coordinate of this PixelSprite instance registration point (hotspot)		 */		public var hotspotX:int = 0;				/**		 * The Y coordinate of this PixelSprite instance registration point (hotspot)		 */		public var hotspotY:int = 0;				/**		 * @private		 * The type of alignment this instance is using (default is HOTSPOT_CENTER)		 */		private var hotspotType:String;				/**		 * The BitmapData object that will be rendered to the RenderLayer		 */		public var bitmapData:BitmapData;				/**		 * @private		 * A copy of the original BitmapData object before any changes took place on it		 */		private var bitmapDataAlpha:BitmapData;				/**		 * The BitmapData object rect property.		 */		public var rect:Rectangle;				/**		 * @private		 * A flag holding if a region limit is in place or not		 */		private var limitEnabled:Boolean = false;				/**		 * @private		 * The x coordinate of the top-left limit region		 */		private var limitX1:int;				/**		 * @private		 * The y coordinate of the top-left limit region		 */		private var limitY1:int;				/**		 * @private		 * The x coordinate of the bottom-right limit region		 */		private var limitX2:int;				/**		 * @private		 * The y coordinate of the bottom-right limit region		 */		private var limitY2:int;				/**		 * TODO Moving to unique class, enabling n-way scrolling support		 * Auto Scrolling vars		 */		private var _autoscroll:Boolean = false;		private var scrollSpeed:int = 0;		private var scrollDirection:uint = 0;		private var scrollBlock:BitmapData;		private var scrollCopyRect:Rectangle;		private var scrollPasteRect:Rectangle;		private var scrollPoint:Point;		public static const SCROLL_LEFT:String = "autoScrollLeft";		public static const SCROLL_RIGHT:String = "autoScrollRight";		public static const SCROLL_UP:String = "autoScrollUp";		public static const SCROLL_DOWN:String = "autoScrollDown";				/**		 * The Hot Spot registration point constants		 */		public static const HOTSPOT_CUSTOM:String = "hotspotCustom";		public static const HOTSPOT_TOP_LEFT:String = "hotspotTopLeft";		public static const HOTSPOT_TOP_CENTER:String = "hotspotTopCenter";		public static const HOTSPOT_TOP_RIGHT:String = "hotspotTopRight";		public static const HOTSPOT_LEFT_MIDDLE:String = "hotspotLeftMiddle";		public static const HOTSPOT_CENTER:String = "hotspotCenter";		public static const HOTSPOT_RIGHT_MIDDLE:String = "hotspotRightMiddle";		public static const HOTSPOT_BOTTOM_LEFT:String = "hotspotBottomLeft";		public static const HOTSPOT_BOTTOM_CENTER:String = "hotspotBottomCenter";		public static const HOTSPOT_BOTTOM_RIGHT:String = "hotspotBottomRight";				/**		 * Creates a PixelSprite instance.		 * <p>		 * Parses the supplied DisplayObject and converts the first frame of animation to a virtual frame.		 * The DisplayObject is drawn to a bitmapData object with the width and height of the 		 * DisplayObject defining the width and height of the BitmapData object.		 * </p>		 * @param displayObject The DisplayObject instance to convert into a PixelSprite object.		 */		public function PixelSprite( displayObject:DisplayObject )		{  			parseClip( displayObject );						rect 	= bitmapData.rect;			width 	= bitmapData.width;			height 	= bitmapData.height;			x		= displayObject.x;			y		= displayObject.y;			top 	= y;			bottom 	= top + height;			left 	= x;			right 	= left + width;						hotspot(PixelSprite.HOTSPOT_CENTER);		}				/**		 * @private		 * Parses the supplied DisplayObject and converts it to a virtual frame.		 * @param displayObject The Display Object to convert.		 */		protected function parseClip( displayObject:DisplayObject ):void		{			var id:String = getQualifiedClassName( displayObject ) + "_" + 1;						//	Check if it is already in the collection (except for Bitmaps)			if ( PixelBlitz.bmdCollection.search( id ) && !displayObject is Bitmap )			{				bitmapData = PixelBlitz.bmdCollection.collection[ id ];			}			else			{				// create a new bitmapData object to draw on				var bmd:BitmapData = new BitmapData( displayObject.width, displayObject.height, true, 0x0 );								//	Does the Display Object have any scaling or rotation applied to it?				if (displayObject.scaleX != 1 || displayObject.scaleY != 1 || displayObject.rotation != 0)				{					var matrix:Matrix = new Matrix();										matrix.scale(displayObject.scaleX, displayObject.scaleY);										bmd.draw( displayObject, matrix );				}				else				{					bmd.draw( displayObject );				}										// add the bitmapData to the collection				bitmapData = PixelBlitz.bmdCollection.addBitmapData( id, bmd );			}		}				/**		 * Confines this PixelSprite instance to the specified area. Direct x/y placement that would		 * force it outside of this area has no effect.		 * @param x1 The x coordinate of the top-left area corner of the limit region		 * @param y1 The y coordinate of the top-left area corner of the limit region		 * @param x2 The x coordinate of the bottom-right area corner of the limit region		 * @param y2 The y coordinate of the bottom-right area corner of the limit region		 * @return True if the limit was successfully created and enabled		 * @see removeLimit		 */		public function addLimit(x1:int, y1:int, x2:int, y2:int):Boolean		{			//	Sanity checks			if (x1 == x2 || y1 == y2)			{				return false;			}						//	Check the values			if (x1 > x2)			{				limitX1 = x2;				limitX2 = x1;			}			else			{				limitX1 = x1;				limitX2 = x2;			}						if (y1 > y2)			{				limitY1 = y2;				limitY2 = y1;			}			else			{				limitY1 = y1;				limitY2 = y2;			}						limitEnabled = true;						return true;		}				/**		 * Removes a previously set region limit. If no limit was set it has no effect.		 * @see addLimit		 */		public function removeLimit():void		{			limitEnabled = false;		}				/**		 * Returns the x coordinate of this PixelSprite instance		 * @return The x coordinate in pixels		 */		public function get x():int		{			return _x;		}				/**		 * Sets the x coordinate of this PixelSprite instance.		 * Has no effect if addLimit is enabled and the x coordinate is outside that region.		 * @param pos The x coordinate location (an int representing whole pixels)		 */		public function set x(pos:int):void		{			if (limitEnabled == false || (limitEnabled == true && pos >= limitX1 && pos <= limitX2))			{				_x = pos;			}		}				/**		 * Returns the y coordinate of this PixelSprite instance		 * @return The y coordinate in pixels		 */		public function get y():int		{			return _y;		}				/**		 * Sets the y coordinate of this PixelSprite instance.		 * Has no effect if addLimit is enabled and the y coordinate is outside that region.		 * @param pos The y coordinate location (an int representing whole pixels)		 */		public function set y(pos:int):void		{			if (limitEnabled == false || (limitEnabled == true && pos >= limitY1 && pos <= limitY2))			{				_y = pos;			}		}				/**		 * Sets the Hot Spot for this PixelSprite to one of 9 pre-defined locations		 * <p> 		 * The Hot Spot is an x-y offset measured from the top left-hand corner of the object, 		 * and is added to the real x-y coordinates prior to rendering. It is akin to the 		 * registration point of a MovieClip in the Flash IDE, and enables easy centering or aligning		 * of the object.		 * </p>		 * @param location The string representing the alignment of this object		 * @example 		 * <code>		 * // Set the registration point of this object to center top		 * player.hotspot(PixelSprite.HOTSPOT_TOP_CENTER);		 * </code>		 */		public function hotspot(location:String):void		{			hotspotType = location;						switch (location)			{				case HOTSPOT_TOP_LEFT:					hotspotX = left;					hotspotY = top;					break;									case HOTSPOT_TOP_CENTER:					hotspotX = left + (width / 2);					hotspotY = top;					break;									case HOTSPOT_TOP_RIGHT:					hotspotX = right;					hotspotY = top;					break;									case HOTSPOT_LEFT_MIDDLE:					hotspotX = left;					hotspotY = top + (height / 2);					break;									case HOTSPOT_CENTER:					hotspotX = -(left + (width / 2));					hotspotY = -(top + (height / 2));					break;									case HOTSPOT_RIGHT_MIDDLE:					hotspotX = right;					hotspotY = top + (height / 2);					break;									case HOTSPOT_BOTTOM_LEFT:					hotspotX = left;					hotspotY = bottom;					break;									case HOTSPOT_BOTTOM_CENTER:					hotspotX = left + (width / 2);					hotspotY = bottom;					break;									case HOTSPOT_BOTTOM_RIGHT:					hotspotX = right;					hotspotY = bottom;					break;									default:					hotspotType = HOTSPOT_CUSTOM;			}		}				/**		 * The true x value after the hotspot has been taken into account		 */		public function get globalX():int		{			if (hotspotX >= 0)			{				return x + hotspotX;			}			else			{				return x - Math.abs(hotspotX);			}		}				/**		 * The true y value after the hotspot has been taken into account		 */		public function get globalY():int		{			if (hotspotY >= 0)			{				return y + hotspotY;			}			else			{				return y - Math.abs(hotspotY);			}		}				/**		 * @private		 */		public function set layer( value:RenderLayer ):void		{			_layer = value;		}				/**		 * The depth or z-order of the PixelSprite instance.		 */		public function get depth():int		{			return _layer.getDepth( this );			}		/**		 * Returns the distance (in pixels) between the two PixelSprite objects.		 * <p> 		 * This returns the distance in pixels between the X/Y of the current and given PixelSprite objects.		 * </p>		 * @param object The PixelSprite instance to test against.		 * @param round Should the resulting distance be rounded to a whole number?		 * @param fromHotSpot Is the distance calculated from the objects hot spot, or from the objects top left-hand corner coordinate		 * @return Returns a number value for the distance in pixels		 * @example 		 * <code>		 * if ( obj1.getDistance( obj2 ) < 100 )		 * {		 * 		trace("objects are within 100 pixels of each other");		 * }		 * </code>		 */		public function getDistance( object:PixelSprite, round:Boolean = true, fromHotSpot:Boolean = true ):Number		{			var dx:Number;			var dy:Number;						if (fromHotSpot)			{				dx = object.globalX - globalX;				dy = object.globalY - globalY;			}			else			{				dx = object.x - x;				dy = object.y - y;			}						var distance:Number = bMath.sqrt(dx * dx + dy * dy);						if (round)			{				return Math.round(distance);			}			else			{				return distance;			}		}				/**		 * Performs a fast box based collision check against the supplied PixelSprite object.		 * <p> 		 * This is a fast bounding box collision test that will always catch the rectangular collision of 2 PixelSprite objects,		 * no matter what size or placement they have		 * </p>		 * @param object The PixelSprite instance to test against.		 * @return Returns a boolean value indicating if a collision occured.		 * @example 		 * <code>		 * if ( obj1.getBoxCollision( obj2 ) )		 * {		 * 		trace("collision occured");		 * }		 * </code>		 */		public function getBoxCollision( object:PixelSprite ):Boolean		{			if ( !( top > object.bottom || bottom < object.top || left > object.right || right < object.left ) )			{				return true;			}			else			{				return false;			}		}				/**		 * Performs a pixel-level collision check against the supplied PixelSprite object.		 * <p> 		 * This is a shape based collision test versus the standard DisplayObject bounding box <code>hitTestObject</code>.		 * The collision check compares the alpha value of each pixel. 		 * </p>		 * @param object The PixelSprite instance to test against.		 * @return Returns a boolean value indicating if a collision occured.		 * @example 		 * <code>		 * if ( obj1.getCollision( obj2 ) )		 * {		 * 		trace("collision occured");		 * }		 * </code>		 */		public function getCollision( object:PixelSprite ):Boolean		{			if ( bitmapData.hitTest( new Point(x, y), 1, object.bitmapData, new Point( object.x, object.y), 1 ) )			{				return true;			}			return false;		}				/**		 * Checks if the supplied point is inside of the PixelSprite object.		 * <p>		 * This method is useful for mouse detection where the point is the mouse x and y properties.		 * </p>		 * @param point The Point to test against.		 * @return A boolean value indicating if a collision occured.		 */		public function getCollisionPoint( point:Point ):Boolean		{			collisionRect.x = (x + PixelBlitz.camera2D.basePoint.x) * _layer.parallax;			collisionRect.y = (y + PixelBlitz.camera2D.basePoint.y) * _layer.parallax;			collisionRect.width = width;			collisionRect.height = height;						if ( collisionRect.containsPoint( point ) )			{				return true;			}						return false;		}				/**		 * Indicates the horizontal scale (percentage) of the object as applied from the registration point.		 * @param value The amount to scale horizontally by		 * @see scaleY		 */		public function set scaleX(value:Number):void		{			if (value > 0.1)			{				scale(value, 1);			}		}				/**		 * Indicates the horizontal scale (percentage) of the object as applied from the registration point.		 * @see scaleY		 */		public function get scaleX():Number		{			return _scaleX;		}				/**		 * Indicates the vertical scale (percentage) of the object as applied from the registration point.		 * @param value The amount to scale vertically by		 * @see scaleX		 */		public function set scaleY(value:Number):void		{			if (value > 0.1)			{				scale(1, value);			}		}				/**		 * Indicates the vertical scale (percentage) of the object as applied from the registration point.		 * @see scaleX		 */		public function get scaleY():Number		{			return _scaleY;		}				/**		 * Sets the horizontal and vertical scale (percentage) of the object together, as applied from the registration point.		 * Also scales the hotSpotX and hotSpotY values by the same amount.		 * @param _sx The amount to scale horizontally by		 * @param _sy The amount to scale vertically by		 */		public function scale(sx:Number, sy:Number):void		{			if (sx <= 0 || sy <= 0)			{				return;			}						var matrix:Matrix = new Matrix();						matrix.scale(sx, sy);						//	In order to scale this object we create a temporary home for it			var scaledBitmapData:BitmapData = new BitmapData(width * sx, height * sy, true, 0x0);						scaledBitmapData.draw( bitmapData, matrix, null, null, null, smoothing );						bitmapData = scaledBitmapData.clone();						//	Copy any scale changes to the bitmapDataAlpha (if it exists)			if (bitmapDataAlpha !== null)			{				scaledBitmapData.draw( bitmapDataAlpha, matrix, null, null, null, smoothing );				bitmapDataAlpha = scaledBitmapData.clone();			}						//	We're done with the temp. version			scaledBitmapData.dispose();						//	Update this objects properties			_scaleX = sx;			_scaleY = sy;						update();						hotspotX *= sx;			hotspotY *= sy;		}				/**		 * The alpha value of the object. If the alpha is 0 the object is removed from the render pipeline.		 * @param value The alpha percentage between 0 and 1.0		 */		public function set alpha(value:Number):void		{			if (value >= 0 && value <= 1)			{				_alpha = value;								if (bitmapDataAlpha === null)				{					//	Back-up the original image					bitmapDataAlpha = new BitmapData(width, height, true, 0x0);					bitmapDataAlpha = bitmapData.clone();				}								//	Reset the image				bitmapData = bitmapDataAlpha.clone();							//	Apply the filter				bitmapData.applyFilter(bitmapData, rect, ZERO_POINT, new ColorMatrixFilter([1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, value, 0]));			}		}				/**		 * The alpha value of the object. If the alpha is 0 the object is removed from the render pipeline.		 * @param value The alpha percentage between 0 and 1.0		 */		public function get alpha():Number		{			return _alpha;		}				/**		 * Tint this object with the colours given. The amount is the intensity of the applied tint.		 * @param red The red value (0 to 255)		 * @param green The green value (0 to 255)		 * @param blue The blue value (0 to 255)		 * @param amount The tint amount (0 to 100)		 */		public function tint(red:uint, green:uint, blue:uint, amount:uint):void		{			var ctransform:ColorTransform = new ColorTransform();			var ratio:Number = amount / 100;						ctransform.redMultiplier = 1 - ratio;			ctransform.greenMultiplier = 1 - ratio;			ctransform.blueMultiplier = 1 - ratio;			ctransform.redOffset = red * ratio;			ctransform.greenOffset = green * ratio;			ctransform.blueOffset = blue * ratio;						bitmapData.colorTransform(rect, ctransform);		}				/**		 * Set this PixelSprite to automatically scroll in one of 4 directions by the specified pixel amount each frame		 * @param direction One of four directions (SCROLL_UP, SCROLL_DOWN, SCROLL_LEFT or SCROLL_RIGHT)		 * @param amount The amount to scroll by in pixels per frame		 */		public function autoScroll(direction:String, amount:uint)		{			switch (direction)			{				case SCROLL_UP:					scrollDirection = 1;					scrollSpeed = -amount;					scrollBlock = new BitmapData(width, amount, true, 0x0);					scrollCopyRect = new Rectangle(0, 0, width, amount);					scrollPasteRect = scrollBlock.rect;					scrollPoint = new Point(0, height - amount);					_autoscroll = true;					break;									case SCROLL_DOWN:					scrollDirection = 2;					scrollSpeed = amount;					scrollBlock = new BitmapData(width, amount, true, 0x0);					scrollCopyRect = new Rectangle(0, height - amount, width, amount);					scrollPasteRect = scrollBlock.rect;					scrollPoint = new Point(0, 0);					_autoscroll = true;					break;									case SCROLL_LEFT:					scrollDirection = 3;					scrollSpeed = -amount;					scrollBlock = new BitmapData(amount, height, true, 0x0);					scrollCopyRect = new Rectangle(0, 0, amount, height);					scrollPasteRect = scrollBlock.rect;					scrollPoint = new Point(width - amount, 0);					_autoscroll = true;					break;									case SCROLL_RIGHT:					scrollDirection = 4;					scrollSpeed = amount;					scrollBlock = new BitmapData(amount, height, true, 0x0);					scrollCopyRect = new Rectangle(width - amount, 0, amount, height);					scrollPasteRect = scrollBlock.rect;					scrollPoint = new Point(0, 0);					_autoscroll = true;					break;									default:					_autoscroll = false;					return;			}		}				/**		 * Stops the PixelSprite from auto scrolling (if active)		 */		public function stopAutoScroll():void		{			_autoscroll = false;		}				/**		 * Removes the PixelSprite from the RenderLayer it is registered to.		 * The dispose method also clears the internal data making it available for Garbage Collection.		 * All external references should be set to null as well to ensure it will be available for Garbage Collection.		 */		public function dispose():void		{			bitmapData = null;			_layer.removeItem( this );		}				/**		 * @private		 */		public function update():void 		{			rect 	= bitmapData.rect;			width 	= bitmapData.width;			height 	= bitmapData.height;			top 	= y;			bottom 	= y + height;			left 	= x;			right 	= x + width;						//	Is this PixelSprite scrolling?			if (_autoscroll)			{				//	Copy the region we're about to loose into the scrollBlock				scrollBlock.copyPixels(bitmapData, scrollCopyRect, ZERO_POINT);								if (scrollDirection <= 2)				{					//	Vertical scrolling					bitmapData.scroll(0, scrollSpeed);				}				else				{					//	Horizontal scrolling					bitmapData.scroll(scrollSpeed, 0);				}								//	Replace the scrolled bit				bitmapData.copyPixels(scrollBlock, scrollPasteRect, scrollPoint);			}		}	}}