package com.dialog
{
	import com.view.Clickable;
	import com.view.View;
	
	import flash.display.Bitmap;
	import flash.text.TextFormat;
	
	import game.dialog.ShowLoader;
	import game.view.closeDlgBackroud.CloseDlgBackground;
	import game.view.new2Guide.NewGuide2Manager;
	import game.view.new2Guide.interfaces.INewGuideView;
	import game.view.viewGuide.interfaces.IViewGuideView;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;


	/**
	 * 对话框基类
	 * @author Michael
	 *
	 */
	public class Dialog extends View implements IDialog, INewGuideView, IViewGuideView
	{
		public static const CLOSE_CONTAINER : String = "closeContainer";
		public static const OPEN_CONTAINER : String = "openContainer";
		public static const SMOOTH_REMOVE : String = "SMOOTH_REMOVE";

		public static const OPEN_MODE_NOTHING : String = "OPEN_MODE_NOTHING";
		public static const OPEN_MODE_TRANSLUCENCE : String = "translucence";


		public function get background() : DisplayObject
		{
			return _background;
		}

		public function set background(value : DisplayObject) : void
		{
			_background = value;
		}

		protected var _okFunction : Function; //OK
		protected var _cancelFunction : Function;
		protected var _parameter : Object;
		/**
		 * 是否为弹出状态
		 */
		public var px : Number;
		public var py : Number;

		private var _width : Number;
		private var _height : Number;

		protected var _closeButton : Button;
		protected var _okButton : Button;

		private var myTitle : Bitmap;
		private var myTextFormat : TextFormat;
		protected var _layer : DisplayObjectContainer;
		/**
		 * up
		 */
		protected var _closeStuat : String = "up"; //
		public var isVisible : Boolean = false;

		private var _background : DisplayObject = null;

		public function Dialog(isAutoInit : Boolean = false)
		{
			super(isAutoInit);
		}

		override protected function addListenerHandler() : void
		{
			this.addViewListener(_closeButton, Event.TRIGGERED, oncancelBtn);
			this.addViewListener(_okButton, Event.TRIGGERED, onOkBtn);
		}

		protected function onOkBtn() : void
		{
			if (_okFunction != null)
			{
				_okFunction.call(null, _parameter);
			}
			close();
		}

		protected function oncancelBtn() : void
		{
			if (_cancelFunction != null)
			{
				_cancelFunction.call(null, _parameter);
			}

			if (enableTween)
				easingOut();
			else
				close();
		}

		protected function clickBackroundClose(alpha:Number=0.1) : void
		{
			background = new CloseDlgBackground(alpha);
			CloseDlgBackground(background).addClickFun(closebg);
		}

		private function closebg(view : Clickable) : void
		{
			if (enableTween)
				easingOut();
			else
				close();
		}

		public function get leftMargin() : Number
		{
			return 165;
		}

		public function get topMargin() : Number
		{
			return 9;
		}

		public function get isPop() : Boolean
		{
			return _layer.contains(this) == true;
		}

		public function open(container : DisplayObjectContainer, parameter : Object = null, okFun : Function = null, cancelFun : Function = null) : void
		{
			_layer = container;

			if (isPop)
			{
				if (isTop(this))
				{
					close();
				}
				else
				{
				}
			}
			else
			{
				_parameter = parameter;

				if (okFun != null)
				{
					_okFunction = okFun;
				}

				if (cancelFun != null)
				{
					_cancelFunction = cancelFun;
				}
				popUp(this);
			}

			playSound(playId);
		}

		protected function get playId() : String
		{
			return "openFace";
		}

		/**
		 * 强制关闭
		 *
		 */
		public function close() : void
		{
			this.dispatchEvent(new Event(CLOSE_CONTAINER));
		}

		override public function set x(tox : Number) : void
		{
			var value : int = int(tox);

			if (value < -this.width + 20)
			{

			}
			else if (this.stage && value > this.stage.stageWidth - 20)
			{
			}
			else
			{
				super.x = value;
			}
		}

		override public function set y(toy : Number) : void
		{
			var value : Number = int(toy);

			if (value < -this.height + 20)
			{
			}
			else if (this.stage && value > this.stage.stageHeight - 20)
			{
			}
			else
			{
				super.y = value;
			}
		}

		/**
		 * 设置为最顶层
		 *
		 */
		public function swapTop() : void
		{
			if (_layer.contains(this))
			{
				var childNun : int = _layer.numChildren;

				if (_layer.getChildIndex(this) != childNun - 1)
				{
					_layer.setChildIndex(this, childNun - 1);
				}
			}
		}



		/**
		 * [方法] 弹出
		 * @param popCon
		 *
		 */
		public function popUp(popCon : Dialog) : void
		{
			_layer.addChild(popCon);
			easingIn();
		}

		/**
		 * [方法] 弹回
		 * @param popCon
		 *
		 */
		public function popBack(popCon : Dialog) : void
		{
			if (_layer && _layer.contains(popCon) == true)
			{
				_layer.removeChild(popCon);
			}

		}

		public function isTop(popCon : Dialog) : Boolean
		{
			if (_layer.contains(popCon) == true && _layer.getChildIndex(popCon) < _layer.numChildren - 1)
			{
				return false;
			}
			else
			{
				return true;
			}
		}



		/**
		 * 显示动画播放完成触发
		 *
		 */
		protected function showTweenComplete() : void
		{

		}

		/**
		 * 隐藏动画播放完成触发
		 *
		 */
		protected function hideTweenComplete() : void
		{
			this.dispatchEvent(new Event(CLOSE_CONTAINER));
		}

		/**
		 * 删除最顶层的弹出窗口
		 *
		 */
		private function removeTopChild() : void
		{
			if (_layer.numChildren == 0)
			{
				return;
			}
			(_layer.getChildAt(_layer.numChildren - 1) as Dialog).close();
		}

		/**
		 * 销毁
		 * 所有子类必须调用调用父类的函数
		 *
		 */
		override public function dispose() : void
		{
			super.dispose();
			_layer = null;
			_okFunction = null;
			_cancelFunction = null;
			_closeButton = null;
		}

		/**
		 * 新手引导
		 * @param name
		 * @return
		 *
		 */
		public function getGuideDisplay(name : String) : *
		{
			var tmp_names : Array = name.split(",");
			var len : int = tmp_names.length;

			var child : DisplayObject = this;

			for (var i : int = 0; i < len; i++)
			{
				child = child[tmp_names[i]];
			}

			if (child is Button)
			{
				Button(child).addEventListener(Event.TRIGGERED, onBtn_click);

				function onBtn_click() : void
				{
					Button(child).removeEventListener(Event.TRIGGERED, onBtn_click);
				}
			}
			return child;
		}

		override protected function easingOut() : void
		{
			if (isViewTweening)
				return;
			var tmp_width : Number = width;
			var tmp_height : Number = height;
			var al : int = alpha;
			touchable = false;
			isViewTweening = true;
			Starling.juggler.tween(this, 0.2, {alpha: 0, width: tmp_width * 1.2, height: tmp_height * 1.2, onUpdate: setToCenter, onComplete: onComplete, transition: Transitions.EASE_OUT});
			function onComplete() : void
			{
				close();
				isViewTweening = false;
				touchable = true;
				width = tmp_width;
				height = tmp_height;
				closeTweenComplete();
				alpha = al;
			}
		}

		/**
		 * 用于回到该界面传递参数哦 
		 * @return 
		 * 
		 */
		public function get backParam() : Object
		{
			return _parameter;
		}

		public function executeGuideFun(name : String) : void
		{

		}

		protected function addGuideEvent(target : DisplayObject, type : String, fun : Function = null) : void
		{
			this.addViewListener(target, type, guideGotoNext);
			function guideGotoNext() : void
			{
				fun != null && fun();
				removeViewListener(target, type, guideGotoNext);
				gotoNext();
			}
		}

		protected function addGuideContextEvent(type : String, fun : Function = null) : void
		{
			this.addContextListener(type, guideGotoNext);
			function guideGotoNext() : void
			{
				removeContextListener(type, guideGotoNext);

				if (fun != null)
					fun();
				gotoNext();
			}
		}

		public function gotoNext(delay : Number = 0, isSendNext : Boolean = false) : void
		{
			ShowLoader.remove();

			if (isSendNext)
				NewGuide2Manager.sendNextSeverStep();
			Starling.juggler.delayCall(NewGuide2Manager.gotoNext, delay);
		}

		public function getViewGuideDisplay(name : String) : *
		{

		}

		public function executeViewGuideFun(name : String) : void
		{

		}

	}
}