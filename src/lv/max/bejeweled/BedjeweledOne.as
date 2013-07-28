package lv.max.bejeweled
{
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.ScalePlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.ui.ContextMenu;
	
	import lv.max.bejeweled.bejeweled.Bejeweled;
	import lv.max.bejeweled.data.AssetsProvider;
	import lv.max.bejeweled.data.GameProperties;
	
	import org.casalib.util.FlashVarUtil;
	import org.casalib.util.StageReference;

	[SWF(frameRate="30", backgroundColor="#0")]
	public class BedjeweledOne extends Sprite
	{

		public function BedjeweledOne()
		{
			stage.scaleMode=StageScaleMode.NO_SCALE;
			stage.align=StageAlign.TOP_LEFT;

			var menu:ContextMenu=new ContextMenu();
			menu.hideBuiltInItems();
			contextMenu=menu;

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(e:Event):void
		{
			StageReference.setStage(stage);

			var propertiesUrl:String=FlashVarUtil.hasKey('properties') ? FlashVarUtil.getValue('properties') : 'bejeweled.json';
			var gameProperties:GameProperties=GameProperties.getInstance();
			gameProperties.addEventListener(GameProperties.LOAD_ERROR_EVENT, onPropertiesError);
			gameProperties.addEventListener(GameProperties.COMPLETE_EVENT, onPropertiesCompelete);
			gameProperties.load(propertiesUrl);
		}

		private function onPropertiesError(e:Event):void
		{
			throw new IllegalOperationError("game properties loading error");
		}

		private function onPropertiesCompelete(e:Event):void
		{
			var assetsUrl:String=FlashVarUtil.hasKey('assets') ? FlashVarUtil.getValue('assets') : 'assets.swf';
			var assetsProvider:AssetsProvider=AssetsProvider.getInstance();
			assetsProvider.addEventListener(AssetsProvider.LOAD_ERROR_EVENT, onAssetsError);
			assetsProvider.addEventListener(AssetsProvider.COMPLETE_EVENT, onAssetsCompelete);
			assetsProvider.load(assetsUrl);

			//todo: show preloader
		}

		private function onAssetsError(e:Event):void
		{
			throw new IllegalOperationError("assets loading error");
		}

		private function onAssetsCompelete(e:Event):void
		{
			TweenPlugin.activate([ScalePlugin, AutoAlphaPlugin]);

			new Bejeweled(this, prepareAssetMap());
		}

		private function prepareAssetMap():Array
		{
			var assetMap:Array=[];
			assetMap['GM0']=AssetsProvider.getInstance().getClass('GM0');
			assetMap['GM1']=AssetsProvider.getInstance().getClass('GM1');
			assetMap['GM2']=AssetsProvider.getInstance().getClass('GM2');
			assetMap['GM3']=AssetsProvider.getInstance().getClass('GM3');
			assetMap['GM4']=AssetsProvider.getInstance().getClass('GM4');
			assetMap['GM5']=AssetsProvider.getInstance().getClass('GM5');
			assetMap['GM6']=AssetsProvider.getInstance().getClass('GM6');
			assetMap['GM7']=AssetsProvider.getInstance().getClass('GM7');
			assetMap['GM8']=AssetsProvider.getInstance().getClass('GM8');
			assetMap['GM9']=AssetsProvider.getInstance().getClass('GM9');
			assetMap['GM10']=AssetsProvider.getInstance().getClass('GM10');
			assetMap['GM11']=AssetsProvider.getInstance().getClass('GM11');
			return assetMap;
		}
	}
}
