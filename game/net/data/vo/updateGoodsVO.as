package game.net.data.vo
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

    public class updateGoodsVO extends DataBase
	{
		public var id : int;  
		public var type : int;  
		public var pile : int;  
		
		public function updateGoodsVO()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			id=data.readInt();  
			type=data.readInt();  
			pile=data.readInt();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeInt(id);  
            byte.writeInt(type);  
            byte.writeInt(pile);  
			return byte;
		}
	}
}

// vim: filetype=php :
