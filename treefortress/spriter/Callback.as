package treefortress.spriter
{
	public class Callback
	{
		
		/**
		 *
		 * @default
		 */
		public var call:Function;
		/**
		 *
		 * @default
		 */
		public var time:int;
		/**
		 *
		 * @default
		 */
		public var addOnce:Boolean;
		/**
		 *
		 * @default
		 */
		public var called:Boolean;
		
		/**
		 *
		 * @param call
		 * @param time
		 * @param addOnce
		 */
		public function Callback(call:Function, time:int, addOnce:Boolean=false):void
		{
			this.call=call;
			this.time=time;
			this.addOnce=addOnce;
		}
		
	}
}