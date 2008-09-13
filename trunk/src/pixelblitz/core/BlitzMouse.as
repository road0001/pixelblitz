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
	import flash.utils.getTimer;
	import flash.ui.Mouse;
	import pixelblitz.utils.BlitzMath;
	
	public class BlitzMouse extends EventDispatcher
	{
		private var bMath:BlitzMath = new BlitzMath();
		
		private var mouseDisplayObject:DisplayObject;
		private var checkMouse:Boolean = false;
		private var _mouseDown:Boolean;
		
		private var trackMouse:Boolean;
		private var mouseStationary:Boolean;
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
		
		private var timeOfMouseDown:int;
		private var timeOfMouseUp:int;
		private var durationOfMouseClick:int;
		
		private var recordClicks:Boolean = false;
		private var recordOnRelease:Boolean;
		private var recordClicksCounter:uint;
		
		private var recordLocation:Boolean = false;
		private var mouseLocations:Array;
		private var recordLocationMax:uint;
		
		public function BlitzMouse():void
		{
		}
		
		// TODO Left Key support Shift
		public function init(listenObject:DisplayObject):void
		{
			checkMouse = true;
			_mouseDown = false;
			mouseDisplayObject = listenObject;
				
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
			mouseDisplayObject.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown, false, 0, true);
			mouseDisplayObject.addEventListener(MouseEvent.MOUSE_UP, mouseUp, false, 0, true);
			mouseDisplayObject.addEventListener(Event.ENTER_FRAME, mainLoop, false, 0, true);
			trackMouse = true;
		}
		
		public function startTrackingMouse():void
		{
			mouseDisplayObject.addEventListener(Event.ENTER_FRAME, mainLoop, false, 0, true);
			trackMouse = false;
		}
		
		public function stopTrackingMouse():void
		{
			mouseDisplayObject.removeEventListener(Event.ENTER_FRAME, mainLoop);
			trackMouse = true;
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
		
		public function get clickDuration():uint
		{
			//	This may not be used often, so no need to calculate within the mouseUp event itself, do it here instead
			durationOfMouseClick = timeOfMouseUp - timeOfMouseDown;
			
			return durationOfMouseClick;
		}
		
		private function stopListening():void
		{
			mouseDisplayObject.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			mouseDisplayObject.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}
		
		public function set trackLocation(state:Boolean)
		{
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
			
			//	Has it moved left / right ?
			if (newX != mouseOldX)
			{
				mouseStationary = false;
				
				if (newX < mouseOldX)
				{
					//	Moved to the left
					mouseMovingLeft = true;
					mouseDistanceX = mouseOldX - newX;
				}
				else
				{
					//	Moved to the right
					mouseMovingRight = true;
					mouseDistanceX = newX - mouseOldX;
				}
				
				mouseXSpeed = mouseDistanceX / mouseDisplayObject.stage.frameRate;
				
				mouseOldX = newX;
			}
			else
			{
				mouseXSpeed = 0;
				mouseDistanceX = 0;
			}
			
			//	Has it moved up / down ?
			if (newY != mouseOldY)
			{
				mouseStationary = false;
				
				if (newY < mouseOldY)
				{
					//	Moved up
					mouseMovingUp = true;
					mouseDistanceY = mouseOldY - newY;
				}
				else
				{
					//	Moved down
					mouseMovingDown = true;
					mouseDistanceY = newY - mouseOldY;
				}
				
				//	Wrong - don't know when the last time this fired was
				mouseYSpeed = mouseDistanceY / mouseDisplayObject.stage.frameRate;
				
				mouseOldY = newY;
			}
			else
			{
				mouseYSpeed = 0;
				mouseDistanceY = 0;
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
		
	}
	
}