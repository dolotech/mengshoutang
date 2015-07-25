package game.net.data.vo
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

    public class TaskInfo extends DataBase
	{
		public var id : int;  
		public var num : Vector.<IData>;  
		public var state : int;  
		
		public function TaskInfo()
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
			num=readObjectArray(TaskPlan);  
			state=data.readUnsignedByte();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeInt(id);  
            writeObjects(num,byte);  
            byte.writeByte(state);  
			return byte;
		}
	}
}

// vim: filetype=php :
