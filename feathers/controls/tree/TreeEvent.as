package feathers.controls.tree
{
	import starling.events.Event;

	/**
	 * Tree的事件类
	 * 目前只有一个事件，就是点击某一个分支所派发的CLICK_NODE事件
	 *
	 * @author yanghongbin
	 * e-mail:assinyang@163.com
	 */
	public class TreeEvent extends Event
	{
		/**
		 * 点击某一个节点的事件名
		 */
		public static const CLICK_NODE:String="clickNode";
		//事件源
		public var item:TreeCellRenderer;

		public function TreeEvent(type:String, _item:TreeCellRenderer, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.item=_item;
			super(type, bubbles, cancelable);

		}
	}
}
