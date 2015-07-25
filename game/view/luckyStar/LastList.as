package game.view.luckyStar
{
	import com.cache.Pool;
	import com.mvc.interfaces.INotification;
	import com.view.View;
	
	import flash.utils.getTimer;
	
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.TiledRowsLayout;
	
	import game.dialog.ShowLoader;
	import game.net.GameSocket;
	import game.net.data.IData;
	import game.net.data.c.CLuck_rebate;
	import game.net.data.s.SLuck_rebate;
	
	import starling.core.Starling;
	
	public class LastList extends View
	{
		private static var time:int = 0;
		private static var quitTime:int ;
		private static var list:Vector.<IData>;
		public function LastList()
		{
			super();
			createList();
			/*if(time > 0)
				time = time - (quitTime - getTimer()/1000);
			if(time < 0 )time = 0;
			if(time == 0)
			{
			
			}*/
			/*else 
			{*/
//				update();
//			}
			send();
		}
		private function send():void
		{
			var cmd:CLuck_rebate = new CLuck_rebate;
			GameSocket.instance.sendData(cmd);
			ShowLoader.add();
		}
		private var isUpdate:Boolean;
		private function update():void
		{
			if(isUpdate)return;
			time --;
			if(time > 0)
				Starling.juggler.delayCall(update,1);
//			else send();
		}
		
		override public function handleNotification(_arg1:INotification):void
		{
			var rebate:SLuck_rebate = _arg1 as SLuck_rebate;
			
//			time = 3000;
			list = rebate.recent;
			restItemRender(rebate.recent);
			ShowLoader.remove();
//			update();
		}
		
		private var _list:List;
		
		
		private function createList():void
		{
			const listLayout:TiledRowsLayout=new TiledRowsLayout();
			listLayout.gap=1;
			listLayout.useSquareTiles=false;
			listLayout.useVirtualLayout=true;
			
			listLayout.tileVerticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_TOP;
			listLayout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
			_list = new List;
			_list.x = 617;
			_list.y = 509;
			_list.width = 305;
			_list.height = 111;
			_list.layout = listLayout;
			_list.paddingTop = 1;
			
			/*_list.addEventListener(Event.CHANGE,onSelect);*/
			_list.itemRendererFactory=tileListItemRendererFactory;
			addChild(_list);
		}
		
		private function restItemRender( dataList:Vector.<IData>):void
		{
			const collection:ListCollection = new ListCollection(dataList);
			_list.dataProvider = collection;
		}
		
		private function tileListItemRendererFactory():IListItemRenderer
		{
			var renderer:LastItemRender = Pool.getObj(LastItemRender);
			if(!renderer)
				renderer = new LastItemRender();
			
			return renderer;
		}
		
		
		
		override public function listNotificationName():Vector.<String>
		{
			var vect:Vector.<String> = new Vector.<String>;
			vect.push(SLuck_rebate.CMD);
			return vect;
		}
		override public function dispose():void
		{
			isUpdate = true;
			quitTime = getTimer();
			Pool.delObjs(LastItemRender);
			super.dispose();
		}
		
	}
}
import com.cache.Pool;

import feathers.controls.renderers.DefaultListItemRenderer;

import game.data.Goods;
import game.data.LuckyStarData;
import game.data.WidgetData;
import game.net.data.vo.RebateRank;
import game.view.luckyStar.LastItemBase;
import game.view.luckyStar.StarData;

class LastItemRender extends DefaultListItemRenderer
{
	private var skin:LastItemBase = new LastItemBase;
	public function LastItemRender()
	{
		defaultSkin = skin;
		setSize(299,36);
		skin.nameTxt.fontName = skin.awardTxt.fontName = "方正综艺简体";
	}
	
	override public function set data(value:Object):void
	{
		if(!value)return;
		skin.nameTxt.text = (value as RebateRank).name;
		var id:int = (value as RebateRank).reward_id;
		var vect:Vector.<LuckyStarData>  = StarData.instance.goodsList;
		
		if(id == 1)
		{
			skin.awardTxt.text  = "金币  x " + (value as RebateRank).reward_num;
		}
		else if(id == 2)
		{
			skin.awardTxt.text  = "钻石  x " + (value as RebateRank).reward_num;
		}
		else if(id == 3 )
		{
			skin.awardTxt.text  = "钻石返利  x " + (value as RebateRank).reward_num;
		}
		else if(id == 5)
		{
			skin.awardTxt.text  = "英雄  x " + (value as RebateRank).reward_num;
		}
		else 
		{
			var widget:WidgetData = new WidgetData(Goods.goods.getValue(id));
			
			skin.awardTxt.text  = widget.name + " x " + (value as RebateRank).reward_num;
		}
		super.data = value;
	}
	
	public function customDispose():void {
		_isDispose = true;
	}
	
	private var _isDispose:Boolean;
	
	override public function dispose():void
	{
		if (_isDispose) {
			super.dispose();
		}
		else {
			Pool.setObj(this)
		}
	}
	
	
}