package game.view.embattle
{
	import com.components.RollTips;
	import com.scene.SceneMgr;
	import com.sound.SoundManager;
	import com.utils.ArrayUtil;
	import com.utils.Constants;
	import com.view.Clickable;
	import com.view.base.event.EventType;

	import feathers.dragDrop.DragDropManager;

	import game.data.HeroData;
	import game.data.TollgateData;
	import game.data.Val;
	import game.manager.BattleAssets;
	import game.manager.GameMgr;
	import game.manager.HeroDataMgr;
	import game.managers.JTPvpInfoManager;
	import game.managers.JTSingleManager;
	import game.net.data.s.SEmbattle;
	import game.net.data.s.SVideoInfo;
	import game.net.message.GameMessage;
	import game.net.message.GoodsMessage;
	import game.view.blacksmith.render.NewHeroList;
	import game.view.city.CityFace;
	import game.view.heroHall.render.HeroIconRender;
	import game.view.new2Guide.NewGuide2Manager;
	import game.view.viewBase.NewEmBattleDlgBase;

	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.text.TextField;

	/**
	 * 布阵界面
	 * @author hyy
	 *
	 */
	public class EmBattleDlg extends NewEmBattleDlgBase
	{
		// 自动布阵
		private static const EMBATTLE:Array=[[0, 1, 0, 1, 1, 1, 0, 1, 0], [1, 0, 1, 1, 1, 1, 0, 0, 0], [1, 1, 0, 1, 1, 0, 0, 1, 0], [0, 0, 0, 1, 1, 1, 1, 0, 1]];
		public static var seat_index:int=0;
		private var tollgateData:TollgateData;
		/**
		 * 是否锁定自动布阵
		 */
		private var isLockAutoSeat:Boolean=false;
		private var list_hero:NewHeroList;
		private var list_grid:Array=[];
		private var isTweening:Boolean=false;
		private var click_pos:int;
		private var mask:Quad;
		private var view_index:EmBattleIndexView;
		private var virtualWidth:int;
		private var virtualHeight:int;

		public function EmBattleDlg()
		{
			super();
		}

		override protected function init():void
		{
			isVisible=true;
			_closeButton=btn_close;
			_okButton=view.getChildByName("btn_battle") as Button;

			list_hero=new NewHeroList(true);
			list_hero.selectedIndex=-1;
			list_hero.setSize(860, 140);
			addChild(list_hero);

			var render:EmbattleGrid;

			for (var i:int=0; i < Val.SEAT_COUNT; i++)
			{
				render=this["pos" + (i + 1)];
				list_grid.push(render);
				render.name=i + "";
				render.index=i;
			}

			if (Constants.isScaleWidth)
			{
				virtualWidth=Constants.FullScreenWidth / Constants.scale_x;
				virtualHeight=Constants.FullScreenHeight / Constants.scale_x;
			}
			else
			{
				virtualWidth=Constants.virtualWidth;
				virtualHeight=Constants.virtualHeight;
			}

			mask=new Quad(virtualWidth, view.y);
			mask.alpha=0;
			addChildAt(mask, 0);
			click_target=mask;

			view_index=new EmBattleIndexView();
			addChild(view_index);
			addChild(view_rank);

			view.y=view_list.y=virtualHeight - view_list.height;
			view.x=virtualWidth * .5;
			view_title.x=view.x;
			btn_close.x=virtualWidth - btn_close.width - 10;
			view_list.x=(virtualWidth - view_list.width) * .5;
			list_hero.move(view_list.x + 25, view_list.y + 23);
			onShowHeroListVisible();

			if (NewGuide2Manager.instance != null)
			{
				this.isLockAutoSeat=true;
				this.touchable=false;
			}

			this.setChildIndex(btn_close, this.numChildren - 1);
		}

		override protected function addListenerHandler():void
		{
			super.addListenerHandler();
			this.addClickFun(onBgClick);
			this.addContextListener(EventType.UPDATE_HERO_LIST_STATUS, onShowHeroListVisible);
			this.addContextListener(EventType.UPDATE_HERO_LIST, onUpdateHeroList);
			this.addContextListener(EventType.UPDATE_HERO_SELECTED, onHeroListSelected);
			this.addContextListener(EventType.UPDATE_TIRED, updateTired);
			this.addContextListener(SEmbattle.CMD + "", battleNotificationName);
			this.addContextListener(SVideoInfo.CMD + "", videoInfoNotification);
			this.addViewListener(view.getChildByName("btn_auto"), Event.TRIGGERED, autoEmbattle);
			this.addViewListener(btn_tired, Event.TRIGGERED, GoodsMessage.onBuyTiredClick);
		}

		/**
		 * 更新疲劳值
		 *
		 */
		protected function updateTired():void
		{
			txt_tired.text=GameMgr.instance.tired + "/100";
		}

		private function onBgClick(view:Clickable):void
		{
			if (list_hero.visible)
				onShowHeroListVisible();

			if (view_rank.isOpen)
				view_rank.onTweenClick();
		}

		override protected function show():void
		{
			tollgateData=_parameter as TollgateData;
			isTweening=false;
			NewHeroList.POSTION=0;
			initHeroSeat();
			onUpdateHeroList();
		}

		/**
		 * 初始化英雄位置
		 *
		 */
		private function initHeroSeat():void
		{
			var tmp_list:Array=HeroDataMgr.instance.getOnBattleHero();
			var render:EmbattleGrid;
			var heroData:HeroData;
			var len:int, i:int;

			if (tollgateData && tollgateData.helpHeroList.length > 0)
			{
				len=tmp_list.length;

				for (i=0; i < len; i++)
				{
					heroData=tmp_list[i];
					heroData.seat=0;
				}

				tmp_list=tollgateData.helpHeroList;
			}

			len=tmp_list.length;

			for (i=0; i < Val.SEAT_COUNT; i++)
			{
				render=list_grid[i];
				render.updateView(null, false);
			}

			for (i=0; i < len; i++)
			{
				heroData=tmp_list[i];

				if (heroData)
				{
					heroData.oldseat=heroData.seat;

					if (heroData.id > 0 && getHelpHeroBySeat(Val.posS2C(heroData.seat)))
					{
						heroData.seat=0;
						continue;
					}
				}

				render=list_grid[Val.posS2C(heroData.seat)];
				render.updateView(heroData, i == len - 1);
				render.visible=true;
			}
		}

		private function getHelpHeroBySeat(seat:int):HeroData
		{
			if (tollgateData == null)
				return null;
			var helpHeroList:Array=tollgateData.helpHeroList;
			var len:int=helpHeroList.length;

			for (var i:int=0; i < len; i++)
			{
				if (Val.posC2S(seat) == HeroData(helpHeroList[i]).seat)
					return helpHeroList[i];
			}
			return null;
		}

		/**
		 * 英雄列表点击
		 * @param evt
		 * @param heroData
		 *
		 */
		private function onHeroListSelected(evt:Event, heroData:HeroData):void
		{
			if (!visible)
				return;

			if (DragDropManager.isDragging)
				return;

			if (heroData.seat > 0)
			{
				addTips("EMBATTLE_ERROR1");
				return;
			}


			if (click_pos != -1)
			{
				var render:EmbattleGrid=list_grid[click_pos];
				var tmp_oldData:HeroData=render.data;

				var onBattleList:Array=HeroDataMgr.instance.getOnBattleHero();

				if (onBattleList.length == HeroDataMgr.instance.seatMax && tmp_oldData == null)
				{
					RollTips.add(getLangue("EMBATTLE_FOUR").replace("*", HeroDataMgr.instance.seatMax));
					return;
				}

				render.updateView(heroData);

				if (tmp_oldData)
				{
					tmp_oldData.seat=0;
					list_hero.updateItem(tmp_oldData);
				}
				list_hero.stopAllSound();
				SoundManager.instance.playSound(heroData.sound);
				onUpdateHeroList(null, heroData);
			}
			onShowHeroListVisible();
		}

		/**
		 * 显示英雄列表状态
		 *
		 */
		private function onShowHeroListVisible(evt:Event=null, pos:int=-1):void
		{

			click_pos=pos;
			var visible:Boolean=list_hero.visible ? false : true;
			list_hero.visible=visible;
			view_list.visible=visible;

			if (visible)
				list_hero.list_hero.selectedIndex=-1;
		}

		/**
		 * 刷新英雄上阵状态
		 *
		 */
		private function onUpdateHeroList(event:Event=null, heroData:HeroData=null):void
		{
			if (!visible)
				return;
			var freeCount:int=HeroDataMgr.instance.getFreeBattleHero().length;
			var count:int=HeroDataMgr.instance.getOnBattleHeroCount();
			var render:EmbattleGrid;

			for (var i:int=0; i < Val.SEAT_COUNT; i++)
			{
				render=list_grid[i];
				render.btn_add.visible=render.data == null && count < HeroDataMgr.instance.seatMax && freeCount > 0;
			}

			if (heroData)
				list_hero.updateItem(heroData);
			else if (list_hero.list_hero.dataViewPort)
				list_hero.list_hero.dataViewPort.dataProvider_refreshItemHandler();
			updateText();
			view_index.updateSeat();
		}

		/**
		 *  退出界面并且恢复布阵前英雄位置
		 *
		 */
		override protected function oncancelBtn():void
		{
			super.oncancelBtn();
			resetSeat();
		}

		/**
		 * 重置英雄的位置
		 *
		 */
		private function resetSeat():void
		{
			var tmp_list:Array=ArrayUtil.change2Array(HeroDataMgr.instance.hash.values());
			var len:int=tmp_list.length;
			var heroData:HeroData;

			for (var i:int=0; i < len; i++)
			{
				heroData=tmp_list[i];

				if (heroData)
				{
					heroData.seat=heroData.oldseat;
				}
			}
		}

		/**
		 * 布阵成功后，清理以前的英雄的位置
		 *
		 */
		private function clearOldSeat():void
		{
			var tmp_list:Array=ArrayUtil.change2Array(HeroDataMgr.instance.hash.values());
			var len:int=tmp_list.length;
			var heroData:HeroData;

			for (var i:int=0; i < len; i++)
			{
				heroData=tmp_list[i];

				if (heroData)
					heroData.oldseat=heroData.seat;
			}
		}

		/**
		 * 自动布阵
		 *
		 */
		public function autoEmbattle():void
		{
			if (isTweening || view_rank.isTweening || BattleAssets.instance.isLoading)
				return;

			if (view_rank.isOpen)
			{
				view_rank.onTweenClick(false);
				Starling.juggler.delayCall(autoEmbattle, 0.3);
				return;
			}

			var heroMgr:HeroDataMgr=HeroDataMgr.instance;
			var onBattleList:Array=heroMgr.getOnBattleHero();
			var tmpArr:Array=heroMgr.getFreeBattleHero();
			var count:int=onBattleList.length, len:int;
			var freeCount:int=tmpArr.length;
			var isSameSeat:Boolean=true;
			var render:EmbattleGrid;
			var heroData:HeroData;
			var helpData:HeroData;
			var index:int=0, i:int;
			var newSeat:int;

			for (i=0; i < count; i++)
			{
				heroData=onBattleList[i];
				heroData.seat=0;
			}

			//如果还有空位，并且有闲置英雄，则自动添加
			if (!heroMgr.isMaxBattle)
			{
				tmpArr.sortOn("getPower", Array.DESCENDING | Array.NUMERIC);
				onBattleList=onBattleList.concat(tmpArr.splice(0, HeroDataMgr.instance.seatMax - count));
			}

			//新手引导需要用到，防止连续点击
			if (isLockAutoSeat)
				seat_index=0;

			onBattleList.sortOn("hp", Array.DESCENDING);
			tmpArr=EMBATTLE[seat_index++ % EMBATTLE.length];
			len=tmpArr.length;

			for (i=0; i < len; i++)
			{
				heroData=null;
				render=list_grid[i];

				if (tmpArr[i] > 0)
				{
					heroData=onBattleList[index++];
					newSeat=Val.posC2S(i);

					if (heroData && heroData.seat != newSeat)
						isSameSeat=false;
				}

				helpData=getHelpHeroBySeat(i);

				if (helpData)
				{
					if (heroData)
					{
						index--;
						heroData.seat=0;
					}
					heroData=helpData;
				}

				if (index < onBattleList.length && i == len - 1)
					render.updateView(heroData, true);
				else
					render.updateView(heroData, index == onBattleList.length);
				heroData && list_hero.updateItem(heroData);
			}
			onUpdateHeroList();

			//如果本次变阵没有英雄改变，则继续自动
			if (!isLockAutoSeat && isSameSeat && onBattleList.length > 0)
				autoEmbattle();
		}

		private function battleNotificationName(evt:Event, shop:SEmbattle):void
		{
			//0成功1失败
			if (shop.status == 1)
			{
				resetSeat();
				initHeroSeat();
				view_index.updateSeat();
			}
			else
			{
				isTweening=true;
				clearOldSeat();
				resetHero();
				_okFunction();
				gotoNext(0, true);
				view_index.visible=false;
				dispatch(EventType.UPDATE_BATTLE_STATUS, HeroDataMgr.instance.getOnBattleHero());
				view_rank.isOpen && view_rank.onTweenClick(false);
				Starling.juggler.tween(view, 0.3, {y: virtualHeight, onComplete: close});
			}
		}

		private function videoInfoNotification():void
		{
			isTweening=true;
			clearOldSeat();
			resetHero();
			view_index.visible=false;
			view_rank.isOpen && view_rank.onTweenClick(false);
			Starling.juggler.tween(view, 0.3, {y: virtualHeight, onComplete: close});
		}

		private function resetHero():void
		{
			//回收英雄
			var render:EmbattleGrid;

			for (var i:int=0; i < Val.SEAT_COUNT; i++)
			{
				render=list_grid[i];

				if (render.data)
					render.data.oldseat=0;
				render.updateView(null, false);
				render.visible=false;
			}
		}

		/**
		 * 更新文本显示
		 *
		 */
		private function updateText():void
		{
			var count:int=HeroDataMgr.instance.getOnBattleHeroCount();
			view_title.visible=tollgateData != null;
			view.getChildByName("txt_count")["text"]=count + "/" + HeroDataMgr.instance.seatMax;
			view.getChildByName("txt_power")["text"]=HeroDataMgr.instance.getPower();
			view.getChildByName("txt_power1")["text"]=tollgateData ? tollgateData.power + "" : "";
			view.getChildByName("txt_tired")["text"]=tollgateData ? tollgateData.tired + "" : "";
			TextField(view_title.getChildByName("text")).text=tollgateData ? tollgateData.tollgateName : "";

			if (tollgateData == null)
			{
				var pvpInfoManager:JTPvpInfoManager=JTSingleManager.instance.pvpInfoManager;

				if (pvpInfoManager.enemy_info)
				{
					view.getChildByName("txt_power1")["text"]=pvpInfoManager.enemy_info.power;
				}
			}
			txt_tired.text=GameMgr.instance.tired + "/" + 100;
		}

		override protected function onOkBtn():void
		{
			if (isTweening || view_rank.isTweening || view_list.visible)
				return;

			if (HeroDataMgr.instance.getOnBattleHeroCount() == 0)
			{
				addTips("NO_HERO");
				return;
			}
			GameMessage.sendEmBattle();
		}


		/**
		 * 新手引导
		 * @param name
		 * @return
		 *
		 */
		override public function getGuideDisplay(name:String):*
		{
			var renderGrid:EmbattleGrid;
			this.touchable=true;

			if (name == "自动布阵按钮")
			{
				onBgClick(null);
				return view.getChildByName("btn_auto");
			}
			else if (name == "开始战斗按钮")
			{

//				if (GameMgr.instance.tollgateID == 1) {
//					setSeat(30008, 12);
//				} else if (GameMgr.instance.tollgateID == 2) {
//					setSeat(30008, 12);
//					setSeat(30002, 15);
//				} else if (GameMgr.instance.tollgateID == 4) {
//					setSeat(30008, 11);
//					setSeat(30002, 14);
//					setSeat(30001, 17);
//				}

				function setSeat(type:int, seat:int):void
				{
					var tmp_hero:HeroData=HeroDataMgr.instance.getHeroBattleHeroByType(type);

					if (tmp_hero)
						tmp_hero.seat=seat;
				}
				onBgClick(null);
				NewGuide2Manager.isLoading=true;
				return _okButton;
			}
			else if (name.indexOf("布阵") >= 0)
			{
				var tmpHeros:Array=name.split(",")[1].split("-");
				var child:EmbattleGrid=list_grid[tmpHeros[0]];

				if (tmpHeros.join("-") == "0-1" || tmpHeros.join("-") == "3-4")
				{
					renderGrid=list_grid[tmpHeros[1]];
					var tmp_heroData:HeroData=renderGrid.data;

					if (tmp_heroData == null)
						return null;
					var q:Quad=new Quad(child.empty_ico.width, child.empty_ico.height * 2);
					q.x=child.x;
					q.y=child.y;
					addChild(q);
					addGuideContextEvent(EventType.UPDATE_HERO_LIST, dragHeroComplete);

					function dragHeroComplete():void
					{
						renderGrid.updateView(null, false);
						child.updateView(tmp_heroData);
						dispatch(EventType.UPDATE_HERO_LIST, tmp_heroData);
					}
					return q;
				}
				addGuideContextEvent(EventType.UPDATE_HERO_LIST_STATUS);
				return child;
			}
			else if (name.indexOf("英雄") >= 0)
			{
				list_hero.validate();
				tmpHeros=name.split(",")[1].split("-");
				var index:int=tmpHeros[0]
				var render:HeroIconRender=list_hero.getChildItem(index) as HeroIconRender;
				render.isDragEnable=false;
				addGuideContextEvent(EventType.UPDATE_HERO_SELECTED, dragHeroListComplete);

				if (!list_hero.visible)
					onShowHeroListVisible(null, tmpHeros[1]);

				function dragHeroListComplete():void
				{
					var tmp_hero:HeroData=list_hero.list_hero.dataProvider.getItemAt(index) as HeroData;

					if (tmp_hero.seat != Val.posC2S(tmpHeros[1]))
					{
						if (tmp_hero.seat > 0)
						{
							renderGrid=list_grid[Val.posS2C(tmp_hero.seat)];
							renderGrid && renderGrid.updateView(null, false);
							tmp_hero.seat=0;
						}
						click_pos=tmpHeros[1];
						renderGrid=list_grid[click_pos];
						renderGrid && renderGrid.updateView(tmp_hero, false);

					}
				}
				return render;
			}
			return null;
		}

		/**
		 * 新手引导专用函数
		 * @param id
		 */
		override public function executeGuideFun(name:String):void
		{
			switch (name)
			{
				case "跳转主城":
					SceneMgr.instance.changeScene(CityFace);
					break;
				default:
					break;
			}
		}

		override public function dispose():void
		{
			super.dispose();
			list_grid.length=0;
		}

	}
}


