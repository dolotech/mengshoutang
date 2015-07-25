package game.scene.world
{
	import com.dialog.DialogMgr;
	import com.mobileLib.utils.DeviceType;
	import com.scene.SceneMgr;
	import com.sound.SoundManager;
	import com.utils.Constants;
	import com.view.base.event.EventType;

	import flash.geom.Rectangle;

	import feathers.controls.Scroller;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.TiledColumnsLayout;
	import feathers.layout.TiledRowsLayout;

	import game.data.MainLineData;
	import game.data.TollgateData;
	import game.hero.AnimationCreator;
	import game.manager.AssetMgr;
	import game.manager.GameMgr;
	import game.net.message.GameMessage;
	import game.net.message.GoodsMessage;
	import game.view.city.CityFace;
	import game.view.dispark.DisparkControl;
	import game.view.dispark.data.ConfigDisparkStep;
	import game.view.new2Guide.NewGuide2Manager;
	import game.view.viewBase.NewMainWorldBase;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;

	import treefortress.spriter.SpriterClip;

	/**
	 * 主线关卡
	 * @author hyy
	 *
	 */
	public class NewMainWorld extends NewMainWorldBase
	{
		public static var curr_pos : int = -1;
		private static var curr_page : int = -1;
		public static var buy_goods : int = -1;
		public static var buy_tired : Boolean;
		protected const list_width : int = 960;
		protected var goto_tollgateID : int;
		protected var isTweening : Boolean;
		protected var isTweeningBottom : Boolean;
		/**
		 * 是否噩梦难度
		 */
		protected var isNightmare : Boolean = false;
		/**
		 * 噩梦特效
		 */
		protected var effect_nigthMare : SpriterClip;
		protected var selected_data : TollgateData;
		protected var isInit : Boolean;
		protected var tag_modle : Image;
		protected var isEndMap : Boolean;
		protected var list_length : int;

		public function NewMainWorld()
		{
			super();
		}

		override protected function init() : void
		{
			view_reward.scaleX = view_reward.scaleY = Constants.isScaleWidth ? Constants.standardWidth / Constants.FullScreenWidth : 1;
			DialogMgr.instance.closeAllDialog();

			SoundManager.instance.playSound("worldmap_bgm", true, 0, 99999);
			SoundManager.instance.tweenVolume("worldmap_bgm", 1.0, 2);

			btn_return.x = Constants.virtualWidth - btn_return.width - 50;
			tag_return.x = btn_return.x + btn_return.width * .5;

			const listLayout : TiledColumnsLayout = new TiledColumnsLayout();
			listLayout.useSquareTiles = false;
			listLayout.useVirtualLayout = true;
			listLayout.tileVerticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_TOP;
			listLayout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
			list_map.width = Constants.virtualWidth;
			list_map.layout = listLayout;
			list_map.horizontalScrollPolicy = Scroller.SCROLL_POLICY_ON;
			list_map.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			list_map.itemRendererFactory = itemRendererFactory;

			function itemRendererFactory() : IListItemRenderer
			{
				const renderer : NewMainWorldRender = new NewMainWorldRender();
				renderer.setSize(list_width, list_map.height);
				renderer.clipRect = new Rectangle(0, 0, list_width, list_map.height)
				return renderer;
			}

			const equiplistLayout : TiledColumnsLayout = new TiledColumnsLayout();
			equiplistLayout.paddingLeft = -40;
			equiplistLayout.gap = -15;
			equiplistLayout.useSquareTiles = true;
			equiplistLayout.useVirtualLayout = true;
			equiplistLayout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
			equiplistLayout.paging = TiledColumnsLayout.TILE_HORIZONTAL_ALIGN_LEFT; //自动排列
			list_reward.layout = equiplistLayout;
			list_reward.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			list_reward.itemRendererFactory = itemEquipRendererFactory;

			function itemEquipRendererFactory() : IListItemRenderer
			{
				const renderer : NewMainRewardRender = new NewMainRewardRender();
				renderer.setSize(102, 120);
				return renderer;
			}

			view_reward.x = Constants.virtualWidth * .5;
			view_reward.y = Constants.virtualHeight;
			view_title.x = view_reward.x;
			view_title.y = -view_title.height;
			view_title.visible = view_reward.visible = false;
			tag_modle = view_reward.getChildByName("tag_modle") as Image;

			addMask(tag_modle);
			JTGiftTollgateComponent.openGift();
			list_map.horizontalScrollPolicy = NewGuide2Manager.instance == null ? Scroller.SCROLL_POLICY_ON : Scroller.SCROLL_POLICY_OFF;

		}

		override protected function addListenerHandler() : void
		{
			super.addListenerHandler();
			this.addViewListener(list_map, Event.SCROLL, listMapScroll);
//			this.addViewListener(list_map, TouchEvent.TOUCH, onTouch);
			this.addViewListener(btn_return, Event.TRIGGERED, onReturnClick);
			this.addViewListener(view_reward.getChildByName("btn_modle"), Event.TRIGGERED, onModleClick);
			this.addViewListener(btn_add, Event.TRIGGERED, onBuyTiredClick);
			this.addViewListener(view_reward.getChildByName("btn_battle"), Event.TRIGGERED, onBattleClick);
			this.addContextListener(EventType.SELECTED_MAINLINE, onSelectedMainLine);
			this.addContextListener(EventType.UPDATE_TIRED, updateTired);
			this.addContextListener(EventType.MAINLINE_HIDDEN, hiddenBottomHandler);
		}

//		private function onTouch(e:TouchEvent):void
//		{
//			var touch:Touch=e.getTouch(stage);
//			switch (touch && touch.phase)
//			{
//				case TouchPhase.BEGAN:
//					hiddenBottomHandler();
//					break;
//			}
//		}

		override public function set data(value : Object) : void
		{
			if (value == null)
				goto_tollgateID = GameMgr.instance.tollgateID;
			else
				goto_tollgateID = int(value);

			if (goto_tollgateID == 0)
				goto_tollgateID = 1;

			if (goto_tollgateID >= TollgateData.tollgateCount)
				goto_tollgateID = TollgateData.tollgateCount - 1;

			if (DeviceType.getType() == DeviceType.DESKTOP)
			{
				if (_staticDic)
				{
					for (var str : String in DisplayObject._staticDic)
					{
						var curValue : int = DisplayObject._staticDic[str];
						var lashValue : int = _staticDic[str] ? _staticDic[str] : 0;

						if (curValue != lashValue)
						{

						}
					}
				}
				else
				{
					_staticDic = {};

					for (str in DisplayObject._staticDic)
					{
						curValue = DisplayObject._staticDic[str];
						_staticDic[str] = curValue;
					}
				}
			}
		}

		private static var _staticDic : Object;

		override protected function show() : void
		{
			updateTired();
			onModleClick();

			var open_page : int = MainLineData.getPageById(goto_tollgateID) + 1;

			if (open_page > MainLineData.list.length)
				open_page = MainLineData.list.length;
			var isInit : Boolean = curr_pos == -1;
			list_map.dataProvider = new ListCollection(MainLineData.list.slice(0, open_page));
			list_length = list_map.dataProvider.length;
			isEndMap = MainLineData.getPageById(goto_tollgateID) == list_length;


			if (curr_pos == -1 || curr_page != open_page)
				curr_pos = (MainLineData.getPageById(goto_tollgateID) - 1) * list_width - (Constants.virtualWidth - list_width) * .5;

			if (isInit && isEndMap)
				curr_pos = list_length * list_width - Constants.virtualWidth;

			if (curr_pos < 0)
				curr_pos = 0;
			curr_page = open_page;
			list_map.scrollToPosition(curr_pos, 0);

			if (NewMainWorld.buy_tired)
			{
				NewMainWorld.buy_tired = false;
				GoodsMessage.onBuyTiredClick();
			}

			if (NewMainWorld.buy_goods != -1)
			{
				var tollgateData : TollgateData = TollgateData.hash.getValue(NewMainWorld.buy_goods);
				DialogMgr.instance.open(NighteMareView, tollgateData.castNightmareGoods);
				NewMainWorld.buy_goods = -1;
			}
		}

		/**
		 * 地图滚动
		 *
		 */
		protected function listMapScroll() : void
		{
			if (!isEndMap)
			{
				var pos : int = (list_length - 1) * list_width - Constants.virtualWidth;

				if (list_map.horizontalScrollPosition >= pos)
				{
					list_map.horizontalScrollPosition = pos;

					if (list_map.horizontalScrollPosition < 0)
						list_map.horizontalScrollPosition = 0;
				}
			}

			if (curr_pos == list_map.horizontalScrollPosition)
				return;
			curr_pos = list_map.horizontalScrollPosition;

			hiddenBottomHandler();
		}

		/**
		 * 开始加载战斗资源
		 *
		 */
		protected function onBattleClick() : void
		{
			var tollgateData : TollgateData = isNightmare ? selected_data.nightmareData : selected_data;

			if (isNightmare)
			{
				if (tollgateData == null)
				{
					addTips("no_nightmare");
					return;
				}

				if (selected_data.nightmare_star != 7)
				{
					addTips("no_star_nightmare");
					return;
				}
			}

			if (tollgateData == null)
				return;
			GameMessage.gotoTollgateData(tollgateData.id);
		}


		/**
		 * 更新疲劳值
		 *
		 */
		protected function updateTired() : void
		{
			txt_power.text = GameMgr.instance.tired + "/100";
		}

		/**
		 * 关卡选择
		 * @param evt
		 *
		 */
		protected function onSelectedMainLine(evt : Event, data : TollgateData, isUpdateModle : Boolean = true) : void
		{
			if (selected_data == data && isUpdateModle || !data)
				return;

			if (isTweeningBottom || y == Constants.virtualHeight - view_reward.height + 20)
				return;

			TextField(view_reward.getChildByName("txt_castPower")).text = "x" + data.tired;
			list_reward.dataProvider = new ListCollection(data.rewardList);
			TextField(view_title.getChildByName("text")).text = data.tollgateName;

			if (isUpdateModle)
			{
				selected_data = data;

				onModleClick(null, isNightmare && selected_data.nightmareData ? false : true);

				if (!view_reward.visible)
				{
					isTweeningBottom = true;
					JTGiftTollgateComponent.closeGift();
					view_title.visible = view_reward.visible = true;
					Starling.juggler.tween(view_reward, 0.3, {y: Constants.virtualHeight - view_reward.height + 20, onComplete: onComplete});
					Starling.juggler.tween(view_title, 0.3, {y: 0});

					//智能判断添加New图标
					DisparkControl.instance.addDisparkHandler(ConfigDisparkStep.DisparkStep10);
				}

				function onComplete() : void
				{
					isTweeningBottom = false;
				}
			}
		}

		/**
		 * 隐藏奖励框
		 *
		 */
		protected function hiddenBottomHandler() : void
		{
			if (isTweeningBottom || view_reward.y == Constants.virtualHeight)
				return;
			isPlayNightMareAnimation = false;
			isTweeningBottom = true;
			Starling.juggler.tween(view_reward, 0.3, {y: Constants.virtualHeight, onComplete: onComplete});
			Starling.juggler.tween(view_title, 0.3, {y: -view_title.height});

			function onComplete() : void
			{
				selected_data = null;
				JTGiftTollgateComponent.openGift();
				view_title.visible = view_reward.visible = false;
				isTweeningBottom = false;
			}
		}

		/**
		 * 购买疲劳
		 *
		 */
		protected function onBuyTiredClick() : void
		{
			GoodsMessage.onBuyTiredClick();
		}

		/**
		 * 跳转回大厅
		 * @param evt
		 *
		 */
		protected function onReturnClick() : void
		{
			SceneMgr.instance.changeScene(CityFace);
			//检查功能开放
			DisparkControl.instance.checkMajorOpen();
		}

		/**
		 * 噩梦难度选择
		 *
		 */
		protected function onModleClick(evt : Event = null, isRest : Boolean = false) : void
		{
			//提示功能未开
			if (evt && !DisparkControl.instance.isOpenHandler(ConfigDisparkStep.DisparkStep10))
			{
				return;
			}

			if (isRest)
			{
				isTweening = false;
				isNightmare = false;
				Starling.juggler.removeTweens(tag_modle);
				tag_modle.x = -tag_modle.width * .5;
				isPlayNightMareAnimation = false;
				return;
			}

			if (isTweening)
				return;

			if (selected_data && selected_data.nightmareData == null)
			{
				addTips("no_nightmare");
				return;
			}

			if (evt)
				isNightmare = !isNightmare;

			if (selected_data)
			{
				var nightmareData : TollgateData = selected_data.nightmareData;
				onSelectedMainLine(evt, isNightmare ? nightmareData : selected_data, false);
			}

			tweenTab(tag_modle, isNightmare, onComplete);

			function onComplete() : void
			{
				isPlayNightMareAnimation = isNightmare;
				isTweening = false;
			}

			//智能判断是否删除功能开放提示图标（噩梦模式）
			DisparkControl.instance.removeDisparkHandler(ConfigDisparkStep.DisparkStep10);
		}

		protected function set isPlayNightMareAnimation(value : Boolean) : void
		{
			if (effect_nigthMare == null)
			{
				effect_nigthMare = AnimationCreator.instance.create("effect_028", AssetMgr.instance);
				effect_nigthMare.x = 0;
				effect_nigthMare.y = 0;
			}

			if (value)
			{
				effect_nigthMare.play(Constants.FullScreenWidth > 960 ? "effect_028_1" : "effect_028_0");
				effect_nigthMare.animation.looping = true;
				addChildAt(effect_nigthMare, this.numChildren - 3);
			}
			else
			{
				effect_nigthMare.stop();
				effect_nigthMare.removeFromParent();
			}
		}

		/**
		 * 关闭打开按钮缓动
		 * @param child
		 * @param isOpen
		 *
		 */
		protected function tweenTab(child : DisplayObject, isOpen : Boolean, onComplete : Function) : void
		{
			isTweening = true;
			Starling.juggler.tween(child, 0.1, {x: (isOpen ? 0 : -child.width * .5), onComplete: onComplete});
		}

		/**
		 * 给音效按钮添加遮罩
		 * @param child
		 *
		 */
		protected function addMask(child : DisplayObject) : void
		{
			var sprite : Sprite = new Sprite();
			sprite.x = child.x;
			sprite.y = child.y;
			child.x = child.y = 0;
			sprite.addChild(child);
			sprite.clipRect = new Rectangle(2, -10, sprite.width + 35, sprite.height + 10);
			view_reward.addChild(sprite);

			DisparkControl.dicDisplay["tag_modle"] = sprite;
		}

		override public function dispose() : void
		{
			selected_data = null;
			effect_nigthMare && effect_nigthMare.dispose();
			NewMainTag.select_effect && NewMainTag.select_effect.removeFromParent(true);
			NewMainTag.select_effect = null;
			JTGiftTollgateComponent.closeGift();
			NewMainWorldRender.disDic();
			SoundManager.instance.tweenVolumeSmall("worldmap_bgm", 0.0, 1);
			super.dispose();
		}

		/**
		 * 新手引导
		 * @param name
		 * @return
		 *
		 */
		override public function getGuideDisplay(name : String) : *
		{
			if (name.indexOf("第一关入口") >= 0)
			{
				if (!list_map.isCreated)
					list_map.validate();
				var index : int = name.split(",").pop();
				return NewMainWorldRender(list_map.dataViewPort.getChildAt(0)).getMapByIndex(index).button;
			}
			else if (name == "布阵")
			{
				isTweeningBottom = true;
				view_reward.visible = true;
				view_reward.y = Constants.virtualHeight - view_reward.height + 20;
				return view_reward.getChildByName("btn_battle");
			}
			else if (name == "关卡礼包")
			{
				list_map.touchable = false;
				JTGiftTollgateComponent.openGift();
				return JTGiftTollgateComponent.getTollageteICON().btn_giftButton;
			}
			else if (name == "领取按钮")
			{
				JTGiftTollgateComponent.open(JTGiftTollgateComponent.getTollageteICON());
				return JTGiftTollgateComponent.instance.btn_get_giftButton;
			}
			return null;
		}

		/**
		 * 新手引导专用函数
		 * @param id
		 * 选取关卡章节
		 */
		override public function executeGuideFun(name : String) : void
		{
			if (name == "跳转主城")
			{
				SceneMgr.instance.changeScene(CityFace);
			}
			else if (name == "礼包界面")
			{
				JTGiftTollgateComponent.open(JTGiftTollgateComponent.getTollageteICON())
			}
			else if (name == "领取")
			{
				JTGiftTollgateComponent.instance.onGetGiftHandler(null);
			}
			else if (name == "主城界面")
			{
				JTGiftTollgateComponent.close();
				SceneMgr.instance.changeScene(CityFace);
			}
		}
	}
}


