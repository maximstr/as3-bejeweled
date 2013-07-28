package lv.max.bejeweled.bejeweled.data
{
	import flash.display.DisplayObject;

	public class GameAssetProvider
	{
		private static var instance:GameAssetProvider;
		private var assetMap:Array;

		public function GameAssetProvider(lock:SingletonBlocker)
		{
			lock;
		}

		public static function getInstance():GameAssetProvider
		{
			if (instance == null)
			{
				instance=new GameAssetProvider(new SingletonBlocker());
			}
			return instance;
		}

		public function setAssetMap(map:Array):void
		{
			this.assetMap=map;
		}

		public function getClass(className:String):Class
		{
			if (assetMap[className])
			{
				return assetMap[className];
			}

			throw new ArgumentError("No such class: " + className, className);
		}

		public function getDisplayObject(className:String):DisplayObject
		{
			var displayClass:Class=getClass(className);
			var display:DisplayObject=new displayClass() as DisplayObject;
			return display;
		}

	}
}

internal class SingletonBlocker
{
}
