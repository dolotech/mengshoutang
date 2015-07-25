package game.view.widget
{
	import com.dragDrop.DragSource;
	
	import starling.textures.Texture;

	public class Widget extends DragSource
	{
		public function Widget(texture:Texture=null,dragable:Boolean = true)
		{
			super(texture,dragable);
		}	
	}
}  