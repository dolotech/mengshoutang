package  com.utils
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;

	/**
	 * 颜色，滤镜工具
	 * @author yangyang
	 *
	 */
	public class FilterUtils
	{
		private static const gaoliang:Array=[ //
			1.2, 0, 0, 0, 0, //
			0, 1.2, 0, 0, 0, //
			0, 0, 1.2, 0, 0, //
			0, 0, 0, 1, 0]; //高亮
		private static const bianhei:Array=[ //
			1, 0, 0, 0, -70, //
			0, 1, 0, 0, -70, //
			0, 0, 1, 0, -70, //
			0, 0, 0, 1, 0]; //变暗图片
		private static const heibai:Array=[ //
			0.33, 0.33, 0.33, 0, 0, //
			0.33, 0.33, 0.33, 0, 0, //
			0.33, 0.33, 0.33, 0, 0, //
			0, 0, 0, 1, 0]; //变成黑白图片，灰度图
		//变红
		private static const red:Array=[ //
			0.25, 0.25, 0.25, 0, 0, //
			0, 0, 0, 0, 0, //
			0, 0, 0, 0, 0, //
			0, 0, 0, 1, 0];

		public function FilterUtils()
		{
		}

		/***
		 * 高亮
		 * */
		public static function highLight(obj:DisplayObject):void
		{
			var filter1:ColorMatrixFilter;
			filter1=new ColorMatrixFilter(gaoliang);
			obj.filters=[filter1];
		}

		/***
		 * 变暗
		 * */
		public static function darken(obj:DisplayObject):void
		{
			var filter1:ColorMatrixFilter;
			filter1=new ColorMatrixFilter(bianhei);
			obj.filters=[filter1];
		}

		/***
		 * 黑白
		 * */
		public static function heibaiSet(obj:DisplayObject):void
		{
			var filter1:ColorMatrixFilter;
			filter1=new ColorMatrixFilter(heibai);
			obj.filters=[filter1];
		}

		/***
		 * 还原默认
		 * */
		public static function reSet(obj:DisplayObject):void
		{
			obj.filters=[];
		}

		/***
		 * 发光
		 * */
		public static function light(obj:DisplayObject, color:uint, qiangdu:Number=1):void
		{
			var glow:GlowFilter=new GlowFilter(color, 1, 5, 5, qiangdu, 3);
			obj.filters=[glow];
		}

		/***
		 * 描边
		 * */
		public static function stroke(obj:DisplayObject, color:uint):void
		{
			var glow:GlowFilter=new GlowFilter(color, 0.5, 2, 2, 5, 3);
			obj.filters=[glow];
		}

		/**
		 *变红
		 * @param obj
		 *
		 */
		public static function redObject(obj:DisplayObject):void
		{
			obj.filters=[new ColorMatrixFilter(red)];
		}

		/**
		 *使一张位图变成黑白
		 * @param source
		 * @return
		 *
		 */
		public static function grayBitmapData(source:BitmapData):void
		{
			var r:int, g:int, b:int, p:int, t:int, a:int;
			var rect:Rectangle=new Rectangle(0, 0, source.width, source.height);
			var data:Vector.<uint>=source.getVector(rect);
			var length:int=data.length;
			for (var i:int=0; i < length; i++)
			{
				p=data[i];
				a=p & 0xff000000;
				r=(p >> 16) & 0x000000ff;
				g=(p >> 8) & 0x000000ff;
				b=p & 0x000000ff;

				t=(r * 0.299 + g * 0.587 + b * 0.114);
				//t=(r*3+g*6+b)/10;
				t=a + (t << 16) + (t << 8) + t;

				data[i]=t;
			}
			source.setVector(rect, data);
		}
	}
}