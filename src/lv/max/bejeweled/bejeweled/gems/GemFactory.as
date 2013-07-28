package lv.max.bejeweled.bejeweled.gems
{
	import flash.display.DisplayObject;

	import lv.max.bejeweled.bejeweled.data.GameAssetProvider;

	public class GemFactory
	{
		private static var instance:GemFactory;
		private var colorMap:Array=[];
		private var clickCallback:Function;
		private var overCallback:Function;
		private var outCallback:Function;

		public function GemFactory(lock:SingletonBlocker)
		{
			lock;
		}

		public static function getInstance():GemFactory
		{
			if (instance == null)
			{
				instance=new GemFactory(new SingletonBlocker());
			}
			return instance;
		}

		public function setColorMap(colorMap:Array):void
		{
			var map:Array=[];
			for each (var color:Object in colorMap)
			{
				map[color.id]=color.color;
			}
			this.colorMap=map;
		}

		public function setClickCallback(f:Function):void
		{
			this.clickCallback=f;
		}

		public function setOverCallback(f:Function):void
		{
			this.overCallback=f;
		}

		public function setOutCallback(f:Function):void
		{
			this.outCallback=f;
		}

		public function getNewGem(gemType:int):Gem
		{
			var display:DisplayObject=GameAssetProvider.getInstance().getDisplayObject('GM' + gemType);
			return new Gem(gemType, display);
		}
	}
}

internal class SingletonBlocker
{
}
