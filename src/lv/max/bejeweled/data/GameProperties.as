package lv.max.bejeweled.data
{
	import com.adobe.serialization.json.JSON;

	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class GameProperties extends EventDispatcher
	{
		public static const COMPLETE_EVENT:String="GameProperties-COMPLETE_EVENT";
		public static const LOAD_ERROR_EVENT:String="GameProperties-LOAD_ERROR_EVENT";

		private static var instance:GameProperties;

		private var gameProperties:Object; //NOPMD

		public function GameProperties(lock:SingletonBlocker)
		{
			lock;
		}

		public static function getInstance():GameProperties
		{
			if (instance == null)
			{
				instance=new GameProperties(new SingletonBlocker());
			}
			return instance;
		}

		public function load(url:String):void
		{
			var loader:URLLoader=new URLLoader();
			configureListeners(loader);

			var request:URLRequest=new URLRequest(url);
			try
			{
				loader.load(request);
			}
			catch (error:Error)
			{
				dispatchEvent(new Event(AssetsProvider.LOAD_ERROR_EVENT));
			}
		}

		public function getProperties():Object //NOPMD
		{
			if (gameProperties)
			{
				return gameProperties;
			}
			else
			{
				throw new IllegalOperationError("gameProperties aren't ready");
			}
		}

		public function getLevelDataObject(levelIndex:int):Object //NOPMD
		{
			return gameProperties.levels[levelIndex];
		}

		public function getLevelCount():int
		{
			return gameProperties.levels.length;
		}

		private function configureListeners(dispatcher:IEventDispatcher):void //NOPMD
		{
			dispatcher.addEventListener(Event.COMPLETE, onComplete);
			dispatcher.addEventListener(Event.OPEN, onOpen);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, onProgress);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
		}

		private function onComplete(event:Event):void
		{
			var loader:URLLoader=URLLoader(event.target);
			this.gameProperties=JSON.decode(loader.data, false);

			dispatchEvent(new Event(GameProperties.COMPLETE_EVENT));
		}

		private function onOpen(event:Event):void
		{
			trace("openHandler: " + event);
		}

		private function onProgress(event:ProgressEvent):void
		{
			trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
		}

		private function onSecurityError(event:SecurityErrorEvent):void
		{
			dispatchEvent(new Event(GameProperties.LOAD_ERROR_EVENT));
		}

		private function onHttpStatus(event:HTTPStatusEvent):void
		{
			trace("httpStatusHandler: " + event);
		}

		private function onIoError(event:IOErrorEvent):void
		{
			dispatchEvent(new Event(GameProperties.LOAD_ERROR_EVENT));
		}

	}
}

internal class SingletonBlocker
{
}
