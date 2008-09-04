/**
* PixelBlitz Engine - BlitzFont
* @link http://www.pixelblitz.org
* @author Richard Davey / Photon Storm
*/

package pixelblitz.utils 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * The BlitzFont class provides an easy way to create and use bitmap fonts and scroll them
	 * TODO - Documentation
	 */
	public class BlitzFont extends EventDispatcher
	{
		private var fontSet:BitmapData;
		private var offsetX:uint;
		private var offsetY:uint;
		private var characterWidth:uint;
		private var characterHeight:uint;
		private var characterSpacingX:uint;
		private var characterSpacingY:uint;
		private var characterPerRow:uint;
		private var grabData:Array
		
		//	Scroll Text
		private var scroller:BitmapData;
		private var scrollerCleanRect:Rectangle;
		private var scrollerBuffer:BitmapData;
		private var scrollEventChar:uint;
		private var scrollEvent:Event;
		private var scrollComplete:Boolean;
		private var scrollPaused:Boolean;
		private var scrollText:String;
		private var scrollWidth:uint;
		private var scrollCharWidth:uint;
		private var scrollSpacing:uint;
		private var scrollSpeed:uint;
		private var scrollWrap:Boolean;
		private var scrollChar:uint;
		private var scrollPos:uint;
		private var scrollRects:Array;
		private var scrollPoint:Point;
		
		public static const SCROLLER_COMPLETE:String = "scrollerComplete";
		public static const SCROLLER_WRAP:String = "scrollerWrap";
		
		public static const ALIGN_LEFT:uint = 0;
		public static const ALIGN_RIGHT:uint = 1;
		public static const ALIGN_CENTER:uint = 2;
		
		public static const SET1:String = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~";
		public static const SET2:String = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		public static const SET3:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 ";
		public static const SET4:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789";
		public static const SET5:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ.,/() '!?-*:0123456789";
		public static const SET6:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ!?:;0123456789\"(),-.' ";
		public static const SET7:String = "AGMSY+:4BHNTZ!;5CIOU.?06DJPV,(17EKQW\")28FLRX-'39";
		public static const SET8:String = "0123456789 .ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		public static const SET9:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ()-0123456789.:,'\"?!";
		public static const SET10:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		public static const SET11:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ.,\"-+!?()':;0123456789";
		
		public function BlitzFont():void
		{
		}
		
        public function init(font:BitmapData, width:uint, height:uint, chars:String, charsPerRow:uint, xSpacing:uint = 0, ySpacing:uint = 0, xOffset:uint = 0, yOffset:uint = 0):void
        {
			//	Take a copy of the font for internal use
			fontSet = font.clone();
			
			characterWidth = width;
			characterHeight = height;
			characterSpacingX = xSpacing;
			characterSpacingY = ySpacing;
			characterPerRow = charsPerRow;
			offsetX = xOffset;
			offsetY = yOffset;
			
			grabData = new Array();
			
			//	Now generate our rects for fast copyPixels later on
			var currentX:uint = offsetX;
			var currentY:uint = offsetY;
			var r:uint = 0;
			
			for (var c:uint = 0; c < chars.length; c++)
			{
				//	The rect is hooked to the ASCII value of the character :)
				//	You don't need to include the space!
				grabData[chars.charCodeAt(c)] = new Rectangle(currentX, currentY, characterWidth, characterHeight);
				
				r++;
				
				if (r == characterPerRow)
				{
					r = 0;
					currentX = offsetX;
					currentY += characterHeight + characterSpacingY;
				}
				else
				{
					currentX += characterWidth + characterSpacingX;
				}
			}
        }
		
		public function defineScroller(width:uint, speed:uint, text:String, autoUpperCase:Boolean = true, wrap:Boolean = true, spacing:uint = 0):BitmapData
		{
			if (width < characterWidth)
			{
				throw Error("Scroll text width cannot be less than the width of the font");
			}
			
			if (width > 2880)
			{
				throw Error("Scroll text width cannot be larger than 2880");
			}
			
			if (autoUpperCase)
			{
				text = text.toUpperCase();
			}
			
			scrollText = removeUnsupportedCharacters(text);
			
			scrollWidth = width;
			scrollCharWidth = characterWidth + spacing;
			scrollSpacing = spacing;
			scrollSpeed = speed;
			scrollWrap = wrap;
			scrollPos = 0;
			scrollComplete = false;
			scrollPaused = false;
			
			scroller = new BitmapData(width, characterHeight, true, 0xf);
			
			//	10 characters look-ahead buffer
			scrollerBuffer = new BitmapData(scrollCharWidth * 10, characterHeight, true, 0xf);
			
			if (scrollSpacing > 0)
			{
				scrollerCleanRect = new Rectangle(scrollWidth - scrollSpacing, 0, scrollSpacing, scroller.height);
			}
			else
			{
				scrollerCleanRect = new Rectangle(scrollWidth - 1, 0, 1, scroller.height);
			}
			
			scrollRects = new Array();
			
			for (var i:uint = 0; i <= scrollerBuffer.width; i++)
			{
				scrollRects.push(new Rectangle(i, 0, scrollSpeed, characterHeight));
			}

			scrollPoint = new Point(width - scrollSpeed, 0);
			
			//	Put the first 10 characters into the buffer
			scrollerBuffer = getLine(scrollText.substr(0, 10), scrollSpacing, false);
			
			scrollChar = 10;
			
			return scroller;
		}
		
		public function addScrollerEvent(char:String, event:Event):void
		{
			scrollEventChar = char.charCodeAt(0);
			scrollEvent = event;
		}
		
		public function removeScrollerEvent():void
		{
			scrollEvent = null;
			scrollEventChar = NaN;
		}
		
		public function updateScroller():void
		{
			if (scrollComplete == false && scrollPaused == false)
			{
				//	Move it
				scroller.lock();
				
				scroller.scroll(-scrollSpeed, 0);

				//	Clean the right-hand area
				scroller.fillRect(scrollerCleanRect, 0xf);
				
				//	Draw it
				scroller.copyPixels(scrollerBuffer, scrollRects[scrollPos], scrollPoint);
				
				scroller.unlock();
				
				scrollPos += scrollSpeed;
				
				//	This next grab will take us over the edge of the buffer
				if (scrollRects[scrollPos].right > scrollerBuffer.width)
				{
					//var diff:uint = scrollRects[scrollPos].right - scrollerBuffer.width;
					
					scrollPos = 0;
					
					scrollerBuffer.lock();
					
					scrollerBuffer.fillRect(new Rectangle(0, 0, scrollerBuffer.width, scrollerBuffer.height), 0xf);
					
					var temp:BitmapData = getLine(scrollText.substr(scrollChar, 10), scrollSpacing, false);
					
					scrollerBuffer.copyPixels(temp, new Rectangle(0, 0, temp.width, temp.height), new Point(0, 0));
					
					scrollerBuffer.unlock();
					
					if (scrollChar + 10 >= scrollText.length)
					{
						//	Do we wrap or don't we?
						if (scrollWrap == false)
						{
							scrollComplete = true;
							dispatchEvent(new Event(BlitzFont.SCROLLER_COMPLETE));
						}
						else
						{
							scrollChar = 0;
							dispatchEvent(new Event(BlitzFont.SCROLLER_WRAP));
						}
					}
					else
					{
						scrollChar += 10;
					}
				}
			}
		}
		
		//	For when you need just 1 single line of text (carriage returns are stripped)
		public function getLine(text:String, customSpacingX:uint = 0, autoUpperCase:Boolean = true):BitmapData
		{
			if (autoUpperCase)
			{
				text = text.toUpperCase();
			}
			
			//	Remove all characters not supported by this font set (excluding spaces)
			text = removeUnsupportedCharacters(text);
			
			//	Sanity checks
			if (text.length * (characterWidth + customSpacingX) > 2880)
			{
				throw Error("Text is too long when converted to bitmap (maximum width is 2880 pixels)");
			}
			
			var x:int = 0;
			var output:BitmapData = new BitmapData(text.length * (characterWidth + customSpacingX), characterHeight, true, 0xf);
			
			pasteLine(output, text, 0, 0, customSpacingX);
			
			return output;
		}
		
		public function getMultiLine(text:String, customSpacingX:uint = 0, customSpacingY:uint = 0, align:uint = 0, autoUpperCase:Boolean = true):BitmapData
		{
			if (autoUpperCase)
			{
				text = text.toUpperCase();
			}
			
			//	Remove all characters not supported by this font set (excluding carriage-returns & spaces)
			text = removeUnsupportedCharacters(text, false);
			
			//	Count how many lines there now are in the text
			var lines:Array = text.split("\n");
			
			var lineCount:uint = lines.length;
			
			//	Work out the longest line
			var longestLine:uint = getLongestLine(text);
			
			//	Sanity checks
			if (longestLine * (characterWidth + customSpacingX) > 2880 || (lineCount * (characterHeight + customSpacingY)) - customSpacingY > 2880)
			{
				throw Error("Text is too long when converted to bitmap (maximum width is 2880 pixels)");
			}
			
			var x:int = 0;
			var y:int = 0;
			var output:BitmapData = new BitmapData(longestLine * (characterWidth + customSpacingX), (lineCount * (characterHeight + customSpacingY)) - customSpacingY, true, 0xf);
			
			//	Loop through each line of text
			for (var i:uint = 0; i < lines.length; i++)
			{
				//	This line of text is held in lines[i] - need to work out the alignment
				switch (align)
				{
					case ALIGN_LEFT:
						x = 0;
						break;
						
					case ALIGN_RIGHT:
						x = output.width - (lines[i].length * (characterWidth + customSpacingX));
						trace("arx " + x);
						break;
						
					case ALIGN_CENTER:
						x = (output.width / 2) - ((lines[i].length * (characterWidth + customSpacingX)) / 2);
						x += customSpacingX / 2;
						break;
				}
				
				pasteLine(output, lines[i], x, y, customSpacingX);
				
				y += characterHeight + customSpacingY;
			}
			
			return output;
		}
		
		//	Get's a single character and returns it without the overhead of calling getLine with a string of length 1
		public function getCharacter(char:String):BitmapData
		{
			var output:BitmapData = new BitmapData(characterWidth, characterHeight, true, 0xf);

			if (grabData[char.charCodeAt(0)] is Rectangle && char.charCodeAt(0) != 32)
			{
				output.copyPixels(fontSet, grabData[char.charCodeAt(0)], new Point(0, 0));
			}
			
			return output;
		}
		
		private function pasteLine(output:BitmapData, text:String, x:uint = 0, y:uint = 0, customSpacingX:uint = 0)
		{
			for (var c:uint = 0; c < text.length; c++)
			{
				//	Is this an event character?
				if (text.charCodeAt(c) == scrollEventChar)
				{
					dispatchEvent(scrollEvent);
				}
				
				//	If it's a space then there is no point copying nothing, so leave a blank space
				if (text.charAt(c) == " ")
				{
					x += characterWidth + customSpacingX;
				}
				else
				{
					//	If the character doesn't exist in the font then we don't want a blank space, we just want to skip it
					if (grabData[text.charCodeAt(c)] is Rectangle)
					{
						output.copyPixels(fontSet, grabData[text.charCodeAt(c)], new Point(x, y));
						x += characterWidth + customSpacingX;
					}
				}
			}
			
		}
		
		private function getLongestLine(text:String):uint
		{
			var lines:Array = text.split("\n");
			
			var longestLine:uint = 0;
			
			for (var i:uint = 0; i < lines.length; i++)
			{
				if (lines[i].length > longestLine)
				{
					longestLine = lines[i].length;
				}
			}
			
			return longestLine;
		}
		
		//	If the character doesn't exist in the font then we don't want a blank space, we just want to skip it
		private function removeUnsupportedCharacters(text:String, stripCR:Boolean = true):String
		{
			var newString:String = "";
			
			for (var c:uint = 0; c < text.length; c++)
			{
				if (grabData[text.charCodeAt(c)] is Rectangle || text.charCodeAt(c) == 32 || (stripCR == false && text.charAt(c) == "\n"))
				{
					newString = newString.concat(text.charAt(c));
				}
			}
			
			return newString;
		}
		
		
	}
	
}