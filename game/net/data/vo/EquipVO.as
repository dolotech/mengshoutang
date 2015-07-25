package game.net.data.vo
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

    public class EquipVO extends DataBase
	{
		public var id : int;  
		public var type : int;  
		public var equip : int;  
		public var level : int;  
		public var socketsNum : int;  
		public var sockets : Vector.<IData>;  
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
		
		public function EquipVO()
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
			equip=data.readInt();  
			level=data.readUnsignedByte();  
			socketsNum=data.readUnsignedByte();  
			sockets=readObjectArray(MagicBallVO);  
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
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeInt(id);  
            byte.writeInt(type);  
            byte.writeInt(equip);  
            byte.writeByte(level);  
            byte.writeByte(socketsNum);  
            writeObjects(sockets,byte);  
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
			return byte;
		}
	}
}

// vim: filetype=php :
