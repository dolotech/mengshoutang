package com.dragDrop
{
	import com.view.Clickable;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import starling.display.DisplayObject;

	/**
	 * 拖动目标 
	 * @author Michael
	 * 
	 */	
	public class DropTarget extends Clickable implements IDropTarget
	{
		protected var _data:DragData;
		protected var _onDragEnter:Signal;
		protected var _onDragMove:Signal;
		protected var _onDragExit:Signal;
		protected var _onDragDrop:Signal;
		
		public function DropTarget(image:DisplayObject)
		{
			this._onDragEnter=new Signal(DropTarget);
			this._onDragMove=new Signal(DropTarget);
			this._onDragExit=new Signal(DropTarget);
			this._onDragDrop=new Signal(DropTarget);
			
			_data = new DragData();
			
			this.addChild(image);
		}
		
		public function get data():DragData
		{
			return _data;
		}
		
		public function onDragEnterHandler(value:Function):void
		{
			_onDragEnter.add(value);
		}
		
		public function onDragDropHandler(value:Function):void
		{
			_onDragDrop.add(value);
		}
		
		public function get onDragEnter():ISignal
		{
			return _onDragEnter;
		}
		
		public function get onDragMove():ISignal
		{
			_onDragMove.removeAll();
			return _onDragMove;
		}
		
		public function get onDragExit():ISignal
		{
			return _onDragExit;
		}
		
		public function get onDragDrop():ISignal
		{
			return _onDragDrop;
		}
		
		
		override public function dispose():void
		{
			_onDragDrop.removeAll();
			_onDragExit.removeAll();
			_onDragMove.removeAll();
			_onDragEnter.removeAll();
			super.dispose();
		}
		
	}
}