package com.utils
{

	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	/**
	 * 位图数字
	 * @author Michael
	 *
	 */
	public class NumberDisplay extends Sprite
	{
		private var isInit : Boolean = false;
		private var _texture : Vector.<Texture>;
		/**
		 * 0=左对齐，1=居中，2=右对齐
		 */
		public var align : int;

		public static const LEFT : int = 0;
		public static const CENTER : int = 1;
		public static const RIGHT : int = 2;
		private var _num : *;
		private var _gap : int;

		public function NumberDisplay(texture : Vector.<Texture>, gap : int = 22, value : int = 0)
		{
			_gap = gap;
			_texture = texture;
			align = value;
		}

		public function get number() : *
		{
			return _num;
		}

		public function set number(str : *) : void
		{
			_num = str;

			while (numChildren > 0)
			{
				removeChildAt(0, true);
			}

			if (str == null)
				return;

			if (str is int || str is Number)
			{
				str = str + "";
			}
			var strLen : int = str.length;

			for (var i : int = 0; i < strLen; i++)
			{

				var subStr : String;

				if (i < strLen)
					subStr = str.charAt(i);
				else
					subStr = null;

				if (subStr)
				{
					if (subStr == "-")
					{
						var texture : Texture = _texture[10];
						var image : Image = new Image(texture);
						image.x = _gap * i;
						addChild(image);
					}
					else if (subStr == "+")
					{
						texture = _texture[11];
						image = new Image(texture);
						image.x = _gap * i;
						addChild(image);
					}
					else
					{
						texture = _texture[int(subStr)];
						image = new Image(texture);
						image.x = _gap * i;
						addChild(image);
					}
				}
			}
		}

		override public function set visible(value : Boolean) : void
		{
			super.visible = value;

			for each (var child : DisplayObject in _texture)
			{
				child.visible = value;
			}

			if (value)
				number = _num;
		}
	}
}
