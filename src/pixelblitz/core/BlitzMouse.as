/**
* PixelBlitz Engine - BlitzMouse Input Class
* @author Richard Davey / Photon Storm
*/
package pixelblitz.core 
{
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import flash.ui.Mouse;
	import pixelblitz.utils.BlitzMath;
	
	public class BlitzMouse extends EventDispatcher
	{
		private var bMath:BlitzMath = new BlitzMath();
		
		private var mouseDisplayObject:DisplayObject;
		public var angleCenterX:uint;
		public var angleCenterY:uint;
		private var checkMouse:Boolean = false;
		private var _mouseDown:Boolean;
		
		private var trackMouse:Boolean;
		private var mouseOverStage:Boolean;
		private var mouseStationary:Boolean;
		private var mouseHidden:Boolean;
		private var mouseMovingUp:Boolean;
		private var mouseMovingDown:Boolean;
		private var mouseMovingLeft:Boolean;
		private var mouseMovingRight:Boolean;
		private var mouseOldX:int;
		private var mouseOldY:int;
		private var mouseDistanceX:int;
		private var mouseDistanceY:int;
		private var mouseSpeed:Number;
		private var mouseXSpeed:Number;
		private var mouseYSpeed:Number;
		
		private var mouseLimited:Boolean;
		private var mouseWithinLimit:Boolean;
		private var mouseLimitAutohideCustom:Boolean;
		private var mouseLimitAutohideStandard:Boolean;
		private var limitX1:int;
		private var limitY1:int;
		private var limitX2:int;
		private var limitY2:int;
		public var allowMoveUp:Boolean;
		public var allowMoveDown:Boolean;
		public var allowMoveLeft:Boolean;
		public var allowMoveRight:Boolean;
		public var allowHorizontalJumpback:Boolean;
		public var allowVerticalJumpback:Boolean;
		
		private var timeOfMouseDown:int;
		private var timeOfMouseUp:int;
		private var durationOfMouseClick:int;
		public var doubleClickRate:uint;
		
		private var recordClicks:Boolean = false;
		private var recordOnRelease:Boolean;
		private var recordClicksCounter:uint;
		
		private var recordLocation:Boolean = false;
		private var mouseLocations:Array;
		private var recordLocationMax:uint;
		
		//	Custom mouse pointers
		private var useCustomPointer:Boolean;
		private var mousePointer:DisplayObject;
		private var pointerOffsetX:int;
		private var pointerOffsetY:int;
		
		public function BlitzMouse():void
		{
		}
		
		public function init(listenObject:DisplayObject, enableTracking:Boolean = true):void
		{
			checkMouse = true;
			_mouseDown = false;
			mouseHidden = false;
			mouseOverStage = false;
			
			//	Allow mouse to move anywhere by default ...
			removeMovementLimits();
			
			mouseDisplayObject = listenObject;
			
			trackMouse = enableTracking;
				
			if (mouseDisplayObject.stage !== null)
			{
				startListening(new Event(Event.ADDED_TO_STAGE));
			}
			else
			{
				mouseDisplayObject.addEventListener(Event.ADDED_TO_STAGE, startListening, false, 0, true);
				mouseDisplayObject.addEventListener(Event.REMOVED_FROM_STAGE, stopListening, false, 0, true);
			}
		}
		
		public function addClickCounter(countOnRelease:Boolean = false):void
		{
			recordClicks = true;
			recordOnRelease = countOnRelease;
			recordClicksCounter = 0;
		}
		
		public function get mouseClicks():uint
		{
			var count:uint = recordClicksCounter;
			
			recordClicksCounter = 0;
			
			return count;
		}
		
		public function removeClickCounter():void
		{
			recordClicks = false;
		}
		
		private function startListening(event:Event):void
		{
			angleCenterX = mouseDisplayObject.stage.stageWidth / 2;
			angleCenterY = mouseDisplayObject.stage.stageHeight / 2;
			
			mouseDisplayObject.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown, false, 0, true);
			mouseDisplayObject.addEventListener(MouseEvent.MOUSE_UP, mouseUp, false, 0, true);
			mouseDisplayObject.addEventListener(MouseEvent.MOUSE_MOVE, mouseEnter, false, 0, true);
			mouseDisplayObject.addEventListener(Event.MOUSE_LEAVE, mouseLeave, false, 0, true);
			
			//	We don't start the enter frame here incase the mouse isn't over our game when it loads, we'll let mouseEnter pick that up
		}
		
		private function mouseEnter(event:MouseEvent):void
		{
			if (mouseOverStage == false)
			{
				mouseOverStage = true;
				mouseOldX = mouseDisplayObject.mouseX;
				mouseOldY = mouseDisplayObject.mouseY;
				startTrackingMouse();
			}
		}
		
		public function limitMovement(up:Boolean, down:Boolean, left:Boolean, right:Boolean):void
		{
			allowMoveUp = up;
			allowMoveDown = down;
			allowMoveLeft = left;
			allowMoveRight = right;
		}
		
		public function removeMovementLimits():void
		{
			allowMoveUp = true;
			allowMoveDown = true;
			allowMoveLeft = true;
			allowMoveRight = true;
			allowHorizontalJumpback = true;
			allowVerticalJumpback = true;
		}
		
		private function mouseLeave(event:Event):void
		{
			mouseOverStage = false;
			
			stopTrackingMouse();
		}
		
		public function startTrackingMouse():void
		{
			mouseDisplayObject.addEventListener(Event.ENTER_FRAME, mainLoop, false, 0, true);
		}
		
		public function stopTrackingMouse():void
		{
			mouseDisplayObject.removeEventListener(Event.ENTER_FRAME, mainLoop);
		}
		
		private function mouseDown(event:MouseEvent):void
		{
			_mouseDown = true;
			
			timeOfMouseDown = getTimer();
			
			if (recordClicks && recordOnRelease == false)
			{
				recordClicksCounter++;
			}
		}
		
		private function mouseUp(event:MouseEvent):void
		{
			_mouseDown = false;
			
			timeOfMouseUp = getTimer();
			
			if (recordClicks && recordOnRelease)
			{
				recordClicksCounter++;
			}
		}
		
		public function limit(zone:Rectangle, autoHideCustom:Boolean = true, autoHideStandard:Boolean = false):void
		{
			limitX1 = zone.x
			limitY1 = zone.y;
			limitX2 = zone.right;
			limitY2 = zone.bottom;
			
			mouseLimited = true;
			mouseLimitAutohideCustom = autoHideCustom;
			mouseLimitAutohideStandard = autoHideStandard;
		}
		
		public function removeLimit():void
		{
			mouseLimited = false;
		}
		
		public function changePointer(pointer:DisplayObject, offsetX:int = 0, offsetY:int = 0):void
		{
			useCustomPointer = true;
			
			mousePointer = pointer;
			
			pointerOffsetX = offsetX;
			pointerOffsetY = offsetY;
			
			hide();
			
			//	Why do this? It stops the pointer being stuck on the stage incase the mouse isn't over it
			//mousePointer.visible = false;
		}
		
		public function hideCustomPointer():void
		{
			useCustomPointer = false;
			
			show();
		}
		
		private function checkWithinLimit(x:int, y:int):Boolean
		{
			if ((x < limitX1 || x > limitX2) || (y < limitY1 || y > limitY2))
			{
				mouseWithinLimit = false;
				
				//	Using a custom pointer
				if (useCustomPointer && mouseLimitAutohideCustom && mousePointer.visible == true)
				{
					mousePointer.visible = false;
				}
				
				//	Is the standard mouse outisde the limit? If autohide is on, we should hide it
				if (mouseLimitAutohideStandard)
				{
					if (mouseHidden == false)
					{
						hide();
					}
				}
				else
				{
					//	Otherwise we should show it again ...
					if (mouseHidden)
					{
						show();
					}
				}
				
				return false;
			}
			else
			{
				mouseWithinLimit = true;
				
				if (useCustomPointer)
				{
					if (mousePointer.visible == false)
					{
						mousePointer.visible = true;
						hide();
					}
				}
				else
				{
					if (mouseHidden)
					{
						show();
					}
				}

				return true;
			}
		}
		
		private function stopListening():void
		{
			mouseDisplayObject.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			mouseDisplayObject.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}
		
		public function set trackLocation(state:Boolean)
		{
			trackMouse = state;
		}
		
		public function show():void
		{
			Mouse.show();
			
			mouseHidden = false;
		}
		
		public function hide():void
		{
			Mouse.hide();
			
			mouseHidden = true;
		}
		
		private function mainLoop(event:Event):void
		{
			mouseStationary = true;
			mouseMovingUp = false;
			mouseMovingDown = false;
			mouseMovingLeft = false;
			mouseMovingRight = false;
			
			var newX:int = mouseDisplayObject.mouseX;
			var newY:int = mouseDisplayObject.mouseY;
			
			//	Has the mouse been limted to a global zone? If so check here
			if (mouseLimited)
			{
				checkWithinLimit(newX, newY);
			}
			
			//	There's no need to do all of this if the user doesn't need it ...
			if (trackMouse)
			{
				//	Has it moved left / right ?
				if (newX != mouseOldX)
				{
					if (newX < mouseOldX)
					{
						//	The mouse has moved to the left
						mouseMovingLeft = true;
						mouseDistanceX = mouseOldX - newX;
						mouseXSpeed = mouseDistanceX / mouseDisplayObject.stage.frameRate;
					}
					else
					{
						//	The mouse has moved to the right
						mouseMovingRight = true;
						mouseDistanceX = newX - mouseOldX;
						mouseXSpeed = mouseDistanceX / mouseDisplayObject.stage.frameRate;
					}
					
					mouseStationary = false;
					mouseOldX = newX;
					
					//	Do we update the custom pointer?
					if (useCustomPointer)
					{
						if (allowMoveLeft && mouseMovingLeft)
						{
							if ((allowHorizontalJumpback == false && newX < mousePointer.x) || allowHorizontalJumpback)
							{
								mousePointer.x = newX + pointerOffsetX;
							}
						}
						else if (allowMoveRight && mouseMovingRight && (allowHorizontalJumpback == false && newX > mousePointer.x))
						{
							if ((allowHorizontalJumpback == false && newX > mousePointer.x) || allowHorizontalJumpback)
							{
								mousePointer.x = newX + pointerOffsetX;
							}
						}
						else if (allowMoveLeft && allowMoveRight)
						{
							mousePointer.x = newX + pointerOffsetX;
						}
					}
				}
				else
				{
					mouseXSpeed = 0;
					mouseDistanceX = 0;
				}
				
				//	Has it moved up / down ?
				if (newY != mouseOldY)
				{
					if (newY < mouseOldY)
					{
						//	The mouse has moved up
						mouseMovingUp = true;
						mouseDistanceY = mouseOldY - newY;
						mouseYSpeed = mouseDistanceY / mouseDisplayObject.stage.frameRate;
					}
					else
					{
						//	The mouse has moved down
						mouseMovingDown = true;
						mouseDistanceY = newY - mouseOldY;
						mouseYSpeed = mouseDistanceY / mouseDisplayObject.stage.frameRate;
					}
					
					mouseStationary = false;
					mouseOldY = newY;
						
					//	Do we update the custom pointer?
					if (useCustomPointer)
					{
						if (allowMoveUp && mouseMovingUp)
						{
							if ((allowVerticalJumpback == false && newY < mousePointer.y) || allowVerticalJumpback)
							{
								mousePointer.y = newY + pointerOffsetY;
							}
						}
						else if (allowMoveDown && mouseMovingDown && newY > mousePointer.y)
						{
							if ((allowVerticalJumpback == false && newY > mousePointer.y) || allowVerticalJumpback)
							{
								mousePointer.y = newY + pointerOffsetY;
							}
						}
						else if (allowMoveUp && allowMoveDown)
						{
							mousePointer.y = newY + pointerOffsetY;
						}
					}
				}
				else
				{
					mouseYSpeed = 0;
					mouseDistanceY = 0;
				}
			}
		}
		
		public function get speed():Number
		{
			return bMath.sqrt(mouseDistanceX * mouseDistanceX + mouseDistanceY * mouseDistanceY);
		}
		
		public function get speedX():Number
		{
			return mouseXSpeed;
		}
		
		public function get speedY():Number
		{
			return mouseYSpeed;
		}
		
		public function get isDown():Boolean
		{
			return _mouseDown;
		}
		
		public function get isUp():Boolean
		{
			if (_mouseDown)
			{
				return false;
			}
			else
			{
				return true;
			}
		}
		
		public function get clickDuration():uint
		{
			//	This may not be used often, so no need to calculate within the mouseUp event itself, do it here instead
			durationOfMouseClick = timeOfMouseUp - timeOfMouseDown;
			
			return durationOfMouseClick;
		}
		
		// TODO Needs coding :)
		public function get wasDoubleClick():Boolean
		{
			return false;
		}
		
		/**
		 * Returns the distance (in pixels) between the display object and the mouse.
		 * <p> 
		 * This returns the distance in pixels between the X/Y of the display object and the mouse.
		 * </p>
		 * @param object The Display Object to test against.
		 * @param round Should the resulting distance be rounded to a whole number?
		 * @return Returns a number value for the distance in pixels
		 * @example 
		 * <code>
		 * if ( mouse.distanceToObject( targetObj ) < 100 )
		 * {
		 * 		trace("Mouse is within 100 pixels of target");
		 * }
		 * </code>
		 */
		public function distanceToObject(displayObject:DisplayObject, round:Boolean = true):Number
		{
			var dx:Number = displayObject.x - mouseOldX;
			var dy:Number = displayObject.y - mouseOldY;
			
			var distance:Number = bMath.sqrt(dx * dx + dy * dy);
			
			if (round)
			{
				return Math.round(distance);
			}
			else
			{
				return distance;
			}
		}
		
		public function angle(asDegrees:Boolean = true, lowerAccuracy:Boolean = false):Number
		{
			var angle:Number;
			
			if (lowerAccuracy)
			{
				angle = bMath.atan2(mouseOldY - angleCenterY, mouseOldX - angleCenterX);
			}
			else
			{
				angle = Math.atan2(mouseOldY - angleCenterY, mouseOldX - angleCenterX);
			}
			
			if (asDegrees)
			{
				return bMath.asDegrees(angle);
			}
			else
			{
				return angle;
			}
		}
		
		public function angleToObject(displayObject:DisplayObject, asDegrees:Boolean = true, lowerAccuracy:Boolean = false):Number
		{
			var angle:Number;
			
			if (lowerAccuracy)
			{
				angle = bMath.atan2(mouseOldY - displayObject.y, mouseOldX - displayObject.x);
			}
			else
			{
				angle = Math.atan2(mouseOldY - displayObject.y, mouseOldX - displayObject.x);
			}
			
			if (asDegrees)
			{
				return bMath.asDegrees(angle);
			}
			else
			{
				return angle;
			}
		}
		
		public function get distanceX():int
		{
			return mouseDistanceX;
		}
		
		public function get distanceY():int
		{
			return mouseDistanceY;
		}
		
		public function get X():int
		{
			return mouseOldX;
		}
		
		public function get Y():int
		{
			return mouseOldY;
		}
		
		public function get isMovingLeft():Boolean
		{
			return mouseMovingLeft;
		}
		
		public function get isMovingRight():Boolean
		{
			return mouseMovingRight;
		}
		
		public function get isMovingUp():Boolean
		{
			return mouseMovingUp;
		}
		
		public function get isMovingDown():Boolean
		{
			return mouseMovingDown;
		}
		
		public function get isStationary():Boolean
		{
			return mouseStationary;
		}
		
		public function get isOverStage():Boolean
		{
			return mouseOverStage;
		}
		
		public function get isWithinLimit():Boolean
		{
			return mouseWithinLimit;
		}
	}
	
}