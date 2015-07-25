package game.view.PVP
{
	import feathers.controls.renderers.DefaultListItemRenderer;

	import game.data.WidgetData;
	import game.manager.AssetMgr;
	import game.view.PVP.ui.JTUIEquipment;
	import game.view.widget.BagWidget;

	import starling.display.Image;

	public class JTPvpEquipItemRender extends DefaultListItemRenderer
	{
		public var item:JTUIEquipment = null;
		private var imageBox:BagWidget = null;
		private var equipLv:Image = null;
		public function JTPvpEquipItemRender()
		{
			super();
			item = new JTUIEquipment();
			equipLv = new Image(AssetMgr.instance.getTexture("ui_iocn_qualifying" + 1));
			item.addChild(equipLv);
			this.defaultSkin = this.item;
			imageBox = new BagWidget();
			item.btn_box.addChild(imageBox);
		}

		override public function set data(value:Object):void
		{
			if (!value)
			{
				return;
			}
			var price:Number = value.price;
			var lv:int = value.level;
			var widget:WidgetData = value.widget;
			imageBox.setWidgetData(widget);
			item.btn_box.upState = AssetMgr.instance.getTexture("ui_gongyong_90wupingkuang" + (widget.quality - 1));
			equipLv.texture = AssetMgr.instance.getTexture("ui_iocn_qualifying" + lv);
			item.btn_box.downState = item.btn_box.upState;
			this.item.txt_name.text = widget.name;
			this.item.txt_horn.text = price.toString();
			super.data = value;
		}
	}
}

