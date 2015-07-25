package com.mvc.core {
    import com.mvc.interfaces.INotification;
    import com.mvc.interfaces.IObserver;
    
    import flash.utils.getQualifiedClassName;
    
    public class Observer/* extends Sprite */implements IObserver {

        protected var _observerName:String = "";

        public function Observer(){
            this._observerName = getQualifiedClassName(this);
            this.initObserver();
        }
        public function removeObserver():void{
			var vector:Vector.<String> = listNotificationName();
			var len:int = vector.length;
			for(var i:int = 0;i<len;i++)
			{
				var name:String = vector[i];
				Facade.removeObserver(name, this);
			}
        }
		
		public function listNotificationName():Vector.<String>
		{
			return new Vector.<String>();
		}
		
		protected function initObserver():void
		{
			var vector:Vector.<String> = listNotificationName();
			var len:int = vector.length;
			for(var i:int = 0;i<len;i++)
			{
				var name:String = vector[i];
				Facade.addObserver(name, this);
			}
        }
        public function handleNotification(arg1:INotification):void
		{
			
        }
        public function getName():String{
            if (this._observerName == null){
                throw (new Error("observer名称不可是空"));
            }
            return (this._observerName);
        }
		
    }
}
