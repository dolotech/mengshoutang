package com.utils
{
	import starling.animation.*;
	import starling.core.*;
	
	public class TweenQueue
	{
		
		private var _tweenList:Array = null;
		private var _index:int = 0;
		public var repeatCount:int = 1;
		private var _curr_tween:Tween = null;
		private var _autoDispose:Boolean = false;
		public var onComplete:Function = null;
		public var insertFun:InsertFunc = null;
		
		public function TweenQueue()
		{
			super();
			this._tweenList = new Array();
		}
		
		private function creatTween(arr:Array):Tween
		{
			var property:String;
			var value:Object;
			var tween:Tween = new Tween(arr[0], arr[1], arr[3]);
			tween.onComplete = this.tweenOnComplete;
			var properties:Object = arr[2];
			for (property in properties)
			{
				value = properties[property];
				if (tween.hasOwnProperty(property))
				{
					tween[property] = value;
				}
				else
				{
					if (arr[0].hasOwnProperty(property))
					{
						tween.animate(property, (value as Number));
					}
					else
					{
						throw(new ArgumentError(("Invalid property: " + property)));
					}
				}
			}
			return (tween);
		}
		
		public function add(target:Object, time:Number, properties:Object, transition:Object = "linear"):void
		{
			this._tweenList.push([target, time, properties, transition]);
		}
		
		private function tweenOnComplete():void
		{
			this._index++;
			if (this._index >= this._tweenList.length)
			{
				if (this.repeatCount == 0)
				{
					this._index = 0;
				}
				else
				{
					if (this.repeatCount == 1)
					{
						this.stop();
						return;
					}
					this.repeatCount--;
					this._index = 0;
				}
			}
			this._curr_tween = this.creatTween(this._tweenList[this._index]);
			if (((!((this.insertFun == null))) && ((this._index == this.insertFun.index))))
			{
				this.insertFun.func();
			}
			Starling.juggler.add(this._curr_tween);
		}
		
		public function start(autoDispose:Boolean = true):void
		{
			this._autoDispose = autoDispose;
			this._index = 0;
			this._curr_tween = this.creatTween(this._tweenList[this._index]);
			Starling.juggler.add(this._curr_tween);
		}
		
		public function stop():void
		{
			if (this._curr_tween)
			{
				Starling.juggler.remove(this._curr_tween);
			}
			if (this.onComplete != null)
			{
				this.onComplete();
			}
			if (this._autoDispose)
			{
				this._tweenList = [];
			}
			this._curr_tween = null;
		}
		
		public function dispose():void
		{
			this.stop();
			this._tweenList = [];
		}
	
	}
} //package com.utils 