package game.view.PVP
{
	import com.langue.Langue;
	
	import feathers.core.PopUpManager;
	
	import game.data.JTPvpNewRuleData;
	import game.view.viewBase.JTPvpRegulationComponentBase;

	/**
	 * 规则面板
	 * @author CabbageWrom
	 * 
	 */	
	public class JTPvpRegulationComponent extends JTPvpRegulationComponentBase
	{
		private static var instance:JTPvpRegulationComponent = null;
		public function JTPvpRegulationComponent()
		{
			super();
			initialize();
		}
		
		override public function showBackground(isClickColse:Boolean=false, x:Number=0, y:Number=0, maxWidth:Number=0, maxHeight:Number=0):void
		{
			super.showBackground(true);
		}
		
		override protected function onCloseBackground():void
		{
			//(this.parent as JTPvpComponent).menu_bars2.selectedButton.selected = false;
			close();
		}
		
		private function initialize():void
		{
			var regulatDatas:Vector.<*> = JTPvpNewRuleData.hash.values();
			var i:int = 0;
			var l:int = regulatDatas.length;
			var index:int = 0;
			var lines:Array = Langue.getLans("pvp_re");
			for (i = 0; i < l; i++)
			{
				var pvpRegulaData:JTPvpNewRuleData = regulatDatas[i] as JTPvpNewRuleData;
				this["txt_value" + i].text =  pvpRegulaData.title1;
				this["txt_name" + i].text = pvpRegulaData.total_num.toString();
			}
		}		
		
		public static function open():void
		{
			if (!instance)
			{
				instance = PopUpManager.addPopUp(new JTPvpRegulationComponent(), false) as JTPvpRegulationComponent;
			}
		}
		
		public static function close():void
		{
			if (instance)
			{
				PopUpManager.removePopUp(instance, true);
				instance.dispose();
				instance = null;
			}
		}
	}
}