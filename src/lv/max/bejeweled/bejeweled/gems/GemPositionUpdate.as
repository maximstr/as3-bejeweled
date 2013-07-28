package lv.max.bejeweled.bejeweled.gems
{
	import flash.geom.Point;

	public class GemPositionUpdate
	{
		public var gem:Gem;
		public var newPosition:Point;

		public function GemPositionUpdate(gem:Gem, newPosition:Point)
		{
			this.gem=gem;
			this.newPosition=newPosition;
		}
	}
}
