package com.utils
{
	/**
	 * 方法代理 
	 * @author Michael
	 * 
	 */	
	public class Delegate
	{
		public static function createFunction(fun : Function, ... arg) : Function
		{
			return function(... otherArg) : void
			{
				fun.apply(null, otherArg.concat(arg));
			}
		}
	}
}