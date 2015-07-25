package game.view.rank
{
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	import game.data.Robot;
	import game.manager.AssetMgr;
	import game.net.data.vo.RankInfo;
	import game.view.rank.ui.JTUIRankItem;
	
	import game.managers.JTRankListInfoManager;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	import com.utils.Constants;
	
	public class JTRankItemRender extends DefaultListItemRenderer
	{
		private var item:JTUIRankItem = new JTUIRankItem();
		private var rankInfo:RankInfo = null;
		private var rankNoImage:Image = null;
		private var rankTypePVP:Image = null;
		private var rankTypeStar:Image = null;
		private var rankTypeMoney:Image = null;
		private var headImage:Image = null;
		public function JTRankItemRender()
		{
			super();	
			this.defaultSkin = item;
			item.txt_head.touchable = false;
			//this.rankTypeStar = createImage("ui_wudixingyunxing_xingxing");
			//this.rankTypeMoney = createImage("ui_tubiao_zuanshi_da");
		}
		
		public function createImage(asset:String):Image
		{
			var texture:Texture = AssetMgr.instance.getTexture(asset);
			var image:Image = new Image(texture)
			image.x = (item.txt_item_name.x + item.txt_item_name.width + 10) * Constants.scale;
			image.y = (item.txt_item_name.y) * Constants.scale;
			this.item.addChild(image);
			return image;
		}
		
		public function showRankTypeImage():void
		{
			item.ui_tubiao_duanwei343318img_NaN.x = 433;
			item.ui_tubiao_duanwei343318img_NaN.y = 18;
			switch(JTRankListInfoManager.rankType)
			{
				case JTRankListInfoManager.RANK_MONEY:
				{
					/*this.rankTypeMoney.visible = true;
                    if(this.rankTypePVP)this.rankTypePVP.visible = false;
					this.rankTypeStar.visible = false;*/
					//this.rankTypePVP.visible = false;
					//this.item.ui_tubiao_duanwei343318img_NaN.visible = true;
					this.item.ui_tubiao_duanwei343318img_NaN.width = 69;
						this.item.ui_tubiao_duanwei343318img_NaN.height = 67;	
					this.item.ui_tubiao_duanwei343318img_NaN.texture = AssetMgr.instance.getTexture("ui_tubiao_zuanshi_da");
					break;
				}
				case JTRankListInfoManager.RANK_PVP:
				{
					if(rankInfo.custom==0)
						rankInfo.custom=1;
					item.ui_tubiao_duanwei343318img_NaN.x = 455;
					item.ui_tubiao_duanwei343318img_NaN.y = 30;
					this.item.ui_tubiao_duanwei343318img_NaN.width = 31;
					this.item.ui_tubiao_duanwei343318img_NaN.height = 43;	
					this.item.ui_tubiao_duanwei343318img_NaN.texture = AssetMgr.instance.getTexture("ui_pvp_rongyuzhibiaozhi");
					break;
				}
				case JTRankListInfoManager.RANK_FIGHT:
				{
					/*this.item.ui_tubiao_duanwei343318img_NaN.visible = false;
					if (this.rankTypePVP)
					{
						this.rankTypePVP.visible = true;
						this.rankTypePVP.texture = AssetMgr.instance.getTexture("ui_iocn_qualifying" + rankInfo.custom);
					}
					else
					{
						this.rankTypePVP = createImage("ui_iocn_qualifying" + rankInfo.custom);
					}*/
					//this.rankTypeStar.visible = false;
					if(rankInfo.custom==0)
						rankInfo.custom=1;
					this.item.ui_tubiao_duanwei343318img_NaN.width = 85;
					this.item.ui_tubiao_duanwei343318img_NaN.height = 57;	
					this.item.ui_tubiao_duanwei343318img_NaN.texture = AssetMgr.instance.getTexture("ui_iocn_qualifying" + rankInfo.custom);
					break;
				}
				case JTRankListInfoManager.RANK_STAR:
				{
					/*this.rankTypeMoney.visible = false;
					if(this.rankTypePVP)this.rankTypePVP.visible = false;
					this.rankTypeStar.visible = true;*/
					/*this.rankTypePVP.visible = false;
					this.item.ui_tubiao_duanwei343318img_NaN.visible = true;*/
					this.item.ui_tubiao_duanwei343318img_NaN.width = 69;
					this.item.ui_tubiao_duanwei343318img_NaN.height = 67;	
					this.item.ui_tubiao_duanwei343318img_NaN.texture = AssetMgr.instance.getTexture("ui_wudixingyunxing_xingxing");
					break;
				}
			}
		}
		
		override protected function itemRenderer_triggeredHandler(event:Event):void
		{
			super.itemRenderer_triggeredHandler(event);
		}
		
		override public function set data(value:Object):void
		{
			if (!value)
			{
				return;
			}
			rankInfo = value as RankInfo;
			showRankTypeImage();
			if (rankInfo.index < 4)
			{
				showRankNoImage(rankInfo.index);
			}
			else
			{
				showRankNoTxt(rankInfo.index);	
			}
			var lines:Array = (rankInfo.name as String).split(".");
			var name:String = lines[0] == "^" ? (Robot.hash.getValue(int(lines[1])) as Robot).name : rankInfo.name ;
			item.txt_item_name.text = name;
			item.txt_rank_info.text = rankInfo.attr.toString();
			item.textField.text = "0";
			var img_head:Image = this.item.txt_head.getChildByName("head") as Image;
			if (!img_head)
			{
				img_head = new Image(AssetMgr.instance.getTexture("ui_pvp_renwutouxiang" + rankInfo.picture));
				img_head.name = "head";
				this.item.txt_head.addChildAt(img_head, this.item.txt_head.numChildren - 2);
			}
			else
			{
				img_head.texture = AssetMgr.instance.getTexture("ui_pvp_renwutouxiang" + rankInfo.picture);
			}
			/*if (!this.headImage)
			{
				var btn_head_txture:Texture = AssetMgr.instance.getTexture('ui_gongyong_100yingxiongkuang_kong2');
				var txt_head:Texture = AssetMgr.instance.getTexture("ui_pvp_renwutouxiang" + rankInfo.picture);
				var img_rang:Image = new Image(txt_head);
				this.headImage = new Image(btn_head_txture);
				this.headImage.x = 96 * Constants.scale;
				this.headImage.y = -5 * Constants.scale;
				img_rang.x = 94 * Constants.scale;
				img_rang.y =  0;
				this.addChild(headImage);
				this.addChild(img_rang);
			}
			else
			{
				this.headImage.texture = AssetMgr.instance.getTexture("ui_pvp_renwutouxiang" + rankInfo.picture);
			}*/
			super.data = value;
		}
		
		private function showRankNoTxt(no:int):void
		{
			if (rankNoImage)
			{
				if (rankNoImage.visible)
				{
					rankNoImage.visible = false;
				}
			}
			if (no >= 100)
			{
				item.txt_rank.text = "未上榜";
			}
			else
			{
				item.txt_rank.text = "NO." + no;
			}
		}
		
		private function showRankNoImage(no:int):void
		{
			var texture:Texture = AssetMgr.instance.getTexture("ui_icon_charts" + no);
			if (!rankNoImage)
			{
				rankNoImage = new Image(texture);
				rankNoImage.y = 20;
				this.addChild(rankNoImage);
			}
			else
			{
				rankNoImage.visible = true;
				rankNoImage.texture = texture;
			}
			item.txt_rank.text = "";
		}
		
		override public function dispose():void
		{
			this.item = null;
			this.rankInfo = null;
			this.rankNoImage = null;
			this.defaultSkin.dispose();
			super.dispose();
		}
		
		override public function set y(value:Number):void
		{
			super.y = value;
		}
		
		public function getRankInfo():RankInfo
		{
			return this.rankInfo;	
		}
		
		public static function instance():JTRankItemRender
		{
			return new JTRankItemRender();
		}
	}
}