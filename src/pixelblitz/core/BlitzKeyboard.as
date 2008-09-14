/**
* PixelBlitz Engine - BlitzKeyboard Input Class
* @author Richard Davey / Photon Storm
*/
package pixelblitz.core 
{
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.ui.KeyLocation;
	import flash.utils.getTimer;
	
	// TODO Left Key support Shift
	// TODO Cheat Mode support (i.e. a set string within a specific time frame)
	public class BlitzKeyboard extends EventDispatcher
	{
		private var keyboardDisplayObject:DisplayObject;
		private var keyboardEvents:Array;
		private var lastKeyCode:uint;
		private var lastKeyLocation:uint;
		private var isKeyDown:Boolean;
		private var keysHeldDown:uint;
		
		private var timeOfLastKeyEvent:uint;
		private var timeOfPreviousKeyEvent:uint;
		
		private var keyboardHits:Array;
		public var recordKeyHits:Boolean;
		
		private var checkKeyboardDispatchEvents:Boolean;
		private var keyboardDispatchEvents:Array;
		
		private var checkKeyboardCalls:Boolean;
		private var keyboardCalls:Array;
		
		private var keyboardPollDelay:uint;
		private var keyboardPollTimer:uint;
		
		private var waitingForKey:Boolean;
		private var waitKeyType:uint;
		private var waitKeyEvent:Event;
		public static const WAITKEY_DOWN:uint = 1;
		public static const WAITKEY_RELEASE:uint = 2;
		
		public static const A:uint = 65;
		public static const ALTERNATE:uint = 18;
		public static const APPLICATION_KEY:uint = 93;
		public static const B:uint = 66;
		public static const BACKQUOTE:uint = 192;
		public static const BACKSLASH:uint = 220;
		public static const BACKSPACE:uint = 8;
		public static const BREAK:uint = 19;
		public static const C:uint = 67;
		public static const CAPS_LOCK:uint = 20;
		public static const COMMA:uint = 188;
		public static const COMMAND:uint = 19;
		public static const CONTROL:uint = 17;
		public static const D:uint = 68;
		public static const DELETE:uint = 46;
		public static const DOWN:uint = 40;
		public static const E:uint = 69;
		public static const END:uint = 35;
		public static const ENTER:uint = 13;
		public static const EQUAL:uint = 187;
		public static const ESCAPE:uint = 27;
		public static const F:uint = 70;
		public static const F1:uint = 112;
		public static const F10:uint = 121;
		public static const F11:uint = 122;
		public static const F12:uint = 123;
		public static const F13:uint = 124;
		public static const F14:uint = 125;
		public static const F15:uint = 126;
		public static const F2:uint = 113;
		public static const F3:uint = 114;
		public static const F4:uint = 115;
		public static const F5:uint = 116;
		public static const F6:uint = 117;
		public static const F7:uint = 118;
		public static const F8:uint = 119;
		public static const F9:uint = 120;
		public static const G:uint = 71;
		public static const H:uint = 72;
		public static const HOME:uint = 36;
		public static const I:uint = 73;
		public static const INSERT:uint = 45;
		public static const J:uint = 74;
		public static const K:uint = 75;
		public static const L:uint = 76;
		public static const LEFT:uint = 37;
		public static const LEFTBRACKET:uint = 219;
		public static const M:uint = 77;
		public static const MINUS:uint = 189;
		public static const N:uint = 78;
		public static const NUMBER_0:uint = 48;
		public static const NUMBER_1:uint = 49;
		public static const NUMBER_2:uint = 50;
		public static const NUMBER_3:uint = 51;
		public static const NUMBER_4:uint = 52;
		public static const NUMBER_5:uint = 53;
		public static const NUMBER_6:uint = 54;
		public static const NUMBER_7:uint = 55;
		public static const NUMBER_8:uint = 56;
		public static const NUMBER_9:uint = 57;
		public static const NUM_LOCK:uint = 144;
		public static const NUMPAD:uint = 21;
		public static const NUMPAD_0:uint = 96;
		public static const NUMPAD_1:uint = 97;
		public static const NUMPAD_2:uint = 98;
		public static const NUMPAD_3:uint = 99;
		public static const NUMPAD_4:uint = 100;
		public static const NUMPAD_5:uint = 101;
		public static const NUMPAD_6:uint = 102;
		public static const NUMPAD_7:uint = 103;
		public static const NUMPAD_8:uint = 104;
		public static const NUMPAD_9:uint = 105;
		public static const NUMPAD_ADD:uint = 107;
		public static const NUMPAD_DECIMAL:uint = 110;
		public static const NUMPAD_DIVIDE:uint = 111;
		public static const NUMPAD_ENTER:uint = 108;
		public static const NUMPAD_MULTIPLY:uint = 106;
		public static const NUMPAD_SUBTRACT:uint = 109;
		public static const O:uint = 79;
		public static const P:uint = 80;
		public static const PAGE_DOWN:uint = 34;
		public static const PAGE_UP:uint = 33;
		public static const PERIOD:uint = 190;
		public static const PRINT_SCREEN:uint = 124;
		public static const Q:uint = 81;
		public static const QUOTE:uint = 222;
		public static const R:uint = 82;
		public static const RIGHT:uint = 39;
		public static const RIGHTBRACKET:uint = 221;
		public static const S:uint = 83;
		public static const SCROLL_LOCK:uint = 145;
		public static const SEMICOLON:uint = 186;
		public static const SHIFT:uint = 16;
		public static const SLASH:uint = 191;
		public static const SPACE:uint = 32;
		public static const T:uint = 84;
		public static const TAB:uint = 9;
		public static const U:uint = 85;
		public static const UP:uint = 38;
		public static const V:uint = 86;
		public static const W:uint = 87;
		public static const X:uint = 88;
		public static const Y:uint = 89;
		public static const Z:uint = 90;
		
		//	Keyboard location special cases
		public static const LEFT_SHIFT:uint = 1000;
		public static const RIGHT_SHIFT:uint = 1001;
		public static const LEFT_CTRL:uint = 1002;
		public static const RIGHT_CTRL:uint = 1003;
		public static const LEFT_ALT:uint = 1004;
		public static const RIGHT_ALT:uint = 1005;
		
		//	Enhanced Keyboards:
		public static const LEFT_WINDOWS_KEY:uint = 91;
		public static const RIGHT_WINDOWS_KEY:uint = 92;
		public static const ENHANCED_NEXT_TRACK:uint = 181;
		public static const ENHANCED_PREV_TRACK:uint = 182;
		public static const ENHANCED_STOP:uint = 183;
		public static const ENHANCED_PLAY_PAUSE:uint = 205;
		public static const ENHANCED_VOLUME:uint = 224;
		public static const ENHANCED_MUTE:uint = 226;
		public static const ENHANCED_BASS:uint = 227;
		public static const ENHANCED_TREBLE:uint = 228;
		public static const ENHANCED_BASS_BOOST:uint = 229;
		public static const ENHANCED_VOLUME_UP:uint = 233;
		public static const ENHANCED_VOLUME_DOWN:uint = 234;
		public static const ENHANCED_BASS_INCREASE:uint = 338;
		public static const ENHANCED_BASS_DECREASE:uint = 339;
		public static const ENHANCED_TREBLE_INCREASE:uint = 340;
		public static const ENHANCED_TREBLE_DECREASE:uint = 341;
		
		public function BlitzKeyboard():void
		{
		}
		
		/**
		 * Initialise the Keyboard Handler to listen to key events from the given display object, and optionally to 
		 * record key hits or not.
		 * @param listenObject The Display Object to listen to (to capture everything, use "stage")
		 * @param countKeyHits Set to true if you wish to count all key hits (see keyHits function)
		 */
		public function init(listenObject:DisplayObject, countKeyHits:Boolean = false):void
		{
			keyboardDisplayObject = listenObject;
			recordKeyHits = countKeyHits;
			
			//	Get everything ready
			flushKeys();
			reset(false);
		}
		
		/**
		 * Flushes out the keyboard buffer, key code, key location and waiting for key status.
		 * To remove keyboard events or function calls use reset() instead
		 * @see reset
		 */
		public function flushKeys():void
		{
			keyboardEvents = new Array();
			keyboardHits = new Array();
			
			lastKeyCode = 0;
			lastKeyLocation = 0;
			
			waitingForKey = false;
			
			isKeyDown = false;
			keysHeldDown = 0;
			
			timeOfLastKeyEvent = 0;
			timeOfPreviousKeyEvent = 0;
		}
		
		/**
		 * Removes all Keyboard Dispatch Events and Function Calls. Optionally also flushes the keyboard.
		 * @param fullReset Flush the keyboard buffer? (default: true)
		 */
		public function reset(fullReset:Boolean = true):void
		{
			if (fullReset)
			{
				flushKeys();
			}
			
			checkKeyboardDispatchEvents = false;
			keyboardDispatchEvents = new Array();
			
			checkKeyboardCalls = false;
			keyboardCalls = new Array();
		}
		
		/**
		 * Start listening for Keyboard Events from the Display Object given in init(). If the Display Object has not yet been added
		 * to the stage then this method waits until the object has been added to the stage before starting.
		 */
		public function go():void
		{
			if (keyboardDisplayObject.stage !== null)
			{
				startListeningKeyboard(new Event(Event.ADDED_TO_STAGE));
			}
			else
			{
				keyboardDisplayObject.addEventListener(Event.ADDED_TO_STAGE, startListeningKeyboard, false, 0, true);
				keyboardDisplayObject.addEventListener(Event.REMOVED_FROM_STAGE, stopListeningKeyboard, false, 0, true);
			}
		}
		
		/**
		 * Stop listening for Keyboard Events from the Display Object given in init().
		 * This method is called automatically if the display object is ever removed from the stage.
		 */
		public function stop():void
		{
			stopListeningKeyboard(new Event(Event.REMOVED_FROM_STAGE));
		}
		
		/**
		 * @private
		 * Start listening for keyboard events and sets a frame timer running
		 */
		private function startListeningKeyboard(event:Event):void
		{
			keyboardDisplayObject.addEventListener(Event.ENTER_FRAME, mainLoop, false, 0, true);
			keyboardDisplayObject.addEventListener(KeyboardEvent.KEY_DOWN, keyDownEvent, false, 0, true);
			keyboardDisplayObject.addEventListener(KeyboardEvent.KEY_UP, keyUpEvent, false, 0, true);
		}
		
		/**
		 * @private
		 * Stops listening for keyboard events and stops the frame timer running
		 */
		private function stopListeningKeyboard(event:Event):void
		{
			keyboardDisplayObject.removeEventListener(Event.ENTER_FRAME, mainLoop);
			keyboardDisplayObject.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownEvent);
			keyboardDisplayObject.removeEventListener(KeyboardEvent.KEY_UP, keyUpEvent);
		}
		
		/**
		 * @private
		 * The main loop, responsible for checking dispatch events and function calls
		 */
		private function mainLoop(event:Event):void
		{
			//	If nothing has happened since the last key event, then don't bother going any further
			if (timeOfLastKeyEvent == timeOfPreviousKeyEvent)
			{
				return;
			}
			else
			{
				timeOfPreviousKeyEvent = timeOfLastKeyEvent;
			}
			
			//	Is there a keyPoll delay active?
			if (keyboardPollDelay > 0)
			{
				if (getTimer() < keyboardPollTimer)
				{
					return;
				}
				else
				{
					keyboardPollTimer = getTimer() + keyboardPollDelay;
				}
			}
			
			if (checkKeyboardDispatchEvents)
			{
				for each (var c:Array in keyboardDispatchEvents)
				{
					//	Should fire onRelease (c[1])
					if (c[1])
					{
						//	Have we captured these keys going down yet? If so, fire the event
						if (c[2])
						{
							if (isUp(c[3], c[4], c[5]))
							{
								//	Ok the keys have been pressed and then let-up again, so dispatch the event
								dispatchEvent(c[0]);
								//	and reset the marker
								keyboardDispatchEvents[c[6]][2] = false;
							}
						}
						else
						{
							if (isDown(c[3], c[4], c[5]))
							{
								keyboardDispatchEvents[c[6]][2] = true;
							}
						}
					}
					else
					{
						//	Should fire on Key Down
						if (isDown(c[3], c[4], c[5]))
						{
							dispatchEvent(c[0]);
						}
					}
				}
			}
			
			//	Key Combo Function calls
			if (checkKeyboardCalls)
			{
				for each (var f:Array in keyboardCalls)
				{
					//	Should it fire onRelease? ([1])
					if (f[1])
					{
						//	Have we captured these keys going down yet? If so, fire the event
						if (f[2])
						{
							if (isUp(f[3], f[4], f[5]))
							{
								//	Ok the keys have been pressed and then let-up again, so call the function
								f[0].call();
								//	and reset the marker
								keyboardCalls[f[6]][2] = false;
							}
						}
						else
						{
							if (isDown(f[3], f[4], f[5]))
							{
								keyboardCalls[f[6]][2] = true;
							}
						}
					}
					else
					{
						//	Should fire on Key Down
						if (isDown(f[3], f[4], f[5]))
						{
							f[0].call();
						}
					}
				}
			}
		}
		
		/**
		 * @private
		 * The KeyboardEvent Key Down handler
		 */
		private function keyDownEvent(event:KeyboardEvent):void
		{
			keyboardEvents[event.keyCode] = true;
			isKeyDown = true;
			lastKeyCode = event.keyCode;
			lastKeyLocation = event.keyLocation;
			keysHeldDown++;
			timeOfLastKeyEvent = getTimer();
			
			//	Are we waiting for an "any key down" event?
			if (waitingForKey && waitKeyType == 1)
			{
				sendWaitKeyEvent();
			}
		}
		
		/**
		 * @private
		 * The KeyboardEvent Key Up handler
		 */
		private function keyUpEvent(event:KeyboardEvent):void
		{
			keyboardEvents[event.keyCode] = false;
			isKeyDown = false;
			lastKeyCode = 0;
			lastKeyLocation = event.keyLocation;
			keysHeldDown--;
			timeOfLastKeyEvent = getTimer();

			if (recordKeyHits)
			{
				keyboardHits[event.keyCode]++;
			}
			
			//	Are we waiting for an "any key up" event?
			if (waitingForKey && waitKeyType == 2)
			{
				sendWaitKeyEvent();
			}
		}
		
		/**
		 * The Keyboard Repeat rate (0 if not set)
		 * @return The repeat rate in ms
		 */
		public function get keyRate():uint
		{
			return keyboardPollDelay;
		}
		
		/**
		 * Set the key repeat rate in ms. This lets you limit the amount of key checks performed per loop.
		 * Note: The timing is only as accurate as Flash's getTimer() function.
		 * @param delay The time in ms to wait after a key press before registering another (1000 = 1 second)
		 */
		public function set keyRate(delay:uint):void
		{
			keyboardPollDelay = delay;
			keyboardPollTimer = 0;
		}
		
		/**
		 * Returns the number of times a key has been pressed since the last call to keyHit, then sets the value to zero.
		 * A single hit is counted when the key is released.
		 * @param keycode The key to check
		 * @return The number of hits since the last call to keyHit
		 */
		public function keyHit(keycode:uint):uint
		{
			var hitCount:uint = uint(keyboardHits[keycode]);
			
			keyboardHits[keycode] = 0;
			
			return hitCount;
		}
		
		/**
		 * Dispatches the given event when any key is pressed.
		 * @param event The event to dispatch when any key is pressed
		 * @param type Set if the event be dispatched on the keyDown (1) or keyUp (2) event
		 * @return True if set successfully, false if not
		 */
		public function waitKey(event:Event, type:uint):Boolean
		{
			if (type == 1 || type == 2)
			{
				waitingForKey = true;
				waitKeyType = type;
				return true;
			}
			else
			{
				waitingForKey = false;
				return false;
			}
		}
		
		/**
		 * @private
		 * Dispatches the "Wait for any Key" event and clears down the state
		 */
		private function sendWaitKeyEvent():void
		{
			waitingForKey = false;
			dispatchEvent(waitKeyEvent);
		}
		
		/**
		 * Returns true if all of the keys given are currently being held down. You may check for a maximum of
		 * three keys at once. Please be aware of certain keyboard limitations with regard to specific key combinations not always registering.
		 * @param keycode The keycode of the first key to check
		 * @param keycode2 The keycode of the second key to check (0 = not used)
		 * @param keycode3 The keycode of the third key to check (0 = not used)
		 * @return true if all keys are being simultaneously held down, false if not
		 */
		public function isDown(keycode:uint, keycode2:uint = 0, keycode3:uint = 0):Boolean
		{
			var result:Boolean = Boolean(keyboardEvents[keycode]);
			
			if (keycode2 > 0 && result)
			{
				result = Boolean(keyboardEvents[keycode2]);
			}
			
			if (keycode3 > 0 && result)
			{
				result = Boolean(keyboardEvents[keycode3]);
			}
			
			return result;
		}
		
		/**
		 * Returns true if all of the keys given are not pressed. You may check for a maximum of
		 * three keys at once.
		 * @param keycode The keycode of the first key to check
		 * @param keycode2 The keycode of the second key to check (0 = not used)
		 * @param keycode3 The keycode of the third key to check (0 = not used)
		 * @return true if all keys are not pressed, false if one or more of them are pressed
		 */
		public function isUp(keycode:uint, keycode2:uint = 0, keycode3:uint = 0):Boolean
		{
			var result:Boolean = Boolean(keyboardEvents[keycode]);
			
			if (keycode2 > 0 && result == false)
			{
				result = Boolean(keyboardEvents[keycode2]);
			}
			
			if (keycode3 > 0 && result == false)
			{
				result = Boolean(keyboardEvents[keycode3]);
			}
			
			if (result)
			{
				return false;
			}
			else
			{
				return true;
			}
		}
		
		/**
		 * TODO Fix so it can handle multiple events from one key combo + add event list support
		 * Registers an Event that will be dispatched every time this key (or key combination) is pressed.
		 * If you have set a Key Rate then the Event will only dispatch as often as the Key Rate allows.
		 * @param event The Event to Dispatch when the key combination is pressed
		 * @param onRelease Set to true if this Event should dispatch when the keys are released. Set to false to dispatch when the keys are held down.
		 * @param keycode The keycode of the first key to check
		 * @param keycode2 The keycode of the second key to check (0 = not used)
		 * @param keycode3 The keycode of the third key to check (0 = not used)
		 * @see removeKeyEvent
		 */
		public function addKeyEvent(event:Event, onRelease:Boolean, keycode:uint, keycode2:uint = 0, keycode3:uint = 0):void
		{
			//	Build up the array index key
			var idxkey:uint = uint(keycode.toString() + keycode2.toString() + keycode3.toString());
			
			//	Store it
			keyboardDispatchEvents[idxkey] = [ event, onRelease, false, keycode, keycode2, keycode3, idxkey ];
			
			//	Enable checking
			if (checkKeyboardDispatchEvents == false)
			{
				checkKeyboardDispatchEvents = true;
			}
		}
		
		/**
		 * Removes a Key Event previously registered by addKeyEvent.
		 * @param keycode The keycode of the first key to check
		 * @param keycode2 The keycode of the second key to check (0 = not used)
		 * @param keycode3 The keycode of the third key to check (0 = not used)
		 * @see addKeyEvent
		 */
		public function removeKeyEvent(event:Event, keycode:uint, keycode2:uint = 0, keycode3:uint = 0):void
		{
			//	Build up the array index key
			var idxkey:uint = uint(keycode.toString() + keycode2.toString() + keycode3.toString());
			
			//	Remove it
			keyboardDispatchEvents.splice(idxkey, 1);
			
			//	Anything left to check?
			if (keyboardDispatchEvents.length == 0)
			{
				checkKeyboardDispatchEvents = false;
			}
		}
		
		/**
		 * TODO Fix bug - onRelease doesn't fire properly on function calls
		 * TODO Fix so it can handle multiple functions from one key combo + add event list support
		 * Registers a Function that will be called every time this key (or key combination) is pressed.
		 * If you have set a Key Rate then the Function will only be called as often as the Key Rate allows.
		 * @param func The Function to call when the key combination is pressed
		 * @param onRelease Set to true if the function should be called when the keys are released. Set to false to call the function when the keys are held down.
		 * @param keycode The keycode of the first key to check
		 * @param keycode2 The keycode of the second key to check (0 = not used)
		 * @param keycode3 The keycode of the third key to check (0 = not used)
		 * @see removeKeyCall
		 */
		public function addKeyCall(func:Function, onRelease:Boolean, keycode:uint, keycode2:uint = 0, keycode3:uint = 0):void
		{
			//	Build up the array index key
			var idxkey:uint = uint(keycode.toString() + keycode2.toString() + keycode3.toString());
			
			//	Store it
			keyboardCalls[idxkey] = [ func, onRelease, false, keycode, keycode2, keycode3 ];
			
			//	Enable checking
			if (checkKeyboardCalls == false)
			{
				checkKeyboardCalls = true;
			}
		}
		
		/**
		 * Removes a Key Function call previously registered by addKeyCall.
		 * @param func The Function to call when the key combination is pressed
		 * @param keycode The keycode of the first key to check
		 * @param keycode2 The keycode of the second key to check (0 = not used)
		 * @param keycode3 The keycode of the third key to check (0 = not used)
		 * @see addKeyCall
		 */
		public function removeKeyCall(func:Function, keycode:uint, keycode2:uint = 0, keycode3:uint = 0):void
		{
			//	Build up the array index key
			var idxkey:uint = uint(keycode.toString() + keycode2.toString() + keycode3.toString());
			
			//	Remove it
			keyboardCalls.splice(idxkey, 1);
			
			//	Anything left to check?
			if (keyboardCalls.length == 0)
			{
				checkKeyboardCalls = false;
			}
		}
		
		/**
		 * Returns the keyCode of the most recently pressed key
		 * @return The keyCode of the last key pressed, or 0 if none
		 */
		public function get keyCode():uint
		{
			return lastKeyCode;
		}

		/**
		 * Returns the keyLocation of the most recently pressed key
		 * @return The keyLocation of the last key pressed
		 */
		public function get keyLocation():uint
		{
			return lastKeyLocation;
		}
		
		/**
		 * Returns the number of keys currently being held down
		 * @return uint
		 */
		public function get keysDown():uint
		{
			return keysHeldDown;
		}
		
		/**
		 * Returns true if any key (no matter which) is currently held down. Returns false if no keys are being held down.
		 * @return Boolean
		 */
		public function get anyKeyDown():Boolean
		{
			return isKeyDown;
		}
	}
}