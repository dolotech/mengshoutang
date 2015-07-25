package game.view.arena
{
	import game.data.GamePhotoData;
	import game.view.uitils.Res;
	import game.view.viewBase.ArenaCreateNameRenderBase;

	public class ArenaCreateNameRender extends ArenaCreateNameRenderBase
	{
		private var _picture : int;

		public function ArenaCreateNameRender()
		{
			super();
		}

		override public function set data(value : Object) : void
		{
			super.data = value;
			var photoData : GamePhotoData = value as GamePhotoData;
			picture = (GamePhotoData.hashMapPhoto.getValue(photoData.id) as GamePhotoData).picture; //人物头像
		}

		public function set picture(value : int) : void
		{
			_picture = value;
			ico_hero.upState = ico_hero.downState = Res.instance.getRolePhoto(value);
		}

		public function get picture() : int
		{
			return _picture;
		}

	}
}