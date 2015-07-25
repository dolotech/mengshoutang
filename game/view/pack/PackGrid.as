package game.view.pack
{
	import com.utils.ObjectUtil;

	import game.base.SelectIcon;
	import game.data.WidgetData;
	import game.manager.AssetMgr;
	import game.view.widget.BagWidget;

	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	public class PackGrid extends Sprite
	{
		private var Icon:BagWidget;
		private var quaity:Button;
		private var quaityDi:Image;

		public function PackGrid(upState:Texture, text:String="", downState:Texture=null)
		{
			quaityDi=new Image(AssetMgr.instance.getTexture('ui_gongyong_90wupingkuang'));
			addQuiackChild(quaityDi);

			Icon=new BagWidget();
			Icon.touchable=false;
			selectIcon=new SelectIcon();
			addChild(Icon);

			quaity=new Button(upState, text, downState);
			quaity.downState=null;
			addQuiackChild(quaity);
		}

		private var _data:Object;

		public function set data(data:Object):void
		{
			_data=data;
			quaity.downState=null;
			addIcon();
		}

		private function addIcon():void
		{
			if (Icon._textFontNumber && Icon._textFontNumber.parent)
			{
				Icon._textFontNumber.removeFromParent();
				Icon._textFontNumber=null;
			}

			if (selectIcon)
				selectIcon.removeFromParent();
			_isOff=false;
			var widget:WidgetData=_data as WidgetData;

			if (!widget) //如果该物品无数据为空,恢复默认
			{
				while (Icon.numChildren)
					Icon.removeChildAt(0);
				quaity.upState=AssetMgr.instance.getTexture("ui_gongyong_90wupingkuang");
				return;
			}
			quaity.upState=AssetMgr.instance.getTexture("ui_gongyong_90wupingkuang" + (widget.quality - 1));
			Icon.setWidgetData(widget);

			if (widget.pile != 0 && widget.tab != 5)
			{
				if (widget.tab == 2 && widget.sort == 4) // 过滤宝珠
				{
					Icon.WidgetNumberToTextField(widget.level, 30, 55, "", "Lv ", 20);
				}
				else
				{
					Icon.WidgetNumberToTextField(widget.pile, 30, 55, "", "x ", 20);
				}
			}
			else if (widget.level > 0)
			{
				Icon.WidgetNumberToTextField(widget.level, 5, 55, "", "+ ", 20);
			}
			Icon.x=0;
			Icon.y=0;

			if (widget.pile == 0 || widget.tab == 5)
				ObjectUtil.setToCenter(this.getChildAt(0), Icon);
		}

		private var _isOff:Boolean;

		public function off():void
		{
			_isOff=true;
			while (Icon.numChildren)
				Icon.removeChildAt(0);
			if (Icon._textFontNumber && Icon._textFontNumber.parent)
			{
				Icon._textFontNumber.removeFromParent();
				Icon._textFontNumber=null;
			}
			quaity.upState=AssetMgr.instance.getTexture("ui_beibao_beibaoshangsuozhuangtai");
			ObjectUtil.setToCenter(this.getChildAt(0), Icon);
			quaity.downState=null;
			_data=null;
		}

		public function addText(color:uint=0xffffff, agoText:String="x"):void
		{
			var widget:WidgetData=_data as WidgetData;
			Icon.WidgetNumberToTextField(widget.pile, 90, 105, "myFont", agoText);
		}

		public function get data():Object
		{
			return _data;
		}

		public function get isOff():Boolean
		{
			return _isOff;
		}

		private var _isSelect:Boolean;
		private var selectIcon:SelectIcon;

		public function select():void
		{
			if (!_isSelect)
			{
				addSelect();
				_isSelect=true;
			}
			else
			{
				selectIcon.removeFromParent();
				_isSelect=false;
			}
		}

		private function addSelect():void
		{
			addChild(selectIcon);
			ObjectUtil.setToCenter(this.getChildAt(0), selectIcon);
		}

		public function get isSelect():Boolean
		{
			return _isSelect;
		}
	}
}
