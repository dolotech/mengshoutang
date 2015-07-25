package game.view.pageList
{
	/**
	 * Chain 链表数据,双向链表
	 * @author litao
	 * 
	 */	
	public class ChainData
	{
		
		private var _next:ChainData;
		private var _prev:ChainData;
		private var _data:Object;
		
		public function set data(data:Object):void
		{
			_data = data;
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		public function set next(next:ChainData):void
		{
			_next = next;	
		}
		public function get next():ChainData
		{
			return _next;
		}
		public function set prev(prve:ChainData):void
		{
			_prev = prve;
		}
		public function get prev():ChainData
		{
			return _prev;
		}
		
		public static function createChain(list:Array):ChainData
		{
			var data:ChainData;
			for (var j :int = 0 ;j < list.length ; j++)
			{
				data = list[j];
				if(j == 0 )data.prev = list[list.length - 1];
				else data.prev = list[j - 1];
				if(j == list.length - 1)data.next = list[0];
				else data.next = list[j + 1];
				
			}
			return list[0];
		}
	}
}