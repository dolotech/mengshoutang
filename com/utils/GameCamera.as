package com.utils
{
	import flash.display.*;

	/**
	 * 截屏
	 * @author thinkpad
	 *
	 */
	public class GameCamera
	{

		private var whileChild_Parent_Arr:Array=[];

		public function takePhoto(target:DisplayObject, w:int, h:int):BitmapData
		{
			this.whileChild_Parent_Arr.length=0;
			var bitmapData:BitmapData=new BitmapData(w, h);
			this.whileChild(target as DisplayObjectContainer);
			bitmapData.draw(target);
			this.resumeWhileChild();
			return (bitmapData);
		}

		private function whileChild(target:DisplayObjectContainer):void
		{

			var index:int=0;
			while (index < target.numChildren)
			{
				var child:DisplayObject=(target.getChildAt(index) as DisplayObject);
				if ((child is Loader))
				{
					this.whileChild_Parent_Arr.push([child.parent, child]);
					child.parent.removeChild(child);
					index--;
				}
				else
				{
					if (child is DisplayObjectContainer)
					{
						this.whileChild(child as DisplayObjectContainer);
					}
				}
				index++;
			}
		}

		private function resumeWhileChild():void
		{
			var index:int=0;
			while (index < this.whileChild_Parent_Arr.length)
			{
				this.whileChild_Parent_Arr[index][0].addChild(this.whileChild_Parent_Arr[index][1]);
				index++;
			}
			this.whileChild_Parent_Arr.length=0;
		}

	}
}