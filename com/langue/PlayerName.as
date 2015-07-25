package com.langue 
{
	import com.singleton.Singleton;
	/**
	 * ...
	 * @author Michael
	 */
	public class PlayerName 
	{
		public static var XML_CLASS:Class;
		private var _xml:XML;
		private var _girl:Array;
		private var _boy:Array;
		private var _firstname:Array;
		public function PlayerName() 
		{
			_xml = new XML(new XML_CLASS());
			
			_firstname = (_xml.item.(@id == "firstname").@value).split("|");
			_boy = (_xml.item.(@id == "men").@value).split("|");
			_girl = (_xml.item.(@id == "women").@value).split("|");
		}
		
		public static function get instance():PlayerName
		{
			return Singleton.getInstance(PlayerName) as PlayerName;
		}
		
		
		public function getBoyName():String
		{
			return _firstname[Math.random() * _firstname.length>>0] + _boy[Math.random() * _boy.length>>0] + _boy[Math.random() * _boy.length>>0];
		}
		public function getGirlName():String
		{
			return _firstname[Math.random() * _firstname.length>>0] + _girl[Math.random() * _girl.length>>0] + _girl[Math.random() * _girl.length>>0];
		}
	}
}