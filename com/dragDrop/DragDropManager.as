package com.dragDrop
{
	import flash.errors.IllegalOperationError;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;

	import feathers.core.PopUpManager;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Stage;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class DragDropManager
	{

		private static const HELPER_POINT:Point=new Point();

		protected static var _touchPointID:int=-1;
		protected static var dragSource:IDragSource;
		protected static var _dragData:DragData;
		protected static var dropTarget:IDropTarget;
		protected static var isAccepted:Boolean=false;
		protected static var avatar:DisplayObject;
		protected static var avatarOffsetX:Number;
		protected static var avatarOffsetY:Number;
		protected static var dropTargetLocalX:Number;
		protected static var dropTargetLocalY:Number;
		protected static var avatarOldTouchable:Boolean;

		public static function get touchPointID():int
		{
			return (_touchPointID);
		}

		public static function get isDragging():Boolean
		{
			return (!((_dragData == null)));
		}

		public static function get dragData():DragData
		{
			return (_dragData);
		}

		public static function startDrag(source:IDragSource, touch:Touch, data:DragData, dragAvatar:DisplayObject=null, dragAvatarOffsetX:Number=0, dragAvatarOffsetY:Number=0):void
		{
			if (isDragging)
			{
				cancelDrag();
			}
			if (!(source))
			{
				throw(new ArgumentError("Drag source cannot be null."));
			}
			if (!(data))
			{
				throw(new ArgumentError("Drag data cannot be null."));
			}
			dragSource=source;
			_dragData=data;
			_touchPointID=touch.id;
			avatar=dragAvatar;
			avatarOffsetX=dragAvatarOffsetX;
			avatarOffsetY=dragAvatarOffsetY;
			touch.getLocation(Starling.current.stage, HELPER_POINT);
			if (avatar)
			{
				avatarOldTouchable=avatar.touchable;
				avatar.touchable=false;
				avatar.x=(HELPER_POINT.x + avatarOffsetX);
				avatar.y=(HELPER_POINT.y + avatarOffsetY);
				PopUpManager.addPopUp(avatar, false, false);
			}
			Starling.current.stage.addEventListener(TouchEvent.TOUCH, stage_touchHandler);
			Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, nativeStage_keyDownHandler, false, 0, true);
			dragSource.onDragStart.dispatch(dragSource, data);
			updateDropTarget(HELPER_POINT);
		}

		public static function acceptDrag(target:IDropTarget):void
		{
			if (dropTarget != target)
			{
				throw(new ArgumentError("Drop target cannot accept a drag at this time. Acceptance may only happen after the onDragEnter signal is dispatched and before the onDragExit signal is dispatched."));
			}
			isAccepted=true;
		}

		public static function cancelDrag():void
		{
			if (!(isDragging))
			{
				return;
			}
			completeDrag(false);
		}

		protected static function completeDrag(isDropped:Boolean):void
		{
			if (!(isDragging))
			{
				throw(new IllegalOperationError("Drag cannot be completed because none is currently active."));
			}
			if (dropTarget)
			{
				dropTarget.onDragExit.dispatch(dropTarget, _dragData, dropTargetLocalX, dropTargetLocalY);
				dropTarget=null;
			}
			var source:IDragSource=dragSource;
			var data:DragData=_dragData;
			cleanup();
			source.onDragComplete.dispatch(source, data, isDropped);
		}

		protected static function cleanup():void
		{
			if (avatar)
			{
				if (PopUpManager.isPopUp(avatar))
				{
					PopUpManager.removePopUp(avatar);
				}
				avatar.touchable=avatarOldTouchable;
				avatar=null;
			}
			Starling.current.stage.removeEventListener(TouchEvent.TOUCH, stage_touchHandler);
			Starling.current.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, nativeStage_keyDownHandler);
			dragSource=null;
			_dragData=null;
		}

		protected static function updateDropTarget(location:Point):void
		{
			var target:DisplayObject=Starling.current.stage.hitTest(location, true);
			while (((target) && (!((target is IDropTarget)))))
			{
				target=target.parent;
			}
			if (target)
			{
				target.globalToLocal(location, location);
			}
			if (target != dropTarget)
			{
				if (((dropTarget) && (isAccepted)))
				{
					dropTarget.onDragExit.dispatch(dropTarget, _dragData, dropTargetLocalX, dropTargetLocalY);
				}
				dropTarget=IDropTarget(target);
				isAccepted=false;
				if (dropTarget)
				{
					dropTargetLocalX=location.x;
					dropTargetLocalY=location.y;
					dropTarget.onDragEnter.dispatch(dropTarget, _dragData, dropTargetLocalX, dropTargetLocalY);
				}
			}
			else
			{
				if (dropTarget)
				{
					dropTargetLocalX=location.x;
					dropTargetLocalY=location.y;
					dropTarget.onDragMove.dispatch(dropTarget, _dragData, dropTargetLocalX, dropTargetLocalY);
				}
			}
		}

		protected static function nativeStage_keyDownHandler(event:KeyboardEvent):void
		{
			if ((((event.keyCode == Keyboard.ESCAPE)) || ((event.keyCode == Keyboard.BACK))))
			{
				event.preventDefault();
				cancelDrag();
			}
		}

		protected static function stage_touchHandler(event:TouchEvent):void
		{
			var stage:Stage;
			var touch:Touch;
			var currentTouch:Touch;
			var isDropped:Boolean;
			stage=Starling.current.stage;
			var touches:Vector.<Touch>=event.getTouches(stage);
			if ((((touches.length == 0)) || ((_touchPointID < 0))))
			{
				return;
			}
			for each (currentTouch in touches)
			{
				if (currentTouch.id == _touchPointID)
				{
					touch=currentTouch;
					break;
				}
			}
			if (!(touch))
			{
				return;
			}
			if (touch.phase == TouchPhase.MOVED)
			{
				touch.getLocation(stage, HELPER_POINT);
				if (avatar)
				{
					avatar.x=(HELPER_POINT.x + avatarOffsetX);
					avatar.y=(HELPER_POINT.y + avatarOffsetY);
				}
				updateDropTarget(HELPER_POINT);
			}
			else
			{
				if (touch.phase == TouchPhase.ENDED)
				{
					_touchPointID=-1;
					isDropped=false;
					if (((dropTarget) && (isAccepted)))
					{
						dropTarget.onDragDrop.dispatch(dropTarget, _dragData, dropTargetLocalX, dropTargetLocalY);
						isDropped=true;
					}
					dropTarget=null;
					completeDrag(isDropped);
					return;
				}
			}
		}

	}
}
