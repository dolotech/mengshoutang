package game.view.luckyStar
{
	import com.cache.Pool;
	import com.langue.Langue;
	import com.mvc.interfaces.INotification;
	import com.view.View;
	
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.TiledRowsLayout;
	
	import game.dialog.ShowLoader;
	import game.manager.AssetMgr;
	import game.net.GameSocket;
	import game.net.data.IData;
	import game.net.data.c.CLuck_rank;
	import game.net.data.s.SLuck_rank;
	import game.view.comm.menu.MenuFactory;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import starling.events.Event;
	
	public class RichList extends View
	{
		private var _type:int;
		public function RichList()
		{
			super();
			createMenu();
			createList();
			send();
		}
		private function send(type:int = 0):void
		{
			var cmd:CLuck_rank = new CLuck_rank;
			cmd.type = type;
			_type = type;
			GameSocket.instance.sendData(cmd);
			ShowLoader.add();
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
			_list.x = 612;
			_list.y = 165;
			_list.width = 320;
			_list.height = 275;
			_list.layout = listLayout;
			_list.paddingTop = 1;
			
			/*_list.addEventListener(Event.CHANGE,onSelect);*/
			_list.itemRendererFactory=tileListItemRendererFactory;
			addChild(_list);
		}
		
		private function restItemRender( dataList:Vector.<IData>):void
		{
			dataList.unshift(null);
			const collection:ListCollection = new ListCollection(dataList);
			_list.dataProvider = collection;
		}
		
		private function tileListItemRendererFactory():IListItemRenderer
		{
			var  renderer:RichItemRender = Pool.getObj(RichItemRender);
			if(!renderer)
				renderer = new RichItemRender();
			
			return renderer;
		}
		
		
		
		private function createMenu():void
		{
			var onFocus:ISignal = new Signal();
			var factory:MenuFactory = new MenuFactory;
			
			factory.onFocus = onFocus;
			var arr:Array = Langue.getLans("arenaMenuText");
			var asset:AssetMgr = AssetMgr.instance;
			factory.factory([
				{"defaultSkin":asset.getTexture("ui_butten_zhoubang"),x:622,y:122,name:"1",isSelect:true,size:32,color:0xffffff,text:"本期",onClick:onSelectCurrent},
				{"defaultSkin":asset.getTexture("ui_butten_zhoubang"),x:772,y:122,name:"2",size:32,color:0xffffff,text:"总榜",onClick:onSelectTotal},
			]);
			addChild(factory);
		}
		
		private function onSelectCurrent(e:Event):void
		{
			if(_type == 1)
				send();
		}
		
		private function onSelectTotal(e:Event):void
		{
			if(_type == 0)
				send(1);
		}
		
		override public function dispose():void
		{
			_list && _list.dispose();
			Pool.delObjs(RichItemRender);
			super.dispose();
		}
		
		
		override public function handleNotification(_arg1:INotification):void
		{

			var ran:SLuck_rank = _arg1 as SLuck_rank;
			if(_type == 0)
			{
			
				restItemRender(ran.recent);
			}
			else if(_type == 1)
			{
				restItemRender(ran.recent);
			}
			ShowLoader.remove();
		}
		
		override public function listNotificationName():Vector.<String>
		{
			var vect:Vector.<String> = new Vector.<String>;
			vect.push(SLuck_rank.CMD);
			return vect;
		}
		
	}
}
import com.cache.Pool;

import feathers.controls.renderers.DefaultListItemRenderer;

import game.net.data.vo.LuckRank;
import game.view.luckyStar.RichItemBase;

class RichItemRender extends DefaultListItemRenderer
{
	private var skin:RichItemBase = new RichItemBase;
	public function RichItemRender()
	{
		this.defaultSkin = skin;
		skin.touchable = false;
		setSize(309,29);
		skin.nameTxt.fontName = "方正综艺简体";
		skin.starTxt.fontName = "方正综艺简体";
		skin.valuesTxt.fontName = "方正综艺简体";
		
	}
	
	override public function set data(value:Object):void
	{
		if(!value)
		{
			super.data = value;
			
			skin.nameTxt.text = "名字";
			skin.starTxt.text  = "幸运星";
			skin.valuesTxt.text = "总价值";
			return;
		}
		
		skin.nameTxt.text  = (value as LuckRank).name;
		skin.starTxt.text  = (value as LuckRank).values +"";
		skin.valuesTxt.text = (value as LuckRank).sum+"";
		super.data = value;
	}
	
	public function customDispose():void {
		_isDispose = true;
	}
	
	private var _isDispose:Boolean;
	
	override public function dispose():void
	{
		if (_isDispose) {
			skin && skin.dispose();
			super.dispose();
		}
		else {
			Pool.setObj(this)
		}
	}
}

