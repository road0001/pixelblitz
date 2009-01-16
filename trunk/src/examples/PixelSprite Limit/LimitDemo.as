/**
* PixelBlitz Engine - Sprite Limite Example
* @author Richard Davey / Photon Storm
*/
package  
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	import pixelblitz.elements.PixelSprite;
	import pixelblitz.core.Renderer2D;
	import pixelblitz.layers.RenderLayer;
	import pixelblitz.core.BlitzKeyboard;
	
	public class LimitDemo extends Sprite
	{
		private var keyboard:BlitzKeyboard;
		
		private var player:PixelSprite;
		private var playerXSpeed:Number = 6;
		private var playerYSpeed:Number = 4;
		
		private var bg:PixelSprite;
		private var bgLayer:RenderLayer = new RenderLayer();
		private var playerLayer:RenderLayer = new RenderLayer();
		
		private var renderer:Renderer2D = new Renderer2D(550, 400);
		
		public function LimitDemo():void
		{
			init();
			go();
		}
		
		private function init():void
		{
			keyboard = new BlitzKeyboard();
			keyboard.init(stage, false);
			
			//	Scrolling Background
			bg = new PixelSprite(new Bitmap(new waterBD(0, 0)));
			bg.hotspot(PixelSprite.HOTSPOT_TOP_LEFT);
			bg.x = 0;
			bg.y = 0;
			bg.autoScroll(PixelSprite.SCROLL_DOWN, 8);
			bgLayer.addItem(bg);
			
			//	The Player
			player = new PixelSprite(new Bitmap(new plane1BD(0, 0)));
			
			//	Limit the player to the region starting from 100,100 down to 450,300
			player.addLimit(100, 100, 450, 300);
			
			//	Ensure the player is placed within this region
			player.x = 275;
			player.y = 200;
			
			bgLayer.addItem(player);
			
			//	Add to the 2DRenderer
			renderer.addLayer(bgLayer);
			
			//	Finally add the 2DRenderer to the display list
			addChild(renderer);
		}
		
		private function go():void
		{
			keyboard.go();
			
			addEventListener(Event.ENTER_FRAME, mainLoop, false, 0, true);
		}
		
		private function mainLoop(event:Event):void
		{
			//	Check for player movement
			updatePlayer();
			
			//	Update the RenderLayers
			renderer.render();
		}
		
		private function updatePlayer():void
		{
			//	Simply move the player around the stage with the cursor keys
			//	The player will never leave the region established in addLimit()
			
			if (keyboard.isDown(BlitzKeyboard.LEFT))
			{
				player.x -= playerXSpeed;
			}
			
			if (keyboard.isDown(BlitzKeyboard.RIGHT))
			{
				player.x += playerXSpeed;
			}
			
			if (keyboard.isDown(BlitzKeyboard.UP))
			{
				player.y -= playerYSpeed;
			}
			
			if (keyboard.isDown(BlitzKeyboard.DOWN))
			{
				player.y += playerYSpeed;
			}
		}
	}
}