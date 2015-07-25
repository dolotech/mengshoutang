package game.view.arena
{
	import com.dialog.DialogMgr;
	import com.view.View;
	
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.TiledRowsLayout;
	
	import game.view.uitils.DisplayMemoryMrg;
	
	import starling.events.Event;

	/**
	 * 
	 * 物品兑换list
	 * @author litao
	 * 
	 */	
	public class ConvertList extends View
	{
		public function ConvertList()
		{
			super();
			
			
		}
		public function creatList(type:String,dataList:Array):void
		{
			var list:List ;
			
			if(numChildren > 0 )
				list  = getChildAt(0) as List;
			
			list && list.removeFromParent();
			
			list = DisplayMemoryMrg.instance.getMemory(type,List) as List;
			setList(list,dataList);
		}
		

		
		private function setList(list:List,dataList:Array):void
		{
			if(!list.dataProvider )
			{
				const listLayout:TiledRowsLayout=new TiledRowsLayout();
				listLayout.gap=20;
				listLayout.useSquareTiles=false;
				listLayout.useVirtualLayout=true;
                listLayout.paddingTop = 12;
				listLayout.tileVerticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_TOP;
				listLayout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
				
				list.x = 30;
				list.y = 175;
				list.width = 780;
				list.height = 388;
				list.layout = listLayout;
				list.addEventListener(Event.CHANGE,onSelect);
				list.itemRendererFactory=tileListItemRendererFactory;
				refreshHeroList(list,dataList);
			}
			addChild(list);
		}
		
		private var _id:int;
		//兑换物品
		private function onSelect(e:Event):void
		{
			if(List(e.currentTarget).selectedIndex == -1)return;
//			if(List(e.currentTarget).selectedItem.widget.tab == 5)
//				DialogMgr.instance.open(ConvertEquipDlg,{widget:List(e.currentTarget).selectedItem.widget,money:List(e.currentTarget).selectedItem.price});
			  DialogMgr.instance.open(ConvertPropsDlg,{widget:List(e.currentTarget).selectedItem.widget,money:List(e.currentTarget).selectedItem.price});
		
			
			
			List(e.currentTarget).selectedIndex = -1;
		}

		private function refreshHeroList(list:List , dataList:Array):void
		{
			const collection:ListCollection = new ListCollection(dataList);
			list.dataProvider = collection;
		}
		
		private function tileListItemRendererFactory():IListItemRenderer
		{
			const renderer:converItemRender = new converItemRender();
			return renderer;
		}
		
		override public function dispose():void
		{
			DisplayMemoryMrg.instance.removeToFirstName("Convert");
			super.dispose();
		}
	}
}
import com.utils.ObjectUtil;

import game.data.WidgetData;
import game.manager.AssetMgr;
import game.view.arena.base.ConvertGoodsBase;
import game.view.widget.BagWidget;

class converItemRender extends ConvertGoodsBase	
{
	private var widget:BagWidget;
	public function converItemRender()
	{
		super();
		setSize(125,169);
		widget = new BagWidget();
		boxButton.addChild(widget);
	}
	private var widgetData:WidgetData;
	private var _price:int;
	override public function set data(value:Object):void
	{
		if(!value)return;
		widgetData = value.widget as WidgetData;
		_price = value.price;
		boxButton.upState = AssetMgr.instance.getTexture("ui_gongyong_90wupingkuang" + (widgetData.quality - 1));
		boxButton.upState = AssetMgr.instance.getTexture("ui_gongyong_90wupingkuang" + (widgetData.quality-1));
		boxButton.downState = boxButton.upState;
		widget.setWidgetData(widgetData);
		ObjectUtil.setToCenter(boxButton .getChildAt(0), widget);
		priceTxt.text = _price + "";
		nameTxt.text = widgetData.name;
		super.data = value;
	}
	
	override public function dispose():void
	{
		widget&&widget.dispose();
		super.dispose();
    }
}
