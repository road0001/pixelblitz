/**
* PixelBlitz Engine - BlitzBox2D
* @link http://www.pixelblitz.org
* @author Richard Davey / Photon Storm
*/

package pixelblitz.physics 
{
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.Joints.b2MouseJoint;
	import Box2D.Dynamics.Joints.b2MouseJointDef;
	
	/**
	 * The BlitzBox2D utility class adds a set of useful helper/creation functions for Box2D
	 * This class is highly experimental and will change a lot over time. Use at your own risk.
	 */
	public class BlitzBox2D
	{
		private var mousePVec:b2Vec2 = new b2Vec2();
		private var getPositionCache:b2Vec2;
		private var getPositionXCache:int;
		private var getPositionYCache:int;
		
		public function BlitzBox2D()
		{
		}
		
		public function createWorld(gravityX:Number, gravityY:Number, canSleep:Boolean = true):b2World
		{
			//	These are a set of rules that control what happens within the physics world
			
			//	The AABB (axis aligned bounding box) is the bounding box that gives the world its limits
			//	The world is centered on X/Y : 0,0 with negative values being "up" and positive being "down"
			
			var worldAABB:b2AABB = new b2AABB();
			
			//	Top Left X/Y - a value of 100 is equivalent to 6000 pixels
			worldAABB.lowerBound.Set(-100.0, -100.0);
			
			//	Bottom Right X/Y
			worldAABB.upperBound.Set(100.0, 100.0);
			
			//	Gravity Vector - the values are in MKS (meters-kilograms-per second)
			//	A positive Y value = down, negative = up. Negative X = Left, Positive X = Right
			
			var gravity:b2Vec2 = new b2Vec2(gravityX, gravityY);
			
			//	Create our world
			return new b2World(worldAABB, gravity, canSleep);
		}
		
		//	posX and posY are the CENTER of this box, not the top left
		public function createBoxObject(world:b2World, posX:Number, posY:Number, degrees:uint, friction:Number, width:Number, height:Number, positionIsPixels:Boolean, scaleIsPixels:Boolean):b2Body
		{
			var newBodyDef:b2BodyDef = new b2BodyDef();
			
			if (positionIsPixels)
			{
				newBodyDef.position.Set(pixelsToPosition(posX), pixelsToPosition(posY));
			}
			else
			{
				newBodyDef.position.Set(posX, posY);
			}
			
			if (degrees > 0)
			{
				newBodyDef.angle = degreesToRadians(degrees);
			}
			
			var newBoxDef:b2PolygonDef = new b2PolygonDef();
			
			if (scaleIsPixels)
			{
				newBoxDef.SetAsBox(pixelsToMeters(width), pixelsToMeters(height));
			}
			else
			{
				newBoxDef.SetAsBox(width, height);
			}
			
			newBoxDef.friction = friction;
			
			var newBody:b2Body = world.CreateBody(newBodyDef);
			newBody.CreateShape(newBoxDef);
			newBody.SetMassFromShapes();
			
			return newBody;
			
		}
		
		public function getBodyAtMouse(world:b2World, x:int, y:int, includeStatic:Boolean = false):b2Body
		{
			var mouseXWorldPhys = pixelsToPosition(x);
			var mouseYWorldPhys = pixelsToPosition(y);
			
			// Make a small box.
			
			mousePVec.Set(mouseXWorldPhys, mouseYWorldPhys);
			//mousePVec.Set(pixelsToPosition(x), pixelsToPosition(y));
			
			var aabb:b2AABB = new b2AABB();
			aabb.lowerBound.Set(mouseXWorldPhys - 0.001, mouseYWorldPhys - 0.001);
			aabb.upperBound.Set(mouseXWorldPhys + 0.001, mouseYWorldPhys + 0.001);
			
			// Query the world for overlapping shapes.
			var k_maxCount:int = 10;
			var shapes:Array = new Array();
			var count:int = world.Query(aabb, shapes, k_maxCount);
			var body:b2Body = null;
			for (var i:int = 0; i < count; ++i)
			{
				if (shapes[i].GetBody().IsStatic() == false || includeStatic)
				{
					var tShape:b2Shape = shapes[i] as b2Shape;
					var inside:Boolean = tShape.TestPoint(tShape.GetBody().GetXForm(), mousePVec);
					if (inside)
					{
						body = tShape.GetBody();
						break;
					}
				}
			}
			return body;
		}
		
		public function attachMouseJointToBody(world:b2World, body:b2Body, x:int, y:int, maxForce:Number, timeStep:Number):b2MouseJoint
		{
			var mouseXWorldPhys = pixelsToPosition(x);
			var mouseYWorldPhys = pixelsToPosition(y);
			
			var jointDef:b2MouseJointDef = new b2MouseJointDef();
			
			jointDef.body1 = world.GetGroundBody();
			jointDef.body2 = body;
			jointDef.target.Set(mouseXWorldPhys, mouseYWorldPhys);
			jointDef.maxForce = maxForce * body.GetMass();
			jointDef.timeStep = timeStep;
			
			return world.CreateJoint(jointDef) as b2MouseJoint;
		}
		
		public function getPositionVector(x:int, y:int):b2Vec2
		{
			//	Don't keep creating the vector unless it has changed
			if (x != getPositionXCache || y != getPositionYCache)
			{
				getPositionCache = new b2Vec2(pixelsToPosition(x), pixelsToPosition(y));
				getPositionXCache = x;
				getPositionYCache = y;
			}
			
			return getPositionCache;
			
		}
		
		/**
		 * Converts the given pixel value into a Number you can use for the Position call
		 * @param	pixels int
		 * @return	Number
		 */
		public function pixelsToPosition(pixels:int):Number
		{
			var result:Number;
			
			if (pixels < 0)
			{
				//	Return negative value
				result = Math.abs(pixels) / 30;
				result = 0 - result;
			}
			else
			{
				result = pixels / 30;
			}
			
			return result;
		}

		public function positionToPixels(position:Number):int
		{
			var result:Number;
			
			if (position < 0)
			{
				//	Return negative value
				result = Math.abs(position) * 30;
				result = 0 - result;
			}
			else
			{
				result = position * 30;
			}
			
			return result;
		}
		
		public function metersToPixels(meters:Number):int
		{
			return meters * 2 * 30;
		}
		
		public function pixelsToMeters(pixels:uint):Number
		{
			return (pixels / 30) / 2;
		}
		
		public function degreesToRadians(degrees:Number):Number
		{
			return degrees * Math.PI / 180;
		}
		
	}
}