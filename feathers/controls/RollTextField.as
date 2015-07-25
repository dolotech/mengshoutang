package feathers.controls
{

	import com.greensock.TweenLite;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	import game.uils.TweenLite;

	import starling.display.Sprite;

	public class RollTextField extends Sprite
	{

		private var w:int;
		private var h:int;
		private var rect:Rectangle;
		private var pt:Point;
		private var copyImg:BitmapData;
		private var curValue:int=0;
		private var offX:int=0;
		public var endFun:Function;

		public function RollTextField()
		{

		}


		public function set text(value:int):void
		{
			if (value == curValue)
			{
				return;
			}

			var myArray:Array=[curValue];
			this.curValue=value;

			if (!rect)
			{
				rect=new Rectangle(0, 0, w, h);
			}
			if (!pt)
			{
				pt=new Point();
			}

			TweenLite.to(myArray, 1, {endArray: [value], onUpdate: onUpdateView, onComplete: onComplete});

			function onUpdateView():void
			{
				var myNewStr:String=String(int(myArray[0]));
				var len:int=myNewStr.length;
				if (copyImg)
				{
					copyImg.dispose();
					copyImg=null;
				}

				copyImg=new BitmapData(len * w, h, true, 0x0);

				for (var i:int=0; i < len; i++)
				{
					var num:int=int(myNewStr.charAt(i)) + offX;
					rect.x=num * w;
					rect.y=0;
					rect.width=w;
					rect.height=h;
					pt.x=i * w;
					pt.y=0;
					copyImg.copyPixels(source, rect, pt);
				}

				bitmapData=copyImg;
			}

			function onComplete():void
			{
				if (endFun != null)
				{
					endFun.apply(null, null);
				}
			}
		}

	}
}
