package lv.max.bejeweled.data
{
	import flash.display.Loader;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	public class AssetsProvider extends EventDispatcher
	{
		public static const COMPLETE_EVENT:String="AssetsProvider-COMPLETE_EVENT";
		public static const LOAD_ERROR_EVENT:String="AssetsProvider-LOAD_ERROR_EVENT";

		private static var instance:AssetsProvider;

		private var loader:Loader;
		private var swfLib:String;
		private var request:URLRequest;

		public function AssetsProvider(block:SingletonBlocker) //NOPMD
		{
		}

		public static function getInstance():AssetsProvider
		{
			if (instance == null)
			{
				instance=new AssetsProvider(new SingletonBlocker());
			}
			return instance;
		}

		public function load(url:String):void
		{
			if (swfLib == null)
			{
				loader=new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
				loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);

				swfLib=url;
				request=new URLRequest(swfLib);
				var context:LoaderContext=new LoaderContext();
				context.applicationDomain=ApplicationDomain.currentDomain;
				loader.load(request, context);
			}
			else
			{
				throw new IllegalOperationError(swfLib + " allready loaded");
			}
		}

		public function getClass(className:String):Class
		{
			var assetClass:Class=null;
			try
			{
				assetClass=loader.contentLoaderInfo.applicationDomain.getDefinition(className) as Class;
			}
			catch (e:Error)
			{
				throw new IllegalOperationError(className + " definition not found in " + swfLib);
			}
			return assetClass;
		}

		private function onComplete(e:Event):void
		{
			dispatchEvent(new Event(AssetsProvider.COMPLETE_EVENT));
		}

		private function onIoError(e:Event):void
		{
			dispatchEvent(new Event(AssetsProvider.LOAD_ERROR_EVENT));
		}

		private function onSecurityError(e:Event):void
		{
			dispatchEvent(new Event(AssetsProvider.LOAD_ERROR_EVENT));
		}

	}
}

internal class SingletonBlocker
{
}
