package game.view.widget
{
	import game.data.Goods;
	import game.data.WidgetData;
	import game.manager.AssetMgr;
	import game.view.comm.GraphicsNumber;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;

	/**
	 * 物品图标
	 * @author Michael
	 *
	 */
	public class BagWidget extends Widget
	{
		public function BagWidget(widgetData:WidgetData=null, dragable:Boolean=true)
		{
			_widget=widgetData;
			if (_widget)
			{
				inits(AssetMgr.instance.getTexture(widgetData.picture), dragable);
			}
		}

		public var _textFontNumber:TextField;
		private var _num:int;
		private var _textNumber:Sprite;
		private var _widget:WidgetData;

		override public function inits(texture:Texture, dragable:Boolean=true):void
		{
			if (texture)
				super.inits(texture, dragable);
		}

		public function get widget():WidgetData
		{
			return _widget;
		}

		private var _qualityImage:Image;

		public function showQuality():void
		{
			var texture:Texture=AssetMgr.instance.getTexture("ui_gongyong_90wupingkuang" + (_widget.quality - 1));
			if (_qualityImage)
			{
				_qualityImage.texture=texture;
			}
			else
			{
				_qualityImage=new Image(texture);
				addChild(_qualityImage);
			}
		}

		//GraphicsNumber的位图数字
		public function setWidgetData(widgetData:Goods):void
		{
			_widget=widgetData as WidgetData;
			inits(AssetMgr.instance.getTexture(widgetData.picture), false);
		}

		//文本
		public function WidgetNumber(num:int, x:int=90, y:int=90, textureFirstName:String="ui_shuzi"):void
		{
			if (_num == num)
				return;

			_num=num;
			if (_textNumber == null)
			{
				_textNumber=GraphicsNumber.instance().getNumber(num + 1, textureFirstName);
				parent.addChild(_textNumber);
				_textNumber.x=x;
				_textNumber.y=y;
			}
		}

		public function WidgetNumberToTextField(num:int, x:int=90, y:int=90, fontName:String="myFont", ago:String="",
			size:int=20):void
		{
			_num=num;
			if (!_textFontNumber)
			{
				_textFontNumber=new TextField(60, 25, ago + num, fontName, size, 0xffffff);
				parent.addChild(_textFontNumber);
				_textFontNumber.hAlign='center';
				_textFontNumber.x=x;
				_textFontNumber.y=y;
				_textFontNumber.touchable=true;
			}
		}
	}
}
