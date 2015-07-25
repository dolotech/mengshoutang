package game.net.data.s
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class SBattle extends DataBase
	{
		public var tried : int;  
		public var currentCheckPoint : int;  
		public var success : int;  
		public var star : int;  
		public var battleHeroes : Vector.<IData>;  
		public var battleCommands : Vector.<IData>;  
		public var upgrade : Vector.<IData>;  
		public var equip : Vector.<IData>;  
		public var props : Vector.<IData>;  
        public static const CMD : int=22002;
		
		public function SBattle()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			tried=data.readInt();  
			currentCheckPoint=data.readShort();  
			success=data.readUnsignedByte();  
			star=data.readUnsignedByte();  
			battleHeroes=readObjectArray(battleHeroesVo);  
			battleCommands=readObjectArray(BattleVo);  
			upgrade=readObjectArray(UpgradeVo);  
			equip=readObjectArray(EquipVOS);  
			props=readObjectArray(GoodsVOS);  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeInt(tried);  
            byte.writeShort(currentCheckPoint);  
            byte.writeByte(success);  
            byte.writeByte(star);  
            writeObjects(battleHeroes,byte);  
            writeObjects(battleCommands,byte);  
            writeObjects(upgrade,byte);  
            writeObjects(equip,byte);  
            writeObjects(props,byte);  
			return byte;
		}
		
		override public function getCmd():int
		{
			return CMD;
		}
	}
}

// vim: filetype=php :
