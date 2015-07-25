package game.view.new2Guide.view
{
	import com.utils.Constants;
	import com.view.Clickable;

	import game.manager.AssetMgr;
	import game.view.new2Guide.NewGuide2Manager;
	import game.view.new2Guide.base.NewGuideStoryBase;
	import game.view.new2Guide.data.NewDialogData;
	import game.view.viewGuide.ViewGuideManager;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	/**
	 * 场景对话
	 * @author hyy
	 *
	 */
	public class NewGuideStory extends NewGuideStoryBase
	{
		private var ico_head : Image;
		private var showAll : Boolean;
		private var container : Sprite;
		private var screenWidth : int;

		override protected function init() : void
		{
			addClickFun(onNext);
			container = new Sprite();
			container.addQuiackChild(bgButton);
			container.addQuiackChild(nameTxt);
			container.addQuiackChild(captionTxt);
			addQuiackChild(container);
			container.touchable = false;

			bgButton.pivotX = bgButton.width * .5;
			bgButton.pivotY = bgButton.height * .5;
			bgButton.y += bgButton.pivotY;

			container.scaleX = container.scaleY = Constants.scale < 1 ? 1 : 1 / Constants.scale;
			container.y += Constants.scale < 1 ? 0 : changePosition(Constants.FullScreenHeight - Constants.virtualHeight);
			screenWidth = Constants.scale < 1 ? Constants.virtualWidth : Constants.FullScreenWidth;
		}

		public function data(dialogData : NewDialogData) : void
		{
			var isRight : Boolean = dialogData.align == 1;
			bgButton.scaleX = isRight ? 1 : -1;
			bgButton.x = (isRight ? bgButton.pivotX + screenWidth - bgButton.width : bgButton.pivotX);
			captionTxt.x = isRight ? screenWidth - bgButton.width + 61 : 21;
			nameTxt.x = isRight ? screenWidth - bgButton.width + 128 : 623;
			showAll = false;

			if (dialogData.photo)
			{
				var texture : Texture = AssetMgr.instance.getTexture(dialogData.photo);

				if (ico_head == null)
					ico_head = new Image(texture);
				else
					ico_head.texture = texture;
				ico_head.readjustSize();
				container.addChildAt(ico_head, 0);
				ico_head.x = isRight ? screenWidth - ico_head.width : ico_head.width;
				ico_head.y = 640 - 125 - ico_head.height;
				ico_head.scaleX = isRight ? 1 : -1;
			}
			showText(dialogData.text, 1);
			nameTxt.text = dialogData.name;
		}

		private function showText(text : String, index : int) : void
		{
			captionTxt.text = text.substr(0, index);

			if (showAll)
			{
				captionTxt.text = text;
				return;
			}

			showAll = index >= text.length;

			if (!showAll)
			{
				Starling.juggler.delayCall(showText, 0.07, text, ++index);
			}

		}

		private function onNext(view : Clickable) : void
		{
			if (!showAll)
			{
				showAll = true;
				return;
			}

			gotoNext();
		}

		private function gotoNext() : void
		{
			NewGuide2Manager.instance && NewGuide2Manager.instance.nextDialog();
			ViewGuideManager.instance && ViewGuideManager.instance.nextDialog();
		}

	}
}


