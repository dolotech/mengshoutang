package game.net.data.vo
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

    public class newMail extends DataBase
	{
		public var id : int;  
		public var from : String;  
		public var content : String;  
		public var time : int;  
		public var items : Vector.<IData>;  
		
		public function newMail()
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
			from=data.readUTF();  
			content=data.readUTF();  
			time=data.readInt();  
			items=readObjectArray(mailItems);  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeInt(id);  
            byte.writeUTF(from);  
            byte.writeUTF(content);  
            byte.writeInt(time);  
            writeObjects(items,byte);  
			return byte;
		}
	}
}

// vim: filetype=php :
