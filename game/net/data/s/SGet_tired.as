package game.net.data.s
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class SGet_tired extends DataBase
	{
		public var tired : int;  
		public var num : int;  
		public var time : int;  
        public static const CMD : int=11007;
		
		public function SGet_tired()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			tired=data.readInt();  
			num=data.readShort();  
			time=data.readInt();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeInt(tired);  
            byte.writeShort(num);  
            byte.writeInt(time);  
			return byte;
		}
		
		override public function getCmd():int
		{
			return CMD;
		}
	}
}

// vim: filetype=php :
