package game.view.replacePhotoList
{
	import game.data.GamePhotoData;
	import game.view.uitils.Res;

	public class NewGamePhotoRender extends SinglePhotoView
	{
		public function NewGamePhotoRender()
		{
			setSize(117, 117);
		}
		
		override public function set data(value : Object) : void
		{
			super.data = value;
			var photoData : GamePhotoData = value as GamePhotoData;
			txt_Level.text = photoData.name;
			
			imagePh.texture = Res.instance.getRolePhoto((GamePhotoData.hashMapPhoto.getValue(photoData.id) as GamePhotoData).picture); //人物头像
			imageVip.visible = false;
		}
		
	}
}