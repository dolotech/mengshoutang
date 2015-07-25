package com.utils
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 *数组类
	 * @author lxh
	 *
	 */
	public class ArrayUtil
	{
		/**
		 *新建内存字节流
		 * @return
		 *
		 */
		public static function newLitteEndianByteArray() : ByteArray
		{
			var result : ByteArray = new ByteArray;
			result.endian = Endian.LITTLE_ENDIAN;
			return result;
		}

		/**
		 *新建数组
		 * @param length
		 * @param c
		 * @return
		 *
		 */
		public static function newArray(length : uint, c : Class = null) : Array
		{
			var result : Array = new Array(length);

			if (c != null)
			{
				for (var i : uint = 0; i < length; i++)
				{
					result[i] = new c;
				}
			}
			return result;
		}

		/**
		 *新建数组且初始化
		 * @param length
		 * @param v
		 * @return
		 *
		 */
		public static function newArrayAndSetValue(length : uint, v : * = 0) : Array
		{
			var result : Array = new Array(length);

			for (var i : uint = 0; i < length; i++)
			{
				result[i] = v;
			}

			return result;
		}

		/**
		 *新建数组通过拷贝
		 * @param src
		 * @param length
		 * @param src_offset
		 * @return
		 *
		 */
		public static function newArrayByCopy(src : Array, length : uint = 0, src_offset : uint = 0) : Array
		{
			if (src == null || length == 0)
				length = src.length;
			var result : Array = new Array(length);

			for (var i : uint = 0; i < length; i++)
			{
				result[i] = src[src_offset + i];
			}

			return result;
		}

		/**
		 *拷贝数组
		 * @param dst
		 * @param src
		 * @param length
		 * @param dst_offset
		 * @param src_offset
		 *
		 */
		public static function copyArray(dst : Array, src : Array, length : uint = 0, dst_offset : uint = 0, src_offset : uint = 0) : void
		{
			if (length == 0 && src != null)
				length = src.length;

			for (var i : uint = 0; i < length; i++)
			{
				dst[dst_offset + i] = src[src_offset + i];
			}
		}

		/**
		 *判断数组
		 * @param dst
		 * @param src
		 * @param length
		 * @param offset
		 * @return
		 *
		 */
		public static function equalArray(dst : Array, src : Array, length : uint = 0, offset : uint = 0) : Boolean
		{
			if (dst == src)
				return true;

			if (dst == null || src == null)
				return false;

			if (dst.length != src.length)
				return false;

			if (length == 0 && src != null)
				length = src.length;

			for (var i : uint = 0; i < length; i++)
			{
				if (dst[offset + i] != src[offset + i])
					return false;
			}
			return true;
		}

		/**
		 *数组元素执行函数
		 * @param dst
		 * @param func
		 *
		 */
		public static function eachArray(dst : Array, func : Function) : void
		{
			if (dst == null || func == null)
				return;

			for (var i : uint = 0; i < dst.length; i++)
			{
				if (dst[i])
				{
					func(dst[i]);
				}
			}
		}

		/**
		 *拷贝二维数组
		 * @param dst
		 * @param src
		 * @param length
		 * @param dst_offset
		 * @param src_offset
		 *
		 */
		public static function copyTwoDimensionArray(dst : Array, src : Array, length : uint = 0, dst_offset : uint = 0, src_offset : uint = 0) : void
		{
			if (src == null)
				return;

			for (var i : uint = 0; i < length; i++)
			{
				dst[dst_offset + i] = src[src_offset + i];
			}
		}

		/**
		 *二维数组元素执行函数
		 * @param dst
		 * @param func
		 *
		 */
		public static function eachTwoDimensionArray(dst : Array, func : Function) : void
		{
			if (dst == null || func == null)
				return;

			for (var i : uint = 0; i < dst.length; i++)
			{
				if (dst[i])
				{
					for (var k : uint = 0; k < dst[i].length; k++)
					{
						if (dst[i][k])
						{
							func(dst[i][k]);
						}
					}
				}
			}
		}

		/**
		 *设置二维数组元素
		 * @param dst
		 * @param val
		 * @param func
		 *
		 */
		public static function freeTwoDimensionArray(dst : Array, val : * = null, func : Function = null) : void
		{
			if (dst == null)
				return;

			for (var i : uint = 0; i < dst.length; i++)
			{
				if (dst[i])
				{
					for (var k : uint = 0; k < dst[i].length; k++)
					{
						if (dst[i][k] && func != null)
						{
							func(dst[i][k]);
						}
						dst[i][k] = val;
					}
					dst[i] = null;
				}
			}
		}

		/**
		 *清空数组
		 * @param src
		 * @param val
		 * @param func
		 * @param length
		 *
		 */
		public static function zeroArray(src : Array, val : * = 0, func : Function = null, length : uint = 0) : void
		{
			if (src == null)
				return;

			if (length <= 0)
				length = src.length;

			for (var i : uint = 0; i < length; i++)
			{
				if (func != null && src[i])
				{
					func(src[i]);
				}
				src[i] = val;
			}
		}

		/**
		 *清空二维数组
		 * @param src
		 * @param val
		 * @param func
		 *
		 */
		public static function zeroTwoDimensionArray(src : Array, val : * = 0, func : Function = null) : void
		{
			if (src == null)
				return;

			for (var i : uint = 0; i < src.length; i++)
			{
				if (src[i])
				{
					var a : Array = src[i];

					if (a)
					{
						for (var j : uint = 0; j < a.length; j++)
						{
							if (func != null && a[j])
							{
								func(a[j]);
							}
							a[j] = val;
						}

					}
				}

			}
		}

		/**
		 *清空三维数组
		 * @param src
		 * @param val
		 * @param func
		 *
		 */
		public static function zeroThreeDimensionArray(src : Array, val : * = 0, func : Function = null) : void
		{
			if (src == null)
				return;

			for (var i : uint = 0; i < src.length; i++)
			{
				if (src[i])
				{
					var a : Array = src[i];

					if (a)
					{
						for (var j : uint = 0; j < a.length; j++)
						{
							var a0 : Array = a[j];

							if (a0)
							{
								for (var k : uint = 0; k < a0.length; k++)
								{
									if (func != null && a0[k])
									{
										func(a0[k]);
									}
									a0[k] = val;
								}
							}
						}

					}
				}

			}
		}

		/**
		 *拷贝数组
		 * @param src
		 * @param beginIndex
		 * @return
		 *
		 */
		public static function cloneArray(src : Array, beginIndex : uint) : Array
		{
			if (src == null)
				return null;
			var result : Array = new Array;
			var n : uint = 0;

			for (var i : uint = beginIndex; i < src.length; i++)
			{
				result[n] = src[i];
				n++;
			}
			return result;
		}

		/**
		 *移动数组单元
		 * @param dst
		 * @param src
		 * @param length
		 * @param dst_offset
		 * @param src_offset
		 *
		 */
		public static function moveArray(dst : Array, src : Array, length : uint = 0, dst_offset : uint = 0, src_offset : uint = 0) : void
		{
			for (var i : uint = 0; i < length; i++)
			{
				dst[dst_offset + i] = src[src_offset + i];
			}
		}

		/**
		 *删除元素
		 * @param arr
		 * @param value
		 *
		 */
		public static function removeValueFromArray(arr : Array, value : Object) : void
		{
			var len : uint = arr.length - 1;

			for (var i : Number = len; i > -1; i--)
			{
				if (arr[i] === value)
				{
					arr.splice(i, 1);
				}
			}
		}

		/**
		 *删除元素
		 * @param arr
		 * @param values
		 *
		 */
		public static function removeValuesFromArray(arr : Array, values : Array) : Array
		{
			var i : int, j : int;

			for (i = 0; i < values.length; i++)
			{
				for (j = 0; j < arr.length; j++)
				{
					if (arr[j] == values[i])
					{
						arr.splice(j, 1);
						break;
					}
				}
			}
			return arr;
		}

		public static function arraysAreEqual(arr1 : Array, arr2 : Array) : Boolean
		{
			if (arr1.length != arr2.length)
			{
				return false;
			}

			var len : Number = arr1.length;

			for (var i : Number = 0; i < len; i++)
			{
				if (arr1[i] !== arr2[i])
				{
					return false;
				}
			}

			return true;
		}

		/**
		 *得到某一页的数据
		 * @param page  第几页
		 * @param pageSize 每一页显示的数据条数
		 * @param datas 数据源
		 * @return
		 *
		 */
		public static function getPageSizeDatas(page : int, pageSize : int, datas : Array) : Array
		{
			if (datas == null)
			{
				return [];
			}
			var startIndex : int = (page - 1) * pageSize;
			var endIndex : int = page * pageSize;
			var dataLen : int = datas.length;

			if (startIndex < 0 || startIndex >= dataLen)
			{
				startIndex = 0;
			}

			if (endIndex >= dataLen)
			{
				endIndex = dataLen;
			}

			return datas.slice(startIndex, endIndex);
		}

		/**
		 * 根据字段删除元素
		 * @param arr
		 * @param field
		 * @param value
		 *
		 */
		public static function deleteArrayByField(arr : *, value : Object, field : String = "") : Object
		{
			if (arr == null)
				return null;

			for (var i : int = arr.length - 1; i >= 0; i--)
			{
				if (arr[i] == null)
					continue;

				if ((field == "" && arr[i] == value) || (field != "" && arr[i][field] == value))
				{
					return arr.splice(i, 1)[0];
				}
			}
			return null;
		}

		/**
		 * 转换vector成Array
		 * @param list
		 * @return
		 *
		 */
		public static function change2Array(list : Object, field : String = "") : Array
		{
			var tmpArr : Array = [];

			for (var i : int = 0, len : int = list.length; i < len; i++)
			{
				if (field != "")
					tmpArr.push(list[i][field]);
				else
					tmpArr.push(list[i]);
			}
			return tmpArr;
		}

		/**
		 * 根据字段删除元素
		 * @param arr
		 * @param field
		 * @param value
		 *
		 */
		public static function getIndexByField(arr : *, value : Object, field : String) : int
		{
			if (arr == null)
				return -1;

			for (var i : int = arr.length - 1; i >= 0; i--)
			{
				if (arr[i] == null)
					continue;

				if ((field == "" && arr[i] == value) || (field != "" && arr[i][field] == value))
				{
					return i;
				}
			}
			return -1;
		}
		
		public static function getArrayObjByField(arr : *, value : Object, field : String = "") : Object
		{
			if (arr == null)
				return null;
			
			for (var i : int = arr.length - 1; i >= 0; i--)
			{
				if (arr[i] == null)
					continue;
				
				if ((field == "" && arr[i] == value) || (field != "" && arr[i][field] == value))
				{
					return arr[i];
				}
			}
			return null;
		}

		public static function addArray(arr : *, value : Object, field : String = "") : void
		{
			if (arr == null)
				return;

			if (field == "")
			{
				var index : int = arr.indexOf(value);

				if (index == -1)
					arr.push(value);
			}
			else
			{
				if (deleteArrayByField(arr, value[field], field) == null)
					arr.push(value);
			}
		}


	}
}