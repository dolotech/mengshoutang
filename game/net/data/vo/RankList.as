package game.net.data.vo
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

    public class RankList extends DataBase
	{
		public var index : int;  
		public var id : int;  
		public var name : String;  
		public var exp : int;  
		public var fighting : int;  
		
		public function RankList()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			index=data.readShort();  
			id=data.readInt();  
			name=data.readUTF();  
			exp=data.readShort();  
			fighting=data.readInt();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeShort(index);  
            byte.writeInt(id);  
            byte.writeUTF(name);  
            byte.writeShort(exp);  
            byte.writeInt(fighting);  
			return byte;
		}
	}
}

// vim: filetype=php :
