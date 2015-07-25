package game.net.data.s
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class SArena_result extends DataBase
	{
		public var gold : int;  
		public var add_exp : int;  
		public var lev : int;  
		public var exp : int;  
        public static const CMD : int=23033;
		
		public function SArena_result()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			gold=data.readInt();  
			add_exp=data.readInt();  
			lev=data.readUnsignedByte();  
			exp=data.readInt();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeInt(gold);  
            byte.writeInt(add_exp);  
            byte.writeByte(lev);  
            byte.writeInt(exp);  
			return byte;
		}
		
		override public function getCmd():int
		{
			return CMD;
		}
	}
}

// vim: filetype=php :
