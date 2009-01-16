package pixelblitz.physics 
{
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	
	public class BlitzBox2DContactPoint 
	{
		public var body1:b2Body;
		public var body2:b2Body;
		public var shape1:b2Shape;
		public var shape2:b2Shape;
		public var separation:Number;
		public var position:b2Vec2;
		
		public function BlitzBox2DContactPoint(s1:b2Shape, s2:b2Shape, f:Number, p:b2Vec2)
		{
			shape1 = s1;
			shape2 = s2;
			separation = f;
			position = p;
			
			body1 = shape1.GetBody();
			body2 = shape2.GetBody();
		}
	}
	
}