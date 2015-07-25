package game.net.data.vo
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

    public class ActiveTarget extends DataBase
	{
		public var id : int;  
		public var name1 : String;  
		public var name2 : String;  
		
		public function ActiveTarget()
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
			name1=data.readUTF();  
			name2=data.readUTF();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeInt(id);  
            byte.writeUTF(name1);  
            byte.writeUTF(name2);  
			return byte;
		}
	}
}

// vim: filetype=php :
