package com.view
{
	import com.components.RollTips;
	import com.langue.Langue;
	import com.sound.SoundManager;
	import com.view.base.event.EventMap;
	import com.view.base.event.ViewDispatcher;

	import flash.geom.Rectangle;

	import game.common.JTLogger;
	import game.manager.AssetMgr;
	import game.net.GameSocket;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	/**
	 * 基本界面基类
	 * @author Administrator
	 */
	public class Clickable extends Sprite
	{
		private var _eventMap : EventMap;
		public var isShow : Boolean;
		/**
		 * 全局事件管理器
		 */
		public var eventDispatcher : ViewDispatcher;

		private var _clickHandler : ISignal;
		public var click_target : DisplayObject;

		protected var _isDown : Boolean;

		protected static const MAX_DRAG_DIST : Number = 50;

		/**
		 * -1根据容器的numChildren是否为0初始化
		 * 0 自动初始化
		 * 1不初始化
		 * @param isAutoInit
		 *
		 */
		public function Clickable(isAutoInit : Boolean = true)
		{
			super();
			initEvent();

			if (isAutoInit)
				init();
		}

		/**
		 * 点击处理
		 * @return
		 *
		 */
		public function addClickFun(fun : Function, isOne : Boolean = false) : void
		{
			if (_clickHandler == null)
				_clickHandler = new Signal(Clickable);
			isOne ? _clickHandler.addOnce(fun) : _clickHandler.add(fun);
		}

		/**
		 * 初始化
		 *
		 */
		protected function init() : void
		{

		}

		protected function initEvent() : void
		{
			eventDispatcher = ViewDispatcher.instance;
			addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removeToStageHandler);
			addEventListener(TouchEvent.TOUCH, onClick);
		}

		public function get eventMap() : EventMap
		{
			if (_eventMap == null)
				_eventMap = new EventMap();
			return _eventMap;
		}

		/**
		 *
		 * @param evt
		 */
		protected function addToStageHandler(evt : Event) : void
		{
			addListenerHandler();
			show();
		}

		/**
		 * 添加事件
		 *
		 */
		protected function addListenerHandler() : void
		{

		}

		/**
		 * 添加到舞台调用
		 *
		 */
		protected function show() : void
		{

		}

		/**
		 * 移出舞台调用
		 *
		 */
		protected function hide() : void
		{

		}

		/**
		 * 外部调用打开界面的操作
		 *
		 */
		public function openView() : void
		{

		}

		public function closeView(dispose : Boolean = false) : void
		{
			this.removeFromParent(dispose);
		}

		public function sendMessage(data : *, isNeedReturn : Boolean = false) : void
		{
			if (data is Class)
				data = new data();
			GameSocket.instance.sendData(data);
		}

		/**
		 * 添加组件事件
		 * @param dispatcher
		 * @param eventString
		 * @param listener
		 * @param eventClass
		 *
		 */
		protected function addViewListener(dispatcher : EventDispatcher, eventString : String, listener : Function, eventClass : Class = null) : void
		{
			if (dispatcher)
				eventMap.mapListener(dispatcher, eventString, listener, eventClass);
		}

		/**
		 * 移除组件事件
		 * @param dispatcher
		 * @param eventString
		 * @param listener
		 * @param eventClass
		 *
		 */
		protected function removeViewListener(dispatcher : EventDispatcher, eventString : String, listener : Function, eventClass : Class = null) : void
		{
			eventMap.unmapListener(dispatcher, eventString, listener, eventClass);
		}

		protected function addServerListener(eventString : int, listener : Function, eventClass : Class = null) : void
		{
			eventMap.mapListener(eventDispatcher, eventString + "", listener, eventClass);
		}

		/**
		 * 添加全局事件
		 * @param eventString
		 * @param listener
		 * @param eventClass
		 *
		 */
		protected function addContextListener(eventString : String, listener : Function, eventClass : Class = null) : void
		{
			eventMap.mapListener(eventDispatcher, eventString, listener, eventClass);
		}


		/**
		 * 移除全局事件
		 * @param eventString
		 * @param listener
		 * @param eventClass
		 *
		 */
		protected function removeContextListener(eventString : String, listener : Function, eventClass : Class = null) : void
		{
			eventMap.unmapListener(eventDispatcher, eventString, listener, eventClass);
		}

		/**
		 * 派发全局事件
		 * @param type
		 * @param obj
		 *
		 */
		protected function dispatch(type : String, obj : * = null) : void
		{
			eventDispatcher.dispatch(type, obj);
		}

		public function move(mx : Number, my : Number) : void
		{
			this.x = mx;
			this.y = my;
		}

		/**
		 * 移除出舞台
		 *
		 */
		protected function removeToStageHandler(evt : Event) : void
		{
			if (_eventMap)
				_eventMap.unmapListeners();
			hide();
		}

		/**
		 * 播放音效
		 * @param id
		 * @param stopSame
		 * @param volume
		 * @param repetitions
		 * @param panning
		 *
		 */
		public function playSound(id : String, stopSame : Boolean = false, volume : Number = 1.0, repetitions : int = 1, panning : Number = 0) : void
		{
			try
			{
				SoundManager.instance.playSound(id, stopSame, volume, repetitions, panning);
			}
			catch (e : Error)
			{
				trace(e);
			}
		}

		override public function dispose() : void
		{
			super.dispose();

			if (_clickHandler)
				_clickHandler.removeAll();
			_clickHandler = null;
			removeToStageHandler(null);
			eventDispatcher = null;
			_eventMap = null;
			closeView();
		}

		public function getLangue(id : String) : String
		{
			return Langue.getLangue(id);
		}

		/**
		 * 输出提示
		 * 打印到屏幕
		 * @param args
		 *
		 */
		public function addTips(info : String) : void
		{
			var msg : String = getLangue(info);
			RollTips.add(msg ? msg : info);
		}

		public function getTexture(name : String) : Texture
		{
			return AssetMgr.instance.getTexture(name)
		}

		/**
		 * 用于调试数据
		 * 上线可能去掉
		 * @param args
		 *
		 */
		public function debug(... args) : void
		{
			JTLogger.debug.apply(this, args);
		}

		public function warn(... args) : void
		{
			JTLogger.warn.apply(this, args);
		}

		public function delayCall(call : Function, delay : Number) : void
		{
			Starling.juggler.delayCall(call, delay);
		}

		/**
		 * 设置是否接受触摸
		 * @param dis
		 * @param enable
		 *
		 */
		public static function setTouchState(dis : DisplayObjectContainer, enable : Boolean = false) : void
		{
			dis.touchable = enable;
			var child : DisplayObject;

			for (var i : int = dis.numChildren - 1; i >= 0; i--)
			{
				child = dis.getChildAt(i);

				if (child is DisplayObjectContainer)
				{
					setTouchState(child as DisplayObjectContainer, enable);
				}
				else
				{
					child.touchable = enable;
				}
			}
		}

		private function onClick(event : TouchEvent) : void
		{
			if (_clickHandler == null)
				return;

			var touch : Touch = event.getTouch(this);

			if (touch == null)
				return;

			if (click_target && touch.target != click_target)
				return;

			if (touch.phase == TouchPhase.BEGAN && !_isDown)
			{
				_isDown = true;
				return;
			}

			if (touch.phase == TouchPhase.MOVED && _isDown)
			{
				var buttonRect : Rectangle = getBounds(stage);

				if (touch.globalX < buttonRect.x - MAX_DRAG_DIST || touch.globalY < buttonRect.y - MAX_DRAG_DIST || touch.globalX > buttonRect.x + buttonRect.width + MAX_DRAG_DIST || touch.globalY > buttonRect.y + buttonRect.height + MAX_DRAG_DIST)
				{
					_isDown = false;
				}
				return;
			}

			if (touch.phase == TouchPhase.ENDED && _isDown)
			{
				_isDown = false;
				_clickHandler.dispatch(this);
			}
		}

	}
}
