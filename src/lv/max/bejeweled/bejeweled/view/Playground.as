package lv.max.bejeweled.bejeweled.view
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;

	import flash.display.DisplayObject;
	import flash.display.Sprite;

	import lv.max.bejeweled.bejeweled.gems.Gem;
	import lv.max.bejeweled.bejeweled.gems.GemPositionUpdate;

	public class Playground extends Sprite
	{
		private static const SWAP_ANITIME:Number=.3;
		private static const REMOVE_ANITIME:Number=.3;
		private static const DROP_ANITIME:Number=.3;
		private static const ADD_ANITIME:Number=.3;

		private var colCount:int=0;
		private var rowCount:int=0;

		public function Playground()
		{

		}

		public function setPlaygroundSize(colCount:int, rowCount:int):void
		{
			this.colCount=colCount;
			this.rowCount=rowCount;
		}

		public function clearPlayground(gemLinesList:Vector.<Vector.<Gem>>, callback:Function):void
		{
			var view:DisplayObject;
			var delay:Number=1;

			for each (var gemLine:Vector.<Gem> in gemLinesList)
			{
				for each (var gem:Gem in gemLine)
				{
					view=gem.getView();
					if (view.parent)
					{
						TweenLite.to(view, REMOVE_ANITIME + .2, {delay: delay, scale: 0, ease: Cubic.easeIn, onCompleteParams: [gem], onComplete: function(g:Gem):void
						{
							g.getView().parent.removeChild(g.getView());
						}});
					}
				}
				delay+=.25;
			}

			TweenLite.to({}, delay + REMOVE_ANITIME + .2, {onComplete: callback});
		}

		public function showGems(gemColumns:Vector.<Vector.<Gem>>, callback:Function):void
		{
			var delay:Number=0;
			for (var i:int=0, cCount:int=gemColumns.length; i < cCount; i++)
			{
				var gemLine:Vector.<Gem>=gemColumns[i];
				for (var j:int=0, rCount:int=gemLine.length; j < rCount; j++)
				{
					var gem:Gem=gemLine[j];
					var view:DisplayObject=gem.getView();
					addChild(view);
					view.alpha=0;
					TweenLite.to(view, .5, {delay: j / 16, alpha: 1});
				}
			}

			TweenLite.to({}, j / 10, {onComplete: function():void
			{
				callback();
			}});
		}

		public function swapGems(gemA:Gem, gemB:Gem, callback:Function):void
		{
			var aPos:int, bPos:int;

			if (gemA.getCol() == gemB.getCol())
			{
				aPos=gemA.getY();
				bPos=gemB.getY();
				TweenLite.to(gemA.getView(), SWAP_ANITIME, {y: bPos, ease: Cubic.easeInOut});
				TweenLite.to(gemB.getView(), SWAP_ANITIME, {y: aPos, ease: Cubic.easeInOut});
			}
			else
			{
				aPos=gemA.getX();
				bPos=gemB.getX();
				TweenLite.to(gemA.getView(), SWAP_ANITIME, {x: bPos, ease: Cubic.easeInOut});
				TweenLite.to(gemB.getView(), SWAP_ANITIME, {x: aPos, ease: Cubic.easeInOut});
			}

			TweenLite.to({}, SWAP_ANITIME, {onComplete: function():void
			{
				if (callback != null)
				{
					callback();
				}
			}});


		}

		public function removeGems(gemList:Vector.<Gem>, callback:Function):void
		{
			for each (var gem:Gem in gemList)
			{
				if (gem.getView().parent)
				{
					TweenLite.to(gem.getView(), REMOVE_ANITIME, {scale: 0, ease: Back.easeIn, onCompleteParams: [gem], onComplete: function(g:Gem):void
					{
						g.getView().parent.removeChild(g.getView());
					}});
				}
			}

			TweenLite.to({}, REMOVE_ANITIME, {onComplete: function():void
			{
				callback();
			}});
		}

		public function getWidth():int
		{
			return colCount * (Gem.GEM_WIDTH + Gem.GEM_GAP) - Gem.GEM_GAP;
		}

		public function getHeight():int
		{
			return rowCount * (Gem.GEM_HEIGHT + Gem.GEM_GAP) - Gem.GEM_GAP;
		}

		public function dropGems(updatePosList:Vector.<GemPositionUpdate>, callback:Function):void
		{
			for each (var gemUpdate:GemPositionUpdate in updatePosList)
			{
				gemUpdate.gem.setRow(gemUpdate.newPosition.y, false);
				TweenLite.to(gemUpdate.gem.getView(), DROP_ANITIME, {y: Gem.calculateYPosByRow(gemUpdate.newPosition.y), ease: Cubic.easeInOut});
			}

			TweenLite.to({}, DROP_ANITIME, {onComplete: function():void
			{
				callback();
			}});
		}

		public function addNewGems(newGemList:Vector.<Gem>, callback:Function):void
		{
			var newY:int;
			var view:DisplayObject;
			var maxGemY:int=0;
			var gem:Gem;

			for each (gem in newGemList)
			{
				if (gem.getY() > maxGemY)
					maxGemY=gem.getY();
			}
			for each (gem in newGemList)
			{
				newY=gem.getY();
				view=gem.getView();
				addChild(view);
				view.y=-maxGemY + newY;
				view.alpha=0;
				TweenLite.to(view, ADD_ANITIME, {y: newY, alpha: 1, ease: Cubic.easeOut});
			}

			TweenLite.to({}, ADD_ANITIME, {onComplete: function():void
			{
				callback();
			}});
		}
	}
}
