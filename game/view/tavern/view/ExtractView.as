package game.view.tavern.view
{
	import com.components.RollTips;
	import com.dialog.DialogMgr;
	import com.langue.Langue;
	import com.mvc.interfaces.INotification;

	import game.data.ConfigData;
	import game.data.HeroData;
	import game.data.HeroPriceData;
	import game.data.IconData;
	import game.data.RoleShow;
	import game.dialog.ShowLoader;
	import game.hero.AnimationCreator;
	import game.manager.AssetMgr;
	import game.manager.GameMgr;
	import game.manager.HeroDataMgr;
	import game.net.data.IData;
	import game.net.data.c.CBuyhero;
	import game.net.data.c.CSearchhero;
	import game.net.data.s.SBuyhero;
	import game.net.data.s.SSearchhero;
	import game.net.data.vo.TavernHeroVo;
	import game.net.message.base.Message;
	import game.view.comm.GetGoodsAwardEffectDia;
	import game.view.comm.HeroSkillDialog;
	import game.view.hero.HeroShow;
	import game.view.loginReward.ResignDlg;
	import game.view.tavern.TavernDialog;
	import game.view.tavern.data.TavernData;
	import game.view.tavern.render.TavernSkillRender;
	import game.view.viewBase.ExtractViewBase;

	import sdk.DataEyeManger;

	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;

	import treefortress.spriter.SpriterClip;

	/**
	 *酒馆界面
	 * @author lfr
	 *
	 */
	public class ExtractView extends ExtractViewBase
	{
		/**父类引用*/
		private var _selfParent:TavernDialog=null;
		private var data:TavernData=TavernData.instance; //酒馆数据
		private var buy_hero_money:int; //刷新英雄请求
		private var qualtiy:uint=0;
		private var heroVotype:TavernHeroVo=null;
		private var index:uint=0;
		private var isInitData:Boolean;

		public function ExtractView(parent:TavernDialog)
		{
			_selfParent=parent;
			super();
		}

		public function initData():void
		{
			if (!isInitData)
			{
				isInitData=true;
				createHero();
				data.fushData1.startTime();
				if (!data.fushData1.isSend)
				{ //如果没有请求过
					var cmd:CSearchhero=new CSearchhero();
					cmd.type=0;
					Message.sendMessage(cmd);
				}
				else
				{ //请求过，直接显示 
					updata();
					cdTime();
				}
			}
		}

		private function createHero():void
		{
			var tavernPanel:Sprite=null;
			var heroShow:HeroShow=null;
			for (var i:int=0; i < 3; i++)
			{
				tavernPanel=this.getChildByName("hero_" + i) as Sprite;
				heroShow=new HeroShow();
				heroShow.name="heroShow";
				heroShow.x=(hero_0.width + 20) >> 1;
				heroShow.y=300;
				tavernPanel.addQuiackChildAt(heroShow, 4);
			}
		}

		override protected function addListenerHandler():void
		{
			super.addListenerHandler();
			btn_Refresh.addEventListener(Event.TRIGGERED, onRefresh);
		}

		/**刷新*/
		private function onRefresh(e:Event=null):void
		{
			if (data.fushData1.time > 0)
			{
				var tip:ResignDlg=DialogMgr.instance.open(ResignDlg) as ResignDlg;
				buy_hero_money=Math.ceil((data.fushData1.time / 60) * ConfigData.instance.diamond_per_min);
				tip.text=Langue.getLangue("tavernBuy").replace("*", buy_hero_money);
				tip.btn_ok.addEventListener(Event.TRIGGERED, function():void
				{
					if (GameMgr.instance.diamond < Math.ceil((data.fushData1.time / 60) * ConfigData.instance.diamond_per_min))
					{
						RollTips.add(Langue.getLangue("diamendNotEnough")); //钻石不足
					}
					else
					{
						var cmd:CSearchhero=new CSearchhero();
						cmd.type=1;
						Message.sendMessage(cmd);
					}
				});
			}
			else
			{
				var cmd:CSearchhero=new CSearchhero();
				cmd.type=1;
				Message.sendMessage(cmd);
			}
		}

		override public function listNotificationName():Vector.<String>
		{
			var vect:Vector.<String>=new Vector.<String>;
			vect.push(SSearchhero.CMD, SBuyhero.CMD);
			return vect;
		}

		/**刷新返回数据*/
		override public function handleNotification(_arg1:INotification):void
		{
			//刷新酒馆
			if (_arg1.getName() == String(SSearchhero.CMD))
			{
				var searchhero:SSearchhero=_arg1 as SSearchhero;
				if (searchhero.code == 0 || searchhero.code == 3) //刷新英雄成功
				{
					DataEyeManger.instance.buyItem(DataEyeManger.FLUSH_HERO, buy_hero_money, 1, DataEyeManger.FLUSH_HERO);
					data.fushData1.time=searchhero.cd;
					data.heroList=searchhero.heroes;
					data.fushData1.isSend=true;
					updata();
					cdTime();
				}
				else if (searchhero.code == 1)
				{
					RollTips.add(Langue.getLangue("notEnoughCoin")); //金币不足
				}
				else if (searchhero.code == 2)
				{
					RollTips.add(Langue.getLangue("diamendNotEnough")); //钻石不足
				}
			}
			else if (_arg1.getName() == String(SBuyhero.CMD))
			{
				var sbuyhero:SBuyhero=_arg1 as SBuyhero;
				var dataVector:Vector.<IconData>=new Vector.<IconData>;
				var iconData:IconData=null;
				var heroData:HeroData=HeroData.hero.getValue(heroVotype.type);
				if (0 == sbuyhero.code)
				{
					iconData=new IconData();
					iconData.QualityTrue="ui_gongyong_90wupingkuang" + (heroVotype.quality - 1);
					iconData.IconTrue=(RoleShow.hash.getValue(heroData.show) as RoleShow).photo;
					iconData.HeroSignTrue="ui_hero_yingxiongpinzhi_0" + (7 - qualtiy);
					iconData.Num="Lv " + 1;
					iconData.IconType=1;
					iconData.IconId=heroData.type;
					iconData.Name=heroData.name;
					dataVector.push(iconData);
					var effectData:Object={vector: dataVector, effectPoint: null, effectName: "effect_037", effectSound: "effect_037", effectFrame: 854};
					DialogMgr.instance.open(GetGoodsAwardEffectDia, effectData, null, null, "translucence", 0x000000, 1);
//                    RollTips.add(Langue.getLangue("buySuccess")); //购买成功 

					//购买到的英雄就删除其下对应的数组下标
					var arr:Vector.<IData>=data.heroList;
					var len:uint=arr == null ? 0 : arr.length;
					var info:TavernHeroVo=null;
					for (var i:int=0; i < len; i++)
					{
						info=arr[i] as TavernHeroVo;
						if (info.id == heroVotype.id)
						{
							arr.splice(i, 1);
							break;
						}
					}
					updata();
				}
				else if (1 == sbuyhero.code)
				{
					RollTips.add(Langue.getLangue("notEnoughCoin")); //金币不足 
				}
				else if (2 == sbuyhero.code)
				{
					RollTips.add(Langue.getLangue("diamendNotEnough")); //钻石不足
				}
				else if (3 == sbuyhero.code)
				{
					RollTips.add(Langue.getLangue("MaxHero")); //英雄格子数不足
				}
				else if (127 == sbuyhero.code)
				{
					RollTips.add(Langue.getLangue("alreadyBuy"));
				}
			}
			ShowLoader.remove();
		}

		//显示英雄
		public function updata():void
		{
			ShowLoader.remove();
			var info:TavernHeroVo=null;
			var btnPanel:Sprite=null;
			var bg:Image=null;
			var icon:Image=null;
			var heroPriceData:HeroPriceData=null;
			var tavernPanel:Sprite=null;
			var heroData:HeroData=null;
			var heroShow:HeroShow=null;
			var action:SpriterClip=null;
			var textureVec:Vector.<Texture>=null;
			var arr:Vector.<IData>=data.heroList;
			var len:int=arr.length;
			var skil:TavernSkillRender=null; //英雄信息类
			var kuang:Image=null;
			var cindex:uint=0;
			for (var i:int=0; i < 3; i++)
			{
				tavernPanel=this.getChildByName("hero_" + i) as Sprite;
				tavernPanel.touchable=true;

				info=getTavneInfoByIndex(arr, i + 1);
				if (info != null)
				{
					heroData=HeroData.hero.getValue(info.type);
					heroShow=tavernPanel.getChildByName("heroShow") as HeroShow;
					heroShow.visible=true;
					heroShow.updateHero(heroData, cindex == len - 1, true);
					cindex++;
					tavernPanel.addQuiackChild(heroShow);

					qualtiy=info.quality - 1;
					bg=tavernPanel.getChildByName("effectbg_1") as Image;
					bg.texture=AssetMgr.instance.getTexture("ui_yingxiongkapaiguang_" + qualtiy + "_1");
					bg=tavernPanel.getChildByName("effectbg_2") as Image;
					bg.texture=AssetMgr.instance.getTexture("ui_yingxiongkapaiguang_" + qualtiy + "_2");
					bg=tavernPanel.getChildByName("effectbg_3") as Image;
					bg.texture=AssetMgr.instance.getTexture("ui_yingxiongkapaiguang_" + qualtiy + "_1");
					TextField(tavernPanel.getChildByName("heroName")).text=heroData.name;

					//购买每一个英雄需要的钻石|金币
					heroPriceData=HeroPriceData.hash.getValue(info.ravity + "" + info.quality);
					TextField(this["textNum_" + i]).text=heroPriceData.price + "";
					icon=this["icon_" + i] as Image;
					icon.visible=true;
					if (heroPriceData.type == 2)
					{
						icon.texture=AssetMgr.instance.getTexture("ui_gongyong_zuanshi");
					}
					else
					{
						icon.texture=AssetMgr.instance.getTexture("ui_gongyong_money");
					}

					//刷新英雄时候的特效
					action=AnimationCreator.instance.create("effect_017", AssetMgr.instance);
					action.play("effect_017");
					Starling.juggler.add(action);
					tavernPanel.addQuiackChildAt(action, 4);
					action.x=145;
					action.y=260;
					action.animationComplete.addOnce(removeEffect);

					//刷新酒馆等到每个英雄的等级
					(tavernPanel.getChildByName("textLv") as TextField).text="1";

					//英雄的 攻|防|治|辅|以及英雄的级别 D C B B+ A A+ S
					textureVec=new Vector.<Texture>;
					textureVec.push(AssetMgr.instance.getTexture("ui_gongyong_zheyetubiao" + heroData.job));
					textureVec.push(AssetMgr.instance.getTexture("ui_hero_yingxiongpinzhi_0" + (7 - qualtiy)));
					var mcImage:MovieClip=tavernPanel.getChildByName("mcImage") as MovieClip;
					if (mcImage == null)
					{
						mcImage=new MovieClip(textureVec, 0.5);
						tavernPanel.addQuiackChild(mcImage);
						mcImage.name="mcImage";
						mcImage.x=226;
						mcImage.y=311;
						Starling.juggler.add(mcImage);
					}
					else
					{
						mcImage.visible=true;
						mcImage.setFrameTexture(0, AssetMgr.instance.getTexture("ui_gongyong_zheyetubiao" + heroData.job));
						mcImage.setFrameTexture(1, AssetMgr.instance.getTexture("ui_hero_yingxiongpinzhi_0" + (7 - qualtiy)));
						mcImage.currentFrame=0;
					}

					(tavernPanel.getChildByName("textLv") as TextField).text="1";
					tavernPanel.getChildByName("yuan1").visible=true;
					tavernPanel.getChildByName("yuan2").visible=true;
					this["textAlreadyBuy_" + i].text="";
					this["buyHero_" + i].touchable=true;
					this["buyHero_" + i].addEventListener(Event.TRIGGERED, onBuy); //请求购买英雄的按钮

					kuang=tavernPanel.getChildByName("kuang") as Image;
					kuang.addEventListener(TouchEvent.TOUCH, onSkill); //英雄信息
					kuang.touchable=true;
				}
				else
				{
					(tavernPanel.getChildByName("textLv") as TextField).text="";
					tavernPanel.getChildByName("yuan1").visible=false;
					tavernPanel.getChildByName("yuan2").visible=false;
					if (tavernPanel.getChildByName("mcImage"))
						tavernPanel.getChildByName("mcImage").visible=false;
					tavernPanel.getChildByName("heroShow").visible=false;
					TextField(tavernPanel.getChildByName("heroName")).text="";
					this["textAlreadyBuy_" + i].text=Langue.getLangue("alreadyBuy");
					this["textNum_" + i].text="";
					this["icon_" + i].visible=false;
					this["buyHero_" + i].touchable=false;
				}
			}
		}

		//取到英雄的ID对应数组的下标
		public function getTavneInfoByIndex(arr:Vector.<IData>, j:uint):TavernHeroVo
		{
			var info:TavernHeroVo=null;
			var _length:int=arr.length
			for (var i:int=0; i < _length; i++)
			{
				info=arr[i] as TavernHeroVo;
				if (info && j == info.id)
				{
					return info;
				}
			}
			return null;
		}

		private function removeEffect(effect:SpriterClip):void
		{
			effect.stop();
			Starling.juggler.remove(effect);
			effect && effect.removeFromParent(true);
		}

		private function cdTime():void
		{
			data.fushData1.cdTime(text_time, text_diamond); //免费倒计时
			if (data.fushData1.time > 0)
			{
				text_FreeRefreshCountdown.text=Langue.getLangue("USING_DIAMOND") + ":";
				text_time.fontSize=28;
			}
			else
			{
				text_time.text=Langue.getLangue("REFRESH_ONE");
				text_time.fontSize=21;
			}
			data.fushData1.onTimeEnd.addOnce(function():void
			{
				text_time.text=Langue.getLangue("REFRESH_ONE");
			});
		}

		private function onSkill(e:TouchEvent):void
		{
			var touch:Touch=e.getTouch(stage);
			switch (touch && touch.phase)
			{
				case TouchPhase.BEGAN:
					var sp:Sprite=(e.currentTarget as Image).parent as Sprite;
					index=uint(sp.name.split("_")[1]);
					heroVotype=getTavneInfoByIndex(data.heroList, index + 1);
					if (heroVotype)
					{
						var heroData:HeroData=HeroData.hero.getValue(heroVotype.type);
						DialogMgr.instance.open(HeroSkillDialog, heroData);
					}
					break;
			}
		}

		private function onBuy(e:Event):void
		{
			index=uint((e.currentTarget as Button).name.split("_")[1]);
			heroVotype=getTavneInfoByIndex(data.heroList, index + 1);
			if (heroVotype == null || heroVotype.id == 0)
			{
				RollTips.add(Langue.getLangue("notHero"));
				return;
			}
			else if (HeroDataMgr.instance.hash.keys().length >= GameMgr.instance.hero_gridCount)
			{
				RollTips.add(Langue.getLangue("MaxHero"));
				return;
			}

			if (GameMgr.instance.diamond < (HeroPriceData.hash.getValue(heroVotype.ravity + "" + heroVotype.quality) as HeroPriceData).price) //钻石小于价格
			{
				RollTips.add(Langue.getLangue("diamendNotEnough")); //钻石不足
			}
			else
			{ //请求购买 英雄
				var cmd:CBuyhero=new CBuyhero();
				cmd.id=heroVotype.id;
				Message.sendMessage(cmd);
			}
		}

		/**销毁*/
		override public function dispose():void
		{
			btn_Refresh.removeEventListener(Event.TRIGGERED, onRefresh);

			for (var i:int=0; i < 3; ++i)
			{
				this["buyHero_" + i].touchable=false;
				this["buyHero_" + i].removeEventListener(Event.TRIGGERED, onBuy);
			}

			while (this.numChildren > 0)
			{
				this.getChildAt(0).removeFromParent(true);
			}
			buy_hero_money=0;
			qualtiy=0;
			heroVotype=null;
			index=0;
		}
	}
}
