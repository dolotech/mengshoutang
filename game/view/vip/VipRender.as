package game.view.vip
{
	import com.langue.Langue;

	import game.data.VipData;
	import game.view.viewBase.VipRenderBase;

	public class VipRender extends VipRenderBase
	{
		public function VipRender()
		{
			super();
		}

		override public function set data(value : Object) : void
		{
			super.data = value;
			var vipData : VipData = value as VipData;

			if (vipData == null)
				return;
			txt_vipLevel2.text = Langue.getLangue("vipday") + vipData.dayPrize;
			txt_day.height = vipData.id == 0 ? 40 : 55;
			txt_vipLevel1.text = "vip" + vipData.id;
			txt_vip.text = vipData.id + "";
			txt_chat.text = vipData.chat + "";
			txt_speed.text = (vipData.fast / 10) + "";
			txt_tired.text = vipData.tired_buy + "";
			txt_jingji.text = vipData.jingji_buy + "";
			txt_best.text = VipData.getRewardName(VipData.list_reward[vipData.reward]);
			var selectedIndex : int = vipData.dayPrize;
			selectedIndex = selectedIndex < 0 ? 0 : selectedIndex;
			txt_day.text = VipData.getRewardName(VipData.list_dayReward[selectedIndex]);
		}
	}
}