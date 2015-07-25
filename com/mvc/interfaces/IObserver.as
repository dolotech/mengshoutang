package  com.mvc.interfaces {

    public interface IObserver {

        function removeObserver():void;
        function handleNotification(_arg1:INotification):void;
		function listNotificationName():Vector.<String>;
    }
}
