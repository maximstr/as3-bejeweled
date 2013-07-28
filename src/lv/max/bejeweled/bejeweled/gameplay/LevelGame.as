/**
 * Created by IntelliJ IDEA.
 * User: max
 * Date: 8/21/11
 * Time: 9:21 PM
 * To change this template use File | Settings | File Templates.
 */
package lv.max.bejeweled.bejeweled.gameplay
{
	import lv.max.bejeweled.bejeweled.gems.Gem;
	import lv.max.bejeweled.bejeweled.view.MainWindow;
	import lv.max.bejeweled.bejeweled.view.Playground;

	public class LevelGame
	{
		private var window:MainWindow;
		private var levelProperties:Object; //NOPMD
		private var playGround:Playground;
		private var levelData:LevelData;

		private var selectedGemList:Vector.<Gem>=new Vector.<Gem>();
		private var levelCompleteCallback:Function;
		private var gameOverCallback:Function;

		private var scores:int=0;

		public function LevelGame()
		{
		}

		public function initNewLevel(levelProperties:Object, playGround:Playground, window:MainWindow):void //NOPMD
		{
			this.levelProperties=levelProperties;
			this.playGround=playGround;
			this.window=window;

			Gem.setClickCallback(onGemClick);
			Gem.setOverCallback(onGemOver);
			Gem.setOutCallback(onGemOut);

			var colCount:int=levelProperties.playGroundSize.height;
			var rowCount:int=levelProperties.playGroundSize.width;
			levelData=new LevelData(colCount, rowCount, Vector.<int>(levelProperties.gems as Array));
			levelData.generateNewGemSet();

			playGround.setPlaygroundSize(colCount, rowCount);
		}

		public function startTheGame(levelCompleteCallback:Function, gameOverCallback:Function):void
		{
			this.levelCompleteCallback=levelCompleteCallback;
			this.gameOverCallback=gameOverCallback;
		}

		public function showInitState(onShowPlaygroundInitStateComplete:Function):void
		{
			playGround.showGems(levelData.getColumnList(), onShowPlaygroundInitStateComplete);
		}

		private function onGemSwapComplete():void
		{
			if (levelData.isGameOverState())
			{
				gameOverCallback();
			}
			else
			{
				if (scores >= levelProperties.scores)
				{
					levelCompleteCallback();
				}
				else
				{
					selectedGemList[0].hideSelectedState();
					selectedGemList[1].hideSelectedState();
					selectedGemList.splice(0, selectedGemList.length);
					Gem.setMouseEnabledForAll(true);
				}
			}
		}

		private function onGemsRemove(newScores:int):void
		{
			scores+=newScores;
			window.updateScores(scores);
		}

		private function onGemClick(gem:Gem):void
		{
			if (selectedGemList.length > 0)
			{
				if (selectedGemList[0].isSwapableWith(gem))
				{
					Gem.setMouseEnabledForAll(false);
					gem.showSelectedState();
					selectedGemList.push(gem);
					new SwapGemsCommand(levelData, playGround, onGemSwapComplete, onGemsRemove).swap(selectedGemList[0], selectedGemList[1]);
				}
				else
				{
					selectedGemList[0].hideSelectedState();
					selectedGemList.splice(0, selectedGemList.length);
				}
			}
			else
			{
				gem.showSelectedState();
				selectedGemList.push(gem);
			}
		}

		private function onGemOver(gem:Gem):void
		{
			; //trace(gem.toString());
		}

		private function onGemOut(gem:Gem):void
		{
			; //trace(gem.toString());
		}

		public function getLevelData():LevelData
		{
			return this.levelData;
		}

	}
}
