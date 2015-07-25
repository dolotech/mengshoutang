package game.view.loginReward.Dla
{
	import com.components.RollTips;
	import com.dialog.DialogMgr;
	import com.langue.Langue;
	import com.mvc.interfaces.INotification;
	import com.view.base.event.EventType;

	import feathers.controls.Scroller;
	import feathers.data.ListCollection;
	import feathers.layout.TiledColumnsLayout;
	import feathers.layout.TiledRowsLayout;

	import game.common.JTGlobalDef;
	import game.data.Goods;
	import game.data.HeroData;
	import game.data.IconData;
	import game.data.RoleShow;
	import game.data.SignData;
	import game.dialog.ShowLoader;
	import game.manager.GameMgr;
	import game.managers.JTFunctionManager;
	import game.net.GameSocket;
	import game.net.data.IData;
	import game.net.data.c.CGet_sign;
	import game.net.data.c.CSign;
	import game.net.data.s.SGet_sign;
	import game.net.data.s.SSign;
	import game.net.data.vo.SignState;
	import game.view.comm.GetGoodsAwardEffectDia;
	import game.view.loginReward.render.PlayersAwardList;
	import game.view.new2Guide.NewGuide2Manager;
	import game.view.viewBase.LoginRewardDlgBase;

	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;

	/**
	 * 新的7天登录奖励
	 * @author lfr
	 * 2014 07 10
	 */
	public class LoginRewardDlg extends LoginRewardDlgBase
	{
		private var _curButton:Button=null;
		private var _curSignType:int=0; //签到的类型 1 2
		private var RECEIVED:int=2; //已领取
		private var CAN_RECEIVE:int=1; //可领取
		private var Not_AVAILABLE:int=0; //未签到
		private var _selectedDay:int; //选中的登录天数
		private var _receiveStatusList:Vector.<int>=new Vector.<int>;
		private var _signPrograssStatusList:Vector.<int>=new Vector.<int>;
		private var dataVector:Vector.<IconData>=null;

		public function LoginRewardDlg()
		{
			enableTween=false;
			isVisible=true;
			initText();
			initReceiveButtonEvent();
			_closeButton=closes;
		}

		override public function close():void
		{
			JTFunctionManager.executeFunction(JTGlobalDef.PLAY_CITY_ANIMATABLE);
			super.close();
		}

		override protected function init():void
		{
			clickBackroundClose();
			const listLayout:TiledRowsLayout=new TiledRowsLayout();
			listLayout.gap=115;
			listLayout.paddingTop=15;
			listLayout.paddingLeft=15;
			listLayout.useSquareTiles=false;
			listLayout.useVirtualLayout=true;
			listLayout.horizontalAlign=TiledRowsLayout.HORIZONTAL_ALIGN_LEFT;
			listLayout.verticalAlign=TiledRowsLayout.TILE_VERTICAL_ALIGN_TOP;
			listLayout.paging=TiledColumnsLayout.PAGING_HORIZONTAL; //自动排列			
			list_award.horizontalScrollPolicy=Scroller.SCROLL_POLICY_ON; //横向滚动 
			list_award.verticalScrollPolicy=Scroller.SCROLL_POLICY_OFF; //禁止垂直滚动
			list_award.layout=listLayout;
			list_award.itemRendererFactory=itemRendererFactory;
			function itemRendererFactory():PlayersAwardList
			{
				const renderer:PlayersAwardList=new PlayersAwardList();
				return renderer;
			}
		}


		private function initText():void
		{
			text_currDay.text=Langue.getLangue("signRewardTips1Txt");
			Day.text=Langue.getLangue("laveDay");
			TextField(btn_day1.getChildByName("text_Day")).text=Langue.getLangue("signRewardDayText1");
			TextField(btn_day2.getChildByName("text_Day")).text=Langue.getLangue("signRewardDayText2");
			TextField(btn_day3.getChildByName("text_Day")).text=Langue.getLangue("signRewardDayText3");
			TextField(btn_day4.getChildByName("text_Day")).text=Langue.getLangue("signRewardDayText4");
			TextField(btn_day5.getChildByName("text_Day")).text=Langue.getLangue("signRewardDayText5");
			TextField(btn_day6.getChildByName("text_Day")).text=Langue.getLangue("signRewardDayText6");
			TextField(btn_day7.getChildByName("text_Day")).text=Langue.getLangue("signRewardDayText7");

			_receiveStatusList[0]=Not_AVAILABLE;
			_receiveStatusList[1]=Not_AVAILABLE;
			_receiveStatusList[2]=Not_AVAILABLE;
			_receiveStatusList[3]=Not_AVAILABLE;
			_receiveStatusList[4]=Not_AVAILABLE;
			_receiveStatusList[5]=Not_AVAILABLE;
			_receiveStatusList[6]=Not_AVAILABLE;

			_signPrograssStatusList[0]=Not_AVAILABLE;
			_signPrograssStatusList[1]=Not_AVAILABLE;
			_signPrograssStatusList[2]=Not_AVAILABLE;
			_signPrograssStatusList[3]=Not_AVAILABLE;
			_signPrograssStatusList[4]=Not_AVAILABLE;
			_signPrograssStatusList[5]=Not_AVAILABLE;
			_signPrograssStatusList[6]=Not_AVAILABLE;
		}

		override public function open(container:DisplayObjectContainer, parameter:Object=null, okFun:Function=null, cancelFun:Function=null):void
		{

			super.open(container, parameter, okFun, cancelFun);
			setToCenter();
			JTFunctionManager.executeFunction(JTGlobalDef.STOP_CITY_ANIMATABLE);

			if (parameter is SSign)
			{
				updateUserData(parameter as SSign);
				return;
			}
			var cmd:CSign=new CSign();
			GameSocket.instance.sendData(cmd);
			ShowLoader.add();

		}

		override public function listNotificationName():Vector.<String>
		{
			var vect:Vector.<String>=new Vector.<String>;
			vect.push(SSign.CMD, SGet_sign.CMD);
			return vect;
		}

		override public function handleNotification(_arg1:INotification):void
		{
			if (_arg1.getName() == String(SSign.CMD))
			{
				var ssign:SSign=_arg1 as SSign;
				updateUserData(ssign);
			}
			else if (_arg1.getName() == String(SGet_sign.CMD))
			{
				var sget_sign:SGet_sign=_arg1 as SGet_sign;
				updateReceive(sget_sign);
			}
			ShowLoader.remove();
		}

		private function updateUserData(info:SSign):void
		{
			_curSignType=info.type;
			updateDaysInfo(info.days1, info.days2, info.days);
			(this["btn_day" + info.days1] as Button).dispatchEvent(new Event(Event.TRIGGERED));
		}

		private function updateDaysInfo(days1:int, days2:int, days:Vector.<IData>):void
		{
			text_currDayNum.text=days1 + ""; //当前登录天数
			var i:int;

			for (i=0; i < days1 - 1; i++)
			{
				_signPrograssStatusList[i]=RECEIVED;
			}
			_signPrograssStatusList[days1 - 1]=CAN_RECEIVE;

			for (i=days1; i < 7; i++)
			{
				_signPrograssStatusList[i]=Not_AVAILABLE;
			}

			var daysLen:int=days.length;
			for (i=0; i < daysLen; i++)
			{
				var state:int;
				if ((days[i] as SignState))
				{
					state=(days[i] as SignState).state;
				}
				_receiveStatusList[i]=state;
			}
			updateReceiveStatus();
		}

		private function updateReceive(info:SGet_sign):void
		{
			if (0 == info.code) //成功
			{
				_receiveStatusList[_selectedDay - 1]=RECEIVED;
				GameMgr.instance.sign_reward=info.state;
				updateReceiveStatus();
//				RollTips.add(Langue.getLangue("signRewardSucceed")); //领取成功提示
				var effectData:Object={vector: dataVector, effectPoint: null, effectName: "effect_036", effectSound: "baoxiangkaiqihuode", effectFrame: 299};
				DialogMgr.instance.open(GetGoodsAwardEffectDia, effectData, null, null, "translucence", 0x000000, 1);
				NewGuide2Manager.sendNextSeverStep();
			}
			else if (1 == info.code)
			{
				RollTips.add(Langue.getLangue("signRewardReceived")); //已经领取
			}
			else if (2 == info.code)
			{
				RollTips.add(Langue.getLangue("NO_Registration")); //没有签到
			}
			else if (3 == info.code)
			{ //背包满
				_receiveStatusList[_selectedDay - 1]=RECEIVED;
				GameMgr.instance.sign_reward=0;
				updateReceiveStatus();
				RollTips.add(Langue.getLangue("packFulls")); // 背包已满,物品已发邮件
			}
			else
			{
				RollTips.add(Langue.getLangue("codeError") + info.code); //领取奖励程序错误
			}
			this.dispatch(EventType.UPDATE_SIGN);
		}

		//更新奖励状态
		private function updateReceiveStatus():void
		{
			var status:int=0;
			for (var i:int=1; i <= 7; i++)
			{
				var openBoxImage:Image=this["btn_day" + i].getChildByName("openBox") as Image; //开的箱子
				var closeBoxImage:Image=this["btn_day" + i].getChildByName("closeBox") as Image; // closeBox 关闭的箱子
				var closeBox1Image:Image=this["btn_day" + i].getChildByName("closeBox1") as Image; // closeBox 灰色关闭的箱子
				var stopReceiveImage:Image=this["btn_day" + i].getChildByName("stopReceive") as Image; // stopReceive 已领取
				var CanReceiveImage:Image=this["btn_day" + i].getChildByName("CanReceive") as Image; // CanReceive 可领取
				var LockImage:Image=this["btn_day" + i].getChildByName("Lock") as Image; //  Lock 锁 
				status=_receiveStatusList[i - 1];
				if (status == RECEIVED) //已领取
				{
					openBoxImage.visible=true;
					closeBoxImage.visible=false;
					closeBox1Image.visible=false;
					stopReceiveImage.visible=true;
					CanReceiveImage.visible=false;
					LockImage.visible=false;
				}
				else if (status == CAN_RECEIVE) //可领取
				{
					openBoxImage.visible=false;
					closeBoxImage.visible=true;
					closeBox1Image.visible=false;
					stopReceiveImage.visible=false;
					CanReceiveImage.visible=true;
					LockImage.visible=false;
				}
				else if (status == Not_AVAILABLE) //不可用
				{
					openBoxImage.visible=false;
					closeBoxImage.visible=false;
					closeBox1Image.visible=true;
					stopReceiveImage.visible=false;
					CanReceiveImage.visible=false;
					LockImage.visible=true;
				}
			}
		}

		// 初始化注册七天登录奖励按钮事件
		private function initReceiveButtonEvent():void
		{
			for (var i:int=1; i <= 7; i++)
			{
				var button:Button=this["btn_day" + i] as Button;
				button.downState=null;
				button.name=String(i - 1);
				button.addEventListener(Event.TRIGGERED, onDayButtonClick);
			}
		}

		private function onDayButtonClick(e:Event=null):void
		{
			var bool:Boolean=true;
			var _scaleXY:Number=0.1;
			var _X:int=8;
			var _Y:int=16;
			if (_curButton != null)
			{
				_curButton.scaleX-=_scaleXY;
				_curButton.scaleY-=_scaleXY;
				_curButton.x+=_X;
				_curButton.y+=_Y;
			}
			else
			{
				bool=false;
			}
			_curButton=e.currentTarget as Button;
			_curButton.scaleX+=_scaleXY;
			_curButton.scaleY+=_scaleXY;
			_curButton.x-=_X;
			_curButton.y-=_Y;
			_curButton.parent.setChildIndex(_curButton, _curButton.parent.numChildren - 1);

			var selectedIndex:int=int(_curButton.name);
			var status:int=_receiveStatusList[selectedIndex];
			if (bool)
			{
				if (status == RECEIVED)
				{
					RollTips.add(Langue.getLangue("signRewardReceived")); //已领取提示
				}
				else if (status == CAN_RECEIVE)
				{
					_selectedDay=selectedIndex + 1;
					receiveRewards(_selectedDay);
				}
				else if (status == Not_AVAILABLE)
				{
					RollTips.add(Langue.getLangue("signRewardNotAvailable")); // 你还不满足条件提示
				}
			}
			getSignDataList(selectedIndex);
		}

		// 点击选中的奖励天数物品列表
		private function getSignDataList(_currClickDay:int):void
		{
			var currClickDay:int=_currClickDay + 1;
			var arrSignData:Vector.<*>=SignData.hash.values();
			var len:int=arrSignData.length;
			for (var i:int=0; i < len; i++)
			{
				var tmpSignData:SignData=arrSignData[i] as SignData;
				if (tmpSignData.type == _curSignType && tmpSignData.id == currClickDay)
				{
					list_award.dataProvider=new ListCollection(getDataList(tmpSignData));
					break;
				}
			}
		}

		/**获取数据集*/
		private function getDataList(data:SignData):Vector.<IconData>
		{
			dataVector=new Vector.<IconData>;
			var i:int=0;
			var itemData:Goods=null;
			var items:Array=null;
			var itemExp:RegExp=/\d+/gs;
			var goodsExp:RegExp=/\{[\d,\,]*\}/gs;
			var iconData:IconData=null;

			if (data.coin > 0)
			{ //奖励金币
				iconData=new IconData();
				iconData.QualityTrue="ui_gongyong_90wupingkuang0";
				iconData.IconTrue="ui_tubiao_jinbi_da";
				iconData.HeroSignTrue="";
				iconData.Num="x " + data.coin;
				iconData.ButtonModel=true;
				iconData.IconType=0;
				iconData.IconId=1;
				iconData.Name=Langue.getLangue("buyMoney"); //"金币"
				dataVector.push(iconData);
			}

			if (data.diamond > 0)
			{ //奖励钻石
				iconData=new IconData();
				iconData.QualityTrue="ui_gongyong_90wupingkuang0";
				iconData.IconTrue="ui_tubiao_zuanshi_da";
				iconData.HeroSignTrue="";
				iconData.Num="x " + data.diamond;
				iconData.ButtonModel=true;
				iconData.IconType=0;
				iconData.IconId=2;
				iconData.Name=Langue.getLangue("buyDiamond"); //"钻石";
				dataVector.push(iconData);
			}

			var heros:Array=data.hero.match(goodsExp); //奖励英雄
			var heroLen:int=heros.length;
			for (i=0; i < heroLen; i++)
			{
				items=heros[i].match(itemExp);
				iconData=new IconData();
				iconData.QualityTrue="ui_gongyong_90wupingkuang" + (uint(items[1]) - 1 > 0 ? uint(items[1]) - 1 : 0);
				iconData.IconTrue=RoleShow.hash.getValue(HeroData.hero.getValue(items[0]).show).photo;
				iconData.HeroSignTrue="ui_hero_yingxiongpinzhi_0" + (7 + 1 - (uint(items[1])));
				iconData.Num="x " + 1;
				iconData.ButtonModel=true;
				iconData.IconType=1;
				iconData.IconId=HeroData.hero.getValue(items[0]).type;
				iconData.Name=String(HeroData.hero.getValue(items[0]).name);
				dataVector.push(iconData);
			}

			var goods:Array=data.tid_num.match(goodsExp); //奖励物品
			var goodsLen:int=goods.length;
			for (i=0; i < goodsLen; i++)
			{
				items=goods[i].match(itemExp);
				itemData=Goods.goods.getValue(items[0]);
				iconData=new IconData();
				iconData.IconId=itemData.type;
				iconData.QualityTrue="ui_gongyong_90wupingkuang" + (itemData.quality - 1);
				iconData.IconTrue=itemData.picture;
				iconData.HeroSignTrue="";
				iconData.Num="x " + items[1];
				iconData.ButtonModel=true;
				iconData.IconType=0;
				iconData.Name=String(itemData.name);
				dataVector.push(iconData);
			}
			return dataVector;
		}


		/**移除图标*/
		private function removeIcons():void
		{
			while (list_award.numChildren > 0)
			{
				list_award.getChildAt(0).removeFromParent(true);
			}
		}

		//请求领取登录奖励
		private function receiveRewards(value:int):void
		{
			var cmd:CGet_sign=new CGet_sign();
			cmd.day=value;
			GameSocket.instance.sendData(cmd);
			ShowLoader.add();
		}

		/**
		 * 新手引导
		 * @param name
		 * @return
		 *
		 */
		override public function getGuideDisplay(name:String):*
		{
			if (name == "领取按钮")
			{

				return btn_day1;

			}
			else if (name == "退出按钮")
			{
				return _closeButton;
			}
			else
			{
				return null;
			}
		}

		/**
		 * 新手引导专用函数
		 * @param id
		 * 领取奖励
		 */
		override public function executeGuideFun(name:String):void
		{
			if (name == "领取")
			{
				_receiveStatusList[0]=CAN_RECEIVE;
				onDayButtonClick();
			}
			else if (name == "退出")
				oncancelBtn();
		}

		override public function dispose():void
		{
			_curButton=null;
			_curSignType=0;
			RECEIVED=0;
			CAN_RECEIVE=0;
			Not_AVAILABLE=0;
			_selectedDay=0;
			_receiveStatusList=null;
			_signPrograssStatusList=null;
			dataVector=null;
			super.dispose();
		}
	}
}
