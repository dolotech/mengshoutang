package game.net.data.vo
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

    public class HeroSkillsVO extends DataBase
	{
		public var skillid : int;  
		public var seat : int;  
		
		public function HeroSkillsVO()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			skillid=data.readInt();  
			seat=data.readUnsignedByte();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeInt(skillid);  
            byte.writeByte(seat);  
			return byte;
		}
	}
}

// vim: filetype=php :
