package com.utils
{
	import flash.geom.Rectangle;

	import starling.display.DisplayObject;

	/**
	 * Starling碰撞区域检测(矩形 ，椭圆)
	 * @author 陈开熙
	 * 2014年8月27日
	 */
	public class HitTest
	{


		/**
		 *
		 * @param target1 对象1
		 * @param target2  对象2
		 * @param isEllipse 是否椭圆碰撞否则矩形碰撞
		 * @return
		 *
		 */
		public static function complexHitTestObject(target1:DisplayObject, target2:DisplayObject, isEllipse:Boolean=true):Boolean
		{
			if (!isEllipse)
			{
				return intersectionRectangle(target1, target2);
			}
			return intersectionEllipse(target1, target2);
		}

		/**
		 *
		 * @param target1
		 * @param target2
		 * @return  是否两个矩形相交
		 *
		 */
		public static function intersectionRectangle(target1:DisplayObject, target2:DisplayObject):Boolean
		{
			if (target1 == null || target2 == null)
			{
				return false;
			}
			if (!target1.root || !target2.root)
			{
				return false;
			}
			var bounds1:Rectangle=target1.getBounds(target1.root);
			var bounds2:Rectangle=target2.getBounds(target2.root);
			return bounds1.intersects(bounds2);

		}


		/**
		 *
		 * @param target1
		 * @param target2
		 * @return  找出相交的矩形
		 *
		 */
		public static function getInterseRectangle(target1:DisplayObject, target2:DisplayObject):Rectangle
		{
			if (target1 == null || target2 == null)
			{
				return new Rectangle();
			}
			if (!target1.root || !target2.root)
			{
				return new Rectangle();
			}
			var bounds1:Rectangle=target1.getBounds(target1.root);
			var bounds2:Rectangle=target2.getBounds(target2.root);
			var intersection:Rectangle=new Rectangle();
			intersection.x=Math.max(bounds1.x, bounds2.x);
			intersection.y=Math.max(bounds1.y, bounds2.y);
			intersection.width=Math.min((bounds1.x + bounds1.width) - intersection.x, (bounds2.x + bounds2.width) - intersection.x);
			intersection.height=Math.min((bounds1.y + bounds1.height) - intersection.y, (bounds2.y + bounds2.height) - intersection.y);
			return intersection;

		}

		/**
		 *
		 * @param target1
		 * @param target2
		 * @return  是否两个椭圆相交
		 *
		 */
		public static function intersectionEllipse(target1:DisplayObject, target2:DisplayObject):Boolean
		{
			if (target1 == null || target2 == null)
			{
				return false;
			}
			if (!target1.root || !target2.root)
			{
				return false;
			}
			var bounds1:Rectangle=target1.getBounds(target1.root);
			var bounds2:Rectangle=target2.getBounds(target2.root);
			return intersectsEllipse(bounds1, bounds2);

		}

		/**
		 * 点是否在椭圆范围内
		 * @param rect
		 * @param px
		 * @param py
		 * @return
		 *
		 */
		public static function contains(rect:Rectangle, px:Number, py:Number):Boolean
		{
			var xRadius:int=rect.width >> 1;
			var yRadius:int=rect.height >> 1;
			var xTar:int=px - rect.x - xRadius;
			var yTar:int=py - rect.y - yRadius;
			return Math.pow(xTar / xRadius, 2) + Math.pow(yTar / yRadius, 2) <= 1;
		}


		/**
		 * 椭圆与椭圆是否相交
		 * @param rect1
		 * @param rect2
		 * @return Boolean
		 */
		public static function intersectsEllipse(rect1:Rectangle, rect2:Rectangle):Boolean
		{
			var halfWidth:Number=rect1.width >> 1;
			var halfHeight:Number=rect1.height >> 1;
			var selfHalfWidth:Number=rect2.width >> 1;
			var selfHalfHeight:Number=rect2.height >> 1;

			return contains(rect2, rect1.x + halfWidth, rect1.y + halfHeight) || contains(rect2, rect1.x + halfWidth, rect1.y) || contains(rect2, rect1.x + rect1.width, rect1.y + halfHeight) || contains(rect2, rect1.x + halfWidth, rect1.y + rect1.height) || contains(rect2, rect1.x + rect1.width, rect1.y + halfHeight) ||

				rect1.contains(rect2.x + selfHalfHeight, rect2.y + selfHalfHeight) || rect1.contains(rect2.x + selfHalfHeight, rect2.y) || rect1.contains(rect2.x + rect2.width, rect2.y + selfHalfHeight) || rect1.contains(rect2.x + selfHalfHeight, rect2.y + rect2.height) || rect1.contains(rect2.x + rect2.width, rect2.y + selfHalfHeight);
		}

		/**
		 *
		 * @param target1
		 * @param target2
		 * @param arr 查找碰撞列表
		 * @return 查找碰撞
		 *
		 */
		public static function hitTestByFind(target1:DisplayObject, target2:DisplayObject, arr:Array, isEllipse:Boolean=true):Boolean
		{
			var len:int=arr.length;
			for (var i:int=0; i < len - 1; i++)
			{
				target1=arr[i];
				for (var j:int=i + 1; j < len; j++)
				{
					target2=arr[j];
					if (HitTest.complexHitTestObject(target1, target2, isEllipse))
					{
						return true;
					}
				}
			}
			return false;
		}

		private static var isrun:Boolean=true;

		/**
		 *
		 * @param arr1 对象数组1
		 * @param arr2  对象数组2
		 * @param callBcak 有发生 碰撞回调
		 * @return
		 *
		 */
		public static function hitTestArray(arr1:Array, arr2:Array, isEllipse:Boolean=true, callBcak:Function=null):Boolean
		{
			if (isrun)
			{
				isrun=false;
				var len1:int=arr1.length;
				var len2:int=arr2.length;
				for (var i:int=0; i < len1; i++)
				{
					for (var j:int=0; j < len2; j++)
					{
						if (HitTest.complexHitTestObject(arr1[i], arr2[j], isEllipse))
						{
							if (callBcak != null)
							{
								callBcak(arr1[i], arr2[j]);
							}
							return true;
						}
					}
				}
			}
			isrun=true;
			return false;
		}

	}
}


