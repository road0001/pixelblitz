/**
* PixelBlitz Engine - BlitzBox2DContactListener 
* @link http://www.pixelblitz.org
* @author Richard Davey / Photon Storm
*/

package pixelblitz.physics 
{
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	
	public class BlitzBox2DContactListener extends b2ContactListener
	{
		public var contactStack:Array = new Array();
		
		public function BlitzBox2DContactListener() 
		{
		}
		
		override public function Add(point:b2ContactPoint):void
		{
			var shape1:b2Shape = point.shape1;
			var shape2:b2Shape = point.shape2;
			var separation:Number = point.separation;
			var position:b2Vec2 = point.position.Copy();

			contactStack.push(new BlitzBox2DContactPoint(shape1, shape2, separation, position));
		}
		
	}
	
}