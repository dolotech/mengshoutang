package game.view.heroHall
{
	import com.dialog.DialogMgr;
	import com.langue.Langue;
	import com.sound.SoundManager;
	import com.utils.Constants;
	import com.view.base.event.EventType;

	import flash.geom.Point;

	import game.common.JTGlobalDef;
	import game.data.ExpData;
	import game.data.Goods;
	import game.data.HeroData;
	import game.data.HeroPriceData;
	import game.data.IconData;
	import game.data.WidgetData;
	import game.dialog.DialogBackground;
	import game.hero.AnimationCreator;
	import game.manager.AssetMgr;
	import game.manager.BattleAssets;
	import game.manager.GameMgr;
	import game.managers.JTFunctionManager;
	import game.net.message.GoodsMessage;
	import game.view.blacksmith.BlacksmithDlg;
	import game.view.comm.GetGoodsAwardEffectDia;
	import game.view.comm.menu.MenuButton;
	import game.view.comm.menu.MenuFactory;
	import game.view.dispark.DisparkControl;
	import game.view.dispark.data.ConfigDisparkStep;
	import game.view.heroHall.render.HeroListRender;
	import game.view.heroHall.view.AdvanceView;
	import game.view.heroHall.view.AultivateView;
	import game.view.heroHall.view.EquimentView;
	import game.view.uitils.FunManager;
	import game.view.viewBase.HeroDialogBase;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import starling.textures.Texture;

	import treefortress.spriter.SpriterClip;

	/**
	 * 英雄模块
	 * @author Samule
	 *
	 */
	public class HeroDialog extends HeroDialogBase
	{
		public static const HERO:int=0;
		public static const UPGRADE:int=1;
		public static const JINHUA:int=2;
		public static const EXP:int=3;

		private var _equimentPanel:EquimentView=null;
		private var _aultivatePanel:AultivateView=null;
		private var _advancePanel:AdvanceView=null;
		private var _heroListPanle:HeroListRender=null;
		private var _factory:MenuFactory=null;
		private var _currData:HeroData=null;
		private var _lablePage:uint=0;

		public function HeroDialog()
		{
			super();
			_closeButton=closeBtn;
		}

		/**初始化*/
		override protected function init():void
		{
			background=new DialogBackground();
			isVisible=false;

			text_diamond.text=GameMgr.instance.diamond + ""; //钻石
			text_coin.text=GameMgr.instance.coin + ""; //金币

			var onFocus:ISignal=new Signal();
			_factory=new MenuFactory();
			_factory.onFocus=onFocus;
			addChild(_factory);

			_heroListPanle=new HeroListRender();
			_heroListPanle.setSize(854, 101);
			_heroListPanle.move(53, 542);
			addChild(_heroListPanle);

			_equimentPanel=new EquimentView(this);
			_aultivatePanel=new AultivateView(this);
			_advancePanel=new AdvanceView(this);
			addQuiackChild(_equimentPanel);
			addQuiackChild(_aultivatePanel);
			addQuiackChild(_advancePanel);

			_equimentPanel.visible=false;
			_equimentPanel.selectEquimp(true);
			_aultivatePanel.visible=false;
			_advancePanel.visible=false;

			isVisible=true;
			GameMgr.instance.onUpateMoney.add(updateMoney);
		}

		private function updateMoney():void
		{
			text_diamond.text=GameMgr.instance.diamond + ""; //钻石
			text_coin.text=GameMgr.instance.coin + ""; //金币
		}

		override protected function addListenerHandler():void
		{
			super.addListenerHandler();
			//更新英雄列表 
			this.addContextListener(EventType.UPDATE_HERO_INDEX, updateHeroList);
			//使用经验药水
			this.addContextListener(EventType.USE_EXP, onUseExpHandler);
			//更新自动换装
			this.addContextListener(EventType.NOTIFY_HERO_EQUIP, updateAtuoEquipHander);
			//玩家身上装备选中
			this.addContextListener(EventType.UPDATE_BODYEQUIP_SELECTED, onHeroEquipClick);
			//英雄进化
			this.addContextListener(EventType.NOTIFY_HERO_PURGE, updateHeroPurge);
			//升星成功
			this.addContextListener(EventType.NOTIFY_HERO_STAR, updateHeroStar);
			//解雇英雄
			this.addContextListener(EventType.REMOVE_HERO, onHeroRemoveNotify);
			//装备数据更新
			this.addContextListener(EventType.UPDATE_HERO_EQUIP, onUpdateHeroEquip);
			//更新英雄信息加了经验
			this.addContextListener(EventType.UPDATE_HERO_INFO, updateHeroInfo);
			//更新英雄信息加了经验升级了
			this.addContextListener(EventType.PLAY_HERO_ANIMATION, playHeroAnimation);
			//英雄选择
			this.addContextListener(EventType.UPDATE_HERO_SELECTED, onHeroSelected);
		}


		/**外部接口设置跳转默认界面*/
		public function selectPanel(lableIndex:int):void
		{
			var defaultSkin:Texture=AssetMgr.instance.getTexture("ui_button_tiebaomutouanjian");
			var downSkin:Texture=AssetMgr.instance.getTexture("ui_button_tiebaomutouanjian_liang");
			var arr:Array=Langue.getLans("heroLableName");
			var labs:Array=[];
			for (var i:int=0; i < 4; i++)
			{
				labs.push({"defaultSkin": defaultSkin, "downSkin": downSkin, x: 55 + i * 150, y: 50, onClick: selectLablePanel, isSelect: i == lableIndex ? true : false, size: i == 3 ? 29 : 32, color: 0xFFE7D0, text: arr[i], name: "lable_" + i});
			}
			_factory.factory(labs);
			selectLableHandler(lableIndex);

		}

		/**选中英雄功能版面*/
		private function selectLablePanel(e:Event):void
		{
			selectLableHandler(int((e.target as MenuButton).name.split("_")[1]));
		}

		/**选择操作*/
		private function selectLableHandler(lableIndex:int):void
		{
			switch (lableIndex)
			{
				case HERO:
					_equimentPanel.visible=true;
					_aultivatePanel.visible=false;
					_advancePanel.visible=false;
					_lablePage=0;
					_equimentPanel.updata(_currData);
					_equimentPanel.selectEquimp(true);
					break;
				case UPGRADE:
					if (!DisparkControl.instance.isOpenHandler(ConfigDisparkStep.DisparkStep13))
					{ //升星功能是否开放
						selectPanel(_lablePage);
						return;
					}

					//智能判断是否删除功能开放提示图标（升星）
					DisparkControl.instance.removeDisparkHandler(ConfigDisparkStep.DisparkStep13);
					_equimentPanel.visible=false;
					_aultivatePanel.visible=true;
					_advancePanel.visible=false;
					_lablePage=1;
					_aultivatePanel.updata(_currData);
					break;
				case JINHUA:
					if (!DisparkControl.instance.isOpenHandler(ConfigDisparkStep.DisparkStep12))
					{ //进化功能是否开放
						selectPanel(_lablePage);
						return;
					}
					//智能判断是否删除功能开放提示图标（进化）
					DisparkControl.instance.removeDisparkHandler(ConfigDisparkStep.DisparkStep12);

					_equimentPanel.visible=false;
					_aultivatePanel.visible=false;
					_advancePanel.visible=true;
					_lablePage=2;
					_advancePanel.updata(_currData);
					break;
				case EXP:
					if (!DisparkControl.instance.isOpenHandler(ConfigDisparkStep.DisparkStep19))
					{ //经验药水功能是否开放
						selectPanel(_lablePage);
						return;
					}
					//智能判断是否删除功能开放提示图标（经验药水）
					DisparkControl.instance.removeDisparkHandler(ConfigDisparkStep.DisparkStep19);

					_equimentPanel.visible=true;
					_aultivatePanel.visible=false;
					_advancePanel.visible=false;
					_lablePage=3;
					_equimentPanel.updata(_currData);
					_equimentPanel.selectEquimp(false);
					break;
				default:
					break;
			}
		}

		/**
		 * 更新英雄列表
		 *
		 */
		private function updateHeroList(evt:Event=null, index:int=-1):void
		{
			var position:Number=_heroListPanle.list_hero.verticalScrollPosition;
			_heroListPanle.selectedIndex=index == -1 ? _heroListPanle.list_hero.selectedIndex : index;
			_heroListPanle.updateHeroList(null);
			_heroListPanle.selectedIndex=_heroListPanle.selectedIndex;
			_heroListPanle.list_hero.verticalScrollPosition=position;
		}

		/**
		 * 使用经验药水
		 * @param evt
		 * @param goods
		 *
		 */
		private function onUseExpHandler(evt:Event, goods:Goods):void
		{
			var useGoods:WidgetData=WidgetData.getWidgetByType(goods.type);

			if (useGoods == null)
			{
				addTips("materialNotEnough");
				return;
			}
			if (_currData.id != 0)
				GoodsMessage.onSendUseExp(_currData.id, useGoods.id);
		}

		/**返回更新英雄数据播放技能特效*/
		private function updateHeroInfo():void
		{
			var upgradeAnimation:SpriterClip=AnimationCreator.instance.create("skill_111", AssetMgr.instance);
			Starling.juggler.add(upgradeAnimation);
			upgradeAnimation.play("skill_111");
			upgradeAnimation.animation.looping=true;
			upgradeAnimation.animationComplete.addOnce(aniComplete);
			addChild(upgradeAnimation);
			upgradeAnimation.x=_equimentPanel._heroAvatar.x;
			upgradeAnimation.y=_equimentPanel._heroAvatar.y - 10;
			function aniComplete(obj:Object=null):void
			{
				upgradeAnimation.removeFromParent(true);
			}
			_equimentPanel.list_exp.dataViewPort.dataProvider_refreshItemHandler();
			heroListPanle.updateItem(_currData);
			selectLableHandler(_lablePage);
		}

		/**返回更新英雄数据播放特效*/
		private function playHeroAnimation(e:Event, info:Object):void
		{
			var upgradeAnimation:SpriterClip=AnimationCreator.instance.create("effect_52004", AssetMgr.instance);
			Starling.juggler.add(upgradeAnimation);
			upgradeAnimation.play("effect_52004");
			upgradeAnimation.animation.looping=true;
			upgradeAnimation.animationComplete.addOnce(aniComplete);
			addChild(upgradeAnimation);
			upgradeAnimation.x=_equimentPanel._heroAvatar.x;
			upgradeAnimation.y=_equimentPanel._heroAvatar.y - 10;
			function aniComplete(obj:Object=null):void
			{
				upgradeAnimation.removeFromParent(true);
			}
			_currData.level=info as int;
			heroListPanle.updateItem(_currData);
			selectLableHandler(_lablePage);
		}

		/**
		 * 自动换装
		 * @param evt
		 * @param heroData
		 *
		 */
		private function updateAtuoEquipHander(evt:Event, heroData:HeroData):void
		{
			_currData=heroData;
			selectLableHandler(_lablePage);
		}

		/**
		 * 英雄装备点击
		 *
		 */
		private function onHeroEquipClick(evt:Event, widgetData:WidgetData):void
		{
			isVisible=false;
			DialogMgr.instance.open(BlacksmithDlg, [BlacksmithDlg.EQUIP, heroListPanle.selectedIndex, _equimentPanel.list_equip.selectedIndex]);
		}

		/**
		 *  英雄进化
		 *
		 */
		private function updateHeroPurge(evt:Event, heroData:HeroData):void
		{
			AnimationCreator.instance.createSecneEffect("effect_016", _advancePanel.currHeroRender.x + 50, _advancePanel.currHeroRender.y + 75, this, AssetMgr.instance);
			onHeroSelected(null, heroData);
			_heroListPanle.updateItem(_currData);
		}


		/**
		 *  英雄升星成功
		 *
		 */
		private function updateHeroStar(evt:Event, heroData:HeroData):void
		{
			AnimationCreator.instance.createSecneEffect("effect_037", _aultivatePanel.kuang.x + 140, _aultivatePanel.kuang.y + 150, this, AssetMgr.instance);
			onHeroSelected(null, heroData);
			_heroListPanle.updateItem(_currData);
		}

		/**返回解散信息*/
		private function onHeroRemoveNotify(evt:Event, heroData:HeroData):void
		{
			if (heroData != null)
			{
				_currData=heroData;
				heroListPanle._selectedIndex=_heroListPanle.selectedIndex - 1;
				if (heroListPanle._selectedIndex < 0)
					heroListPanle._selectedIndex=0;
				heroListPanle.updateHeroList(null);
				heroListPanle.selectedIndex=heroListPanle.selectedIndex;
				_equimentPanel && _equimentPanel.list_exp.dataViewPort.dataProvider_refreshItemHandler();
				selectLableHandler(_lablePage);
				addTips("heroDismissal");

			}
			else
			{
				var heroPriceData:HeroPriceData=HeroPriceData.hash.getValue((_currData.rarity == 0 ? 1 : _currData.rarity) + "" + _currData.quality) as HeroPriceData;
				var tmp_arr:Array=_currData.items.match(/\d+/gs);

				var dataVector:Vector.<IconData>=new Vector.<IconData>;
				var iconData:IconData=null;
				var dominonNum:uint=FunManager.hero_dismissal(heroPriceData.price, _currData.level);
				if (dominonNum > 0)
				{ //奖励钻石
					iconData=new IconData();
					iconData.QualityTrue="ui_gongyong_90wupingkuang0";
					iconData.IconTrue="ui_tubiao_zuanshi_da";
					iconData.HeroSignTrue="";
					iconData.Num="x " + dominonNum;
					iconData.IconType=0;
					iconData.IconId=2;
					iconData.Name=iconData.Name=Langue.getLangue("buyDiamond"); //"钻石";
					dataVector.push(iconData);
				}

				var goods:Array=ExpData.getGoodsList(_currData.level);
				var goodsLen:int=goods.length;
				var itemData:Goods=null;
				for (var i:int=0; i < goodsLen; i++)
				{
					itemData=goods[i].data as Goods;
					iconData=new IconData();
					iconData.IconId=itemData.type;
					iconData.QualityTrue="ui_gongyong_90wupingkuang0" //+ (itemData.quality - 1);
					iconData.IconTrue=itemData.picture;
					iconData.HeroSignTrue="";
					iconData.Num="x " + goods[i].num;
					iconData.IconType=0;
					iconData.Name=String(itemData.name);
					dataVector.push(iconData);
				}

				var effectData:Object={vector: dataVector, effectPoint: new Point(Constants.virtualWidth >> 1, (Constants.virtualHeight >> 1) - 50), effectName: "effect_037", effectSound: "effect_037", effectFrame: 854};
				DialogMgr.instance.open(GetGoodsAwardEffectDia, effectData, null, null, "translucence", 0x000000, 1);
			}
		}

		/**
		 * 装备数据更新
		 *
		 */
		private function onUpdateHeroEquip(evt:Event, widget:WidgetData):void
		{
			_equimentPanel && _equimentPanel.list_equip.dataProvider.updateItem(widget);
		}

		public function get heroListPanle():HeroListRender
		{
			return _heroListPanle;
		}

		/**
		 * 英雄列表选择
		 * @param view
		 * @param heroData
		 *
		 */
		private var sound:String

		private function onHeroSelected(e:Event, heroData:HeroData):void
		{
			if (heroData == null || BattleAssets.instance.isLoading)
				return;
			_currData=heroData;
			_heroListPanle.stopAllSound();
			if (sound != _currData.sound)
			{
				sound=_currData.sound;
				SoundManager.instance.playSound(_currData.sound, true, 1, 1);
			}

			switch (_lablePage)
			{
				case 0:
					_equimentPanel && _equimentPanel.updata(_currData);
					_equimentPanel && _equimentPanel.selectEquimp(true);
					break;
				case 1:
					_aultivatePanel && _aultivatePanel.updata(_currData);
					break;
				case 2:
					_advancePanel && _advancePanel.updata(_currData);
					break;
				case 3:
					_equimentPanel && _equimentPanel.updata(_currData);
					_equimentPanel && _equimentPanel.selectEquimp(false);
					break;
				default:
					break;
			}
		}

		/**显示*/
		protected function configDisparkStep():void
		{
			//功能开放引导
			DisparkControl.dicDisplay["hero_table_0"]=_factory.tableButtons[0];
			DisparkControl.dicDisplay["hero_table_1"]=_factory.tableButtons[1];
			DisparkControl.dicDisplay["hero_table_2"]=_factory.tableButtons[2];
			DisparkControl.dicDisplay["hero_table_3"]=_factory.tableButtons[3];

			//智能判断是否添加功能开放提示图标（进化）
			DisparkControl.instance.addDisparkHandler(ConfigDisparkStep.DisparkStep12);
			//智能判断是否添加功能开放提示图标（升星）
			DisparkControl.instance.addDisparkHandler(ConfigDisparkStep.DisparkStep13);
			//智能判断是否添加功能开放提示图标（分解）
			DisparkControl.instance.addDisparkHandler(ConfigDisparkStep.DisparkStep16);
			//智能判断是否添加功能开放提示图标（经验药水）
			DisparkControl.instance.addDisparkHandler(ConfigDisparkStep.DisparkStep19);


			//智能判断是否添加功能开放提示图标（装备强化）
			DisparkControl.instance.addDisparkHandler(ConfigDisparkStep.DisparkStep1);
			//智能判断是否添加功能开放提示图标（装备合成）
			DisparkControl.instance.addDisparkHandler(ConfigDisparkStep.DisparkStep15);
			//智能判断是否添加功能开放提示图标（装备镶嵌）
			DisparkControl.instance.addDisparkHandler(ConfigDisparkStep.DisparkStep17);

		}

		/**大开*/
		override public function open(container:DisplayObjectContainer, parameter:Object=null, okFun:Function=null, cancelFun:Function=null):void
		{
			JTFunctionManager.executeFunction(JTGlobalDef.STOP_CITY_ANIMATABLE);
			super.open(container, parameter, okFun, cancelFun);
			setToCenter();
			if (parameter && parameter is int)
			{
				_lablePage=parameter as int;
			}
			selectPanel(_lablePage);
			configDisparkStep();
		}

		override public function close():void
		{
			super.close();
			JTFunctionManager.executeFunction(JTGlobalDef.PLAY_CITY_ANIMATABLE);
		}


		/**销毁*/
		override public function dispose():void
		{
			_equimentPanel && _equimentPanel.removeFromParent(true);
			_aultivatePanel && _aultivatePanel.removeFromParent(true);
			_advancePanel && _advancePanel.removeFromParent(true);
			_equimentPanel=null;
			_aultivatePanel=null;
			_advancePanel=null;
			super.dispose();
		}

	}
}
