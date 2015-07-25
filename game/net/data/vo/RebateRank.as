package game.net.data.vo
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

    public class RebateRank extends DataBase
	{
		public var name : String;  
		public var reward_id : int;  
		public var reward_num : int;  
		
		public function RebateRank()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			name=data.readUTF();  
			reward_id=data.readInt();  
			reward_num=data.readInt();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeUTF(name);  
            byte.writeInt(reward_id);  
            byte.writeInt(reward_num);  
			return byte;
		}
	}
}

// vim: filetype=php :
