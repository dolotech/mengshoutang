package game.net.data.s
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class SArena_refresh extends DataBase
	{
		public var code : int;  
		public var time : int;  
		public var team1 : int;  
		public var team2 : int;  
		public var targets : Vector.<IData>;  
        public static const CMD : int=23022;
		
		public function SArena_refresh()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			code=data.readUnsignedByte();  
			time=data.readInt();  
			team1=data.readUnsignedByte();  
			team2=data.readUnsignedByte();  
			targets=readObjectArray(RefreshTarget);  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeByte(code);  
            byte.writeInt(time);  
            byte.writeByte(team1);  
            byte.writeByte(team2);  
            writeObjects(targets,byte);  
			return byte;
		}
		
		override public function getCmd():int
		{
			return CMD;
		}
	}
}

// vim: filetype=php :
