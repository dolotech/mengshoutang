package game.view.activity.data
{
	import com.mvc.core.Facade;
	import com.mvc.interfaces.INotification;
	import com.mvc.interfaces.IObserver;
	
	import flash.utils.getQualifiedClassName;

	public class ActivityFirstPayData implements IObserver
	{
		public function ActivityFirstPayData()
		{
			initObserver();
		}
		
		/**
		 * 
		 * @return 
		 */
		public function getName():String
		{
			return (getQualifiedClassName(this));
		}
		
		/**
		 * 
		 */
		public function removeObserver():void
		{
			var vector:Vector.<String>=listNotificationName();
			var len:int=vector.length;
			for (var i:int=0; i < len; i++)
			{
				var name:String=vector[i];
				Facade.removeObserver(name, this);
			}
		}
		
		/**
		 * 
		 */
		protected function initObserver():void
		{
			var vector:Vector.<String>=listNotificationName();
			var len:int=vector.length;
			for (var i:int=0; i < len; i++)
			{
				var name:String=vector[i];
				Facade.addObserver(name, this);
			}
		}
		
		/**
		 * 
		 * @param _arg1
		 */
		public function handleNotification(_arg1:INotification):void
		{
			
		}
		
		/**
		 * 
		 * @return 
		 */
		public function listNotificationName():Vector.<String>
		{
			return new Vector.<String>();
		}

		
	}
}