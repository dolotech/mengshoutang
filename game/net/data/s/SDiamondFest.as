package game.net.data.s
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class SDiamondFest extends DataBase
	{
		public var code : int;  
		public var loadUrl : String;  
		public var ratingUrl : String;  
		public var ids : Vector.<IData>;  
        public static const CMD : int=25002;
		
		public function SDiamondFest()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			code=data.readInt();  
			loadUrl=data.readUTF();  
			ratingUrl=data.readUTF();  
			ids=readObjectArray(FestValues);  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeInt(code);  
            byte.writeUTF(loadUrl);  
            byte.writeUTF(ratingUrl);  
            writeObjects(ids,byte);  
			return byte;
		}
		
		override public function getCmd():int
		{
			return CMD;
		}
	}
}

// vim: filetype=php :
