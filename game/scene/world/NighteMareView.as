package game.scene.world
{
	import feathers.controls.Scroller;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.TiledColumnsLayout;
	import feathers.layout.TiledRowsLayout;
	
	import game.data.Goods;
	import game.data.MainLineData;
	import game.manager.GameMgr;
	import game.net.message.GameMessage;
	import game.view.viewBase.NighteMareViewBase;
	
	import starling.events.Event;
	import starling.text.TextField;


	/**
	 * 噩梦难度
	 * @author hyy
	 *
	 */
	public class NighteMareView extends NighteMareViewBase
	{
		public function NighteMareView()
		{
			super();
		}

		override protected function init() : void
		{
			_closeButton = btn_ok;
			const equiplistLayout : TiledColumnsLayout = new TiledColumnsLayout();
			equiplistLayout.useSquareTiles = false;
			equiplistLayout.useVirtualLayout = true;
			equiplistLayout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
			list_reward.layout = equiplistLayout;
			list_reward.horizontalScrollPolicy = Scroller.SCROLL_POLICY_ON;
			list_reward.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			list_reward.itemRendererFactory = itemEquipRendererFactory;

			function itemEquipRendererFactory() : IListItemRenderer
			{
				const renderer : NighteMareRender = new NighteMareRender();
				renderer.setSize(140, 120);
				return renderer;
			}

			setToCenter();
			clickBackroundClose();
		}

		override protected function show() : void
		{
			if (_parameter == null)
			{
				this.close();
				return;
			}
			list_reward.dataProvider = new ListCollection([_parameter]);
			var goods : Goods = _parameter as Goods;
			var tmp_list : Array = goods.drop_location ? goods.drop_location.split(",") : [];
			var len : int = tmp_list.length;
			var data : MainLineData;
			var text : TextField;

			for (var i : int = 0; i < len; i++)
			{
				if (i >= 4)
					break;
				data = MainLineData.getPoint(tmp_list[i]);
				text = this["txt_drop" + i];
				text.name = data.id + "";
				text.text = data.pointName;
				text.color = GameMgr.instance.tollgateID >= data.pointID ? 0x00ff00 : 0xff0000;
			}
		}

		override protected function addListenerHandler() : void
		{
			super.addListenerHandler();

			for (var i : int = 0; i < 4; i++)
			{
				this["txt_drop" + i].touchable = true;
				this.addViewListener(this["txt_drop" + i], Event.TRIGGERED, onTouch)
			}
		}

		private function onTouch(evt : Event) : void
		{
			var textField : TextField = evt.currentTarget as TextField;

			if (textField)
			{
				var data : MainLineData = MainLineData.getPoint(int(textField.name));

				if (data)
				{
					if (GameMgr.instance.tollgateID >= data.pointID)
					{
						if (data.isFb)
							GameMgr.instance.game_type = GameMgr.FB;
						GameMessage.gotoTollgateData(data.id);
					}
					else
					{
						var lastPoint : MainLineData = MainLineData.getPoint(data.pointID - 1);
						addTips(getLangue("onOpen") + (lastPoint ? lastPoint.pointName : ""));
					}
				}

			}
		}

	}
}