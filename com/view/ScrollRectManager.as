package com.view
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.display.DisplayObject;

	public class ScrollRectManager
	{

		public static var scrollRectOffsetX:Number=0;
		public static var scrollRectOffsetY:Number=0;
		public static var currentScissorRect:Rectangle;

		public static function adjustTouchLocation(location:Point, target:DisplayObject):void
		{
			var matrix:Matrix;
			var targetWithScrollRect:IDisplayObjectWithScrollRect;
			var scrollRect:Rectangle;
			var newTarget:DisplayObject=target;
			while (newTarget.parent)
			{
				newTarget=newTarget.parent;
				if ((newTarget is IDisplayObjectWithScrollRect))
				{
					targetWithScrollRect=IDisplayObjectWithScrollRect(newTarget);
					scrollRect=targetWithScrollRect.scrollRect;
					if (((!(scrollRect)) || ((((scrollRect.x == 0)) && ((scrollRect.y == 0))))))
					{
					}
					else
					{
						matrix=newTarget.getTransformationMatrix(target, matrix);
						location.x=(location.x + (scrollRect.x * matrix.a));
						location.y=(location.y + (scrollRect.y * matrix.d));
					}
				}
			}
		}

		public static function toStageCoordinates(location:Point, target:DisplayObject):void
		{
			var matrix:Matrix;
			var targetWithScrollRect:IDisplayObjectWithScrollRect;
			var scrollRect:Rectangle;
			var newTarget:DisplayObject=target;
			while (newTarget.parent)
			{
				newTarget=newTarget.parent;
				if ((newTarget is IDisplayObjectWithScrollRect))
				{
					targetWithScrollRect=IDisplayObjectWithScrollRect(newTarget);
					scrollRect=targetWithScrollRect.scrollRect;
					if (((!(scrollRect)) || ((((scrollRect.x == 0)) && ((scrollRect.y == 0))))))
					{
					}
					else
					{
						matrix=newTarget.getTransformationMatrix(target, matrix);
						location.x=(location.x - (scrollRect.x * matrix.a));
						location.y=(location.y - (scrollRect.y * matrix.d));
					}
				}
			}
		}

		public static function getBounds(object:DisplayObject, targetSpace:DisplayObject, result:Rectangle=null):Rectangle
		{
			var matrix:Matrix;
			var targetWithScrollRect:IDisplayObjectWithScrollRect;
			var scrollRect:Rectangle;
			if (!(result))
			{
				result=new Rectangle();
			}
			object.getBounds(targetSpace, result);
			var newTarget:DisplayObject=object;
			while (newTarget.parent)
			{
				newTarget=newTarget.parent;
				if ((newTarget is IDisplayObjectWithScrollRect))
				{
					targetWithScrollRect=IDisplayObjectWithScrollRect(newTarget);
					scrollRect=targetWithScrollRect.scrollRect;
					if (((!(scrollRect)) || ((((scrollRect.x == 0)) && ((scrollRect.y == 0))))))
					{
					}
					else
					{
						matrix=newTarget.getTransformationMatrix(object, matrix);
						result.x=(result.x - (scrollRect.x * matrix.a));
						result.y=(result.y - (scrollRect.y * matrix.d));
					}
				}
			}
			return (result);
		}

	}
}
