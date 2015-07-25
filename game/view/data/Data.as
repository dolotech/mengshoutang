package game.view.data
{
	import com.data.HashMap;
	import com.singleton.Singleton;
	
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import starling.animation.DelayedCall;
	import starling.core.Starling;
	import starling.text.TextField;

	public class Data
	{
		/**
		 *cd时间 
		 */		
		private var _time:int = 0;
		/**
		 *cd 最大时间 
		 */		
		public var maxTime:int = 0;
		/**
		 *是否请求过 
		 */		
		public var isSend:Boolean = false;
		
		public var onTimeEnd:ISignal = new Signal();
		
		private static var hash:HashMap  = new HashMap(); 
		
		
		public static function get instance():Data
		{
			return Singleton.getInstance(Data) as Data;
		}
		
		public  function  create(key:Object):void
		{
			var d:Data  = hash.getValue(key) ;
			if(d==null)
			{
			
				d = hash.put(key,clone());
			}
		}
		
		public function getData(key:Object):Data
		{
			return hash.getValue(key);
		}
		
		public function remove(key:Object):Data
		{
			return hash.remove(key);
		}
		
		public function clone():Data
		{
			var newObj:Data = new this["constructor"]();
			var ba:ByteArray = new ByteArray();
			ba.writeObject(this);
			ba.position = 0;
			var obj:Object = ba.readObject();
			
			for (var key:String in obj)
			{
				if((typeof obj[key]) != "object")
				{
					newObj[key] = obj[key];
				}
			}	
			lastTime = getTimer();
			isTime = true;
			newObj.update();
			return newObj;
		}
		
		private var _text:TextField;
		private var _consume:TextField;
		private var call:DelayedCall;
		public function cdTime(text:TextField,consume:TextField = null):void
		{
			this._text = text;
			_consume = consume;
			update();
		}
		
		private function update():void
		{
			var num:String;
			var num1:String;
			var t:int =  _time -  (getTimer() - lastTime )/1000 ;
			if(t > 0 )
			{
				num = t%60 >= 10  ?t%60+"":"0"+t%60;//秒
				num1 = (t / 60 >> 0)%60 + "";
				if(_text)
				_text.text = "" + (t / 60/60 >> 0)+ ":"+ num1 + ":" + num + "" ;
				
				
				if(_consume)
				{
					_consume.text = (Math.ceil((t / 60)/2)) +"";
				}
				call = 	Starling.juggler.delayCall(update,1);
			}
			else 
			{
				if(_text)_text.text = "";
				if(_consume) _consume.text = "";
				onTimeEnd.dispatch();
			}		
		}
		private var isTime:Boolean;
		public function startTime():void
		{
			if(!isTime)
			{
				update();
				lastTime  = getTimer();
			}

			isTime = true;
		}
		
		private  var lastTime:int;
		private var stop:int = 0;
		public function dispose():void
		{
			_text && _text.dispose();
			_consume && _consume.dispose();
			_text = null;
			_consume = null;
			stop = 1;
			Starling.juggler.remove(call);
		}
		
		public function set time(time:int):void
		{
			this._time = time == 0 ? 0:time;
			lastTime = getTimer();
			Starling.juggler.remove(call);
		}
		
		public function get time():int
		{
			return  _time -  (getTimer() - lastTime )/1000 ;
		}
	}
}