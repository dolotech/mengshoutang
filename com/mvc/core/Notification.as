package com.mvc.core {
    import com.mvc.interfaces.INotification;

    public class Notification implements INotification {

        private var name:String = "";
        private var type:String = "";
        private var body:Object = null;

		
        public function Notification(arg1:String = "", _arg2:Object=null, _arg3:String=null){
            this.name = arg1;
            this.body = _arg2;
            this.type = _arg3;
        }
        public function getName():String{
            return (this.name);
        }
        public function setBody(arg1:Object):void{
            this.body = arg1;
        }
        public function getBody():Object{
            return (this.body);
        }
        public function setType(arg1:String):void{
            this.type = arg1;
        }
        public function getType():String{
            return (this.type);
        }
        public function toString():String{
            var _local1:String = ("Notification Name: " + this.getName());
            _local1 = (_local1 + ("\nBody:" + ((this.body)==null) ? "null" : this.body.toString()));
            _local1 = (_local1 + ("\nType:" + ((this.type)==null) ? "null" : this.type));
            return (_local1);
        }
		
		public function setName(value:String):void{
			this.name = value;
		}

    }
}
