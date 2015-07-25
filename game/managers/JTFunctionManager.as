package game.managers
{
	import game.common.JTLogger;
	
	import flash.utils.Dictionary;
	/**
	 * 
	 * @author CabbageWrom
	 * 函数管理器
	 * 
	 */	
	public class JTFunctionManager
	{
		private static var map:Dictionary = new Dictionary(false);
		
		/**
		 * 
		 * @param key 函数的键值
		 * @param callBack  要执行的回调函数
		 * @param isWeak  是否弱引用
		 * 
		 */		
		public static function registerFunction(key:String, callBack:Function, isWeak:Boolean = false):void
		{
			var functionList:Vector.<JTFunctionData> = map[key];
			if (functionList)
			{
				for each (var refFunctionData:JTFunctionData in functionList)
				{
					var fun:Function = refFunctionData.fun;
					if (fun != callBack)
					{
						continue;
					}
//					JTLogger.warn("[JTFunctionManager.registerFunction] Has Register The Function:" + key);
					return;
				}
			}
			else
			{
				functionList = new Vector.<JTFunctionData>();
				map[key] = functionList;
				
			}
			var functionData:JTFunctionData = new JTFunctionData();
			functionData.fun = callBack;
			functionData.isWeak = isWeak;
			functionData.key = key;
			functionList.push(functionData);
		}
		
		private static function copyFunctionVector(functionList:Vector.<JTFunctionData>):Vector.<JTFunctionData>
		{
			var copyFunction:Vector.<JTFunctionData> = new Vector.<JTFunctionData>();
			copyFunction = copyFunction.concat(functionList);
			return copyFunction;
		}
		
		/**
		 * 
		 * @param key 要执行的回调函数的键值
		 * @param args  要传递的数据
		 * 
		 */		
		public static function executeFunction(key:String, ...args):void
		{
			var functionList:Vector.<JTFunctionData> = map[key];
			if (!functionList)
			{
//				JTLogger.warn("[JTFunctionManager.executeFunction] Don't Has Register The Function:" + key);
				return;
			}
			var functionListLength:int = functionList.length;
			if (functionListLength == 0)
			{
//				JTLogger.warn("[JTFunctionManager.executeFunction] Don't Has Register The Function:" + key);
				return;
			}
			var copyFunctionList:Vector.<JTFunctionData> = copyFunctionVector(functionList);
			for each (var copyFunction:JTFunctionData in copyFunctionList)
			{
				if (!copyFunction)
				{
					continue;
				}
				var fun:Function = copyFunction.fun;
				var weak:Boolean = copyFunction.isWeak;
				if (fun == null)
				{
					continue;
				}
				fun.apply(null, args);
				if (!weak)
				{
					continue;	
				}
				removeFunction(key,fun);
			}
		}
		
		/**
		 * 
		 * @param key 要移除的函数的键值
		 * @param callBack 要移除的函数
		 * 
		 */		
		public static function removeFunction(key:String, callBack:Function):void
		{
			var functionList:Vector.<JTFunctionData> = map[key];
			if (!functionList)
			{
//				JTLogger.warn("[JTFunctionManager.removeFunction] Don't Has Register The Function:" + key);
				return;
			}
			var functionListLength:int = functionList.length;
			if (functionListLength == 0)
			{
				map[key] = null;
				delete map[key];
//				JTLogger.warn("[JTFunctionManager.removeFunction] Don't Has Register The Function:" + key);
				return;
			}
			if (callBack == null)
			{
				map[key] = null;
				delete map[key];
//				JTLogger.warn("[JTFunctionManager.removeFunction] Don't Afferent Function empty" + key);
				return;
			}
			var index:int = 0;
			for (index = 0; index < functionList.length; index++)
			{
				var functionData:JTFunctionData = functionList[index];
				if (!functionData)
				{
					functionList.splice(index, 1);
					index --;
					continue;
				}
				var fun:Function = functionData.fun;
				if (fun == callBack)
				{
					fun = null;
					functionList.splice(index, 1);
					index --;
					break;
				}
			}
			if (functionList.length == 0)
			{
				map[key] = null;
				delete map[key];
			}
			//JTLogger.info("[JTFunctionManager.removeFunction] Sueeccd removeFunction:" + key);
		}
		
		
		public static function checkRegisterFunction():void
		{
			for (var value:Object in map)
			{
				if (!value)
				{
					continue;
				}
				var functionList:Vector.<JTFunctionData> = map[value];
				JTLogger.info("[JTFunctionManager.checkRegisterFunction]" + value);
				if (!functionList)
				{
					continue;
				}
				JTLogger.info("[JTFunctionManager.checkRegisterFunction]" + value,"_____" + "Length:" + functionList.length);
			}
		}
	}
}
class JTFunctionData
{
	public var key:String = null;
	public var fun:Function = null;
	public var isWeak:Boolean = false;
}