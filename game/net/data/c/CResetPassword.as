package game.net.data.c
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class CResetPassword extends DataBase
	{
		public var account : String;  
		public var verifyCode : int;  
		public var password : String;  
        public static const CMD : int=11112;
		
		public function CResetPassword()
		{
		}
		
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			account=data.readUTF();  
			verifyCode=data.readInt();  
			password=data.readUTF();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeUTF(account);  
            byte.writeInt(verifyCode);  
            byte.writeUTF(password);  
			return byte;
		}
		
		override public function getCmd():int
		{
			return CMD;
		}
	}
}

// vim: filetype=php :
