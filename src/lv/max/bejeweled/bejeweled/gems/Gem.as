package lv.max.bejeweled.bejeweled.gems
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;

	public class Gem
	{
		public static const GEM_GAP:int=2;
		public static const GEM_WIDTH:int=32;
		public static const GEM_HEIGHT:int=32;

		private var gemType:int=0;
		private var view:DisplayObject;

		private var gemMouseEnabled:Boolean=true;
		private static var allMouseEnabled:Boolean=true;
		private static var clickCallback:Function;
		private static var overCallback:Function;
		private static var outCallback:Function;
		private var col:int;
		private var row:int;

		public function Gem(gemType:int, movie:DisplayObject)
		{
			this.gemType=gemType;
			this.view=movie;

			view.addEventListener(MouseEvent.CLICK, onClick);
			view.addEventListener(MouseEvent.MOUSE_OVER, onOver)
			view.addEventListener(MouseEvent.MOUSE_OUT, onOut)
		}

		private function onClick(event:MouseEvent):void
		{
			if (allMouseEnabled && gemMouseEnabled && clickCallback != null)
			{
				clickCallback(this);
			}
		}

		private function onOver(event:MouseEvent):void
		{
			if (allMouseEnabled && gemMouseEnabled && overCallback != null)
			{
				overCallback(this);
			}
		}

		private function onOut(event:MouseEvent):void
		{
			if (allMouseEnabled && gemMouseEnabled && outCallback != null)
			{
				outCallback(this);
			}
		}

		public function getGemType():int
		{
			return gemType;
		}

		public function setCol(value:int, updatePosition:Boolean=true):void
		{
			this.col=value;
			if (updatePosition)
			{
				view.x=value * (GEM_WIDTH + GEM_GAP) + GEM_WIDTH / 2;
			}
		}

		public function setColByPosition(value:int):void
		{
			this.col=int((value - GEM_WIDTH / 2) / (GEM_WIDTH + GEM_GAP));
		}

		public function getCol():int
		{
			return col;
		}

		public function setRow(value:int, updatePosition:Boolean=true):void
		{
			this.row=value;
			if (updatePosition)
			{
				view.y=value * (GEM_HEIGHT + GEM_GAP) + GEM_HEIGHT / 2;
			}
		}

		public function setRowByPosition(value:int):void
		{
			this.col=int((value - GEM_HEIGHT / 2) / (GEM_HEIGHT + GEM_GAP));
		}

		public function getRow():int
		{
			return row;
		}

		public function getX():int
		{
			return view.x;
		}

		public function getY():int
		{
			return view.y;
		}

		public function getView():DisplayObject
		{
			return view;
		}

		public function get mouseEnabled():Boolean
		{
			return gemMouseEnabled;
		}

		public function set mouseEnabled(value:Boolean):void
		{
			gemMouseEnabled=value;
		}

		public function showSelectedState():void
		{
			mouseEnabled=false;
			view.filters=[new GlowFilter(0xFFFFFF, 1, 6, 6, 10, 2)];
		}

		public function hideSelectedState():void
		{
			mouseEnabled=true;
			view.filters=[];
		}

		public static function setMouseEnabledForAll(value:Boolean):void
		{
			allMouseEnabled=value;
		}

		public static function setClickCallback(callback:Function):void
		{
			Gem.clickCallback=callback;
		}

		public static function setOverCallback(callback:Function):void
		{
			Gem.overCallback=callback;
		}

		public static function setOutCallback(callback:Function):void
		{
			Gem.outCallback=callback;
		}

		public static function calculateXPosByCol(col:int):int
		{
			return col * (GEM_WIDTH + GEM_GAP) + GEM_WIDTH / 2;
		}

		public static function calculateYPosByRow(row:int):int
		{
			return row * (GEM_HEIGHT + GEM_GAP) + GEM_HEIGHT / 2;
		}

		public function isSwapableWith(anotherGem:Gem):Boolean
		{
			var vDist:int=Math.abs(getCol() - anotherGem.getCol());
			var hDist:int=Math.abs(getRow() - anotherGem.getRow());

			return vDist + hDist == 1;
		}

		public function clonePosition(anotherGem:Gem):void
		{
			setCol(anotherGem.getCol());
			setRow(anotherGem.getRow());
		}

		public function getGemPosition():Point
		{
			return new Point(getCol(), getRow());
		}

		public function swapColRow(gem:Gem):void
		{
			var thisCol:int=this.getCol();
			var thisRow:int=this.getRow();
			this.setCol(gem.getCol(), false);
			this.setRow(gem.getRow(), false);
			gem.setCol(thisCol, false);
			gem.setRow(thisRow, false);
		}

		public function toString():String
		{
			return gemType + '[' + getCol() + ':' + getRow() + ']';
		}
	}
}
