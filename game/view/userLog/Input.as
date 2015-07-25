package game.view.userLog
{
	import com.utils.TouchProxy;
	
	import feathers.controls.TextInput;
	import feathers.controls.text.StageTextTextEditor;
	import feathers.core.ITextEditor;
	import feathers.events.FeathersEventType;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import starling.events.Event;
	import starling.events.Touch;

	public class Input
	{

		private var _isPassword : Boolean = true; //是否是密码文本
		private var _size : int = 32; //字体大小
		private var _color : uint = 0xffffcc; //字体颜色
		private var _max : int = 16; //最大几个字符
		private var _min : int = 6; //最小几个字符
		private var _defaultText : String; //默认文本
		private var _defaultColor : uint = 0x999999; //默认文本颜色
		private var _showDefaultText : Boolean = true; //是否显示默认文本
		private var _input : TextInput; //输入文本对象
		private var _onChangeError : ISignal = new Signal(); //文本规则错误派发
		private var _onChnageOk : ISignal = new Signal(); //文本规则正确派发
		private var _onRegainDefault : ISignal = new Signal(); //恢复默认文本派发
		private var _index : int;
		private var _passMath : Boolean = true;

		public function StartFactory() : void
		{
			if (_input == null)
				throw new Error(_input + ",TextInput is null object");
			_isFocus = _showDefaultText;
			_input.textEditorProperties.fontSize = _size;
			_input.textEditorProperties.color = _showDefaultText ? _defaultColor : _color;
			_input.text = _showDefaultText ? _defaultText : "";
//			_input.defaultText = _showDefaultText;
			_input.textEditorFactory = function factory() : ITextEditor
			{
				var editor : StageTextTextEditor = new StageTextTextEditor;
				editor.maxChars = _max;
//				editor.fontFamily = "方正综艺简体";
//				editor.defaultText = _showDefaultText;
				return editor;
			}
			_input.addEventListener(FeathersEventType.FOCUS_IN, onFocusIn);
			_input.addEventListener(FeathersEventType.FOCUS_OUT, onFocusOut);
			_input.addEventListener(Event.CHANGE, onFocusOut);
			var touch : TouchProxy = new TouchProxy(_input);
			touch.onClick.add(onClick);
		}


		private function onClick(e : Touch) : void
		{

		}


		private function onChange(e : Event) : void
		{
			if (_input.text.length > 0 && _input.text != _defaultText && _isPassword)
				_input.textEditorProperties.displayAsPassword = _isPassword;
			else
				_input.textEditorProperties.displayAsPassword = false;
		}

		public var _isFocus : Boolean;

		private function onFocusIn(e : Event) : void
		{
			if (_showDefaultText && _isFocus)
			{
				_input.text = "";
				_isFocus = false;
				_input.textEditorProperties.color = _color;
			}
			//input.selectRange(0, input.text.length);
		}

		private function onFocusOut(e : Event) : void
		{
			if (_showDefaultText && !_isFocus && _input.text.length <= 0)
			{
				//_input.text = _defaultText;
				_isFocus = true;
				_input.textEditorProperties.color = _defaultColor;
				_onRegainDefault.dispatch(_index);
			}
			else
			{
				_input.textEditorProperties.color = _color;
				if (_passMath)
					passwordRule();
				else
					userNameRule();
			}

		}


		private function passwordRule() : void
		{
			if (!_isFocus && _input.text.length >= _min && Verification.specialUnicodes((_input.text)))
				_onChnageOk.dispatch(_index);
			else
				_onChangeError.dispatch(_index);

		}


		private function userNameRule() : void
		{
			if (!_isFocus && _input.text.length >= min && Verification.specialSign(_input.text))
			{
				_onChnageOk.dispatch(_index);
			}
			else
				_onChangeError.dispatch(_index);
		}


		public function findText() : Boolean
		{
			if (_input.text == _defaultText)
				return false;

			return true;
		}

		public function findRule(isPassword : Boolean) : Boolean
		{
			if (isPassword)
			{
				for (var i : int = 0; i < _input.text.length; i++)
				{
					if (!_isFocus && _input.text.length >= _min && Verification.specialUnicode(_input.text.charAt(i)))
						return true;
				}
			}
			else
			{
				if (!_isFocus && _input.text.length >= min && Verification.specialSign(_input.text))
					return true;
			}
			return false;
		}




		/**
		 *
		 * @return 恢复默认文本的派发
		 *
		 */
		public function get onRegainDefault() : ISignal
		{
			return _onRegainDefault;
		}

		/**
		 *
		 * @return 输入的文本符合规则
		 *
		 */
		public function get onChangeRight() : ISignal
		{
			return _onChnageOk;
		}


		/**
		 *
		 * @return 输入的文本规则错误派发
		 *
		 */
		public function get onChangeError() : ISignal
		{
			return _onChangeError;
		}

		/**
		 *
		 * @param input TextInput
		 *
		 */
		public function set input(input : TextInput) : void
		{
			_input = input;
		}

		/**
		 *
		 * @param isPassword 是否是密码文本
		 *
		 */
		public function set isPassword(isPassword : Boolean) : void
		{
			_isPassword = isPassword;
		}

		/**
		 *
		 * @param size 字体大小
		 *
		 */
		public function set size(size : int) : void
		{
			_size = size;
		}

		/**
		 *
		 * @param color 字体颜色
		 *
		 */
		public function set color(color : uint) : void
		{
			_color = color;
		}

		/**
		 *
		 * @param max 最大文本长度
		 *
		 */
		public function set max(max : int) : void
		{
			_max = max;
		}

		/**
		 *
		 * @param min 最小文本长度
		 *
		 */
		public function set min(min : int) : void
		{
			_min = min;
		}

		/**
		 *
		 * @param min 最小文本长度
		 *
		 */
		public function get min() : int
		{
			return _min;
		}

		/**
		 *
		 * @param text 默认文本
		 *
		 */
		public function set defaultText(text : String) : void
		{
			_defaultText = text;
		}

		/**
		 *
		 * @param color 默认文本颜色
		 *
		 */
		public function set defaultColor(color : uint) : void
		{
			_defaultColor = color;
		}

		/**
		 *
		 * @param isShow 是否显示默认文本
		 *
		 */
		public function set showDefaultText(isShow : Boolean) : void
		{
			_showDefaultText = isShow;
		}

		public function set index(index : int) : void
		{
			_index = index;
		}


		/**
		 *
		 * @return 恢复默认文本的派发
		 *
		 */
		public function set passMatch(passMatch : Boolean) : void
		{
			_passMath = passMatch;
		}

	}
}