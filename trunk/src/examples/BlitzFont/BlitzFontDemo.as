/**
* PixelBlitz - BlitzFont Demo
* @author Richard Davey / Photon Storm (rich@photonstorm.com)
*/

package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.display.Sprite;
	import fl.motion.easing.Elastic;
	import fl.motion.easing.Bounce;
	import gs.TweenLite;
	import pixelblitz.utils.BlitzFont;
	
	public class BlitzFontDemo extends Sprite
	{
		private var font:BlitzFont = new BlitzFont();
		private var font2:BlitzFont = new BlitzFont();
		
		private var text:Bitmap;
		private var scroller:Bitmap;
		
		public static const RND_SCROLLER_Y:String = "randomScrollerY";
		
		public function BlitzFontDemo():void
		{
			
			//	Pick a random font for the drop-down text
			//	These fonts are all in the FLA file with linkage set accordingly, uncomment one to see it in action
			
			switch (int(Math.random() * 8))
			{
				case 0:
					font.init(new tskFontBD(0, 0), 32, 25, "ABCDEFGHIJKLMNOPQRSTUVWXYZ!?{}.:-,'0123456789", 10);
					break;
					
				case 1:
					font.init(new deltaforceFontBD(0, 0), 16, 16, BlitzFont.SET4 + ".:;!?\"'()^-,/abcdefghij", 20, 0, 1);
					break;
					
				case 2:
					font.init(new naosFontBD(0, 0), 31, 32, BlitzFont.SET10 + "4()!45789", 6, 16, 1);
					break;
					
				case 3:
					font.init(new spazTLBFontBD(0, 0), 32, 32, BlitzFont.SET11 + "#", 9, 1, 1);
					break;
					
				case 4:
					font.init(new knighthawksFontBD(0, 0), 31, 25, BlitzFont.SET2, 10, 1, 0);
					break;
					
				case 5:
					font.init(new tbjFontBD(0, 0), 32, 32, BlitzFont.SET10 + " 1234567890,.:'-<>!", 9, 2, 2, 1, 1);
					break;
					
				case 6:
					font.init(new goldFontBD(0, 0), 16, 16, "!     :() ,?." + BlitzFont.SET10, 20);
					break;
					
				case 7:
					font.init(new bluepinkFontBD(0, 0), 32, 32, BlitzFont.SET2, 10);
					break;
					
				case 8:
					font.init(new bubblesFontBD(0, 0), 32, 32, " FLRX!AGMSY?BHNTZ-CIOU. DJPV, EKQW' ", 6);
					break;
			}
			
			//	The font for the scroll text
			font2.init(new spazTLBFontBD(0, 0), 32, 32, BlitzFont.SET11 + "#", 9, 1, 1);
			
			//	Create an image from the first font
			var welcome:Bitmap = new Bitmap(font.getMultiLine("welcome to the\npixelblitz\nblitzfont demo", 1, 16, BlitzFont.ALIGN_CENTER));
			welcome.x = (stage.stageWidth / 2) - welcome.width / 2;
			welcome.y = -200; // Hide off-screen for the reveal

			//	Some text for our scroller
			var blah:String = "      you can create scrollers like this with 1 line of code. the speed, spacing and wrap handling are all under your control. ";
			blah = blah.concat("you can also bind custom events to a character, the period makes this scroller randomly change y position!  ... see?!  .... ");
			blah = blah.concat("scrollers may not be used very much anymore. but should you want it, it's only 1 line of code away!      ");
			blah = blah.concat("hmm aren't i supposed to send out some greetings now or something?! ah sod that...     wrap :)           ");
			
			//	Scroll Text definition
			scroller = new Bitmap(font2.defineScroller(550, 6, blah, true, true, 2));
			//scroller.cacheAsBitmap = true;
			
			//	Add an event to the scroller, when it gets a . character it'll fire this event
			font2.addScrollerEvent(".", new Event(RND_SCROLLER_Y));
			
			scroller.y = 240;
			
			addChild(welcome);
			addChild(scroller);
			
			//	Drop the welcome message into place after a short delay
			TweenLite.to(welcome, 6, { y: 64, ease: Elastic.easeOut, delay: 4 } );

			//	A custom event the scroller itself will dispatch
			font2.addEventListener(RND_SCROLLER_Y, moveScroller, false, 0, true);
			
			//	The main loop
			addEventListener(Event.ENTER_FRAME, mainLoop, false, 0, true);
		}
		
		private function mainLoop(event:Event):void
		{
			//	That's it basically :)
			font2.updateScroller();
		}
		
		private function moveScroller(event:Event):void
		{
			//	If you don't have TweenLite, just use this line instead:
			//scroller.y = 200 + (Math.random() * 160);
			
			TweenLite.to(scroller, 2, { y: 200 + Math.random() * 160, ease: Bounce.easeIn, overwrite: false } );
		}
		
	}
	
}