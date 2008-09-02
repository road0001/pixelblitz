/**
* PixelBlitz Engine - BlitzMouse Input Class
* @author Richard Davey / Photon Storm
*/
package com.normsoule.pixelblitz.core 
{
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.utils.getTimer;
	
	public class BlitzMouse extends EventDispatcher
	{
		private var checkMouse:Boolean = false;
		private var mouseOldX:int;
		private var mouseOldY:int;
		private var mouseDistance:int;
		private var mouseXSpeed:int;
		private var mouseYSpeed:int;
		private var mouseClicks:uint;
		
		public function BlitzMouse():void
		{
		}
		
		// TODO Left Key support Shift
		public function init(listenObject:DisplayObject):void
		{
			checkMouse = true;
			
			keyboardDisplayObject = listenObject;
			//keyboardEvents = new Array();
			//keyboardHits = new Array();
			//keyboardDispatchEvents = new Array();
			//keyboardCalls = new Array();
			//checkKeyboardCalls = false;
			//checkKeyboardDispatchEvents = false;
			//isKeyDown = false;
			//waitingForKey = false;
			//keysHeldDown = 0;
			//timeOfLastKeyEvent = 0;
			//timeOfPreviousKeyEvent = 0;
			//recordKeyHits = countKeyHits;
				
			//if (listenObject.stage !== null)
			//{
				//startListeningKeyboard(new Event(Event.ADDED_TO_STAGE));
			//}
			//else
			//{
				//keyboardDisplayObject.addEventListener(Event.ADDED_TO_STAGE, startListeningKeyboard, false, 0, true);
				//keyboardDisplayObject.addEventListener(Event.REMOVED_FROM_STAGE, stopListeningKeyboard, false, 0, true);
			//}
		}
		
		private function startListening(event:Event):void
		{
		}
		
		private function stopListening():void
		{
		}
		
		private function mainLoop(event:Event):void
		{
		}
		
	}
	
}