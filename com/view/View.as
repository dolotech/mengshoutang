package com.view
{

	import com.mvc.core.Facade;
	import com.mvc.interfaces.INotification;
	import com.mvc.interfaces.IObserver;
	import com.utils.Constants;

	import starling.animation.IAnimatable;
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.events.Event;


	/**
	 * 显示对象的基类
	 * @author Michael
	 *
	 */
	public class View extends Clickable implements IAnimatable, IObserver
	{
		protected var enableTween : Boolean = false;
		protected var isViewTweening : Boolean = false;
		protected var transition : String = Transitions.EASE_OUT_BACK;

		public function View(isAutoInit : Boolean = true)
		{
			super(isAutoInit);
		}
		private var _facade : Facade;

		/**
		 * 添加到舞台
		 * @param evt
		 *
		 */
		override protected function addToStageHandler(evt : Event) : void
		{
			super.addToStageHandler(evt);
			_facade = Facade.instance;
			initObserver();
		}

		/**
		 * 移除出舞台
		 *
		 */
		override protected function removeToStageHandler(evt : Event) : void
		{
			super.removeToStageHandler(evt);
			removeObserver();
		}

		protected function initObserver() : void
		{
			var vector : Vector.<String> = listNotificationName();
			var len : int = vector.length;

			for (var i : int = 0; i < len; i++)
			{
				Facade.addObserver(vector[i], this);
			}
		}

		/**
		 *
		 */
		public function removeObserver() : void
		{
			var vector : Vector.<String> = listNotificationName();
			var len : int = vector.length;

			for (var i : int = 0; i < len; i++)
			{
				Facade.removeObserver(vector[i], this);
			}
		}

		/**
		 *
		 * @param _arg1
		 */
		public function handleNotification(_arg1 : INotification) : void
		{

		}

		/**
		 *
		 * @return
		 */
		public function listNotificationName() : Vector.<String>
		{
			return new Vector.<String>();
		}

		/**
		 *
		 * @param time
		 */
		public function advanceTime(time : Number) : void
		{

		}


		/**
		 * 移到当前容器顶端
		 *
		 */
		protected function getTop() : void
		{
			if (parent)
			{
				parent.addChild(this);
			}
		}

		/**
		 *
		 * @param _arg1
		 * @param _arg2
		 */
		public function setToXCenter() : void
		{
			this.x = ((Constants.FullScreenWidth - this.width + x * Constants.scale) * .5);
		}

		/**
		 *
		 * @param _arg1
		 * @param _arg2
		 */
		public function setToYCenter() : void
		{
			this.y = ((Constants.FullScreenHeight - this.height + y * Constants.scale) * .5);
		}


		public function setToBottomCenter() : void
		{
			this.x = (Constants.FullScreenWidth - width) * .5;
			this.y = (Constants.FullScreenHeight - height) - changePosition(30);
		}

		/**
		 * 放到屏幕中间
		 * @param _arg1
		 */
		public function setToCenter(x : int = 0, y : int = 0) : void
		{
			this.x = (Constants.FullScreenWidth - this.width + x * Constants.scale) * .5;
			this.y = (Constants.FullScreenHeight - this.height + y * Constants.scale) * .5;
		}

		/**
		 * 在一个有缩放的容器里面，里面坐标需要改变
		 * @param value
		 * @param isTag  如果是宽度需要相乘
		 * @return
		 *
		 */
		public function changePosition(value : int, isTag : Boolean = false) : Number
		{
			return isTag ? value * Constants.scale : value / Constants.scale;
		}

		/**
		 *设置二级界面是否开启缓动缩放打开方式
		 *
		 */
		public function easingIn() : void
		{
			if (!enableTween || isViewTweening || width == 0 || height == 0)
				return;
			var tmp_width : Number = width;
			var tmp_height : Number = height;
			width = height = tmp_height * 0.8;
			touchable = false;
			isViewTweening = true;
			Starling.juggler.tween(this, 0.3, {width: tmp_width, height: tmp_height, onUpdate: setToCenter, onComplete: onComplete, transition: transition});

			function onComplete() : void
			{
				isViewTweening = false;
				touchable = true;
				width = tmp_width;
				height = tmp_height;
				openTweenComplete();
			}
		}

		protected function openTweenComplete() : void
		{

		}

		protected function easingOut() : void
		{
			if (isViewTweening)
				return;
			var tmp_width : Number = width;
			var tmp_height : Number = height;
			touchable = false;
			isViewTweening = true;
			Starling.juggler.tween(this, 0.2, {width: tmp_width * .2, height: tmp_height * .2, onUpdate: setToCenter, onComplete: onComplete});

			function onComplete() : void
			{
				removeFromParent(true);
				isViewTweening = false;
				touchable = true;
				width = tmp_width;
				height = tmp_height;
				closeTweenComplete();
			}
		}

		protected function closeTweenComplete() : void
		{

		}

		public function tween(target : Object, time : Number, properties : Object) : void
		{
			Starling.juggler.tween(target, time, properties);
		}
		
		
	}
}
