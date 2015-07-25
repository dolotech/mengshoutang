package game.net.data.vo
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

    public class videoDataInfo extends DataBase
	{
		public var iswin : int;  
		public var videoHeroes : Vector.<IData>;  
		public var videoCommands : Vector.<IData>;  
		public var videoUpgrade : Vector.<IData>;  
		
		public function videoDataInfo()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			iswin=data.readUnsignedByte();  
			videoHeroes=readObjectArray(videoHeroesVo);  
			videoCommands=readObjectArray(videoVo);  
			videoUpgrade=readObjectArray(videoUpgradeVo);  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeByte(iswin);  
            writeObjects(videoHeroes,byte);  
            writeObjects(videoCommands,byte);  
            writeObjects(videoUpgrade,byte);  
			return byte;
		}
	}
}

// vim: filetype=php :
