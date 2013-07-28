package lv.max.bejeweled.bejeweled.gameplay
{
	import lv.max.bejeweled.bejeweled.gems.Gem;
	import lv.max.bejeweled.bejeweled.view.Alert;
	import lv.max.bejeweled.bejeweled.view.MainWindow;
	import lv.max.bejeweled.bejeweled.view.Playground;
	import lv.max.bejeweled.data.GameProperties;

	public class GameDirector
	{
		private var window:MainWindow;
		private var playGround:Playground;
		private var currentLevel:LevelGame;
		private var currentLevelIndex:int;

		private var resizeCallback:Function;

		public function GameDirector(window:MainWindow, playGround:Playground, resizeCallback:Function)
		{
			this.window=window;
			this.playGround=playGround;
			this.resizeCallback=resizeCallback;
		}

		public function start():void
		{
			currentLevelIndex=0;
			startNewLevel();
		}

		public function startNewLevel():void
		{
			window.updateTime(0);
			window.updateScores(0);
			Gem.setMouseEnabledForAll(false);

			if (currentLevel)
			{
				playGround.clearPlayground(currentLevel.getLevelData().getColumnList(), onPlayGroundClearComplete);
			}
			else
			{
				onPlayGroundClearComplete();
			}
		}

		private function onPlayGroundClearComplete():void
		{
			currentLevel=new LevelGame();
			currentLevel.initNewLevel(GameProperties.getInstance().getLevelDataObject(currentLevelIndex), playGround, window);
			resizeCallback(null);
			currentLevel.showInitState(onShowPlaygroundInitStateComplete);
		}

		private function onShowPlaygroundInitStateComplete():void
		{
			currentLevel.startTheGame(onLevelComplete, onGameOver);
			window.startGameTimer();
			Gem.setMouseEnabledForAll(true);
		}

		private function onLevelComplete():void
		{
			window.stopGameTimer();

			if (currentLevelIndex >= GameProperties.getInstance().getLevelCount() - 1)
			{
				new Alert('GAME COMPLETE');
				currentLevelIndex=0;
				startNewLevel();
			}
			else
			{
				new Alert('LEVEL ' + currentLevelIndex + ' COMPLETE');
				currentLevelIndex++;
				startNewLevel();
			}
		}

		private function onGameOver():void
		{
			window.stopGameTimer();
			new Alert('GAME OVER ON LEVEL ' + currentLevelIndex);
			currentLevelIndex=0;
			startNewLevel();
		}


	}
}
