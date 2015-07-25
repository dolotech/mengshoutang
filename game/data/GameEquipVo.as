package game.data
{
	import game.net.data.IData;

	public class GameEquipVo
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
		public function GameEquipVo()
		{
		}
	}
}