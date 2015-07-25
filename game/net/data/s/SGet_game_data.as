package game.net.data.s
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class SGet_game_data extends DataBase
	{
		public var diamond : int;  
		public var coin : int;  
		public var tollgateid : int;  
		public var tired : int;  
		public var bagequ : int;  
		public var bagprop : int;  
		public var bagmat : int;  
		public var arenaname : String;  
		public var picture : int;  
		public var lucknum : int;  
		public var horn : int;  
		public var chattime : int;  
		public var tollgateprize : int;  
		public var verify : int;  
		public var level : int;  
		public var herotab : int;  
		public var viplev : int;  
		public var firstpay : int;  
        public static const CMD : int=11003;
		
		public function SGet_game_data()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			diamond=data.readInt();  
			coin=data.readInt();  
			tollgateid=data.readInt();  
			tired=data.readInt();  
			bagequ=data.readShort();  
			bagprop=data.readShort();  
			bagmat=data.readShort();  
			arenaname=data.readUTF();  
			picture=data.readUnsignedByte();  
			lucknum=data.readInt();  
			horn=data.readInt();  
			chattime=data.readUnsignedByte();  
			tollgateprize=data.readUnsignedByte();  
			verify=data.readInt();  
			level=data.readUnsignedByte();  
			herotab=data.readUnsignedByte();  
			viplev=data.readUnsignedByte();  
			firstpay=data.readUnsignedByte();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeInt(diamond);  
            byte.writeInt(coin);  
            byte.writeInt(tollgateid);  
            byte.writeInt(tired);  
            byte.writeShort(bagequ);  
            byte.writeShort(bagprop);  
            byte.writeShort(bagmat);  
            byte.writeUTF(arenaname);  
            byte.writeByte(picture);  
            byte.writeInt(lucknum);  
            byte.writeInt(horn);  
            byte.writeByte(chattime);  
            byte.writeByte(tollgateprize);  
            byte.writeInt(verify);  
            byte.writeByte(level);  
            byte.writeByte(herotab);  
            byte.writeByte(viplev);  
            byte.writeByte(firstpay);  
			return byte;
		}
		
		override public function getCmd():int
		{
			return CMD;
		}
	}
}

// vim: filetype=php :
