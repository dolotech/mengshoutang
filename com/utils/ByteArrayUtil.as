package com.utils
{

	import flash.utils.ByteArray;

	/**
	 * 简单混淆ByteArray
	 */
	public class ByteArrayUtil
	{
		/**
		 * 密文
		 */
		public static var key:String='20130428';

		/**
		 * 加密
		 * @param bytes
		 * @return
		 *
		 */
		public static function encryptByteArray(bytes:ByteArray):ByteArray
		{
			var encryptBytes:ByteArray=new ByteArray();
			var len:int=bytes.length;
			var keylen:int=key.length;
			var keys:Array=[];
			var flag:int=0;
			var i:int;

			for (i=0; i < keylen; i++)
			{
				keys.push(key.charCodeAt(i));
			}

			for (i=0; i < len; i++, flag++)
			{
				if (flag >= keylen)
				{
					flag=0;
				}
				encryptBytes.writeByte(bytes[i] + keys[flag]);
			}
			return encryptBytes;
		}


		/**
		 * 解密
		 * @param bytes
		 * @return
		 *
		 */
		public static function decryptByteArray(bytes:ByteArray):ByteArray
		{
			var decryptBytes:ByteArray=new ByteArray();
			var len:int=bytes.length;
			var keylen:int=key.length;
			var keys:Array=[];
			var flag:int=0;
			var i:int;

			for (i=0; i < keylen; i++)
			{
				keys.push(key.charCodeAt(i));
			}

			for (i=0; i < len; i++, flag++)
			{
				if (flag >= keylen)
				{
					flag=0;
				}
				decryptBytes.writeByte(bytes[i] - keys[flag]);
			}
			return decryptBytes;
		}
	}
}