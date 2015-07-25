package game.view.goodsGuide
{
	import com.dialog.Dialog;
	import com.dialog.DialogMgr;
	import com.utils.Constants;
	import com.view.base.event.EventType;
	
	import game.data.ForgeData;
	import game.data.HeroData;
	import game.data.WidgetData;
	import game.net.message.EquipMessage;
	import game.net.message.GameMessage;
	import game.scene.BattleScene;
	import game.view.city.CityFace;
	import game.view.gameover.LostView;
	import game.view.goodsGuide.view.GoodsGuideForgeView;
	import game.view.goodsGuide.view.GoodsGuideInfoView;
	import game.view.goodsGuide.view.GoodsGuideList;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;

	/**
	 * 装备/合成物品
	 * @author hyy
	 *
	 */
	public class GoodsEquipOrForgeDlg extends Dialog
	{
		private var list_goods : GoodsGuideList;
		private var view_goodsInfo : GoodsGuideInfoView;
		private var view_forge : GoodsGuideForgeView;
		private var isTweening : Boolean;
		public static var curr_hero : HeroData;

		public function GoodsEquipOrForgeDlg()
		{
			super(true);
		}

		override protected function init() : void
		{
			view_goodsInfo = new GoodsGuideInfoView();
			addChild(view_goodsInfo);
			view_goodsInfo.visible = false;

			view_forge = new GoodsGuideForgeView();
			addChild(view_forge);
			view_forge.visible = false;

			list_goods = new GoodsGuideList();
			addChild(list_goods);

			clickBackroundClose();
		}

		override protected function show() : void
		{
			var tmp_arr : Array = ForgeData.getGoodsListBySort(4);
			var tag_a : int;
			var tag_b : int;
			tmp_arr.sort(sort);
			function sort(a : ForgeData, b : ForgeData) : int
			{
				tag_a = tag_b = 0;

				if (WidgetData.getWidgetNoEquipByType(a.type, curr_hero.id))
					tag_a += 2;

				if (WidgetData.getWidgetNoEquipByType(b.type, curr_hero.id))
					tag_b += 2;

				if (a.id < b.id)
					tag_a++;

				if (b.id < a.id)
					tag_b++;

				if (tag_a > tag_b)
					return -1

				if (tag_a < tag_b)
					return 1
				return 0
			}
			list_goods.list = tmp_arr;

			view_goodsInfo.setToCenter();
			list_goods.easingIn();
		}

		override protected function addListenerHandler() : void
		{
			super.addListenerHandler();
			this.addViewListener(view_goodsInfo.btn_ok, Event.TRIGGERED, onChangeForgeViewHandler);
			this.addContextListener(EventType.SELECTED_TITLE_GOODS_GUIDE, onSelectedGOodsGuide);
			this.addContextListener(EventType.NOTIFY_FORGE_EQUIP, onReturnForgeEquip);
			this.addContextListener(EventType.NOTIFY_HERO_EQUIP, onUpdateEquipNotify);
			this.addContextListener(EventType.CHANGE_BATTLE, onChangeBattle);
		}
		
		private function onChangeBattle(event : Event, id : int) : void
		{
			var currScene : Class = DialogMgr.instance.currScene;
			
			if (currScene == BattleScene)
				currScene = CityFace;
			GameMessage.removeBackDialog(LostView);
			GameMessage.gotoTollgateData(id, currScene, DialogMgr.instance.currDialogs, DialogMgr.instance.currDialogParams);
		}

		override public function open(container : DisplayObjectContainer, parameter : Object = null, okFun : Function = null, cancelFun : Function = null) : void
		{
			curr_hero = parameter as HeroData;
			super.open(container, parameter, okFun, cancelFun);
		}

		/**
		 * 装备称号返回
		 *
		 */
		private function onUpdateEquipNotify() : void
		{
			view_goodsInfo.updateBtnStatus();
		}

		/**
		 * 合成返回
		 *
		 */
		private function onReturnForgeEquip(evt : Event, isSuccess : Boolean) : void
		{
			list_goods.list_equip.dataViewPort.dataProvider_refreshItemHandler();
			view_forge.list_equip.dataViewPort.dataProvider_refreshItemHandler();
		}

		/**
		 * 切换到合成界面
		 *
		 */
		private function onChangeForgeViewHandler() : void
		{
			//合成
			if (view_goodsInfo.btn_ok.text == getLangue("forge"))
			{
				view_forge.visible = true;
				view_forge.move(view_goodsInfo.x, view_goodsInfo.y);
				view_forge.data = view_goodsInfo.data;
				view_goodsInfo.visible = false;
			}
			//装备/替换
			else if (view_goodsInfo.btn_ok.text == getLangue("EQUIP") || view_goodsInfo.btn_ok.text == getLangue("replace"))
			{
				var equip : WidgetData = WidgetData.getCanEquipWidgetByType(view_goodsInfo.data.type);
				EquipMessage.sendReplaceEquip(5, curr_hero, equip.id);
			}
			//卸下
			else if (view_goodsInfo.btn_ok.text == getLangue("noreplceNull"))
			{
				equip = WidgetData.getCanEquipWidgetByType(view_goodsInfo.data.type);
				EquipMessage.sendReplaceEquip(5, curr_hero, 0);
			}
		}

		private function onSelectedGOodsGuide(evt : Event, forgeData : ForgeData) : void
		{
			if (isTweening)
				return;
			isTweening = true;

			if (!view_goodsInfo.visible && !view_forge.visible)
			{
				var left_width : int = list_goods.width;
				var right_width : int = view_goodsInfo.width;
				var left_x : int = (Constants.virtualWidth - left_width - right_width) * .5;
				var right_x : int = left_x + left_width + 4;
				view_goodsInfo.visible = true;
				Starling.juggler.tween(list_goods, 0.3, {x: left_x, transition: Transitions.EASE_OUT});
				Starling.juggler.tween(view_goodsInfo, 0.3, {x: right_x, onComplete: onComplete, transition: Transitions.EASE_OUT});
			}
			else
			{
				onComplete();
			}

			function onComplete() : void
			{
				view_forge.visible = false;
				view_goodsInfo.visible = true;
				view_goodsInfo.curr_data = curr_hero;
				view_goodsInfo.data = forgeData;
				isTweening = false;
			}
		}

		override public function dispose() : void
		{
			super.dispose();
			curr_hero = null;
		}
	}
}