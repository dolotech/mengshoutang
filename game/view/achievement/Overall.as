package game.view.achievement
{
	import com.langue.Langue;
	import com.mvc.interfaces.INotification;

	import flash.geom.Rectangle;

	import game.data.Attain;
	import game.dialog.ShowLoader;
	import game.net.GameSocket;
	import game.net.data.c.CAttain_init;
	import game.net.data.s.SAttain_init;
	import game.view.achievement.data.AchievementData;
	import game.view.viewBase.OverallBase;

	import starling.display.Sprite;

	/**
	 * 成就   总览
	 * @author litao
	 *
	 */
	public class Overall extends OverallBase
	{
		private var _data:AchievementData=AchievementData.instance;
		public var list:TaskList;
		private var m_width:int=158;

		public function Overall()
		{
			super();
			initView();
		}

		protected function initView():void
		{
			var arr:Array=Langue.getLans("AchievementMenu");
			for (var i:int=0; i < arr.length; i++)
			{
				this["Progress" + (i + 1)].text=arr[i];
			}
			lastComplete.text=Langue.getLans("AchievementComplete")[0];
			ProgressLook.text=Langue.getLans("AchievementComplete")[1];
			list=new TaskList;
			addChild(list);
			list.inits(670, 321);

			if (!_data.isSend)
				send();
			else
			{
				Rest();
			}
		}

		public function showProgress():void
		{
			var parcent:Number=0;
			var heroTotal:int=_data.getSectionTotals(4);
			var heroComplete:int=heroTotal - (_data.getSectionCompletes(_data.SectionList(4)));
			ProgressRate4.text=heroComplete + " / " + heroTotal;
			parcent=heroComplete / heroTotal;
			maskBar(par4, m_width, 15, parcent);

			var fightTotal:int=_data.getSectionTotals(3);
			var fightComplete:int=fightTotal - (_data.getSectionCompletes(_data.SectionList(3)));
			ProgressRate3.text=fightComplete + " / " + fightTotal;
			parcent=fightComplete / fightTotal;
			maskBar(par3, m_width, 15, parcent);

			var dailyTotal:int=_data.getSectionTotals(2);
			var dailyComplete:int=dailyTotal - (_data.getSectionCompletes(_data.SectionList(2)));
			ProgressRate2.text=dailyComplete + " / " + dailyTotal;
			parcent=dailyComplete / dailyTotal;
			maskBar(par2, m_width, 15, parcent);

			var totals:int=Attain.totals;
			var complete:int=fightComplete + heroComplete + dailyComplete;
			ProgressRate1.text=complete + " / " + totals;
			parcent=complete / totals;
			maskBar(par1, 577, 13, parcent);
		}

		private function maskBar(mask:Sprite, w:Number, h:Number, parcent:Number):void
		{
			mask.clipRect=new Rectangle(0, 0, w * parcent, h);
		}

		public function Rest():void
		{
			if (_data.attainInfo)
			{
				list.restItemRender(_data.attainInfo);
				showProgress();
			}
		}

		private function send():void
		{
			var cmd:CAttain_init=new CAttain_init;
			GameSocket.instance.sendData(cmd);
			ShowLoader.add();
		}

		override public function handleNotification(_arg1:INotification):void
		{
			var info:SAttain_init=_arg1 as SAttain_init;
			_data.attainInfo=info.ids;
			_data.receive();

			Rest();
			_data.isSend=true;

			ShowLoader.remove();
		}

		override public function listNotificationName():Vector.<String>
		{
			var vect:Vector.<String>=new Vector.<String>;
			vect.push(SAttain_init.CMD);
			return vect;
		}

		override public function dispose():void
		{
			list && list.dispose();
			super.dispose();
			list=null;
			m_width=0;
		}
	}
}
