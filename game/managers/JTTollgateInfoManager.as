package game.managers
{
	import com.components.RollTips;
	import com.langue.Langue;
	import com.mvc.interfaces.INotification;

	import game.common.JTGlobalDef;
	import game.data.JTTollgateGIftData;
	import game.manager.GameMgr;
	import game.net.data.s.SGet_tollgatePrize;
	import game.net.data.s.STollgateNotice;

	/**
	 * 关卡礼包管理器
	 * @author CabbageWrom
	 *
	 */
	public class JTTollgateInfoManager extends JTDataInfoManager
	{
		public var isGetGift:Boolean=false;
		private var _current_TollgateID:int=1;

		public function JTTollgateInfoManager()
		{
			super();
			JTFunctionManager.registerFunction(JTGlobalDef.GIFT_TOLLGATE_NOTICE, onTollgateNoticeHanlder);
			JTFunctionManager.registerFunction(JTGlobalDef.UPDATE_TOLLGATE_NOTICE, onUpdateTollgateNoticeHanlder);
		}

		public function get current_TollgateID():int
		{
			return _current_TollgateID;
		}

		private function onUpdateTollgateNoticeHanlder():void
		{
			var currentTollageteData:JTTollgateGIftData=JTTollgateGIftData.getTollgateGift(_current_TollgateID);

			if (!currentTollageteData)
				this.isGetGift=false;
			else
				this.isGetGift=GameMgr.instance.tollgateID > currentTollageteData.id2;
		}

		public function set current_TollgateID(value:int):void
		{
			GameMgr.instance.tollgateprize=_current_TollgateID=value;
			var currentTollageteData:JTTollgateGIftData=JTTollgateGIftData.getTollgateGift(_current_TollgateID);

			if (!currentTollageteData)
				this.isGetGift=false;
			else
				this.isGetGift=GameMgr.instance.tollgateID > currentTollageteData.id2;
		}

		private function onTollgateNoticeHanlder(result:Object):void
		{
			current_TollgateID=(result as STollgateNotice).id;
		}

		override public function handleNotification(gameData:INotification):void
		{
			var downProtocol:String=gameData.getName();

			switch (downProtocol)
			{
				case STollgateNotice.CMD.toString():
				{
					JTFunctionManager.executeFunction(JTGlobalDef.GIFT_TOLLGATE_NOTICE, gameData);
					break;
				}
				case SGet_tollgatePrize.CMD.toString():
				{
					var getGift:SGet_tollgatePrize=gameData as SGet_tollgatePrize;
					var message:Array=Langue.getLans("tollgateGift");

					switch (getGift.code)
					{
						case 0:
						{
							this.current_TollgateID=getGift.id;
//                            RollTips.showTips("signRewardSucceed");
							break;
						}
						case 1:
						{
							RollTips.add(message[1]);
							break;
						}
						case 2:
						{
							RollTips.add(message[2]);
							break;
						}
						case 3:
						{
							RollTips.showTips("packFulls");
							break;
						}
						default:
						{
							RollTips.add(message[3]);
							break;
						}
					}
					JTFunctionManager.executeFunction(JTGlobalDef.GET_TOLLGATE_GIFT, gameData);
					break;

				}
				default:
					break;
			}
		}

		override public function listNotificationName():Vector.<String>
		{
			this.pushProcotol(STollgateNotice.CMD);
			this.pushProcotol(SGet_tollgatePrize.CMD);
			return super.downProcotols;
		}
	}
}
