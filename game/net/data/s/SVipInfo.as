package game.net.data.s
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class SVipInfo extends DataBase
	{
		public var lev : int;  
		public var diamond : int;  
		public var free : int;  
		public var chattime : int;  
		public var prize : int;  
		public var fast : int;  
		public var tired : int;  
		public var coli_buy : int;  
		public var fb_buy : int;  
        public static const CMD : int=35010;
		
		public function SVipInfo()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			lev=data.readUnsignedByte();  
			diamond=data.readInt();  
			free=data.readInt();  
			chattime=data.readUnsignedByte();  
			prize=data.readUnsignedByte();  
			fast=data.readUnsignedByte();  
			tired=data.readUnsignedByte();  
			coli_buy=data.readUnsignedByte();  
			fb_buy=data.readUnsignedByte();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeByte(lev);  
            byte.writeInt(diamond);  
            byte.writeInt(free);  
            byte.writeByte(chattime);  
            byte.writeByte(prize);  
            byte.writeByte(fast);  
            byte.writeByte(tired);  
            byte.writeByte(coli_buy);  
            byte.writeByte(fb_buy);  
			return byte;
		}
		
		override public function getCmd():int
		{
			return CMD;
		}
	}
}

// vim: filetype=php :
