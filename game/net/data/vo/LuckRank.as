package game.net.data.vo
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

    public class LuckRank extends DataBase
	{
		public var name : String;  
		public var values : int;  
		public var sum : int;  
		
		public function LuckRank()
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
			values=data.readInt();  
			sum=data.readInt();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeUTF(name);  
            byte.writeInt(values);  
            byte.writeInt(sum);  
			return byte;
		}
	}
}

// vim: filetype=php :
