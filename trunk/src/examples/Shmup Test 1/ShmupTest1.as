/**
* PixelBlitz Engine Shoot-em-up Test 1
* @author Richard Davey / Photon Storm
*/
package  
{
	import pixelblitz.core.*;
	import pixelblitz.effects.*;
	import pixelblitz.elements.*;
	import pixelblitz.layers.*;
	import pixelblitz.utils.*;
	import pixelblitz.core.BlitzKeyboard;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	public class ShmupTest1 extends Sprite
	{
		private var keyboard:BlitzKeyboard;
		
		private var player:PixelSprite;
		private var playerXSpeed:Number = 6;
		private var playerYSpeed:Number = 4;
		private var fireRate:uint = 50;
		private var lazerDelay:uint = 0;
		private var lazerMax:uint = 40;
		private var lazerSpeed:uint = 24;
		
		private var boss:PixelSprite;
		private var bossXSpeed:Number = 6;
		
		private var baddieMax:uint = 200;
		private var baddieBaseSpeed:uint = 2;
		private var spawnTimer:uint = 0;
		private var spawnRate:uint = 50;
		
		private var bulletMax:uint = 5000;
		
		private var bg:PixelSprite;
		private var bgLayer:RenderLayer = new RenderLayer();
		private var playerLayer:RenderLayer = new RenderLayer();
		private var lazerLayer:RenderLayer = new RenderLayer();
		private var bulletLayer:RenderLayer = new RenderLayer();
		private var baddieLayer:RenderLayer = new RenderLayer();
		private var bossLayer:RenderLayer = new RenderLayer();
		
		private var renderer:Renderer2D = new Renderer2D(550, 400);
		
		private var lazers:Array = new Array();
		private var bullets:Array = new Array();
		private var baddies:Array = new Array();
		
		private var test:Bitmap;
		
		public function ShmupTest1():void
		{
			init();
			
			go();
		}
		
		private function init():void
		{
			trace("Init Graphics / Objects");
			
			keyboard = new BlitzKeyboard();
			keyboard.init(stage, false);
			
			//	Background
			bg = new PixelSprite(new Bitmap(new waterBD(0, 0)));
			bg.hotspot(PixelSprite.HOTSPOT_TOP_LEFT);
			bg.x = 0;
			bg.y = 0;
			bg.autoScroll(PixelSprite.SCROLL_DOWN, 8);
			bgLayer.addItem(bg);
			
			//	1) The Player
			player = new PixelSprite(new Bitmap(new plane1BD(0, 0)));
			player.x = 275;
			player.y = 340;
			//player.addToCollisionGroup(255, 0, 0);
			playerLayer.addItem(player);
			
			boss = new PixelSprite(new Bitmap(new boss1BD(0, 0)));
			boss.xSpeed = 2;
			boss.moveLeft = true;
			boss.x = 275;
			boss.y = 100;
			bossLayer.addItem(boss);
			
			//	2) The bullets you can fire, stored in the bullets array
			bullets = new Array();
			lazers = new Array();
			
			//	3) The Invaders  - There are 3 types of invader. They are collected in a 500 px wide block (leaving 50px for left/right movement)
			baddies = new Array();
			
			//	Our Layer effects :)
			//lazerLayer.effect = new TrailsEffect();
			//bulletLayer.effect = new TrailsEffect();
			
			//	Add the layers to the renderer
			renderer.addLayer(bgLayer);
			renderer.addLayer(bossLayer);
			renderer.addLayer(bulletLayer);
			renderer.addLayer(baddieLayer);
			renderer.addLayer(lazerLayer);
			renderer.addLayer(playerLayer);
			
			//	Add the renderer to the display list
			addChild(renderer);
		}
		
		private function go():void
		{
			//playerLayer.render();
			//bulletLayer.render();
			
			//test = new Bitmap(playerLayer.bitmapData);
			//
			//addChild(test);
			//
			
			keyboard.go();
			
			addEventListener(Event.ENTER_FRAME, mainLoop, false, 0, true);
		}
		
		private function mainLoop(event:Event):void
		{
			updatePlayer();
			
			updateLazers();
			
			updateBoss();
			
			spawnBaddie();
			
			updateBaddies();
			
			updateBullets();
			
			renderer.render();
		}
		
		private function spawnBoss():void
		{
			
		}
		
		private function updateBoss():void
		{
			if (boss.moveLeft)
			{
				boss.x -= boss.xSpeed;
				
				if (boss.x < 50)
				{
					boss.moveLeft = false;
				}
			}
			else
			{
				boss.x += boss.xSpeed;
				
				if (boss.x > 500)
				{
					boss.moveLeft = true;
				}
			}
		}
		
		private function spawnBaddie():void
		{
			//	Stop it going TOO mad :)
			if (getTimer() > spawnTimer && baddies.length < baddieMax)
			{
				spawnTimer = getTimer() + spawnRate;
				
				var baddie:PixelSprite = new PixelSprite( new Bitmap(new enemy1BD(0,0) ) );
				//var baddie:PixelSprite = new PixelSprite( new Bitmap(new boss1BD(0,0) ) );
				
				baddie.x = Math.random() * 550;
				baddie.y = -100;
				baddie.speed = baddieBaseSpeed + Math.random() * 6;
				baddie.xdrift = -2 + (Math.random() * 4);
				baddie.lastFired = getTimer() + Math.random() * 500;
				
				baddieLayer.addItem(baddie);
				
				baddies.push(baddie);
			}
		}
		
		private function updatePlayer():void
		{
			if (keyboard.isDown(BlitzKeyboard.LEFT) && player.x > 0)
			{
				player.x -= playerXSpeed;
			}
			
			if (keyboard.isDown(BlitzKeyboard.RIGHT) && player.x < 550)
			{
				player.x += playerXSpeed;
			}
			
			if (keyboard.isDown(BlitzKeyboard.UP) && player.y > 0)
			{
				player.y -= playerYSpeed;
			}
			
			if (keyboard.isDown(BlitzKeyboard.DOWN) && player.y < 400)
			{
				player.y += playerYSpeed;
			}
			
			if (keyboard.isDown(BlitzKeyboard.CONTROL) && getTimer() > lazerDelay)
			{
				launchLazer();
			}
		}
		
		private function updateBaddies():void
		{
			for ( var b:int = 0; b < baddies.length; b++ )
			{
				var baddie:PixelSprite = baddies[b];
				
				baddie.x += baddie.xdrift;
				baddie.y += baddie.speed;
				
				//	Shoot?
				if (getTimer() > baddie.lastFired)
				{
					launchBullet(baddie.x, baddie.y, baddie.speed * 3);
					baddie.lastFired = 100 + (getTimer() + Math.random() * 100);
				}
				
				if (baddie.y > 440)
				{
					baddie.dispose();
					baddies.splice( b, 1 );
				}
			}
		}
		
		private function updateBullets():void
		{
			for ( var b:int = 0; b < bullets.length; b++ )
			{
				var bullet:PixelSprite = bullets[b];
				
				bullet.y += bullet.speed;
				
				if (bullet.y > 450)
				{
					bullet.dispose();
					bullets.splice( b, 1 );
				}
			}
		}
		
		private function launchBullet(x:int, y:int, speed:int):void
		{
			if (bullets.length < bulletMax)
			{
				var bullet:PixelSprite = new PixelSprite( new Bitmap(new bulletBD(0,0) ) );
				
				bullet.x = x;
				bullet.y = y;
				//bullet.addToCollisionGroup(255, 255, 255);
				bullet.speed = speed;
				
				bulletLayer.addItem(bullet);
				
				bullets.push(bullet);
			}
		}
		
		private function updateLazers():void
		{
			for ( var b:int = 0; b < lazers.length; b++ )
			{
				var lazer:PixelSprite = lazers[b];
				
				lazer.y -= lazerSpeed;
				
				//	Off the screen? Then dispose of it
				if (lazer.y < -40)
				{
					lazer.dispose();
					lazers.splice( b, 1 );
				}
			}
		}
		
		private function launchLazer():void
		{
			if (lazers.length < lazerMax)
			{
				lazerDelay = getTimer() + fireRate;
				
				var lazer:PixelSprite = new PixelSprite( new Bitmap(new lazerBD(0,0) ) );
				
				lazer.x = player.x;
				lazer.y = player.y;
				
				lazerLayer.addItem(lazer);
				
				lazers.push(lazer);
			}
		}
	}
}