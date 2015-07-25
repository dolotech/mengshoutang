package game.view.achievement.data
{
	import com.components.RollTips;
	import com.data.HashMap;
	import com.dialog.DialogMgr;
	import com.langue.Langue;
	import com.mvc.core.Facade;
	import com.mvc.interfaces.INotification;
	import com.mvc.interfaces.IObserver;
	import com.scene.SceneMgr;
	import com.singleton.Singleton;
	import com.view.base.event.EventType;
	import com.view.base.event.ViewDispatcher;

	import flash.utils.getQualifiedClassName;

	import game.common.JTLogger;
	import game.data.Attain;
	import game.data.Goods;
	import game.data.HeroData;
	import game.data.IconData;
	import game.dialog.ShowLoader;
	import game.net.data.IData;
	import game.net.data.c.CAttain_init;
	import game.net.data.s.SAttain_get;
	import game.net.data.s.SAttain_init;
	import game.net.data.s.SAttain_send;
	import game.net.data.s.SAttaintoday;
	import game.net.data.s.SAttaintoday_send;
	import game.net.data.vo.AttainInfo;
	import game.scene.BattleScene;
	import game.view.achievement.TipAchievement;
	import game.view.comm.GetGoodsAwardEffectDia;
	import game.view.gameover.WinView;
	import game.view.new2Guide.NewGuide2Manager;
	import game.view.pageList.ChainData;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import starling.core.Starling;

	public class AchievementData implements IObserver
	{
		public static var isFirstGuide:Boolean=false;
		public var isSend:Boolean=false;
		private var dataVector:Vector.<IconData>=null;
		public var attainInfo:Vector.<IData>;

		public function getAttainInfoById(id:int):AttainInfo
		{
			if (attainInfo == null)
				return null;
			var len:int=attainInfo.length;
			var info:AttainInfo;

			for (var i:int=0; i < len; i++)
			{
				info=attainInfo[i] as AttainInfo;

				if (info.id == id)
					return info;
			}
			return null;
		}
		/**
		 *领奖ID
		 */
		public var getId:int;
		/**
		 * 1=战斗,2=英雄,3=功能,4=竞技,5=日常，6=总览
		 */
		public var currentSection:int;
		/**
		 * 领取成功后，通知更新
		 */
		public var onUpate:ISignal=new Signal();

		public var isReceive:Boolean;

		public function AchievementData()
		{
			initObserver();
			init();
		}

		//清空数据
		public function clear():void
		{
			isSend=false;
			attainInfo=null;
			getId=0;
			currentSection=0;
		}

		public static function get instance():AchievementData
		{
			return Singleton.getInstance(AchievementData) as AchievementData;
		}

		private function init():void
		{
			var hash:HashMap=Attain.taskList;
			var chainList:HashMap=new HashMap;
			hash.eachValue(function(arr:Vector.<Attain>):void {
				for (var i:int=0; i < arr.length; i++) {
					var chainData:ChainData=new ChainData;
					chainData.data=arr[i];
					chainList.put(arr[i].id, chainData);
				}
				createChain(chainList);
				chainList=new HashMap;

			});
		}

		public var hash:HashMap=new HashMap;

		private function createChain(arr:HashMap):void
		{
			arr.eachValue(function(chainData:ChainData):void {
				if (chainData.data.next > 0) {
					chainData.next=arr.getValue(chainData.data.next);
					chainData.next.prev=chainData;
					hash.put(chainData.data.id, chainData);
				}
			});
		}

		//小组总数
		public function total(conditionType:int):int
		{
			return Attain.taskList.getValue(conditionType).length;
		}

		//小组当前任务的第几个
		public function currentIndex(id:int):int
		{
			var index:int=0;

			while ((hash.getValue(id) as ChainData) && (hash.getValue(id) as ChainData).prev != null)
			{
				index++;
				id=(hash.getValue(id) as ChainData).prev.data.id;
			}
			return index;
		}

		//日常剩余任务
		public function daily():int
		{
			var index:int=0;

			for (var i:int=0; i < attainInfo.length; i++)
			{
				var info:AttainInfo=attainInfo[i] as AttainInfo;

				if (info.id != 0)
					if (info.type == 6 || info.type == 7 || info.type == 8)
					{
						index++;
					}
			}
			return index;
		}

		//小组分类
		public function SectionList(section:int):Vector.<IData>
		{
			var vect:Vector.<IData>=new Vector.<IData>;

			for (var i:int=0; i < attainInfo.length; i++)
			{
				var info:AttainInfo=attainInfo[i] as AttainInfo;

				if (info.id != 0)
				{
					var attain:Attain=Attain.hash.getValue(info.id);

					if (attain && attain.type == section)
					{
						vect.push(info);
					}
				}
			}
			return vect;
		}

		//小节总数
		public function getSectionTotals(type:int):int
		{
			var index:int;
			Attain.hash.eachValue(function(value:Attain):void {
				if (value.type == type)
					index++;
			});
			return index;
		}

		//小节完成个数
		public function getSectionCompletes(vect:Vector.<IData>):int
		{
			var index:int;

			for (var i:int=0; i < vect.length; i++)
			{
				index+=remain((vect[i] as AttainInfo).id);
			}
			return index;
		}

		//小组完成数
		public function remain(id:int):int
		{
			var index:int=1;

			while ((hash.getValue(id) as ChainData) && (hash.getValue(id) as ChainData).next != null)
			{
				index++;
				id=(hash.getValue(id) as ChainData).next.data.id;
			}
			return index;
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
			var i:int=0;
			var index:int;
			//推送
			if (_arg1.getName() == String(CAttain_init.CMD))
			{
				ShowLoader.remove();
				attainInfo=SAttain_init(_arg1).ids;
				receive();
				ViewDispatcher.dispatch(EventType.UPDATE_ACHIEVEMENT, attainInfo);
			}
			else if (_arg1.getName() == String(SAttain_send.CMD))
			{
				var info:SAttain_send=_arg1 as SAttain_send;
				var tip:TipAchievement;

				if (attainInfo)
				{
					for (i=0; i < attainInfo.length; i++)
					{
						var info1:AttainInfo=attainInfo[i] as AttainInfo;

						if (info1.id == info.id && info1.type == 0)
						{
							info1.type=1;

							if (!(SceneMgr.instance.getCurScene() is BattleScene))
							{
								tip=new TipAchievement();
								tip.open(Starling.current.stage, info1);
							}
							else
							{
								WinView.achievementData=info1;
							}
							updateStatus(true);
							break;
						}
					}
				}
				else
				{
					var data:AttainInfo=new AttainInfo();
					data.id=info.id;

					if (!(SceneMgr.instance.getCurScene() is BattleScene))
					{
						tip=new TipAchievement();
						tip.open(Starling.current.stage, data);
					}
					else
					{
						WinView.achievementData=data;
					}
					updateStatus(true);
				}
			}
			//领取
			else if (_arg1.getName() == String(SAttain_get.CMD))
			{
				ShowLoader.remove();
				var getInfo:SAttain_get=_arg1 as SAttain_get;
				var isBreak:Boolean;
				var num:int=0;
				var iconData:IconData=null;
				dataVector=new Vector.<IconData>;
				switch (getInfo.code)
				{
					case 0:
						var tmp_data:AttainInfo=AchievementData.instance.getAttainInfoById(getId);
						var tmp_attainData:Attain=Attain.hash.getValue(getId);

						var hero:HeroData=null;
						var goods:Goods=null;
						if (tmp_data && tmp_attainData)
						{
							tmp_data.num=tmp_attainData.finish_num=-1;
							iconData=new IconData();
							if (tmp_attainData.goodsType == 5)
							{ //英雄
								hero=HeroData.hero.getValue(tmp_attainData.values);
								iconData.IconId=tmp_attainData.values;
								iconData.Num="x " + 1;
								goods=Goods.goods.getValue(tmp_attainData.values);
								iconData.QualityTrue="ui_gongyong_90wupingkuang" + hero.quality;
								iconData.Name=hero.name;
							}
							else
							{
								iconData.IconId=tmp_attainData.goodsType;
								iconData.Num="x " + tmp_attainData.values;
								goods=Goods.goods.getValue(tmp_attainData.goodsType);
								iconData.Name=goods.name;
							}
							if (tmp_attainData.goodsType == 1 || tmp_attainData.goodsType == 2 || tmp_attainData.goodsType == 3)
							{
								iconData.QualityTrue="ui_gongyong_90wupingkuang0";
							}
							else if (tmp_attainData.goodsType != 5)
							{
								iconData.QualityTrue="ui_gongyong_90wupingkuang" + (goods.quality - 1);
							}
							iconData.IconTrue=goods.picture;
							iconData.HeroSignTrue="";
							iconData.IconType=tmp_attainData.goodsType;
							dataVector.push(iconData);
							var effectData:Object={vector: dataVector, effectPoint: null, effectName: "effect_036", effectSound: "baoxiangkaiqihuode",
									effectFrame: 299};
							DialogMgr.instance.open(GetGoodsAwardEffectDia, effectData, null, null, "translucence", 0x000000,
								1);
						}
//						RollTips.add(Langue.getLangue("signRewardSucceed"));
						break;
					case 3:
						RollTips.add(Langue.getLangue("packFulls"));
						break;
					default:
						break;
				}

				var len:int=attainInfo.length;
				for (i=0; i < len; i++)
				{
					if ((attainInfo[i] as AttainInfo).id == getId)
					{
						(attainInfo[i] as AttainInfo).id=getInfo.id;
						(attainInfo[i] as AttainInfo).type=getInfo.type;
						(attainInfo[i] as AttainInfo).num=-1;
						onUpate.dispatch();
					}
					else
					{
						if ((attainInfo[i] as AttainInfo).type == 1)
							num++;
					}
				}
				updateStatus(num > 0);

				//只能发送一次，防止2此操作
				if (!isFirstGuide)
				{
					isFirstGuide=true;
					//新手引导
					NewGuide2Manager.sendNextSeverStep();
					NewGuide2Manager.gotoNext();
				}
			}
			//每日任务增减推送
			else if (_arg1.getName() == SAttaintoday.CMD.toString())
			{
				var attaintoday:SAttaintoday=_arg1 as SAttaintoday;
				var tmp_attainInfo:AttainInfo;

				//# 1=增加,2=删除
				if (attaintoday.num == 1)
				{
					tmp_attainInfo=new AttainInfo();
					tmp_attainInfo.id=attaintoday.id;
					tmp_attainInfo.type=2;
					attainInfo.push(tmp_attainInfo);

				}
				else if (attaintoday.num == 2)
				{
					tmp_attainInfo=getAttainInfoById(attaintoday.id);
					index=attainInfo.indexOf(tmp_attainInfo);
					index >= 0 && attainInfo.splice(index, 1);
				}
			}
			//每日任务完成数量推送
			else if (_arg1.getName() == SAttaintoday_send.CMD.toString())
			{
				var attaintoday_send:SAttaintoday_send=_arg1 as SAttaintoday_send;
				tmp_attainInfo=getAttainInfoById(attaintoday_send.id);

				if (tmp_attainInfo)
				{
					tmp_attainInfo.num=attaintoday_send.num;
					tmp_attainData=Attain.hash.getValue(attaintoday_send.id);
					if (tmp_attainData && tmp_attainData.condition == attaintoday_send.num)
						updateStatus(true);
				}
				else
					JTLogger.warn("没有找到推送每日任务数量ID：" + attaintoday_send.id);
			}
		}

		public function receive():void
		{
			var num:int;
			var i:int;

			if (attainInfo)
				for (i=0; i < attainInfo.length; i++)
				{
					if ((attainInfo[i] as AttainInfo).type == 1)
					{
						num++;
						break;
					}
				}
			updateStatus(num > 0);
		}

		/**
		 * 更新成就提示
		 * @param isReceive true 需要提示
		 *
		 */
		private function updateStatus(isReceive:Boolean):void
		{
			this.isReceive=isReceive;
			ViewDispatcher.dispatch(EventType.NOTIFY_ACHIEVEMENT, isReceive);
		}

		/**
		 *
		 * @return
		 */
		public function listNotificationName():Vector.<String>
		{
			var vect:Vector.<String>=new Vector.<String>;
			vect.push(SAttain_send.CMD, SAttain_get.CMD, CAttain_init.CMD, SAttaintoday.CMD, SAttaintoday_send.CMD);
			return vect;
		}
	}
}
