package game.view.PVP
{
	import com.dialog.DialogMgr;
	import com.langue.Langue;
	
	import game.common.JTGlobalFunction;
	
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	import game.dialog.ShowLoader;
	import game.net.GameSocket;
	import game.net.data.c.CColiseumRivalFightInfo;
	import game.net.data.vo.ColiseumReportList;
	import game.view.PVP.ui.JTUIPvpFightReport;
	import game.view.tipPanel.TipPanelDlg;
	
	import game.managers.JTPvpInfoManager;
	
	import starling.events.Event;

	public class JTPvpReportItemRender extends DefaultListItemRenderer
	{
		public var item:JTUIPvpFightReport = null;
		public function JTPvpReportItemRender()
		{
			super();
			item = new JTUIPvpFightReport();
			this.defaultSkin = item;
			this.item.btn_pk.addEventListener(Event.TRIGGERED, onSendRePKHandler);
		}
		
		private function onSendRePKHandler(e:Event):void
		{
			if (!this.data)
			{
				return;
			}
			var tips:TipPanelDlg  = DialogMgr.instance.open(TipPanelDlg) as TipPanelDlg;
			tips.createVerify(Langue.getLangue("reportPormpt"), onClickBuyHandler, onCanelHandler);
			e.stopImmediatePropagation();
		}
		
		private function onCanelHandler():void
		{
			DialogMgr.instance.deleteDlg(TipPanelDlg);
		}
		
		private function onClickBuyHandler():void
		{
			JTPvpInfoManager.type = JTPvpInfoManager.TYPE_FIGHT;
			var rankInfo:ColiseumReportList = data as ColiseumReportList;
			var sendPkPackage:CColiseumRivalFightInfo = new CColiseumRivalFightInfo();
			sendPkPackage.id = rankInfo.id;
			sendPkPackage.type = JTPvpInfoManager.TYPE_FIGHT;
			GameSocket.instance.sendData(sendPkPackage);
			DialogMgr.instance.deleteDlg(TipPanelDlg);
			ShowLoader.add();
		}
		
		override public function set data(value:Object):void
		{
			if (!value)
			{
				return;
			}
			var fightReport:ColiseumReportList = value as ColiseumReportList;
			this.item.txt_about.isHtml = true;
			this.item.txt_about.text = JTGlobalFunction.toHTMLStyle("#ff9900", "[" + fightReport.name + "] : ", 18) + Langue.getLangue("reportPKTitle");
			super.data = value;
		}
	}
}