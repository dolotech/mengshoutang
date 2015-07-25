package game.net.data
{
	import com.mvc.interfaces.INotification;
	
	import flash.utils.ByteArray;
	/**
	 * 游戏网络通讯数据包基类
	 *  
	 * @author Michael
	 * 
	 */
	public class DataBase implements IData, INotification 
	{
		protected var data : ByteArray;
		private var _name:String = "";
		
		public function setName(value:String):void{
			_name = value;
		}
		
		public function getName():String{
			return _name;
		}
		public function setBody(arg1:Object):void{
		}
		public function getBody():Object{
			return this;
		}
		public function setType(arg1:String):void{
		}
		public function getType():String{
			return "";
		}
		
		public function toString():String{
			
			return "";
		}

		public function serialize() : ByteArray
		{
			return null;
		}

		public function deSerialize(data : ByteArray) : void
		{
			this.data = data;
		}

		public function getCmd() : int
		{
			return 0;
		}
		
		protected function writeObjects(value : Vector.<IData>, byte : ByteArray) : void
		{
			var len:int = value.length;
			byte.writeShort(len);
			for(var i:int = 0; i < len; i++)
			{
				byte.writeBytes(value[i].serialize());
			}
		}
		
		
		protected function writeStrings(value : Vector.<String>, byte : ByteArray) : void
		{
			var len:int = value.length;
			byte.writeShort(len);
			for(var i:int = 0; i < len; i++)
			{
				byte.writeUTF(value[i]);
			}
		}
		
		protected function writeBytes(value : Vector.<int>, byte : ByteArray) : void
		{
			var len:int = value.length;
			byte.writeShort(len);
			for(var i:int = 0; i < len; i++)
			{
				byte.writeByte(value[i]);
			}
		}
		
		
		protected function writeShorts(value : Vector.<int>, byte : ByteArray) : void
		{
			var len:int = value.length;
			byte.writeShort(len);
			
			for(var i:int = 0; i < len; i++)
			{
				byte.writeShort(value[i]);
			}
		}
		
		
		
		/**
		 *
		 * @param value
		 * @param byte
		 *
		 */
		protected function writeInts(value : Vector.<int>, byte : ByteArray) : void
		{
			var len : int = value.length;
			byte.writeShort(len);

			for(var i:int = 0; i < len; i++)
			{
				byte.writeInt(value[i]);
			}
		}


		protected function readArrayInt() : Vector.<int>
		{
			var tmpArr  : Vector.<int> = new Vector.<int>;
			var len : int = data.readShort();

			for(var i : int = 0; i < len; i++)
			{
				tmpArr[i] = data.readInt();
			}
			return tmpArr;
		}

		protected function readArrayString() : Vector.<String>
		{
			var tmpArr  : Vector.<String> = new Vector.<String>;
			var len : int = data.readShort();

			for(var i : int = 0; i < len; i++)
			{
				tmpArr[i]= data.readUTF();
			}
			return tmpArr;
		}


		protected function readObjectArray(type : Class) : Vector.<IData>
		{
			var tmpArr : Vector.<IData> = new Vector.<IData>;
			var len : int = data.readShort();

			var k:int = 0;
			for(var i : int = 0; i < len; i++)
			{
				var obj : IData = readObject(type);

				if(obj)
				{
					tmpArr[k++] = obj;
				}
			}
			return tmpArr;
		}

		protected function readByteArray()  : Vector.<int>
		{
			var tmpArr : Vector.<int> = new Vector.<int>;
			var len : int = data.readShort();

			for(var i : int = 0; i < len; i++)
			{
				tmpArr[i] = data.readUnsignedByte();
			}
			return tmpArr;
		}

		protected function readShortArray() :  Vector.<int>
		{
			var tmpArr : Vector.<int> = new Vector.<int>;
			var len : int = data.readShort();

			for(var i : int = 0; i < len; i++)
			{
				tmpArr[i] = data.readUnsignedShort();
			}
			return tmpArr;
		}

		protected function readObject(type : Class) : IData
		{
			var obj : IData = new type() as IData;

			if(obj == null)
			{
				return null;
			}
			obj.deSerialize(data);
			return obj;
		}
	}
}