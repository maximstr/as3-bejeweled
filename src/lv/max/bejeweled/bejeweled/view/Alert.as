package lv.max.bejeweled.bejeweled.view
{
	import flash.external.ExternalInterface;

	public class Alert
	{
		public function Alert(text:String)
		{
			ExternalInterface.call('alert', text);
		}
	}
}
