package  com.mvc.interfaces {
    

    public interface IFacade {

//        function addObserver(_arg1:String, _arg2:IObserver):void;
//        function removeObserver(_arg1:String, _arg2:IObserver):void;
        function notifyObserver(_arg1:INotification):Boolean;

    }
}
