package game.scene.world
{
	import com.dialog.DialogMgr;
	import com.langue.Langue;
	import com.utils.Constants;

	import feathers.core.PopUpManager;

	import game.common.JTGlobalDef;
	import game.data.IconData;
	import game.data.JTTollgateGIftData;
	import game.hero.AnimationCreator;
	import game.manager.AssetMgr;
	import game.manager.GameMgr;
	import game.managers.JTFunctionManager;
	import game.managers.JTSingleManager;
	import game.managers.JTTollgateInfoManager;
	import game.net.GameSocket;
	import game.net.data.c.CGet_tollgatePrize;
	import game.net.data.s.SGet_tollgatePrize;
	import game.scene.world.base.JTUIGitTollgate;
	import game.view.comm.GetGoodsAwardEffectDia;

	import starling.display.Sprite;
	import starling.events.Event;

	import treefortress.spriter.SpriterClip;

	public class JTGiftTollgateComponent extends JTUIGitTollgate
	{
		public static var instance:JTGiftTollgateComponent=null;
		private const TYPE_STAR:int=3; //幸运星
		private const TYPE_TRIED:int=7; //疲劳值
		private const TYPE_DIAMOND:int=2; //钻石
		private var dataVector:Vector.<IconData>=null;

		public function JTGiftTollgateComponent()
		{
			super();
			initialize();
			this.btn_get_giftButton.addEventListener(Event.TRIGGERED, onGetGiftHandler);
			JTFunctionManager.registerFunction(JTGlobalDef.GET_TOLLGATE_GIFT, getTollgateGiftResponse);
		}

		override public function showBackground(isClickColse:Boolean=false, x:Number=0, y:Number=0, maxWidth:Number=0,
			maxHeight:Number=0):void
		{
			super.showBackground(true);
		}

		override protected function onCloseBackground():void
		{
			close();
		}

		public function onGetGiftHandler(e:Event):void
		{
			var tollgateInfoManager:JTTollgateInfoManager=JTSingleManager.instance.tollgateInfoManager;
			var curTollgateData:JTTollgateGIftData=JTTollgateGIftData.getTollgateGift(tollgateInfoManager.current_TollgateID);
			if (!curTollgateData)
			{
				return;
			}
			if (GameMgr.instance.tollgateID > curTollgateData.id2)
			{
				var getGiftPackage:CGet_tollgatePrize=new CGet_tollgatePrize();
				GameSocket.instance.sendData(getGiftPackage);
			}
		}

		private function initialize():void
		{
			var tollgateInfoManager:JTTollgateInfoManager=JTSingleManager.instance.tollgateInfoManager;
			var curTollgateData:JTTollgateGIftData=JTTollgateGIftData.getTollgateGift(tollgateInfoManager.current_TollgateID);
			this.txt_diamond.text="x 0";
			this.txt_star.text="x 0";
			this.txt_tried.text="x 0";
			this.img_mc_icon.visible=this.btn_get_giftButton.touchable=tollgateInfoManager.isGetGift;
			if (!curTollgateData)
			{
				return;
			}
			this.txt_tolltage_num.text=GameMgr.instance.tollgateID - 1 + "/" + curTollgateData.id2;
			setArgs(curTollgateData.prize);
		}

		private function setArgs(list:Array):void
		{
			var i:int=0;
			var l:int=list.length;
			var iconData:IconData=null;
			dataVector=new Vector.<IconData>;
			for (i=0; i < l; i++)
			{
				var dataInfo:Object=list[i] as Object;
				var type:int=dataInfo[0];
				var count:int=dataInfo[1];
				switch (type)
				{
					case TYPE_DIAMOND:
					{
						this.txt_diamond.text="x " + count;

						iconData=new IconData();
						iconData.IconId=TYPE_DIAMOND;
						iconData.QualityTrue="ui_gongyong_90wupingkuang0";
						iconData.IconTrue="ui_tubiao_zuanshi_da";
						iconData.HeroSignTrue="";
						iconData.Num="x " + count;
						iconData.IconType=0;
						iconData.Name=Langue.getLangue("buyDiamond"); //"钻石"
						dataVector.push(iconData);
						break;
					}
					case TYPE_STAR:
					{
						this.txt_tried.text="x " + count;

						iconData=new IconData();
						iconData.IconId=TYPE_STAR;
						iconData.QualityTrue="ui_gongyong_90wupingkuang0";
						iconData.IconTrue="icon_3";
						iconData.HeroSignTrue="";
						iconData.Num="x " + count;
						iconData.IconType=0;
						iconData.Name=Langue.getLangue("buyLucky"); //"幸运星"
						dataVector.push(iconData);
						break;
					}
					case TYPE_TRIED:
					{
						this.txt_star.text="x " + count;
						iconData=new IconData();
						iconData.IconId=TYPE_TRIED;
						iconData.QualityTrue="ui_gongyong_90wupingkuang0";
						iconData.IconTrue="icon_7";
						iconData.HeroSignTrue="";
						iconData.Num="x " + count;
						iconData.IconType=0;
						iconData.Name=Langue.getLangue("buyFatigue"); //"疲劳值"
						dataVector.push(iconData);
						break;

					}

					default:
						break;
				}
			}
		}

		private function getTollgateGiftResponse(result:Object):void
		{
			var tollgateInfoManager:JTTollgateInfoManager=JTSingleManager.instance.tollgateInfoManager;
			var tollgateGift:SGet_tollgatePrize=result as SGet_tollgatePrize;
			if (tollgateGift.code == 0)
			{
				var giftAmintion:SpriterClip=AnimationCreator.instance.create("effect_baoxiangshanguang", AssetMgr.instance,
					true);
				giftAmintion.play("effect_baoxiangshanguang");
				giftAmintion.animation.looping=false;
				giftAmintion.addCallback(onPlayComplete, 500);
				giftAmintion.name="giftAminition";
				this.addChild(giftAmintion);
				this.setChildIndex(this.btn_get_giftButton, this.numChildren - 1);
				giftAmintion.x=this.btn_get_giftButton.x + btn_get_giftButton.width / 2;
				giftAmintion.y=this.btn_get_giftButton.y + btn_get_giftButton.height / 2;
				this.img_mc_icon.visible=false;
				btn_get_giftButton.upState=AssetMgr.instance.getTexture("ui_shangcheng_jinxiangzikai");
			}
			else
			{
				this.img_mc_icon.visible=false;
			}
			var effectData:Object={vector: dataVector, effectPoint: null, effectName: "effect_036", effectSound: "baoxiangkaiqihuode",
					effectFrame: 299};
			DialogMgr.instance.open(GetGoodsAwardEffectDia, effectData, null, null, "translucence", 0x000000, 1);
		}

		private function removeAnimation():void
		{
			var giftAminition:SpriterClip=this.getChildByName("giftAminition") as SpriterClip;
			giftAminition && giftAminition.removeFromParent();
			giftAminition.dispose();
			giftAminition=null;
			btn_get_giftButton.upState=AssetMgr.instance.getTexture("ui_shangcheng_jinxiangziguan");
			this.setChildIndex(this.img_mc_icon, this.numChildren - 1);
		}

		private function onPlayComplete():void
		{
			initialize();
			removeAnimation();
		}

		private function showFlyAnimation():void
		{

		}

		override public function dispose():void
		{
			super.dispose();
			JTFunctionManager.removeFunction(JTGlobalDef.GET_TOLLGATE_GIFT, getTollgateGiftResponse);
			getTollageteICON().refreshImage();
		}

		public static function open(parent:Sprite):void
		{
			if (!instance)
			{
				instance=PopUpManager.addPopUp(new JTGiftTollgateComponent(), false) as JTGiftTollgateComponent;
			}
		}

		public static function close():void
		{
			if (instance)
			{
				instance.removeFromParent();
				instance.dispose();
				instance=null;
			}
		}

		private static var tollgateIcon:JTTollgateGiftICON=null;

		public static function openGift():void
		{
			if (!tollgateIcon)
			{
				tollgateIcon=new JTTollgateGiftICON();
				tollgateIcon=PopUpManager.addPopUp(tollgateIcon, false, false) as JTTollgateGiftICON;
				tollgateIcon.x=Constants.FullScreenWidth - tollgateIcon.width - 10 * Constants.scale;
				tollgateIcon.y=Constants.FullScreenHeight - tollgateIcon.height - 10 * Constants.scale;
			}
		}

		public static function getTollageteICON():JTTollgateGiftICON
		{
			return tollgateIcon;
		}

		public static function closeGift():void
		{
			if (tollgateIcon)
			{
				/*tollgateIcon.removeFromParent();
				tollgateIcon.dispose();*/
				PopUpManager.removePopUp(tollgateIcon, true);
				tollgateIcon=null;
			}
		}
	}
}
import game.base.JTSprite;
import game.data.JTTollgateGIftData;
import game.manager.AssetMgr;
import game.managers.JTSingleManager;
import game.managers.JTTollgateInfoManager;
import game.scene.world.JTGiftTollgateComponent;

import starling.display.Button;
import starling.display.Image;
import starling.events.Event;
import starling.textures.Texture;

class JTTollgateGiftICON extends JTSprite
{
	public var btn_giftButton:Button=null;
	public var mc_markImage:Image=null;

	public function JTTollgateGiftICON()
	{
		super();
		var ui_icon_rewards_quest00Texture:Texture=AssetMgr.instance.getTexture('ui_icon_ rewards_quest');
		btn_giftButton=new Button(ui_icon_rewards_quest00Texture);
		btn_giftButton.x=0;
		btn_giftButton.y=0;
		this.addQuiackChild(btn_giftButton);
		var mc_markTexture:Texture=AssetMgr.instance.getTexture('ui_zhuxian_zhandoutongguan_new');
		mc_markImage=new Image(mc_markTexture);
		mc_markImage.x=0;
		mc_markImage.y=0;
		mc_markImage.width=52;
		mc_markImage.height=52;
		mc_markImage.touchable=false;
		this.addQuiackChild(mc_markImage);
		this.btn_giftButton.addEventListener(Event.TRIGGERED, onMouseClickHandler);
		refreshImage();
	}

	public function refreshImage():void
	{
		var tollgateInfoManager:JTTollgateInfoManager=JTSingleManager.instance.tollgateInfoManager;
		var curTollgateData:JTTollgateGIftData=JTTollgateGIftData.getTollgateGift(tollgateInfoManager.current_TollgateID);
		if (!curTollgateData)
		{
			this.visible=false;
		}
		else
		{
			this.mc_markImage.visible=JTSingleManager.instance.tollgateInfoManager.isGetGift;
		}
	}

	private function onMouseClickHandler(e:Event):void
	{
		if (JTGiftTollgateComponent.instance)
		{
			JTGiftTollgateComponent.close();
		}
		else
		{
			JTGiftTollgateComponent.open(this);
		}
		//e.stopImmediatePropagation();
	}

	override public function dispose():void
	{
		super.dispose();
		this.btn_giftButton && this.btn_giftButton.addEventListener(Event.TRIGGERED, onMouseClickHandler);
		this.mc_markImage=null;
		this.btn_giftButton=null;
	}

}
