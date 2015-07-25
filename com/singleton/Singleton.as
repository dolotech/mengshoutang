package com.singleton
{
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * 单例被移除时广播事件
	 * 
	 * @author Michael
	 */
	public class Singleton extends EventDispatcher
	{		
		// 单例管理器
		private static var _manager:Object = new Object();
		private static var _instanceList:Array = [];
		
		public function Singleton():void
		{
//			
		}
			
		//删除单例对象
		public function dispose():void
		{           
			var name:String = getQualifiedClassName(this);
			delete _manager[name];
			_manager[name] = null;	
			
			_instanceList.splice(_instanceList.indexOf(name), 1);
			
			// 移除时发送事件
//			dispatchEvent(new Event(Event.REMOVED));
		}
		
		public static function remove(target:Object):void
		{
			var name:String = getQualifiedClassName(target);
			
			delete _manager[name];
			_manager[name] = null;	
			
			_instanceList.splice(_instanceList.indexOf(name), 1);
		}
		
		/**
		 * 返回单例对象
		 * @param	classOject	类对象
		 * @return
		 */
		public static function getInstance(classOject:Class):Object
		{
			var name:String = getQualifiedClassName(classOject);			
			if (_manager[name] == null)			
			{
				_manager[name] = new classOject();	
				_instanceList.push(name);
			}
			
			return _manager[name];
		}
		
		public static function hasInstance(classOject:Class):Boolean
		{
			var name:String = getQualifiedClassName(classOject);
			
			return (_manager[name] != null && _manager[name] != undefined);
		}
		
		/**
		 * 返回单例列表
		 * @return
		 */
		public static function get instanceNameList():Array
		{			
			return _instanceList;
		}
		
		/**
		 * 单例的数量
		 */
		public static function get intanceCount():int { return _instanceList.length; }		
		
	}
	
}