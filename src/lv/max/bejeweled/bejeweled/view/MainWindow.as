package lv.max.bejeweled.bejeweled.view
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;

	public class MainWindow extends Sprite
	{
		private static const DEFAULT_TEXT_HEIGHT:int=32;

		private var scoreTF:TextField=new TextField();
		private var timeTF:TextField=new TextField();
		private var gameTimer:Timer=new Timer(100);
		private var gameStartTime:Number;

		public function MainWindow()
		{
			initTextField(scoreTF);
			initTextField(timeTF);
			gameTimer.addEventListener(TimerEvent.TIMER, onGameTime);

			updateTime(0);
			updateScores(0);
		}

		public function resize(sWidth:int, sHeight:int, pgHeight:int):void
		{
			scoreTF.x=timeTF.x=int((sWidth - scoreTF.width) * .5);
			scoreTF.y=int((((sHeight - pgHeight) / 2) - DEFAULT_TEXT_HEIGHT) / 2);
			timeTF.y=sHeight - scoreTF.y - DEFAULT_TEXT_HEIGHT;
		}

		private function initTextField(tf:TextField):void
		{
			addChild(tf);
			tf.width=300;
			var tFormat:TextFormat=new TextFormat();
			tFormat.color=0xAAAAAA;
			tFormat.size=DEFAULT_TEXT_HEIGHT;
			tFormat.align=TextFormatAlign.CENTER;
			tf.defaultTextFormat=tFormat;
		}

		public function updateScores(value:int):void
		{
			scoreTF.text=value.toString();
		}

		public function updateTime(t:int):void
		{
			var st:int=int(t / 1000 * .5);
			var m:int=st / 60;
			var s:int=st - m * 60;
			var mText:String=String(m > 9 ? m : '0' + m);
			var sText:String=String(s > 9 ? s : '0' + s);
			timeTF.text=mText + ':' + sText;
		}

		public function startGameTimer():void
		{
			gameStartTime=new Date().getTime();
			updateTime(0);
			gameTimer.reset();
			gameTimer.start();
		}

		public function stopGameTimer():void
		{
			gameTimer.stop();
		}

		protected function onGameTime(event:TimerEvent):void
		{
			updateTime(new Date().getTime() - gameStartTime);
		}

	}
}
