package game.net.data.vo
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

    public class mailItems extends DataBase
	{
		public var type : int;  
		public var num : int;  
		public var custom : int;  
		
		public function mailItems()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			type=data.readInt();  
			num=data.readInt();  
			custom=data.readInt();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeInt(type);  
            byte.writeInt(num);  
            byte.writeInt(custom);  
			return byte;
		}
	}
}

// vim: filetype=php :
