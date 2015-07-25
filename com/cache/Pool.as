package com.cache
{

	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.DisplayObject;

	/**
	 * 对象池
	 * @author blank
	 *
	 */
	public class Pool
	{
		/**
		 * 对象分类列表
		 */
		private static var objs:Dictionary=new Dictionary(true);

		/**
		 * 存入对象
		 * @param obj 对象
		 * @param alias 对象的别名,如果不指定此值,则使用 getQualifiedClassName() 函数获取 obj 对象的完全限定名做为别名存储
		 *
		 */
		public static function setObj(obj:*, alias:String=null):void
		{
			if (!alias)
			{
				alias=getQualifiedClassName(obj);
			}

			var objArr:Array=objs[alias] || (objs[alias]= []);

            if(objArr.indexOf(obj) == -1)
            {
                objArr[objArr.length]=obj;
            }
		}

		/**
		 * 取出对象
		 * @param alias 对象的别名( Class 或 String )
		 * @return
		 *
		 */
		public static function getObj(arg:*):*
		{
			var alias:String;

			if (arg is Class)
			{
				alias=getQualifiedClassName(arg);
			}
			else
			{
				alias=arg;
			}

			var objArr:Array=objs[alias];
			if (objArr)
			{
				return objArr.pop();
			}
			return null;
		}

		/**
		 * 移除指定别名的所有对象
		 * @param alias
		 *
		 */
		public static function delObjs(ClassName:Class):void
		{
			var alias:String;
			if (!alias)
			{
				alias=getQualifiedClassName(ClassName);
			}
			
			var objArr:Array=objs[alias];
			if (objArr)
			{
                del(objArr);
				delete objs[alias];
			}
		}

        private static function del(arr:Array):void
        {
            for each(var obj:Object in arr)
            {
                if(obj)
                {
                    if(obj is IAnimatable)
                    {
                        Starling.juggler.remove(obj as IAnimatable);
                    }
                    Starling.juggler.removeTweens(obj);
                    if(obj is DisplayObject)
                    {
                        (obj as DisplayObject).removeFromParent();
                    }
                    if(obj.hasOwnProperty("customDispose"))
                    {
                        obj.customDispose();
                    }
                    obj.dispose();
                }
            }
        }

		/**
		 * 移除所有对象
		 *
		 */
		public static function delAllObjs():void
		{
			for each (var arr:Array in objs)
			{
                del(arr);
			}
			
			objs=new Dictionary(true);
		}
	}

}
