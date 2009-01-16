/**
* PixelBlitz Engine - Scroll Demo
* @author Richard Davey / Photon Storm
*/
package  
{
	import pixelblitz.core.*;
	import pixelblitz.elements.*;
	import pixelblitz.layers.*;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class AutoScrollDemo extends Sprite
	{
		private var credits:Bitmap;
		private var layer:RenderLayer = new RenderLayer();
		private var renderer:Renderer2D = new Renderer2D(640, 400);
		
		public function AutoScrollDemo():void
		{
			credits = new Bitmap(new creditsBD(0, 0));
			credits.x = 0;
			credits.y = 300;

			var bg:Bitmap = new Bitmap(new scrollBD(0, 0));
			
			var s:uint = 17;
			
			for (var y:uint = 0; y < 400; y += 10)
			{
				if (y <= 150 || y >= 240)
				{
					var bdSlice:BitmapData = new BitmapData(640, 10, true, 0x0);
					
					bdSlice.copyPixels(bg.bitmapData, new Rectangle(0, y, 640, 10), new Point(0, 0));
					
					var slice:PixelSprite = new PixelSprite(new Bitmap(bdSlice));
					
					slice.hotspot(PixelSprite.HOTSPOT_TOP_LEFT);
					slice.autoScroll(PixelSprite.SCROLL_LEFT, s);
					
					slice.x = 0;
					slice.y = y;
					
					layer.addItem(slice);
					
					if (y <= 150)
					{
						s--;
					}
					
					if (y >= 230)
					{
						s++;
					}
				}
			}
			
			renderer.addLayer(layer);
			
			addChild(credits);
			addChild(renderer);
			
			addEventListener(Event.ENTER_FRAME, mainLoop, false, 0, true);
		}
		
		private function mainLoop(event:Event):void
		{
			credits.y -= 0.5;
			
			if (credits.y < -600)
			{
				trace("reset");
				credits.y = 300;
			}
			
			renderer.render();
		}
	}
}