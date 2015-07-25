package game.view.arena
{
	import com.langue.Langue;
	import com.mvc.interfaces.INotification;
	import com.utils.ObjectUtil;
	import com.utils.StringUtil;
	
	import game.data.ArenaLevel;
	import game.dialog.DialogBackground;
	import game.dialog.ShowLoader;
	import game.manager.AssetMgr;
	import game.manager.GameMgr;
	import game.net.GameSocket;
	import game.net.data.c.CArena_init;
	import game.net.data.s.SArena_init;
	import game.net.message.RoleInfomationMessage;
	import game.view.arena.base.ArenaDlgBase;
	import game.view.comm.menu.MenuButton;
	import game.view.comm.menu.MenuFactory;
	import game.view.uitils.DisplayMemoryMrg;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;

	/**
	 * 
	 * 竞技场
	 * @author litao
	 * 
	 */	
	public class ArenaDlg extends ArenaDlgBase
	{
		private var faceFactory:ArenafaceFactory;
		public function ArenaDlg()
		{
			isVisible = true;
			super();
			_closeButton = closeButton;
			faceFactory = new ArenafaceFactory();
			addChild(faceFactory);

            background = new DialogBackground();
		}
		
		override public function open(container:DisplayObjectContainer, parameter:Object=null, okFun:Function=null, cancelFun:Function=null):void
		{
			super.open(container, parameter, okFun, cancelFun);

            RankNameTxt.text = Langue.getLans("rankTitles")[0];
			addPlayer();//添加玩家头像.名字等相关信息
			updateMoney();
			createMenu();//创建菜单按钮
			GameMgr.instance.onUpateMoney.add(updateMoney);
			faceFactory.createFace("dare");
			ArenaDareData.instance.create("dare");
			if(!(ArenaDareData.instance.getData("dare") as ArenaDareData).isRequestLevel)
				send();
			else 
			{
				showValue();
			}
			(ArenaDareData.instance.getData("dare") as ArenaDareData).onUpdate.add(showValue);
            setToXCenter();
		}
		
		private function send():void
		{
			var cmd:CArena_init = new CArena_init;
			GameSocket.instance.sendData(cmd);
			ShowLoader.add();
		}
		
		override public function handleNotification(_arg1:INotification):void
		{
			var arenaInit:SArena_init = _arg1 as SArena_init;
			var data:ArenaDareData = ArenaDareData.instance.getData("dare") as ArenaDareData;			
			data.honor = arenaInit.honor;
			data.level = arenaInit.level;
			data.isRequestLevel = true;
			data.point = arenaInit.point;
			data.rank = arenaInit.rank;
			showValue();
			ShowLoader.remove();
		}
		
		private var level:Image;
		//显示玩家段位，荣誉值等
		private function showValue():void
		{
			var data:ArenaDareData = ArenaDareData.instance.getData("dare") as ArenaDareData;
			if(GameMgr.instance.honor == 0)
			GameMgr.instance.honor = data.honor;
			
			GameMgr.instance.updateMoney();
			
			RankTxt.text = data.rank + "";
			var levelFontName:String = "ui_tubiao_duanwei1.";
            var levelNumber:int =  data.level;
			if(levelNumber >= 10 && levelNumber <=18)
			{
				levelFontName = "ui_tubiao_duanwei2.";
				levelIconImage.texture = AssetMgr.instance.getTexture("ui_tubiao_duanwei2");
                levelNumber = levelNumber - 9;
			}
			else if(levelNumber >= 19 && levelNumber <=27)
			{
				levelFontName = "ui_tubiao_duanwei3.";
				levelIconImage.texture = AssetMgr.instance.getTexture("ui_tubiao_duanwei3");
                levelNumber = levelNumber - 18;
			}
            else    if(levelNumber <= 9)
            {
                levelNumber =   10-(levelNumber);
            }
			
			level && level.removeFromParent(true);
            var tmpTexture:Texture = AssetMgr.instance.getTexture(levelFontName + levelNumber);
            level = new Image(tmpTexture);
			addChild(level);
			ObjectUtil.setToCenter(levelIconImage,level);
			
			currentLevelNameTxt.text = ArenaLevel.hash.getValue(data.level).name;
			nextLevelNameTxt.text = ArenaLevel.hash.getValue(data.level + 1).name;
			
			var prs:int = data.point/ArenaLevel.hash.getValue(data.level).integral * parImage.width;
			parBgImage.width = prs;
			
			progressTxt.text = data.point + "/" + ArenaLevel.hash.getValue(data.level).integral;
		}
		
		override public function listNotificationName():Vector.<String>
		{
			var vect:Vector.<String > = new Vector.<String>;
			vect.push(SArena_init.CMD);
			return vect;
		}
		
		private var factory:MenuFactory
		private function createMenu():void
		{
			var onFocus:ISignal = new Signal();
			factory = new MenuFactory;
			var defaultSkin:Texture = AssetMgr.instance.getTexture("ui_button_hechenganjian_shuijing1");
			var downSkin:Texture = AssetMgr.instance.getTexture("ui_button_hechenganjian_shuijing_xuanzhong");
			factory.onFocus = onFocus;
			var arr:Array = Langue.getLans("arenaMenuText");
            const positionY:int = 563;
			factory.factory([
				{"defaultSkin":defaultSkin,"downSkin":downSkin,x:63,y:positionY,onClick:onSelect,name:"dare",isSelect:true,size:32,color:0xffffff,text:arr[0],scale:0.9},
				{"defaultSkin":defaultSkin,"downSkin":downSkin,x:180,y:positionY,onClick:onSelect,name:"convert",size:32,color:0xffffff,text:arr[1],scale:0.9},
				{"defaultSkin":defaultSkin,"downSkin":downSkin,x:298,y:positionY,onClick:onSelect,name:"Battlefield",size:32,color:0xffffff,text:arr[2],scale:0.9},
				{"defaultSkin":defaultSkin,"downSkin":downSkin,x:416,y:positionY,onClick:onSelect,name:"rank",size:32,color:0xffffff,text:arr[3],scale:0.9},
				{"defaultSkin":defaultSkin,"downSkin":downSkin,x:533,y:positionY,onClick:onSelect,name:"Reward",size:32,color:0xffffff,text:arr[4],scale:0.9},
			]);
			addChild(factory);
		}
		
		private function onSelect(e:Event):void
		{
			var name:String = (e.target as MenuButton).name;
			faceFactory.createFace(name);
		}
		
		
		private function addPlayer():void
		{
			var texture:Texture = AssetMgr.instance.getTexture("ui_pvp_renwutouxiang" + RoleInfomationMessage.my_photo_id); //人物头像 
			var photo:Image = new Image(texture);
			addChildAt(photo,getChildIndex(photoBgImage)+1);
			photo.x = photoBgImage.x;
			photo.y = photoBgImage.y;
			nameTxt.text = GameMgr.instance.arenaname;
			nameTxt.fontName = "方正综艺简体";
		}
		
		private function updateMoney():void
		{
			StringUtil.changePriceText(GameMgr.instance.diamond, diamondTxt, kTxt);
			StringUtil.changePriceText(GameMgr.instance.honor, honorTxt, k1Txt, false);
		}
		
		public function getObject(name:String):Object
		{
			return factory.getChildByName(name);
		}
		
		override public function dispose():void
		{
			GameMgr.instance.onUpateMoney.remove(updateMoney);
			DisplayMemoryMrg.instance.removeToMemory("dare");
			DisplayMemoryMrg.instance.removeToMemory("convert");
			DisplayMemoryMrg.instance.removeToMemory("Battlefield");
			DisplayMemoryMrg.instance.removeToMemory("rank");
			DisplayMemoryMrg.instance.removeToMemory("Reward");
			
			super.dispose();
		}
		
	}
}