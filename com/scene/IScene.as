package com.scene
{
	public interface IScene
	{
		function set data(value:Object):void;
		function get data():Object;

		function removeFromParent(dispose:Boolean = false):void;

		function showSwap():void;

		function dispose():void;
	}
}