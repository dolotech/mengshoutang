package game.data
{
	import starling.display.DisplayObjectContainer;

	/**
	 * 创建建筑动画数据
	 * @author hyy
	 *
	 */
	public class CreateHouseData
	{
		public function CreateHouseData(createName : String, x : Number, y : Number, looping : Boolean, container : DisplayObjectContainer, index : int = -1, onTouch : Function = null, scaleX : Number = 1.0, scaleY : Number = 1.0, disName : String = "")
		{
			this.createName = createName;
			this.x = x;
			this.y = y;
			this.looping = looping;
			this.container = container;
			this.index = index;
			this.scaleX = scaleX;
			this.scaleY = scaleY;
			this.onTouch = onTouch;
			this.disName = disName;
		}
		public var playName : String;
		public var disName : String;
		public var createName : String;
		public var x : Number;
		public var y : Number;
		public var scaleX : Number;
		public var scaleY : Number;
		public var looping : Boolean;
		public var onTouch : Function;
		public var container : DisplayObjectContainer;
		public var index : int;

		public function dispose() : void
		{
			container = null;
			onTouch = null;
		}
	}
}