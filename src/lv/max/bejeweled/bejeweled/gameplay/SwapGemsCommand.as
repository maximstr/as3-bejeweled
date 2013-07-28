package lv.max.bejeweled.bejeweled.gameplay
{
	import lv.max.bejeweled.bejeweled.gems.Gem;
	import lv.max.bejeweled.bejeweled.gems.GemPositionUpdate;
	import lv.max.bejeweled.bejeweled.view.Playground;

	public class SwapGemsCommand
	{
		private var levelData:LevelData;
		private var playGround:Playground;
		private var swapCompleteCallback:Function;
		private var gemRemoveCallback:Function;
		private var gem1:Gem;
		private var gem2:Gem;
		private var scoreGained:int=0;

		public function SwapGemsCommand(levelData:LevelData, playGround:Playground, swapCompleteCallback:Function, gemRemoveCallback:Function)
		{
			this.levelData=levelData;
			this.playGround=playGround;
			this.swapCompleteCallback=swapCompleteCallback;
			this.gemRemoveCallback=gemRemoveCallback;
		}

		public function swap(gem1:Gem, gem2:Gem):void
		{
			this.gem1=gem1;
			this.gem2=gem2;

			gem1.swapColRow(gem2);
			playGround.swapGems(gem1, gem2, onGemSwapComplete);
		}

		private function onGemSwapComplete():void
		{
			if (!checkForWinLines())
			{
				playGround.swapGems(gem1, gem2, onGemSwapBackComplete);
				gem1.swapColRow(gem2);
			}
		}

		private function checkForWinLines():Boolean
		{
			var winList:Vector.<Vector.<Gem>>=levelData.getWinCombinationList();
			var currentScores:int=scoreGained;
			var j:int;
			if (winList.length > 0)
			{
				var removeList:Vector.<Gem>=new Vector.<Gem>();
				for each (var gemList:Vector.<Gem> in winList)
				{
					removeList=removeList.concat(gemList);
					j=gemList.length;
					while (j--)
					{
						currentScores=currentScores == 0 ? 10 : currentScores * 1.9;
					}
				}
				levelData.removeGems(removeList);
				playGround.removeGems(removeList, onGemRemove);

				gemRemoveCallback(currentScores);
				scoreGained+=currentScores;
				return true;
			}

			return false;
		}

		private function onGemRemove():void
		{
			var updatePosList:Vector.<GemPositionUpdate>=levelData.getGemPositionUpdateList();
			if (updatePosList.length > 0)
			{
				playGround.dropGems(updatePosList, onGemDropped);
			}
			else
			{
				fillGemGaps();
			}
		}

		private function onGemDropped():void
		{
			if (!checkForWinLines())
			{
				fillGemGaps();
			}
		}

		private function fillGemGaps():void
		{
			var newGemList:Vector.<Gem>=levelData.fillGemGaps();
			playGround.addNewGems(newGemList, onNewGemAddedToField);
		}

		private function onNewGemAddedToField():void
		{
			if (!checkForWinLines())
			{
				swapCompleteCallback();
			}
		}

		private function onGemSwapBackComplete():void
		{
			swapCompleteCallback();
		}
	}
}
