package com.utils
{
	import flash.display.InteractiveObject;
	import flash.filters.ColorMatrixFilter;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;

	import starling.animation.IAnimatable;

	import starling.core.Starling;

	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;

	/**
	 * as3对象操作工具类集合
	 * @author Michael  <br/>
	 * <br/>
	 * getChildrenArr     获取可视对象的所有孩子集合
	 * getDeth            获取可视对象相对于父容器的层次索引
	 * removeAllChildren  移除目标可视容器对象中所有的子对象
	 * deepObjectToString amf数据输出格式化
	 * baseClone          深度克隆对象
	 * isString           是否为字符串类型
	 * isNumber           是否为数值型类型
	 * isBoolean          是否为Boolean类型
	 * isFunction         是否为函数类型
	 */
	public class ObjectUtil
	{

		public static function setToTopCenter(original:DisplayObject, target:DisplayObject):void
		{
			target.x=original.x + (original.width - target.width) * .5;
//			target.y = original.y + (original.height - target.height) *.5;
		}

		public static function setToCenter(original:DisplayObject, target:DisplayObject):void
		{
			target.x=original.x + (original.width - target.width) * .5;
			target.y=original.y + (original.height - target.height) * .5;
		}

		public static function setToTargetCenter(parent:DisplayObject, target:DisplayObject):void
		{
			target.x=(parent.width - target.width) >> 1;
			target.y=(parent.height - target.height) >> 1;
		}

		public static function setToRightBottom(original:DisplayObject, target:DisplayObject):void
		{
			target.x=original.width + original.x - target.width;
			target.y=original.height + original.y - target.height;
		}

		public static function copyAttribute(original:DisplayObject, target:DisplayObject):void
		{
			target.x=original.x;
			target.y=original.y;
			target.width=original.width;
			target.height=original.height;
		}

		/**
		 *	颜色变灰
		 * @param io
		 * @param b
		 *
		 */
		public static function setEnbled(io:InteractiveObject, b:Boolean):void
		{
			var matrix:Array;
			var filter:ColorMatrixFilter;
			io.mouseEnabled=b;
			if (b == false)
			{
				matrix=new Array();
				matrix=matrix.concat([0.33, 0.33, 0.33, 0, 0]);
				matrix=matrix.concat([0.33, 0.33, 0.33, 0, 0]);
				matrix=matrix.concat([0.33, 0.33, 0.33, 0, 0]);
				matrix=matrix.concat([0, 0, 0, 1, 0]);
				filter=new ColorMatrixFilter(matrix);
				io.filters=[filter];
			}
			else
			{
				io.filters=[];
			}

		}

		public static function setChildrenVisible(mc:DisplayObjectContainer, b:Boolean):void
		{
			var childNum:int=mc.numChildren;
			for (var i:int=0; i < childNum; i++)
			{
				var child:DisplayObject=mc.getChildAt(i);
				mc.visible=b;
			}
		}

		/**
		 * 等比缩放
		 * @param	sp
		 * @param	wid
		 */
		public static function setScale(sp:DisplayObject, wid:Number):void
		{
			if (sp.width > sp.height)
			{
				sp.width=wid;
				sp.scaleY=sp.scaleX;
			}
			else
			{
				sp.height=wid;
				sp.scaleX=sp.scaleY;
			}
		}


		/**
		 * 震动显示对象
		 * @param        target        震动目标对象
		 * @param        time          震动持续时长（秒）
		 * @param        rate          震动频率(一秒震动多少次)
		 * @param        maxDis        震动最大距离
		 */
		public static function shakeObj(target:DisplayObject, time:Number=0.5, rate:Number=6, maxDis:Number=6):void
		{
			if (target.hasEventListener(Event.ENTER_FRAME))
			{
				return;
			}
			var _shake_init_x:int=target.x;
			var _shake_init_y:int=target.y;
			var _count:int=time * rate;
			maxDis*=2;
			var initTime:int=getTimer();

			target.addEventListener(Event.ENTER_FRAME, onShake);

			function onShake(e:Event):void
			{
				if ((getTimer() - initTime) / 1000 > time)
				{
					target.removeEventListener(Event.ENTER_FRAME, onShake);
					target.x=_shake_init_x;
					target.y=_shake_init_y;
					return;
				}
				target.x=_shake_init_x + (Math.random() - 0.5) * maxDis;
				target.y=_shake_init_y + (Math.random() - 0.5) * maxDis;
			}
		}


		public static function sortY(target:DisplayObjectContainer):void
		{
			var len:int=target.numChildren;
			var arr:Array=[];
			for (var i:int=0; i < len; i++)
			{
				var child:DisplayObject=target.getChildAt(i) as DisplayObject;
				arr[i]=child;
			}
			arr.sortOn("y");
			for (i=0; i < len; i++)
			{
				child=arr[i];
				target.setChildIndex(child, i);
			}
		}

		/**
		 * 获取可视对象的所有孩子集合
		 * @param container 目标可视对象
		 * @return 可视对象的所有孩子集合
		 */
		public static function getChildrenArr(container:DisplayObjectContainer):Vector.<starling.display.DisplayObject>
		{
			var result:Vector.<starling.display.DisplayObject>=new Vector.<DisplayObject>;
			for (var i:int=0; i < container.numChildren; i++)
			{
				result[i]=container.getChildAt(i);
			}
			return result;
		}

		/**
		 * 获取可视对象相对于父容器的层次索引
		 * @param dis 目标可视对象
		 * */
		public static function getDeth(dis:DisplayObject):int
		{
			if (dis.parent)
			{
				return dis.parent.getChildIndex(dis);
			}
			else
			{
				return -1;
			}
		}

		/**
		 * 移除目标可视容器对象中所有的子对象
		 * @param container 目标可视容器对象
		 * @param recursion 是否递归，移除子孙最底层所有子对象，默认为false
		 * @return void
		 */
		public static function removeAllChildren(container:DisplayObjectContainer, recursion:Boolean=false):void
		{
			if (container)
			{
				while (container.numChildren > 0)
				{
					var p:DisplayObjectContainer=container.removeChildAt(0) as DisplayObjectContainer;
					if (recursion && p)
					{
						removeAllChildren(p);
					}
				}
			}
		}

		/**
		 * amf数据输出格式化
		 * @return
		 */
		static public function deepObjectToString(obj:*, level:int=0, output:String=""):*
		{
			var tabs:String="";
			for (var i:int=0; i < level; i++)
			{
				tabs+="\t";
			}
			for (var child:* in obj)
			{
				output+=tabs + "[" + child + "] => " + obj[child];
				var childOutput:String=deepObjectToString(obj[child], level + 1);
				if (childOutput != "")
				{
					output+=" {\n" + childOutput + tabs + "}";
				}
				output+="\n";
			}
			if (level > 20)
			{
				return "";
			}
			return output;
		}

		/**
		 * 深度克隆对象
		 */
		public static function baseClone(source:*):*
		{
			var typeName:String=getQualifiedClassName(source);
			var packageName:String=typeName.split("::")[1];
			var cls:Class=Class(getDefinitionByName(typeName));
			registerClassAlias(packageName, cls);
			var ba:ByteArray=new ByteArray();
			ba.writeObject(source);
			ba.position=0;
			return ba.readObject();
		}

		public static function clone(source:*):*
		{
			var newObj:*=new source["constructor"]();
			var ba:ByteArray=new ByteArray();
			ba.writeObject(source);
			ba.position=0;
			var obj:Object=ba.readObject();
			return obj;
		}

		/**
		 * 是否为字符串类型
		 */
		public static function isString(value:*):Boolean
		{
			return (typeof(value) == "string" || value is String);
		}

		/**
		 * 是否为数值型类型
		 */
		public static function isNumber(value:*):Boolean
		{
			return (typeof(value) == "number" || value is Number);
		}

		/**
		 * 是否为Boolean类型
		 */
		public static function isBoolean(value:*):Boolean
		{
			return (typeof(value) == "boolean" || value is Boolean);
		}

		/**
		 * 是否为函数类型
		 */
		public static function isFunction(value:*):Boolean
		{
			return (typeof(value) == "function" || value is Function);
		}

		/** @private */
		public static const DEG:Number=-180 / Math.PI;
		/** @private */
		public static const RAD:Number=Math.PI / -180;

		/**
		 * Finds the sign of the provided value.
		 * @param	value		The Number to evaluate.
		 * @return	1 if value is greater then 0, -1 if value is less then 0, and 0 when value == 0.
		 */
		public static function sign(value:Number):int
		{
			return value < 0 ? -1 : (value > 0 ? 1 : 0);
		}

		/**
		 * Finds the angle (in degrees) from point 1 to point 2.
		 * @param	x1		The first x-position.
		 * @param	y1		The first y-position.
		 * @param	x2		The second x-position.
		 * @param	y2		The second y-position.
		 * @return	The angle from (x1, y1) to (x2, y2).
		 */
		public static function angle(x1:Number, y1:Number, x2:Number, y2:Number):Number
		{
			var a:Number=Math.atan2(y2 - y1, x2 - x1) * DEG;
			return a < 0 ? a + 360 : a;
		}

		/**
		 * Sets the x/y values of the provided object to a vector of the specified angle and length.
		 * @param	object		The object whose x/y properties should be set.
		 * @param	angle		The angle of the vector, in degrees.
		 * @param	length		The distance to the vector from (0, 0).
		 * @param	x			X offset.
		 * @param	y			Y offset.
		 */
		public static function angleXY(object:Object, angle:Number, length:Number=1, x:Number=0, y:Number=0):void
		{
			angle*=RAD;
			object.x=Math.cos(angle) * length + x;
			object.y=Math.sin(angle) * length + y;
		}

		/**
		 * Find the distance between two points.
		 * @param	x1		The first x-position.
		 * @param	y1		The first y-position.
		 * @param	x2		The second x-position.
		 * @param	y2		The second y-position.
		 * @return	The distance.
		 */
		public static function distance(x1:Number, y1:Number, x2:Number=0, y2:Number=0):Number
		{
			return Math.sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
		}

		/**
		 * Find the distance between two rectangles. Will return 0 if the rectangles overlap.
		 * @param	x1		The x-position of the first rect.
		 * @param	y1		The y-position of the first rect.
		 * @param	w1		The width of the first rect.
		 * @param	h1		The height of the first rect.
		 * @param	x2		The x-position of the second rect.
		 * @param	y2		The y-position of the second rect.
		 * @param	w2		The width of the second rect.
		 * @param	h2		The height of the second rect.
		 * @return	The distance.
		 */
		public static function distanceRects(x1:Number, y1:Number, w1:Number, h1:Number, x2:Number, y2:Number, w2:Number, h2:Number):Number
		{
			if (x1 < x2 + w2 && x2 < x1 + w1)
			{
				if (y1 < y2 + h2 && y2 < y1 + h1)
					return 0;
				if (y1 > y2)
					return y1 - (y2 + h2);
				return y2 - (y1 + h1);
			}
			if (y1 < y2 + h2 && y2 < y1 + h1)
			{
				if (x1 > x2)
					return x1 - (x2 + w2);
				return x2 - (x1 + w1)
			}
			if (x1 > x2)
			{
				if (y1 > y2)
					return distance(x1, y1, (x2 + w2), (y2 + h2));
				return distance(x1, y1 + h1, x2 + w2, y2);
			}
			if (y1 > y2)
				return distance(x1 + w1, y1, x2, y2 + h2)
			return distance(x1 + w1, y1 + h1, x2, y2);
		}

		/**
		 * Find the distance between a point and a rectangle. Returns 0 if the point is within the rectangle.
		 * @param	px		The x-position of the point.
		 * @param	py		The y-position of the point.
		 * @param	rx		The x-position of the rect.
		 * @param	ry		The y-position of the rect.
		 * @param	rw		The width of the rect.
		 * @param	rh		The height of the rect.
		 * @return	The distance.
		 */
		public static function distanceRectPoint(px:Number, py:Number, rx:Number, ry:Number, rw:Number, rh:Number):Number
		{
			if (px >= rx && px <= rx + rw)
			{
				if (py >= ry && py <= ry + rh)
					return 0;
				if (py > ry)
					return py - (ry + rh);
				return ry - py;
			}
			if (py >= ry && py <= ry + rh)
			{
				if (px > rx)
					return px - (rx + rw);
				return rx - px;
			}
			if (px > rx)
			{
				if (py > ry)
					return distance(px, py, rx + rw, ry + rh);
				return distance(px, py, rx + rw, ry);
			}
			if (py > ry)
				return distance(px, py, rx, ry + rh)
			return distance(px, py, rx, ry);
		}

		/**
		 * Clamps the value within the minimum and maximum values.
		 * @param	value		The Number to evaluate.
		 * @param	min			The minimum range.
		 * @param	max			The maximum range.
		 * @return	The clamped value.
		 */
		public static function clamp(value:Number, min:Number, max:Number):Number
		{
			if (max > min)
			{
				value=value < max ? value : max;
				return value > min ? value : min;
			}
			value=value < min ? value : min;
			return value > max ? value : max;
		}

		/**
		 * Clamps the object inside the rectangle.
		 * @param	object		The object to clamp (must have an x and y property).
		 * @param	x			Rectangle's x.
		 * @param	y			Rectangle's y.
		 * @param	width		Rectangle's width.
		 * @param	height		Rectangle's height.
		 */
		public static function clampInRect(object:Object, x:Number, y:Number, width:Number, height:Number, padding:Number=0):void
		{
			object.x=clamp(object.x, x + padding, x + width - padding);
			object.y=clamp(object.y, y + padding, y + height - padding);
		}

		/**
		 * Transfers a value from one scale to another scale. For example, scale(.5, 0, 1, 10, 20) == 15, and scale(3, 0, 5, 100, 0) == 40.
		 * @param	value		The value on the first scale.
		 * @param	min			The minimum range of the first scale.
		 * @param	max			The maximum range of the first scale.
		 * @param	min2		The minimum range of the second scale.
		 * @param	max2		The maximum range of the second scale.
		 * @return	The scaled value.
		 */
		public static function scale(value:Number, min:Number, max:Number, min2:Number, max2:Number):Number
		{
			return min2 + ((value - min) / (max - min)) * (max2 - min2);
		}

		/**
		 * Transfers a value from one scale to another scale, but clamps the return value within the second scale.
		 * @param	value		The value on the first scale.
		 * @param	min			The minimum range of the first scale.
		 * @param	max			The maximum range of the first scale.
		 * @param	min2		The minimum range of the second scale.
		 * @param	max2		The maximum range of the second scale.
		 * @return	The scaled and clamped value.
		 */
		public static function scaleClamp(value:Number, min:Number, max:Number, min2:Number, max2:Number):Number
		{
			value=min2 + ((value - min) / (max - min)) * (max2 - min2);
			if (max2 > min2)
			{
				value=value < max2 ? value : max2;
				return value > min2 ? value : min2;
			}
			value=value < min2 ? value : min2;
			return value > max2 ? value : max2;
		}

		/**
		 * Returns the next item after current in the list of options.
		 * @param	current		The currently selected item (must be one of the options).
		 * @param	options		An array of all the items to cycle through.
		 * @param	loop		If true, will jump to the first item after the last item is reached.
		 * @return	The next item in the list.
		 */
		public static function next(current:*, options:Array, loop:Boolean=true):*
		{
			if (loop)
				return options[(options.indexOf(current) + 1) % options.length];
			return options[Math.max(options.indexOf(current) + 1, options.length - 1)];
		}

		/**
		 * Returns the item previous to the current in the list of options.
		 * @param	current		The currently selected item (must be one of the options).
		 * @param	options		An array of all the items to cycle through.
		 * @param	loop		If true, will jump to the last item after the first is reached.
		 * @return	The previous item in the list.
		 */
		public static function prev(current:*, options:Array, loop:Boolean=true):*
		{
			if (loop)
				return options[((options.indexOf(current) - 1) + options.length) % options.length];
			return options[Math.max(options.indexOf(current) - 1, 0)];
		}

		/**
		 * Swaps the current item between a and b. Useful for quick state/string/value swapping.
		 * @param	current		The currently selected item.
		 * @param	a			Item a.
		 * @param	b			Item b.
		 * @return	Returns a if current is b, and b if current is a.
		 */
		public static function swap(current:*, a:*, b:*):*
		{
			return current == a ? b : a;
		}

		/**
		 * Creates a color value by combining the chosen RGB values.
		 * @param	R		The red value of the color, from 0 to 255.
		 * @param	G		The green value of the color, from 0 to 255.
		 * @param	B		The blue value of the color, from 0 to 255.
		 * @return	The color uint.
		 */
		public static function getColorRGB(R:uint=0, G:uint=0, B:uint=0):uint
		{
			return R << 16 | G << 8 | B;
		}

		/**
		 * Creates a color value with the chosen HSV values.
		 * @param	h		The hue of the color (from 0 to 1).
		 * @param	s		The saturation of the color (from 0 to 1).
		 * @param	v		The value of the color (from 0 to 1).
		 * @return	The color uint.
		 */
		public static function getColorHSV(h:Number, s:Number, v:Number):uint
		{
			h=int(h * 360);
			var hi:int=Math.floor(h / 60) % 6, f:Number=h / 60 - Math.floor(h / 60), p:Number=(v * (1 - s)), q:Number=(v * (1 - f * s)), t:Number=(v * (1 - (1 - f) * s));
			switch (hi)
			{
				case 0:
					return int(v * 255) << 16 | int(t * 255) << 8 | int(p * 255);
				case 1:
					return int(q * 255) << 16 | int(v * 255) << 8 | int(p * 255);
				case 2:
					return int(p * 255) << 16 | int(v * 255) << 8 | int(t * 255);
				case 3:
					return int(p * 255) << 16 | int(q * 255) << 8 | int(v * 255);
				case 4:
					return int(t * 255) << 16 | int(p * 255) << 8 | int(v * 255);
				case 5:
					return int(v * 255) << 16 | int(p * 255) << 8 | int(q * 255);
				default:
					return 0;
			}
			return 0;
		}

		/**
		 * Finds the red factor of a color.
		 * @param	color		The color to evaluate.
		 * @return	A uint from 0 to 255.
		 */
		public static function getRed(color:uint):uint
		{
			return color >> 16 & 0xFF;
		}

		/**
		 * Finds the green factor of a color.
		 * @param	color		The color to evaluate.
		 * @return	A uint from 0 to 255.
		 */
		public static function getGreen(color:uint):uint
		{
			return color >> 8 & 0xFF;
		}

		/**
		 * Finds the blue factor of a color.
		 * @param	color		The color to evaluate.
		 * @return	A uint from 0 to 255.
		 */
		public static function getBlue(color:uint):uint
		{
			return color & 0xFF;
		}

		/**
		 * Shuffles the elements in the array.
		 * @param	a		The Object to shuffle (an Array or Vector).
		 */
		public static function shuffle(a:Object):void
		{
			if (a is Array || a is Vector.<*>)
			{
				var i:int=a.length, j:int, t:*;
				while (--i)
				{
					t=a[i];
					a[i]=a[j=Math.random() * (i + 1)];
					a[j]=t;
				}
			}
		}

		/**
		 * Sorts the elements in the array.
		 * @param	object		The Object to sort (an Array or Vector).
		 * @param	ascending	If it should be sorted ascending (true) or descending (false).
		 */
		public static function sort(object:Object, ascending:Boolean=true):void
		{
			if (object is Array || object is Vector.<*>)
				quicksort(object, 0, object.length - 1, ascending);
		}

		/**
		 * Sorts the elements in the array by a property of the element.
		 * @param	object		The Object to sort (an Array or Vector).
		 * @param	property	The numeric property of object's elements to sort by.
		 * @param	ascending	If it should be sorted ascending (true) or descending (false).
		 */
		public static function sortBy(object:Object, property:String, ascending:Boolean=true):void
		{
			if (object is Array || object is Vector.<*>)
				quicksortBy(object, 0, object.length - 1, ascending, property);
		}

		/** @private Quicksorts the array. */
		private static function quicksort(a:Object, left:int, right:int, ascending:Boolean):void
		{
			var i:int=left, j:int=right, t:Number, p:*=a[Math.round((left + right) * .5)];
			if (ascending)
			{
				while (i <= j)
				{
					while (a[i] < p)
						i++;
					while (a[j] > p)
						j--;
					if (i <= j)
					{
						t=a[i];
						a[i++]=a[j];
						a[j--]=t;
					}
				}
			}
			else
			{
				while (i <= j)
				{
					while (a[i] > p)
						i++;
					while (a[j] < p)
						j--;
					if (i <= j)
					{
						t=a[i];
						a[i++]=a[j];
						a[j--]=t;
					}
				}
			}
			if (left < j)
				quicksort(a, left, j, ascending);
			if (i < right)
				quicksort(a, i, right, ascending);
		}

		/** @private Quicksorts the array by the property. */
		private static function quicksortBy(a:Object, left:int, right:int, ascending:Boolean, property:String):void
		{
			var i:int=left, j:int=right, t:Object, p:*=a[Math.round((left + right) * .5)][property];
			if (ascending)
			{
				while (i <= j)
				{
					while (a[i][property] < p)
						i++;
					while (a[j][property] > p)
						j--;
					if (i <= j)
					{
						t=a[i];
						a[i++]=a[j];
						a[j--]=t;
					}
				}
			}
			else
			{
				while (i <= j)
				{
					while (a[i][property] > p)
						i++;
					while (a[j][property] < p)
						j--;
					if (i <= j)
					{
						t=a[i];
						a[i++]=a[j];
						a[j--]=t;
					}
				}
			}
			if (left < j)
				quicksortBy(a, left, j, ascending, property);
			if (i < right)
				quicksortBy(a, i, right, ascending, property);
		}


		public static function stopAnimation(animationList:Array, constainer:DisplayObjectContainer):void
		{
			var len:int=constainer.numChildren;

			for (var i:int=0; i < len; i++)
			{
				var child:DisplayObject=constainer.getChildAt(i);

				if (child is IAnimatable)
				{
					if (Starling.juggler.contains(child as IAnimatable))
					{
						animationList.push(child);
						Starling.juggler.remove(child as IAnimatable);
					}
				}
				else if (child is DisplayObjectContainer)
				{
					stopAnimation(animationList, child as DisplayObjectContainer);
				}
			}
		}


		public static function resumeAnimation(animationList:Array):void
		{
			var len:int=animationList.length;
			for (var i:int=0; i < len; i++)
			{
				var child:IAnimatable=animationList[i];
				Starling.juggler.add(child);
			}
			animationList.length=0;
		}

	}
}
