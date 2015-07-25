package game.view.vip
{
	import com.components.RollTips;
	import com.langue.Langue;
	import com.utils.ArrayUtil;
	import com.utils.Constants;
	import com.view.base.event.EventType;
	import com.view.base.event.ViewDispatcher;

	import feathers.controls.ScrollContainer;
	import feathers.controls.Scroller;
	import feathers.layout.TiledColumnsLayout;
	import feathers.layout.TiledRowsLayout;

	import game.data.DiamondShopData;
	import game.data.VipData;
	import game.manager.UiManager;
	import game.uils.Config;
	import game.view.viewBase.VipChargeRenderBase;

	import sdk.AccountManager;

	import starling.events.Event;

	public class VipChargeView extends ScrollContainer
	{
		private var view : VipChargeRenderBase;

		public function VipChargeView()
		{
			super();
			init();
		}

		protected function init() : void
		{
			const listLayout : TiledColumnsLayout = new TiledColumnsLayout();
			listLayout.gap = 8;
			listLayout.useSquareTiles = false;
			listLayout.tileVerticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_TOP;
			listLayout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
			verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			this.layout = listLayout;
			this.setSize(740, 270);
			view = new VipChargeRenderBase();
			this.addChild(view);


			for (var i : int = 0; i < 8; i++)
			{
				var diamond : DiamondShopData = DiamondShopData.list[i];
				view["box" + i].name = diamond.idNume;
				view["box" + i].addEventListener(Event.TRIGGERED, onClick);
				view["itemNum" + i].text = diamond.diamond + Langue.getLangue("diamond");
//				view["itemPrice" + i].text = (Config.device == Config.android) ? "" : diamond.rmb + Langue.getLangue("rmb");

				if (i < 7)
					view["tag_double" + i].visible = diamond.double == 1;
			}

			view.box8.addEventListener(Event.TRIGGERED, onMyCardClick);
			view.txt_reward.text = VipData.month_card.today;
			ViewDispatcher.instance.addEventListener(EventType.UPDATE_DIAMOND_DOUBLE, onUpdateDouble);
		}

		private function onMyCardClick() : void
		{
			UiManager.loadAndOpenView(UiManager.MYCARD_PAY);
		}

		private function onUpdateDouble() : void
		{
			for (var i : int = 0; i < 7; i++)
			{
				var diamond : DiamondShopData = DiamondShopData.list[i];
				view["tag_double" + i].visible = diamond.double == 1;
			}
		}

		/**
		 * 充值
		 * @param evt
		 *
		 */
		private function onClick(evt : Event) : void
		{
			if (isScrolling)
				return;
			var name : String = evt.target["name"].match("(?<=\").*(?=\")")[0];
			var diamond : DiamondShopData = ArrayUtil.getArrayObjByField(DiamondShopData.list, evt.target["name"], "idNume") as DiamondShopData;

			if (Config.device == Config.android)
			{
				UiManager.loadAndOpenView(UiManager.ANDROID_PAY, diamond);
				return;
			}

			try
			{
				AccountManager.instance.pay(diamond.shopid.toString(), name, diamond.rmb, 1);
			}
			catch (e : Error)
			{
				RollTips.add(Langue.getLangue("buying"));
			}
		}

		override public function dispose() : void
		{
			super.dispose();
			ViewDispatcher.instance.removeEventListener(EventType.UPDATE_DIAMOND_DOUBLE, onUpdateDouble);
		}
	}
}