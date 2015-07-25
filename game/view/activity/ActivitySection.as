package game.view.activity
{
	import com.data.HashMap;
	
	import flash.utils.getDefinitionByName;
	
	import avmplus.getQualifiedClassName;
	
	import game.data.ActivityListData;
	import game.view.activity.activity.ActivityCodeView;
	import game.view.activity.activity.ActivityFirstPay;
	import game.view.activity.activity.ActivityGifts;
	import game.view.activity.activity.AllGifts.BindingGoodFriend;
	import game.view.activity.activity.AllGifts.FriendCode;
	import game.view.activity.activity.AllGifts.FriendLogin;
	import game.view.activity.activity.AllGifts.MicroChannel;
	import game.view.activity.activity.AllGifts.Rating;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	
	public class ActivitySection extends Sprite
	{
		
		private var disposeList:Vector.<String> = new Vector.<String>;
		public function ActivitySection()
		{
			super();
			classes(
				ActivityFirstPay,
				ActivityGifts,
				BindingGoodFriend,
				FriendCode,
				FriendLogin,
				MicroChannel,
				Rating,
				ActivityCodeView
			);
		}
		
		public function  section (id:int,index:int=-1):void
		{
			var activityList:ActivityListData = ActivityListData.hash.getValue(id);
			var datas:HashMap = activityList.getValues();
			var cls:Class = getDefinitionByName("game.view.activity.activity."+activityList.showClass) as Class;
			
			var child:DisplayObject = numChildren > 0 ? getChildAt(0):null;
		
			child && child.removeFromParent(true);
			
			var key:String = getQualifiedClassName(cls);
			var activity:IActivity = new cls;
			activity.data = datas;
			if(index>0)
				activity.scrollToPageIndex=index;
			addChild(activity as DisplayObject);
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
		
		private function classes(...args):void{}
	}
}