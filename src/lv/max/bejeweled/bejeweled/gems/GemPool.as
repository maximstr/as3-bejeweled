package lv.max.bejeweled.bejeweled.gems
{
	import flash.display.DisplayObject;

	public class GemPool
	{
		private static var instance:GemPool;
		private var gemListMap:Array=[];

		public function GemPool(block:SingletonBlocker)
		{
		}

		public static function getInstance():GemPool
		{
			if (instance == null)
			{
				instance=new GemPool(new SingletonBlocker());
			}
			return instance;
		}

		public function popGem(gemType:int):Gem
		{
			if (!gemListMap[gemType])
			{
				gemListMap[gemType]=new Vector.<Gem>();
			}

			var gemList:Vector.<Gem>=gemListMap[gemType];

			if (gemList.length == 0)
			{
				return getNewGem(gemType);
			}

			return resetGemProperties(gemList.pop());
		}

		private function resetGemProperties(gem:Gem):Gem
		{
			gem.mouseEnabled=true;
			gem.hideSelectedState();
			var view:DisplayObject=gem.getView();
			view.alpha=1;
			view.filters=[];
			view.scaleX=view.scaleY=1;
			view.visible=true;
			return gem;
		}

		public function pushGem(gem:Gem):void
		{
			var gemType:int=gem.getGemType();

			if (!gemListMap[gemType])
			{
				gemListMap[gemType]=new Vector.<Gem>();
			}

			(gemListMap[gemType] as Vector.<Gem>).push(gem);
		}

		private function getNewGem(gemType:int):Gem
		{
			return GemFactory.getInstance().getNewGem(gemType);
		}
	}
}

internal class SingletonBlocker
{
}

