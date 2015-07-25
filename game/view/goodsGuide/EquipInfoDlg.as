package game.view.goodsGuide
{
	import com.dialog.Dialog;
	import com.dialog.DialogMgr;
	import com.view.base.event.EventType;
	
	import game.data.ForgeData;
	import game.data.Goods;
	import game.data.WidgetData;
	import game.net.message.EquipMessage;
	import game.net.message.GameMessage;
	import game.scene.BattleScene;
	import game.view.city.CityFace;
	import game.view.gameover.LostView;
	import game.view.goodsGuide.view.GoodsDropList;
	import game.view.goodsGuide.view.GoodsGuideForgeView;
	import game.view.goodsGuide.view.GoodsGuideInfoView;
	
	import starling.events.Event;

	/**
	 * 装备引导
	 * @author hyy
	 *
	 */
	public class EquipInfoDlg extends Dialog
	{
		protected var view_goodsInfo : GoodsGuideInfoView; //物品引导详细信息
		protected var view_drop : GoodsDropList; //掉落列表
		protected var view_forge : GoodsGuideForgeView; //合成界面

		public function EquipInfoDlg()
		{
			super(true);
		}

		override protected function init() : void
		{
			enableTween = true;
			view_goodsInfo = new GoodsGuideInfoView();
			addChild(view_goodsInfo);
			clickBackroundClose();
		}

		override protected function show() : void
		{
			var goods : Goods = _parameter as Goods;

			if (goods.isPack)
			{
				var forgeData : ForgeData = ForgeData.hash.getValue(goods.type);

				if (forgeData && goods.isForge)
				{
					view_forge = new GoodsGuideForgeView();
					view_forge.x = view_goodsInfo.width + 4;
					addChild(view_forge);
				}
				else if (goods.drop_location)
				{
					view_drop = new GoodsDropList();
					view_drop.x = view_goodsInfo.width + 4;
					addChild(view_drop);
				}
			}
			else
			{
				view_goodsInfo.btn_Swallow.visible = goods.isPack;
			}
			view_goodsInfo.data = goods;
			view_goodsInfo.btn_ok.visible = goods.isPack;
		}

		override protected function openTweenComplete() : void
		{
			var widget : Goods = _parameter as Goods;

			if (view_drop)
				view_drop.data = widget;
			else if (view_forge)
				view_forge.data = widget;
//			else if (view_goodsInfo)
//				view_goodsInfo.data = widget;
		}

		override protected function addListenerHandler() : void
		{
			super.addListenerHandler();
			this.addViewListener(view_goodsInfo.btn_ok, Event.TRIGGERED, onChangeForgeViewHandler);
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

		protected function onChangeForgeViewHandler() : void
		{
			if (WidgetData.getWidgetByType(view_goodsInfo.data.type) == null)
			{
				addTips("notGet_goods");
				return;
			}
			else if (view_goodsInfo.data.Price == 0)
			{
				addTips("cantSell");
				return;
			}
			EquipMessage.sendSellGoods(view_goodsInfo.data as Goods);
		}

		override public function dispose() : void
		{
			super.dispose();
			view_goodsInfo && view_goodsInfo.removeFromParent(true);
			view_drop && view_drop.removeFromParent(true);
			view_forge && view_forge.removeFromParent(true);
		}
	}
}


