package game.net.data.vo
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

    public class SkillParamVo extends DataBase
	{
		public var seat : int;  
		public var paramValue : int;  
		
		public function SkillParamVo()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			seat=data.readInt();  
			paramValue=data.readInt();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeInt(seat);  
            byte.writeInt(paramValue);  
			return byte;
		}
	}
}

// vim: filetype=php :
