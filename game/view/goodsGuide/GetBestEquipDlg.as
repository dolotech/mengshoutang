package game.view.goodsGuide
{
	import com.dialog.Dialog;
	import com.dialog.DialogMgr;
	import com.utils.ArrayUtil;
	import com.utils.Constants;
	import com.view.View;
	import com.view.base.event.EventType;
	
	import game.data.ForgeData;
	import game.data.Goods;
	import game.net.message.GameMessage;
	import game.scene.BattleScene;
	import game.view.city.CityFace;
	import game.view.gameover.LostView;
	import game.view.goodsGuide.view.GoodsDropList;
	import game.view.goodsGuide.view.GoodsGuideForgeView;
	import game.view.goodsGuide.view.GoodsGuideList;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.events.Event;

	/**
	 * 获得最好的装备
	 * @author hyy
	 *
	 */
	public class GetBestEquipDlg extends Dialog
	{
		private var list_goods : GoodsGuideList;
		private var view_drop : GoodsDropList;
		private var view_forge : GoodsGuideForgeView;

		public function GetBestEquipDlg()
		{
			super(true);
		}

		override protected function init() : void
		{
			list_goods = new GoodsGuideList();
			addChild(list_goods);
			clickBackroundClose();
		}

		override protected function addListenerHandler() : void
		{
			super.addListenerHandler();
			this.addContextListener(EventType.SELECTED_TITLE_GOODS_GUIDE, onSelectedGOodsGuide);
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

		override protected function show() : void
		{
			var tmp_goods : Object = _parameter[0];
			var type : int = int(tmp_goods.type);
			var level : int = int(tmp_goods.level);
			var tmp_list : Array = ArrayUtil.change2Array(Goods.goods.values());
			var len : int = tmp_list.length;
			var tmp_guide_list : Array = [];
			var tmp_pvp_list : Array = [];
			var goods : Goods;

			//小于10级的，强制查看10级的装备
			if (level < 10)
				level = 10;

			for (var i : int = 0; i < len; i++)
			{
				goods = tmp_list[i];

				if (goods.sort != type || goods.tab != 5 || goods.limitLevel > level)
					continue;

				if (goods.isGuide == 2)
				{
					tmp_guide_list.push(goods);
				}
				else if (goods.isPvp == 1)
				{
					tmp_pvp_list.push(goods);
				}
			}
			tmp_guide_list.sortOn("limitLevel", Array.NUMERIC | Array.DESCENDING);
			tmp_pvp_list.sortOn("limitLevel", Array.NUMERIC | Array.DESCENDING);

//			if (tmp_guide_list.length > 2)
//				tmp_guide_list.length = 2;
//
//			if (tmp_pvp_list.length > 1)
//				tmp_pvp_list.length = 1;

			if (_parameter.length > 1)
				list_goods.index = _parameter[1];
			list_goods.list = tmp_guide_list.concat(tmp_pvp_list);
			list_goods.easingIn();
		}

		private function onSelectedGOodsGuide(evt : Event, goods : Goods) : void
		{
			var forgeData : ForgeData = ForgeData.hash.getValue(goods.type);
			var tmp_view : View;

			if (forgeData)
			{
				if (view_forge == null)
				{
					view_forge = new GoodsGuideForgeView();
					view_forge.x = list_goods.x;
					view_forge.y = list_goods.y;
				}
				view_forge.data = forgeData;
				tmp_view = view_forge;
			}
			else if (goods.drop_location)
			{
				if (view_drop == null)
				{
					view_drop = new GoodsDropList();
					view_drop.x = list_goods.x;
					view_drop.y = list_goods.y;
				}
				view_drop.data = goods;
				tmp_view = view_drop;
			}
			view_drop && view_drop.removeFromParent();
			view_forge && view_forge.removeFromParent();

			var left_width : int = list_goods.width;
			var right_width : int = tmp_view ? tmp_view.width : 0;
			var left_x : int = (Constants.virtualWidth - left_width - right_width) * .5;
			var right_x : int = left_x + left_width + 4;
			tmp_view && addChildAt(tmp_view, 0);
			Starling.juggler.tween(list_goods, 0.3, {x: left_x, transition: Transitions.EASE_OUT});
			tmp_view && Starling.juggler.tween(tmp_view, 0.3, {x: right_x, transition: Transitions.EASE_OUT});
		}

		override public function dispose() : void
		{
			super.dispose();
			view_drop && view_drop.removeFromParent(true);
			view_forge && view_forge.removeFromParent(true);
		}

		override public function get backParam() : Object
		{
			return [_parameter[0], list_goods.list_equip.selectedIndex];
		}
	}
}