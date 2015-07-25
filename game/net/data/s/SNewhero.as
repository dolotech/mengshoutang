package game.net.data.s
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class SNewhero extends DataBase
	{
		public var id : int;  
		public var type : int;  
		public var seat : int;  
		public var quality : int;  
		public var level : int;  
		public var exp : int;  
		public var foster : int;  
		public var hp : int;  
		public var attack : int;  
		public var defend : int;  
		public var puncture : int;  
		public var hit : int;  
		public var dodge : int;  
		public var crit : int;  
		public var critPercentage : int;  
		public var anitCrit : int;  
		public var toughness : int;  
		public var seat1 : int;  
		public var seat2 : int;  
		public var seat3 : int;  
		public var seat4 : int;  
		public var seat5 : int;  
        public static const CMD : int=14025;
		
		public function SNewhero()
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
			type=data.readInt();  
			seat=data.readUnsignedByte();  
			quality=data.readUnsignedByte();  
			level=data.readUnsignedByte();  
			exp=data.readInt();  
			foster=data.readUnsignedByte();  
			hp=data.readInt();  
			attack=data.readInt();  
			defend=data.readInt();  
			puncture=data.readInt();  
			hit=data.readInt();  
			dodge=data.readInt();  
			crit=data.readInt();  
			critPercentage=data.readInt();  
			anitCrit=data.readInt();  
			toughness=data.readInt();  
			seat1=data.readInt();  
			seat2=data.readInt();  
			seat3=data.readInt();  
			seat4=data.readInt();  
			seat5=data.readInt();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeInt(id);  
            byte.writeInt(type);  
            byte.writeByte(seat);  
            byte.writeByte(quality);  
            byte.writeByte(level);  
            byte.writeInt(exp);  
            byte.writeByte(foster);  
            byte.writeInt(hp);  
            byte.writeInt(attack);  
            byte.writeInt(defend);  
            byte.writeInt(puncture);  
            byte.writeInt(hit);  
            byte.writeInt(dodge);  
            byte.writeInt(crit);  
            byte.writeInt(critPercentage);  
            byte.writeInt(anitCrit);  
            byte.writeInt(toughness);  
            byte.writeInt(seat1);  
            byte.writeInt(seat2);  
            byte.writeInt(seat3);  
            byte.writeInt(seat4);  
            byte.writeInt(seat5);  
			return byte;
		}
		
		override public function getCmd():int
		{
			return CMD;
		}
	}
}

// vim: filetype=php :
