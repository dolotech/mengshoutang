package game.net.data.vo
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

    public class TaskPlan extends DataBase
	{
		public var type : int;  
		public var number : int;  
		
		public function TaskPlan()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			type=data.readInt();  
			number=data.readInt();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeInt(type);  
            byte.writeInt(number);  
			return byte;
		}
	}
}

// vim: filetype=php :
