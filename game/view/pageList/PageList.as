package game.view.pageList
{
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;

	/**
	 * 滑动
	 * @author litao
	 * 
	 */	
	public class PageList extends Sprite
	{
		private var _clss:Class;
		public var _select:ChainData;
		public var gesture:Gesture =  new Gesture(this as DisplayObject);
		public var  Prev:ISignal;
		public var  Next:ISignal;
		public var currentNext:ISignal;
		public var currentPrev:ISignal;
		public var  onInit:ISignal  =  new Signal();
		
		public function PageList(childClass:Class)
		{
			
			Prev = new Signal;
			Next = new Signal;
			currentNext = new Signal();
			currentPrev = new Signal();
			_clss = childClass;
			_select = new ChainData();
			var heroSelect:ChainData = new ChainData;

			_select.next = heroSelect;
			_select.prev = heroSelect;
		
			heroSelect.next = _select;
			heroSelect.prev = _select;

			
			_select.data = new _clss;
			heroSelect.data = new _clss;
			
			
			if(!stage)
				this.addEventListener(Event.ADDED_TO_STAGE,toStage);
			else toStage(null);
		}
		private function toStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,toStage);
			var q:Quad = new Quad(stage.stageWidth,stage.stageHeight);
			q.alpha = 0.01;
			addChildAt(q,0);
			
			add(_select.data as DisplayObject);
			gesture.onGesture.add(onGesture);
			onInit.dispatch(_select.data);
			
		}
		
		private function onGesture(path:String):void
		{
			if(path == "left")
			{
				onPrev(null);
			}
			else if(path == "right")
			{
				onNext(null);
			}
			else if(path == "back")
			{
				if(_select.prev.data.parent != null)
					_select.prev.data.	removeFromParent();
				else if(_select.next.data.parent != null)
					_select.next.data.removeFromParent();
					
			}
			else 
			{
				move(path);
			}
		}
		
		private function move(path:String):void
		{
			if(path == "LeftMove")
			{
				if(_select.next.data.parent == null )
				{
					_select.next.data.x = 1000;
					addChild(_select.next.data as DisplayObject);
					currentNext.dispatch(_select.next.data);
				}
			
				_select.next.data.x = 1000 +  _select.data.x;
			}
			else 
			{
				
				if(_select.prev.data.parent == null )
				{
					_select.prev.data.x = -1000;
					addChild(_select.prev.data as DisplayObject);
					currentPrev.dispatch(_select.prev.data);
				}
			
				_select.prev.data.x = -1000 +  _select.data.x;
			}
		}
		
		
		public function onPrev(e:Event = null):void
		{
			if(!isMove)return;
			isMove = false;
			gesture.isMove = false;
			var child:DisplayObject = _select.data as DisplayObject;
			Starling.juggler.tween(child,0.5,{x:-1000,onComplete:onComplete});
		
			function onComplete():void
			{
				child.removeFromParent();
			}
//			_select.prev.data.x = 1000;
			
			add(_select.prev.data);
			Starling.juggler.tween(_select.prev.data,0.5,{x:_select.prev.data.pivotX,onComplete:onShow});
			Prev.dispatch(_select.prev.data);
			
			function onShow():void
			{
				isMove = true;
				gesture.isMove = true;
				_select = _select.prev;
				gesture.target =_select.data as DisplayObject;
			}
		}
		
		private var isMove:Boolean = true;
		public function onNext(e:Event = null):void
		{
			if(!isMove)return;
			isMove = false;
			gesture.isMove = false;
			var child:DisplayObject = _select.data as DisplayObject;
			Starling.juggler.tween(child,0.5,{x:1000,onComplete:onComplete});
			function onComplete():void
			{
				child.removeFromParent();
			}

//			_select.next.data.x = -1000;
			add(_select.next.data);
			
			
			Starling.juggler.tween(_select.next.data,0.5,{x:_select.next.data.pivotX,onComplete:onShow});
			Next.dispatch(_select.next.data);
			function onShow():void
			{
				isMove = true;
				gesture.isMove = true;
				_select = _select.next;
				gesture.target = _select.data as DisplayObject;
			}
		}
		
		public function get isTriggered():Boolean
		{
			return gesture.currentMove;
		}
		
		
		private var first:Boolean = true;
		private function add(child:Object):void
		{
			if((child as DisplayObject).parent == null)
				this.addChild(child as DisplayObject);
			var i:int  = 0 , length:int = child.numChildren - 1;
			for (i ; i < length ; i ++)
			{
				child.getChildAt(i).touchable = true;
				if(child.getChildAt(i) is Button)
					(child.getChildAt(i) as Button).downState = null;
			}
		
			gesture.target = _select.data as DisplayObject;
			
			
			if(child.pivotX >=  child.width/2)
			{
				child.pivotX = child.width/2 + 3;
				child.pivotY = child.height/2 + 3;
				child.x  += child.width/2;
				child.y  +=  child.height/2 ;
			}
		}
		override public function dispose():void
		{
			Prev.removeAll();
			if(stage)
				stage.removeEventListeners(TouchEvent.TOUCH);
			Next.removeAll();
			currentNext.removeAll();
			currentPrev.removeAll();
			onInit.removeAll();
			_select.data.dispose();
			_select.next.data.dispose();
			_select.prev.data.dispose();
			gesture.dispose();
			super.dispose();
		}
	}
}