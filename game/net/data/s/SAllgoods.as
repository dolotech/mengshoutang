package game.net.data.s
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class SAllgoods extends DataBase
	{
		public var type : int;  
		public var equip : Vector.<IData>;  
		public var props : Vector.<IData>;  
        public static const CMD : int=13001;
		
		public function SAllgoods()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			type=data.readUnsignedByte();  
			equip=readObjectArray(EquipVO);  
			props=readObjectArray(GoodsVO);  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeByte(type);  
            writeObjects(equip,byte);  
            writeObjects(props,byte);  
			return byte;
		}
		
		override public function getCmd():int
		{
			return CMD;
		}
	}
}

// vim: filetype=php :
