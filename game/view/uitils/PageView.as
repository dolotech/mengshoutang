package game.view.uitils
{
	import com.view.View;

	import game.manager.AssetMgr;

	import starling.display.Image;

	/**
	 * 页数显示
	 * @author hyy
	 *
	 */
	public class PageView extends View
	{
		private var list : Array = [];

		/**
		 * @param count  页数的数量
		 * @param gap    距离
		 * 
		 */
		public function PageView(count : int, gap : int = 0)
		{
			super(true);

			var img : Image;

			for (var i : int = 0; i < count; i++)
			{
				img = new Image(AssetMgr.instance.getTexture("ui_gongyong_yemianqiehuan2"));
				addChild(img);
				img.x = (img.width + gap) * i;
				list.push(img);
			}
		}

		/**
		 * 当前页数 
		 * @param value
		 * 
		 */
		public function set selectedIndex(value : int) : void
		{
			var len : int = list.length;

			for (var i : int = 0; i < len; i++)
			{
				Image(list[i]).texture = AssetMgr.instance.getTexture("ui_gongyong_yemianqiehuan" + (i == value ? 1 : 2));
			}
		}
	}
}