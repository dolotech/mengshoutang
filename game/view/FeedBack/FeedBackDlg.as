package game.view.FeedBack
{
	import com.components.RollTips;
	import com.dialog.DialogMgr;
	import com.langue.Langue;
	import com.mvc.interfaces.INotification;
	import com.utils.ObjectUtil;
	import com.utils.StringUtil;

	import flash.text.TextFormat;

	import feathers.controls.Button;
	import feathers.controls.TextArea;
	import feathers.events.FeathersEventType;

	import game.dialog.ShowLoader;
	import game.manager.AssetMgr;
	import game.net.GameSocket;
	import game.net.data.c.CFeedback;
	import game.net.data.s.SFeedback;

	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;

	/*
	 *
	 * 游戏反馈
	 * */
	public class FeedBackDlg extends FeedBackDlgBase
	{
		private var _textInput : TextArea = new TextArea();
		private var default_text : TextField = new TextField(534, 30, "", "", 24, 0xffffff);

		public function FeedBackDlg()
		{
			super();
			_closeButton = closeButton;
			default_text.touchable = submitImage.touchable = false;
			default_text.hAlign = 'left';
			_textInput.width = 534;
			_textInput.height = 257;
			this.addChild(_textInput);
			this.addChild(default_text);
			default_text.x = _textInput.x = 98;
			default_text.y = _textInput.y = 96;
			_textInput.padding = 4;
			_textInput.textEditorProperties.textFormat = new TextFormat("", 24, 0xffffff);
			default_text.text = getLangue("feedbackDlgInitInfo");
			_textInput.addEventListener(FeathersEventType.FOCUS_IN, onFocusIn);
			_textInput.addEventListener(FeathersEventType.FOCUS_OUT, onFocusOut);
			_textInput.maxChars = 280;
			suggestionTxt.text = Langue.getLangue("feedbackDlgSuggestion");
			bugTxt.text = Langue.getLangue("feedbackDlgBug");
			titleTxt.text = Langue.getLangue("feedbackDlgTitle");
			tips1Txt.text = Langue.getLangue("feedbackDlgTips1");
			tips2Txt.text = Langue.getLangue("feedbackDlgTips2");

			tips2Txt.fontName = "方正综艺简体";
			initSuggestionButtonEvent();
			initBugButtonEvent();
			initSubmitButton();
			DialogMgr.instance.closeAllDialog();
		}

		override protected function show() : void
		{
			setToCenter();
		}

		private function initSubmitButton() : void
		{
			submitButton.addEventListener(Event.TRIGGERED, onSubmitButton);
		}

		private function onSubmitButton(e : Event) : void
		{
			_textInput.text = StringUtil.trim(_textInput.text);

			if (_textInput.text == "" || _textInput.text == Langue.getLangue("feedbackDlgInitInfo"))
			{
				RollTips.add(Langue.getLangue("feedbackDlgSubmitEmpty"));
			}
			else
			{
				var cmd : CFeedback = new CFeedback();

				if (_isBugSelected)
				{
					cmd.type = 2;
				}
				else
				{
					cmd.type = 1;
				}
				cmd.content = _textInput.text;
				GameSocket.instance.sendData(cmd);
				ShowLoader.add();
			}
		}

		override public function handleNotification(_arg1 : INotification) : void
		{
			if (_arg1.getName() == String(SFeedback.CMD))
			{
				var snotice : SFeedback = _arg1 as SFeedback;
				updateSubmit(snotice);

			}
			ShowLoader.remove();
		}

		override public function listNotificationName() : Vector.<String>
		{
			var vect : Vector.<String> = new Vector.<String>;
			vect.push(SFeedback.CMD);
			return vect;
		}

		private function updateSubmit(info : SFeedback) : void
		{

			if (info.code == 0) //成功
			{
				RollTips.add(Langue.getLangue("feedbackDlgSubmitSucceed"));
			}
			else if (info.code == 1) //失败
			{
				RollTips.add(Langue.getLangue("feedbackDlgSubmitError"));
			}
			close();
		}

		private function onFocusIn() : void
		{
			_textInput.selectRange(0, _textInput.text.length);
			default_text.visible = false;
		}

		private function onFocusOut() : void
		{
			if (_textInput.text != "")
			{
				default_text.text = _textInput.text;
			}
			else
			{
				default_text.text = getLangue("feedbackDlgInitInfo");
			}
			default_text.visible = true;
		}

		private var suggestionButton : Button;

		private function initSuggestionButtonEvent() : void
		{
			suggestionButton = new Button();
			ObjectUtil.copyAttribute(suggsetionImage, suggestionButton);
			this.addQuiackChild(suggestionButton);
			suggestionButton.addEventListener(Event.TRIGGERED, onSuggestionButton);
		}

		private var _isBugSelected : Boolean = false;

		private function onSuggestionButton() : void
		{
			var onTexture : Texture = AssetMgr.instance.getTexture('ui_Feedback_button1');
			var offTexture : Texture = AssetMgr.instance.getTexture('ui_Feedback_button2');
			_isBugSelected = false;
			suggsetionImage.texture = onTexture;
			suggsetionImage.width = onTexture.width;
			suggsetionImage.height = onTexture.height;
			bugImage.texture = offTexture;
			bugImage.width = offTexture.width;
			bugImage.height = offTexture.height;
		}

		private var bugButton : Button;

		private function initBugButtonEvent() : void
		{
			bugButton = new Button();
			ObjectUtil.copyAttribute(bugImage, bugButton);
			this.addQuiackChild(bugButton);
			bugButton.addEventListener(Event.TRIGGERED, onBugButton);
		}

		private function onBugButton() : void
		{
			var onTexture : Texture = AssetMgr.instance.getTexture('ui_Feedback_button1');
			var offTexture : Texture = AssetMgr.instance.getTexture('ui_Feedback_button2');
			_isBugSelected = true;
			suggsetionImage.texture = offTexture;
			suggsetionImage.width = offTexture.width;
			suggsetionImage.height = offTexture.height;
			bugImage.texture = onTexture;
			bugImage.width = onTexture.width;
			bugImage.height = onTexture.height;
		}

		override public function dispose() : void
		{
			_textInput.removeEventListener(FeathersEventType.FOCUS_IN, onFocusIn);
			_textInput.removeEventListener(FeathersEventType.FOCUS_OUT, onFocusOut);
			_textInput.dispose();

			bugButton.dispose();
			suggestionButton.dispose();
			super.dispose();
		}
	}
}