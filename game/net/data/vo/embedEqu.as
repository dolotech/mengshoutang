package game.net.data.vo
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

    public class embedEqu extends DataBase
	{
		public var equid : int;  
		public var gemid : int;  
		
		public function embedEqu()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			equid=data.readInt();  
			gemid=data.readInt();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeInt(equid);  
            byte.writeInt(gemid);  
			return byte;
		}
	}
}

// vim: filetype=php :
