package com.dialog
{
	import starling.display.DisplayObjectContainer;

	public interface IDialog
	{
		function open(container : DisplayObjectContainer, parameter:Object = null,okFun : Function = null, cancelFun : Function = null) : void;
		function close() : void;
	}
}