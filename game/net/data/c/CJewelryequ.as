package game.net.data.c
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class CJewelryequ extends DataBase
	{
		public var equid : int;  
		public var jewtid : int;  
		public var ids : Vector.<int>;  
        public static const CMD : int=13026;
		
		public function CJewelryequ()
		{
		}
		
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			equid=data.readInt();  
			jewtid=data.readInt();  
			ids=readArrayInt();
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeInt(equid);  
            byte.writeInt(jewtid);  
			writeInts(ids,byte);  
			return byte;
		}
		
		override public function getCmd():int
		{
			return CMD;
		}
	}
}

// vim: filetype=php :
