package game.dialog
{
	import com.utils.Assets;
	import com.utils.Constants;
	import com.view.View;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.deg2rad;
	import starling.utils.rad2deg;

	/**
	 * 转圈圈的加载动画
	 * @author Michael
	 *
	 */
	public class ShowLoader extends View
	{
		private var _load : Sprite;
		private var mask : Quad;
		private var txt : TextField;
		private static var _instance : ShowLoader;

		public function ShowLoader()
		{
			super();
		}

		override protected function init() : void
		{
			mask = Assets.getImage(Assets.Alpha_Backgroud);
			mask.width = Constants.FullScreenWidth;
			mask.height = Constants.FullScreenHeight;
			mask.alpha = 0.6;
			mask.touchable = true;
			addChild(mask);

			_load = new Sprite();
			var load : Image = Assets.getImage(Assets.LoadingICO);
			_load.scaleX = _load.scaleY = Constants.scale;

			load.x = -load.width / 2;
			load.y = -load.height / 2;
			txt = new TextField(200, 24, "", "", 18, 0xffffff);
			txt.hAlign = 'center';
			_load.addChild(load);
			_load.touchable = false;
			addChild(txt);
			addChild(_load);
		}

		override public function move(x : Number, y : Number) : void
		{
			y -= txt.height;
			load.x = x;
			load.y = y;
			txt.x = x - (txt.width) * .5;
			txt.y = y + load.height * .5;
		}

		public function get load() : Sprite
		{
			return _load;
		}

		public static function add(text : String = "") : void
		{
			remove();

			if (_instance == null)
				_instance = new ShowLoader();
			_instance.txt.text = text;
			_instance.move(.5 * (Starling.current.stage.stageWidth), .5 * (Starling.current.stage.stageHeight));
			Starling.current.stage.addChild(_instance);
			Starling.juggler.tween(_instance.load, 1.5, {repeatCount: 99999, rotation: deg2rad(360 + rad2deg(_instance.load.rotation))});
		}


		public function remove() : void
		{
			Starling.juggler.removeTweens(load);
			removeFromParent();
		}

		public static function remove() : void
		{
			if (_instance)
				_instance.remove();
		}
	}
}