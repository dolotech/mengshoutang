package game.scene
{
	import com.utils.Constants;
	import com.view.Clickable;

	import game.common.JTLogger;
	import game.data.HeroData;
	import game.data.MonsterData;
	import game.data.RoleShow;
	import game.data.StoryConfigData;
	import game.data.StoryData;
	import game.manager.BattleAssets;
	import game.manager.HeroDataMgr;
	import game.view.new2Guide.base.NewGuideStoryBase;

	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.textures.Texture;

	/**
	 * 场景对话
	 * @author hyy
	 *
	 */
	public class NewBattleWords extends NewGuideStoryBase
	{
		private var ico_head : Image;
		private var showAll : Boolean;
		private var container : Sprite;
		private var onComplement : Function;
		private var dialogData : StoryConfigData;
		private var story_list : Array;
		private var isEnd : Boolean;
		private var data : StoryData;
		private var screenWidth : int;
		private var last_pos : int = -1;

		public function NewBattleWords(dialogData : StoryConfigData, onComplement : Function = null)
		{
			this.dialogData = dialogData;
			this.onComplement = onComplement;
			super();
		}

		override protected function init() : void
		{
			var q : Quad = new Quad(Constants.FullScreenWidth, Constants.FullScreenHeight);
			q.alpha = 0;
			addChild(q);
			q.scaleX = q.scaleY = 1 / Constants.scale;
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

		override protected function show() : void
		{
			story_list = [].concat(StoryData.dic[dialogData.id]);
			showStoryView();
		}

		private function showStoryView() : void
		{
			data = story_list.shift();

			if (data == null)
			{
				story_list.length == 0 ? dispose() : showStoryView();
				return;
			}
			var isRight : Boolean = data.pos == 2;
			isEnd = false;
			bgButton.scaleX = isRight ? 1 : -1;
			bgButton.x = (isRight ? bgButton.pivotX + screenWidth - bgButton.width : bgButton.pivotX);
			captionTxt.x = isRight ? screenWidth - bgButton.width + 61 : 21;
			nameTxt.x = isRight ? screenWidth - bgButton.width + 100 : 623;

			if (ico_head)
				ico_head.visible = false;
			captionTxt.text = nameTxt.text = "";

			if (data.target != -1)
			{
				var target : HeroData;

				if (data.target == 0)
					target = HeroDataMgr.instance.getMaxLevelHero();
				else
					target = MonsterData.monster.getValue(data.target);
				var roleShow : RoleShow = RoleShow.hash.getValue(target.show) as RoleShow;
				var texture : Texture = BattleAssets.instance.getTexture(roleShow.half_photo);

				if (texture != null)
				{
					if (ico_head == null)
					{
						ico_head = new Image(texture);
						container.addChildAt(ico_head, 0);
					}
					else
						ico_head.texture = texture;
					ico_head.readjustSize();
					nameTxt.text = target.name;

					if (last_pos == data.pos)
					{
						ico_head.x = isRight ? screenWidth - ico_head.width : ico_head.width;
					}
					else
					{
						ico_head.x = isRight ? screenWidth : -ico_head.width;
						tween(ico_head, 0.5, {x: isRight ? screenWidth - ico_head.width : ico_head.width, transition: Transitions.EASE_OUT_BACK});
					}
					ico_head.y = 640 - 125 - ico_head.height;
					ico_head.scaleX = isRight ? 1 : -1;
					ico_head.visible = true;
				}
				else
				{
					warn("找不到ID:" + roleShow.half_photo);
				}

			}
			Starling.juggler.delayCall(showText, last_pos == data.pos ? 0 : 0.6, data.caption, 1);
			last_pos = data.pos;
		}

		private function showText(caption : String, index : int) : void
		{
			captionTxt.text = caption.substring(0, index);

			if (index >= caption.length || isEnd)
			{
				isEnd = true;
				captionTxt.text = caption;
			}
			else
				Starling.juggler.delayCall(showText, 0, caption, ++index);
		}

		private function onNext(view : Clickable) : void
		{
			if (!isEnd)
			{
				isEnd = true
				return;
			}

			if (story_list.length > 0)
				showStoryView();
			else
				dispose();
		}

		override public function dispose() : void
		{
			super.dispose();
			container.scaleX = container.scaleY = 1;
			onComplement != null && onComplement();
			onComplement = null;
			dialogData = null;
		}
	}
}


