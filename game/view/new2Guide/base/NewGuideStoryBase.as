package game.view.new2Guide.base
{
	import com.view.View;

	import game.manager.AssetMgr;

	import starling.display.Image;
	import starling.text.TextField;
	import starling.textures.Texture;

	public class NewGuideStoryBase extends View
	{
		public var bgButton : Image;
		public var nameTxt : TextField;
		public var captionTxt : TextField;

		public function NewGuideStoryBase()
		{
			super(false);
			var bgTexture : Texture = AssetMgr.instance.getTexture('story_words');
			bgButton = new Image(bgTexture);
			bgButton.x = 960;
			bgButton.y = 399;
			bgButton.width = 960;
			bgButton.height = 241;
			this.addQuiackChild(bgButton);
			nameTxt = new TextField(250, 43, '', '', 35, 0xffffff, false);
			nameTxt.touchable = false;
			nameTxt.hAlign = 'center';
			nameTxt.x = 600;
			nameTxt.y = 442;
			this.addQuiackChild(nameTxt);
			captionTxt = new TextField(849, 106, '', '', 30, 0x000000, false);
			captionTxt.touchable = false;
			captionTxt.hAlign = 'left';
			captionTxt.x = 21;
			captionTxt.y = 518;
			this.addQuiackChild(captionTxt);
			init();
		}

		override public function dispose() : void
		{
			super.dispose();
			bgButton.dispose();
		}

	}
}

