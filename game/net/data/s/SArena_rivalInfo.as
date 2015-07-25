package game.net.data.s
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class SArena_rivalInfo extends DataBase
	{
		public var number : int;  
		public var cd : int;  
		public var chance : int;  
		public var team1 : int;  
		public var team2 : int;  
		public var targets : Vector.<IData>;  
        public static const CMD : int=23015;
		
		public function SArena_rivalInfo()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			number=data.readUnsignedByte();  
			cd=data.readInt();  
			chance=data.readUnsignedByte();  
			team1=data.readUnsignedByte();  
			team2=data.readUnsignedByte();  
			targets=readObjectArray(RivalInfo);  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeByte(number);  
            byte.writeInt(cd);  
            byte.writeByte(chance);  
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
