package game.view.story
{
	import com.dialog.Dialog;

	import game.data.StoryData;
	import game.manager.AssetMgr;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import starling.animation.DelayedCall;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import starling.text.TextField;
	import com.utils.Constants;

	public class WinStory extends Dialog
	{
		private var storyData : Array;
		private var sc1 : WinStoryBase1;
		private var sc2 : WinStoryBase2;
		public var onPlayComplete : ISignal;

		public function WinStory()
		{
			super();
			onPlayComplete = new Signal();
			sc1 = new WinStoryBase1();
			sc2 = new WinStoryBase2();
			addChild(sc1);
			addChild(sc2);
			sc2.bgButton.downState = null;
			sc1.bgButton.downState = null;
			sc1.visible = false;
			sc2.visible = false;
			sc2.bgButton.getChildAt(0).scaleX = -1;
			sc2.addEventListener(Event.TRIGGERED, onPlay);
			sc1.addEventListener(Event.TRIGGERED, onPlay);
			sc1.x = Constants.virtualWidth - sc2.width;
			y = (Constants.virtualHeight - height) - 399;
		}

		private var isPlay : Boolean;
		private var isClick : Boolean;
		private var showAll : Boolean;

		private function onPlay(e : Event) : void
		{
			sc2.bgButton.getChildAt(0).scaleX = -1;

			if (isClick)
			{
				if (showAll)
					Starling.juggler.tween(this, 1, {alpha: 0, onComplete: function() : void
						{

							close();

						}});

				if (!showAll)
					showAll = true;
				return;
			}

			if (storyData.length == 0)
			{
				isClick = true;

			}
			else
			{
				if (!isPlay)
				{
					start();
					isPlay = true;
				}
				else
				{
					showAll = true;
				}
			}
		}

		override public function dispose() : void
		{
			sc1.dispose();
			sc2.dispose();
			Starling.juggler.remove(call);
			onPlayComplete.dispatch();
			super.dispose();
		}


		private function Change(value : StoryData) : void
		{
			sc2.bgButton.getChildAt(0).scaleX = -1;

			if (value.pos == 2)
			{
				sc2.visible = false;
				sc1.visible = true;


				sc1.nameTxt.text = value.name;


				Starling.juggler.remove(call);
				showText(value.caption, 1, sc1.captionTxt);

				var button : Button = sc1.getChildByName("sc1") as Button;
				button && button.removeFromParent(true);

				if (value.photo != "")
				{

					button = new Button(AssetMgr.instance.getTexture(value.photo));
					sc1.addChildAt(button, 0);
					button.downState = null;
					button.name = "sc1";
					button.x = 960 - button.width;
					button.y = 640 - 125 - button.height;
				}
			}
			else
			{
				sc1.visible = false;
				sc2.visible = true;

				sc1.nameTxt.text = value.name;

				sc2.captionTxt.text = value.caption;

				Starling.juggler.remove(call);
				showText(value.caption, 1, sc2.captionTxt);

				var button1 : Button = sc2.getChildByName("sc2") as Button;
				button1 && button1.removeFromParent(true);

				if (value.photo != "")
				{
					button1 = new Button(AssetMgr.instance.getTexture(value.photo));

					sc2.addChildAt(button1, 0);
					button1.getChildAt(0).scaleX = -1;
					button1.x = button1.width;
					button1.name = "sc2";
					button1.downState = null;
					button1.y = 640 - 125 - button1.height;
				}
			}
		}
		private var call : DelayedCall

		private function showText(formerText : String, currentText : int, target : TextField) : void
		{
			target.text = formerText.substr(0, currentText);

			if (showAll)
			{
				if (storyData.length > 0)
					showAll = false;
				isPlay = false;
				target.text = formerText;
				return;
			}

			if (currentText < formerText.length)
			{
				{
					currentText++;
					call = Starling.juggler.delayCall(showText, 0.07, formerText, currentText, target);
				}
			}
			else
			{
				isPlay = false;
			}

		}

		override public function open(container : DisplayObjectContainer, parameter : Object = null, okFun : Function = null, cancelFun : Function = null) : void
		{
			super.open(container, parameter, okFun, cancelFun);
			storyData = (parameter as Array).concat();
			start(); //对话开始

		}

		//对话开始
		private function start() : void
		{
			var data : StoryData = storyData[0];
			storyData.splice(0, 1);
			Change(data);
		}


	}
}