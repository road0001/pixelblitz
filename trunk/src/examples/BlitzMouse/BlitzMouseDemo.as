package  
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import pixelblitz.core.BlitzKeyboard;
	import pixelblitz.core.BlitzMouse;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class BlitzMouseDemo extends Sprite
	{
		private var keyboard:BlitzKeyboard = new BlitzKeyboard();
		private var mouse:BlitzMouse = new BlitzMouse();
		private var debug:TextField;
		private var clicks:uint = 0;
		private var pointer1:Bitmap = new Bitmap(new pointer1BD(0, 0));
		private var arrow1:MovieClip = new arrowMC();
		private var arrow2:MovieClip = new arrowMC();
		private var arrow3:MovieClip = new arrowMC();
		
		public function BlitzMouseDemo():void
		{
			debug = new TextField();
			debug.autoSize = TextFieldAutoSize.LEFT;
			debug.selectable = false;
			debug.textColor = 0xffffff;
			
			arrow1.x = 140;
			arrow1.y = 30;

			arrow2.x = 500;
			arrow2.y = 360;
			
			arrow3.x = 200;
			arrow3.y = 290;
			
			mouse.init(stage);
			
			keyboard.init(stage);
			
			keyboard.addKeyCall(toggleUp, false, BlitzKeyboard.UP);
			keyboard.addKeyCall(toggleDown, false, BlitzKeyboard.DOWN);
			keyboard.addKeyCall(toggleLeft, false, BlitzKeyboard.LEFT);
			keyboard.addKeyCall(toggleRight, false, BlitzKeyboard.RIGHT);
			
			//	Set a zone limit
			mouse.limit(new Rectangle(121, 25, 400, 260));
			
			//	Put the pointer in the middle
			pointer1.x = 275;
			pointer1.y = 200;
			
			mouse.changePointer(pointer1);
			//mouse.show();
			
			//	Limit it's movement :)
			
			//	They can only move to the left!
			//mouse.limitMovement(true, false, true, false);
			//mouse.allowHorizontalJumpback = false;
			//mouse.allowVerticalJumpback = false;
			
			//	They can only move to the right!
			//mouse.limitMovement(false, false, false, true);
			
			//	They can only move left and right
			//mouse.limitMovement(false, false, true, true);
			
			//	They can only move up
			//mouse.limitMovement(true, false, false, false);
			
			//	They can only move vertically
			//mouse.limitMovement(true, true, false, false);
			
			addChild(debug);
			addChild(pointer1);
			addChild(arrow1);
			addChild(arrow2);
			addChild(arrow3);
			
			keyboard.go();
			
			addEventListener(Event.ENTER_FRAME, mainLoop, false, 0, true);
		}
		
		private function toggleUp():void
		{
			if (mouse.allowMoveUp)
			{
				mouse.allowMoveUp = false;
			}
			else
			{
				mouse.allowMoveUp = true;
			}
		}
		
		private function toggleDown():void
		{
			if (mouse.allowMoveDown)
			{
				mouse.allowMoveDown = false;
			}
			else
			{
				mouse.allowMoveDown = true;
			}
		}
		
		private function toggleLeft():void
		{
			if (mouse.allowMoveLeft)
			{
				mouse.allowMoveLeft = false;
			}
			else
			{
				mouse.allowMoveLeft = true;
			}
		}
		
		private function toggleRight():void
		{
			if (mouse.allowMoveRight)
			{
				mouse.allowMoveRight = false;
			}
			else
			{
				mouse.allowMoveRight = true;
			}
		}
		
		private function mainLoop(event:Event):void
		{
			arrow1.rotation = mouse.angleToObject(arrow1);
			arrow2.rotation = mouse.angleToObject(arrow2);
			arrow3.rotation = mouse.angleToObject(arrow3);
			
			var s:String;
			
			s = "X / Y: " + mouse.X.toString() + " " + mouse.Y.toString() + "\n";
			s += "Over Stage?: " + mouse.isOverStage.toString() + "\n";
			s += "Button down: " + mouse.isDown.toString() + "\n";
			s += "Moving Left: " + mouse.isMovingLeft.toString() + "\n";
			s += "Moving Right: " + mouse.isMovingRight.toString() + "\n";
			s += "Moving Up: " + mouse.isMovingUp.toString() + "\n";
			s += "Moving Down: " + mouse.isMovingDown.toString() + "\n";
			s += "Speed X: " + mouse.speedX.toString() + "\n";
			s += "Speed Y: " + mouse.speedY.toString() + "\n";
			s += "Distance X: " + mouse.distanceX.toString() + "\n";
			s += "Distance Y: " + mouse.distanceY.toString() + "\n";
			s += "Angle: " + mouse.angle().toString() + "\n\n";
			s += "Allow Up: " + mouse.allowMoveUp.toString() + "\n";
			s += "Allow Down: " + mouse.allowMoveDown.toString() + "\n";
			s += "Allow Left: " + mouse.allowMoveLeft.toString() + "\n";
			s += "Allow Right: " + mouse.allowMoveRight.toString() + "\n";
			
			debug.text = s;
		}
		
	}
	
}