package game.view.arena
{
	import com.langue.Langue;
	import com.view.View;
	
	import game.data.Convert;
	import game.data.Goods;
	import game.data.WidgetData;
	import game.manager.AssetMgr;
	import game.view.comm.menu.MenuButton;
	import game.view.comm.menu.MenuFactory;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import starling.events.Event;

	/**
	 * 竞技场,物品兑换
	 * @author litao
	 * 
	 */	
	public class ConvertFace extends View 
	{
		
		private var list:ConvertList;
		public function ConvertFace()
		{

			super();
			createGoodsData();
			createMenu();
			list = new ConvertList;
			list.creatList("Convert1",List1);
			addChild(list);
		}
		
		private function createMenu():void
		{
			var onFocus:ISignal = new Signal();
			var factory:MenuFactory = new MenuFactory;
		
			factory.onFocus = onFocus;
			var arr:Array = Langue.getLans("arenaMenuText");
			var asset:AssetMgr = AssetMgr.instance;
            const positonX:int = 813;
			factory.factory([
				{"defaultSkin":asset.getTexture("ui_button_hechenganjian_tu1"),"downSkin":asset.getTexture("ui_button_hechenganjian1"),x:positonX,y:197,onClick:onSelect,name:"1",isSelect:true,scale:0.7},
				{"defaultSkin":asset.getTexture("ui_button_hechenganjian_shipin_tu3"),"downSkin":asset.getTexture("ui_button_hechenganjian_shipin3"),x:positonX,y:268,onClick:onSelect,name:"2",scale:0.7},
				{"defaultSkin":asset.getTexture("ui_button_hechenganjian_shipin_tu2"),"downSkin":asset.getTexture("ui_button_hechenganjian_shipin2"),x:positonX,y:338,onClick:onSelect,name:"3",scale:0.7},
				{"defaultSkin":asset.getTexture("ui_button_hechenganjian_shipin_tu1"),"downSkin":asset.getTexture("ui_button_hechenganjian_shipin1"),x:positonX,y:410,onClick:onSelect,name:"4",scale:0.7},
				{"defaultSkin":asset.getTexture("ui_button_hechenganjian_cailiao_tu"),"downSkin":asset.getTexture("ui_button_hechenganjian_cailiao"),x:positonX,y:479,onClick:onSelect,name:"5",scale:0.7},
			]);
			
			addChild(factory);
		}
		
		private var List1:Array = [];
		private var List2:Array = [];
		private var List4:Array = [];
		private var List3:Array = [];
		private var List5:Array = [];
		
		
		private function createGoodsData():void
		{
			var vect:Vector.<*> = Convert.hash.values();
			var widget:WidgetData ;
			for (var i:int = 0 ; i < vect.length ; i ++)
			{
				widget = new WidgetData(Goods.goods.getValue((vect[i] as Convert).id));
				if(widget.tab == 5)
				{
					if(widget.seat == 1)
					{
						List1.push({widget:widget,price:(vect[i] as Convert).price});
					}
					else if(widget.seat == 4)
					{
						List2.push({widget:widget,price:(vect[i] as Convert).price});
					}
					else if(widget.seat == 2)
					{
						List3.push({widget:widget,price:(vect[i] as Convert).price});
					}
					else if(widget.seat == 3)
					{
						List4.push({widget:widget,price:(vect[i] as Convert).price});
					}
				}
				else if(widget.tab == 1 || widget.tab == 2)
				{
					List5.push({widget:widget,price:(vect[i] as Convert).price});
				}
			}
			List1.sortOn(["price"],Array.NUMERIC);
			List2.sortOn(["price"],Array.NUMERIC);
			List3.sortOn(["price"],Array.NUMERIC);
			List4.sortOn(["price"],Array.NUMERIC);
			List5.sortOn(["price"],Array.NUMERIC);
		}
		
		private function onSelect(e:Event):void
		{
			var name:String = (e.target as MenuButton).name;
			list.creatList("Convert"+name,this["List" + name]);
		}
		
		override public function dispose():void
		{
			list && list.dispose();
			super.dispose();
		}
		
	}
}