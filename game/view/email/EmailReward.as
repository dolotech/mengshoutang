package game.view.email
{
	import com.view.View;

	import game.data.Goods;
	import game.data.HeroData;
	import game.data.RoleShow;
	import game.manager.AssetMgr;
	import game.net.data.vo.mailItems;
	import game.view.uitils.Res;

	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;

	/**
	 * 邮件物品奖励
	 * @author hyy
	 *
	 */
	public class EmailReward extends View
	{
		private var box:Button;
		private var view:Sprite;

		public function EmailReward(view:Sprite, isAutoInit:Boolean=false)
		{
			super(isAutoInit);
			this.view=view;
			this.box=view.getChildByName("box") as Button;
		}

		public function set data(data:Object):void
		{
			var item:mailItems=data as mailItems;
			var icon_type:String="ui_button_mail";
			var type:int=item ? item.type : 0;
			var icon:Image=view.getChildByName("icon") as Image;
			var text:TextField=view.getChildByName("txt_num") as TextField;
			view.visible=box.visible=visible=data != null;
			box.upState=AssetMgr.instance.getTexture("ui_gongyong_90wupingkuang0");
			text.text=(item ? "x" + item.num : "");

			/*	# 1=金币,
			   # 2=钻石,
			   # 3=幸运星,
			   # 5=英雄,
			   # 7=疲劳值,
			 # 大于100 = 物品ID*/
			switch (type)
			{
				case 0:
					icon_type="ui_button_mail";
					break;
				case 1:
					icon_type="ui_tubiao_jinbi_da";
					break;
				case 2:
					icon_type="ui_tubiao_zuanshi_da";
					break;
				case 3:
					icon_type="icon_3";
					break;
				case 5:
					var heroData:HeroData=HeroData.hero.getValue(item.num);
					if (heroData == null)
					{
						addTips("没有该英雄" + item.custom);
						break;
					}
					box.upState=box.downState=AssetMgr.instance.getTexture("ui_gongyong_90wupingkuang" + (item.custom - 1));
					text.text="x 1";
					icon_type=(RoleShow.hash.getValue(heroData.show) as RoleShow).photo;
					break;
				default:
					var goods:Goods=(Goods.goods.getValue(item.type) as Goods);
					if (goods == null)
					{
						addTips("没有该物品" + item.type);
						break;
					}
					icon_type=goods.picture;
					box.upState=box.downState=Res.instance.getQualityPhoto(goods.quality);
					break;
			}
			icon.texture=AssetMgr.instance.getTexture(icon_type);
			icon.visible=data == "1" ? true : item;
		}

	}
}
