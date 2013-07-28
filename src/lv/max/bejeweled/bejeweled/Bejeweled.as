package lv.max.bejeweled.bejeweled
{
	import flash.display.Sprite;
	import flash.events.Event;

	import lv.max.bejeweled.bejeweled.data.GameAssetProvider;
	import lv.max.bejeweled.bejeweled.gameplay.GameDirector;
	import lv.max.bejeweled.bejeweled.gems.GemFactory;
	import lv.max.bejeweled.bejeweled.view.MainWindow;
	import lv.max.bejeweled.bejeweled.view.Playground;
	import lv.max.bejeweled.data.GameProperties;

	public class Bejeweled
	{
		private var root:Sprite;
		private var window:MainWindow;
		private var playGround:Playground;

		private var director:GameDirector;


		public function Bejeweled(root:Sprite, assetClassMap:Array)
		{
			this.root=root;

			initGUI();
			initData(assetClassMap);
			startTheGame();

			root.stage.addEventListener(Event.RESIZE, onStageResize);
			onStageResize(null);
		}

		private function initGUI():void
		{
			window=new MainWindow();
			root.addChild(window);
			playGround=new Playground();
			root.addChild(playGround);
		}

		private function initData(assetClassMap:Array):void
		{
			GameAssetProvider.getInstance().setAssetMap(assetClassMap);
			GemFactory.getInstance().setColorMap(GameProperties.getInstance().getProperties().gem_colors);
			director=new GameDirector(window, playGround, onStageResize);
		}

		private function startTheGame():void
		{
			director.start();
		}

		private function onStageResize(e:Event):void
		{
			var swidth:int=root.stage.stageWidth;
			var sheight:int=root.stage.stageHeight;

			if (playGround)
			{
				var pwidth:int=playGround.getWidth();
				var pheight:int=playGround.getHeight();
				var pscale:Number=Math.min((swidth * .6) / pwidth, (sheight * .6) / pheight);

				var pgWidth:int=pwidth * pscale;
				var pgHeight:int=pheight * pscale;

				playGround.scaleX=playGround.scaleY=pscale;
				playGround.x=int((swidth - pgWidth) * .5);
				playGround.y=int((sheight - pgHeight) * .5);

				if (window)
				{
					window.resize(swidth, sheight, pgHeight);
				}
			}
		}

	}
}
