package com.langue
{

	/**
	 * 遊戲语言包
	 * @author Michael
	 *
	 */
	public class Langue
	{
		private static var _xml:XML;

		/**
         *
         * GUIDE_GOTO
		 *获取单条文本
		 * @param id
		 * @return
		 *
		 */
		public static function getLangue(id:String):String
		{
			if (!_xml)
			{
				throw(new Error("语言包未初始化"));
			}
			return _xml.item.(@id == id).@value;
		}

		/**
		 * 获取一组用"|"分隔的文本
		 * @param id
		 * @return
		 *
		 */
		public static function getLans(id:String):Array
		{
			var str:String=getLangue(id);
			return str.split("|");
		}

		public static function init(xml:XML):void
		{
			_xml=xml;
		}
		
		public static function getString():String
		{
			if(!_xml)
			{
				throw(new Error("语言包未初始化"));
			}
			var str:String;
			var arr:Array = [];
		
			for each(var x:XML in _xml.children())
			{
				arr = getLans(x.@id)
				for (var i:int = 0 ; i < arr.length ; i ++)
				{
					str += arr[i];
				}
			}
			return str;
		}

	}
}
