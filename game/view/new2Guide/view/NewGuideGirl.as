package game.view.new2Guide.view
{
	import com.scene.SceneMgr;
	import com.view.Clickable;

	import game.hero.AnimationCreator;
	import game.manager.AssetMgr;
	import game.scene.BattleScene;
	import game.view.new2Guide.NewGuide2Manager;
	import game.view.new2Guide.data.NewDialogData;
	import game.view.viewGuide.ViewGuideManager;

	import starling.core.Starling;
	import starling.display.Sprite;

	import treefortress.spriter.SpriterClip;

	public class NewGuideGirl extends Clickable
	{
		private var girl_animation:SpriterClip;
		private var view_dialog:NewGuideDialog;
		public var showAll:Boolean;
		private var container:Sprite;
		private var cur_text:String;

		public function NewGuideGirl()
		{
			super();
		}

		override protected function init():void
		{
			container=new Sprite();
			girl_animation=AnimationCreator.instance.create("effect_Newbieguide", AssetMgr.instance);
			girl_animation.play("effect_Newbieguide");
			girl_animation.animation.looping=true;
			Starling.juggler.add(girl_animation);
			view_dialog=new NewGuideDialog();
			girl_animation.y=120;
			girl_animation.x=330;
			container.addChild(view_dialog);
			container.addChild(girl_animation);
			container.touchable=false;
			addQuiackChild(container);
			addClickFun(onNext);
		}

		public function data(dialogData:NewDialogData):void
		{
			var battleScene:BattleScene=SceneMgr.instance.getCurScene() as BattleScene;

			if (battleScene)
			{
				container.x=460;
				container.y=170;
			}
			else
			{
				container.x=460;
				container.y=320;
			}
			showAll=false;
			cur_text=dialogData.text;
			showText(dialogData.text, 1);
		}

		private function showText(text:String, index:int):void
		{
			if (cur_text != text)
				return;

			view_dialog.txt_des.text=text.substr(0, index);

			if (showAll)
			{
				view_dialog.txt_des.text=text;
				return;
			}
			showAll=index >= text.length;

			if (!showAll)
			{
				Starling.juggler.delayCall(showText, 0.07, text, ++index);
			}
		}

		private function onNext(view:Clickable):void
		{
			if (!showAll)
			{
				showAll=true;
				return;
			}
			gotoNext();
		}

		public function gotoNext():void
		{
			NewGuide2Manager.instance && NewGuide2Manager.instance.nextDialog();
			ViewGuideManager.instance && ViewGuideManager.instance.nextDialog();
		}
	}
}


