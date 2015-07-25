package game.view.userLog
{
	import game.view.userLog.data.ServerInfoData;
	import game.view.viewBase.ShowServerRenderBase;

	public class ShowServerRender extends ShowServerRenderBase
	{
		public function ShowServerRender()
		{
			super();
		}

		override public function set data(value : Object) : void
		{
			super.data = value;
			var serverData : ServerInfoData = value as ServerInfoData;
			txt_name.text = serverData.name;
			tag_new.visible = serverData.status == 4;
			tag_hot.visible = serverData.status == 2;
			tag_afterOpen.visible = serverData.status == 5;
			btn_bg.disable = serverData.status == 3;
		}
	}
}