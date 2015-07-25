package game.common
{
	import com.langue.Langue;
	import com.utils.StringUtil;

	import flash.utils.Dictionary;

	import game.data.Goods;
	import game.data.ShopData;
	import game.manager.AssetMgr;
	import game.net.message.GoodsMessage;
	import game.view.viewBase.JTUIFastBuyBase;

	import starling.display.Button;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;

	/**
	 * 快速购买通用框
	 * @author CabbageWrom
	 *
	 */
	public class JTFastBuyComponent extends JTUIFastBuyBase
	{
		public static const FAST_BUY_MONEY : int = 1;
		public static const FAST_BUY_STAR : int = 3;
		public static const FAST_BUY_HORN : int = 8;
		private static var buy_type : int = 0;

		public function JTFastBuyComponent()
		{
			super();
		}

		override protected function init() : void
		{
			clickBackroundClose(0.3);
			_closeButton = back;
			enableTween = true;
			var titles : Array = Langue.getLans("starBuyTitle")
			title.text = titles[buy_type - 1];
			back.text = Langue.getLangue("quit");
			back.fontSize = 30;
			back.fontColor = 0xffffff;

			star1.x = 70;
			star1.y = 93;

			star2.x = 242;
			star2.y = 93;

			star3.x = 410;
			star3.y = 93;
		}


		override protected function addListenerHandler() : void
		{
			super.addListenerHandler();
		}

		override protected function show():void
		{
			setItemProperty(int(_parameter));
		}

		private function setItemProperty(type : int) : void
		{
			buy_type = type;
			var i : int = 0;
			var shopHashMap : Dictionary = ShopData.hash.getMap();
			var icon_name : String = null

			for each (var shopData : ShopData in shopHashMap)
			{
				if (shopData.type != type)
				{
					continue;
				}
				i++;
				var txt_caption : TextField = this["caption" + i] as TextField;
				var txt_price : TextField = this["price" + i] as TextField;
				txt_caption.text = (type == FAST_BUY_MONEY ? Langue.getLangue("buyMoney") : Langue.getLangue("buyNumber")) + ":" + StringUtil.changePrice(shopData.count);
				txt_price.text = shopData.count * shopData.cost + "";
				var itemData : Goods = Goods.goods.getValue(type) as Goods;

				if (!itemData.picture)
				{
					JTLogger.error("[JTFastBuyComponent.show]Can't Find The Type" + type + "Icon!");
				}
				var texture : Texture = AssetMgr.instance.getTexture(itemData.picture);
				(this["star" + i] as Button).upState = texture;
				(this["star" + i] as Button).addEventListener(Event.TRIGGERED, onSendBuyItem);
				(this["star" + i] as Button).name = shopData.id + "";
			}
		}

		private function onSendBuyItem(e : Event) : void
		{
			var btn_buy : Button = e.target as Button;
			GoodsMessage.onSendBuyItem(int(btn_buy.name));
		}

	}
}
