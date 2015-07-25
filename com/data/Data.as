package com.data
{
	import flash.utils.ByteArray;
	import flash.utils.describeType;

	public class Data
	{
		/**
		 *唯一ID
		 */
		public var id : int;
		/**
		 * 名称
		 */
		public var name : String = "";

		/**
		 *　 复制目标对象公共属性值，到当前对象
		 *
		 * 	注意：当前对象跟目标对象属性要一致
		 * @param value
		 *
		 */
		public function copy(value : Object) : void
		{
			var ba : ByteArray = new ByteArray();
			ba.writeObject(value);
			ba.position = 0;
			var obj : Object = ba.readObject();

			for (var key : String in obj)
			{
				if ((typeof value[key]) != "object")
				{
					this[key] = obj[key];
				}
			}
		}

		public static function initData(data : ByteArray, hash : HashMap, dataClass : Class, id : String = "id") : void
		{
			data.position = 0;
			var vector : Array = data.readObject() as Array;
			var len : int = vector.length;
			var instance : *;

			for (var i : int = 0; i < len; i++)
			{
				var obj : Object = vector[i];
				instance = new dataClass();

				for (var key : String in obj)
				{
					instance[key] = obj[key];
				}
				hash.put(instance[id], instance);
			}
		}

		/**
		 * 复制当前对象，并复制公共属性值
		 * 包括静态属性和动态属性
		 * @return
		 *
		 */
		public function clone() : Data
		{
			var newObj : Data = new this["constructor"]() as Data;
			var ba : ByteArray = new ByteArray();
			ba.writeObject(this);
			ba.position = 0;
			var obj : Object = ba.readObject();

			for (var key : String in obj)
			{
				if ((typeof obj[key]) != "object")
				{
					newObj[key] = obj[key];
				}
			}
			return newObj;
		}

		/**
		 *  打印当前对象所有公共属性值
		 * @return
		 *
		 */
		public function toString() : String
		{
			var ba : ByteArray = new ByteArray();
			ba.writeObject(this);
			ba.position = 0;

			var obj : Object = ba.readObject();
			var str : String = "";

			for (var key : String in obj)
			{
				str += key + ": " + obj[key] + " ";
			}
			return str;
		}

		public static function readObject(child : *, obj : Object) : void
		{
			var value : *;
			var key : String;
			var data : XML = describeType(obj);

			if (data.@name == "Object")
			{
				for (key in obj)
				{
					child[key] = obj[key];
				}
				return;
			}

			for each (var variable : * in data.variable)
			{
				key = String(variable.@name);
				value = obj[key];

				if (value == null || value == undefined)
				{
					continue;
				}

				if (child[key] is int)
				{
					child[key] = int(value);
				}
				else if (child[key] is Number)
				{
					child[key] = Number(value);
				}
				else if (child[key] is Boolean)
				{
					child[key] = Boolean(int(value));
				}
				else
				{
					child[key] = value;
				}
			}
		}


	}
}