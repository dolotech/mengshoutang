package game.managers
{
	import com.mvc.core.Facade;
	import com.mvc.interfaces.INotification;
	import com.mvc.interfaces.IObserver;
	
	import game.common.JTLogger;
	/**
	 * 数据管理器基类
	 * @author CabbageWrom
	 * 
	 */	
	public class JTDataInfoManager implements IObserver
	{
		public var downProcotols:Vector.<String> = null;
		public function JTDataInfoManager()
		{
			downProcotols = new Vector.<String>();
			listNotificationName();
			initObserver();
		}
		
		public function clears():void
		{
			
		}
		
		public function reset():void
		{
			
		}
		
		public function conver():void
		{
			
		}
		
		public function clone():Vector.<*>
		{
			return null;
		}
		
		public function copy():Vector.<*>
		{
			return null;
		}
		
		protected function initObserver() : void
		{
			var l:int = downProcotols.length;
			var i:int = 0;
			for (i = 0; i < l; i++)
			{
				Facade.addObserver(downProcotols[i], this);
			}
		}
		
		public function destory():void
		{
			removeObserver();
		}
		
		/**
		 *
		 * @return
		 */
		public function listNotificationName():Vector.<String>
		{
			return downProcotols;
		}
		
		public function pushProcotol(procotol:int):void
		{
			if (!procotol)
			{
				JTLogger.error("[JTDataInfoManager.pushProcotol]  This Procotol For Zero!");
			}
			var downProcotol:String = procotol.toString(); 
			if (this.downProcotols.indexOf(downProcotol) != -1)
			{
				JTLogger.error("[JTDataInfoManager.pushProcotol] The DownProcotols Has this Procotol:" + procotol);
			}
			else
			{
				this.downProcotols.push(procotol);
			}
		}
		
		/**
		 *
		 * @param _arg1
		 */
		public function handleNotification(gameData:INotification) : void
		{
			
		}
		
		/**
		 *
		 */
		public function removeObserver() : void
		{
			var len:int = downProcotols.length;
			var i:int = 0;
			for (i = 0; i < len; i++)
			{
				Facade.removeObserver(downProcotols.shift(), this);
			}
		}
		
	}
}