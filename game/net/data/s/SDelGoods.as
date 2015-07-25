package game.net.data.s
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class SDelGoods extends DataBase
	{
		public var props : Vector.<IData>;  
        public static const CMD : int=13030;
		
		public function SDelGoods()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			props=readObjectArray(DelGoodsVO);  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
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
