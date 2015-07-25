package game.view.activity.activity.AllGifts
{
	import com.utils.ObjectUtil;

	import flash.geom.Point;

	import game.data.FestPrizeData;
	import game.data.Goods;
	import game.data.HeroData;
	import game.data.RoleShow;
	import game.manager.AssetMgr;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;

	public class Box extends Sprite
	{
		private var point:Point=new Point(23, 260);
		private var box:Image;
		private var qualityDi:Image=null;

		public function Box(texture:Texture)
		{
			box=new Image(texture);
			addChild(box);

			this.x=point.x;
			this.y=point.y;
		}

		public function set data(data:FestPrizeData):void
		{
			var type:int=data.ReceiveType;
			var num:int=data.num;
			var image:Image;
			var texture:Texture;
			var text:TextField=new TextField(80, 35, "", "", 21, 0xffffff);
			text.hAlign='right';
			text.y=50;

			if (qualityDi == null)
			{
				qualityDi=new Image(AssetMgr.instance.getTexture("ui_gongyong_90wupingkuang"));
				this.addQuiackChildAt(qualityDi, 0);
			}
			else
			{
				qualityDi && qualityDi.removeFromParent(true);
			}

			if (type == 1)
			{
				texture=AssetMgr.instance.getTexture("ui_tubiao_jinbi_da");
				image=new Image(texture);
			}
			else if (type == 2)
			{
				texture=AssetMgr.instance.getTexture("ui_tubiao_zuanshi_da");
				image=new Image(texture);
			}
			else if (type == 3)
			{
				texture=AssetMgr.instance.getTexture("ui_wudixingyunxing_xingxing");
				image=new Image(texture);
			}
			else if (type == 5)
			{
				var heroData:HeroData=HeroData.hero.getValue(type);
				var photo:String=(RoleShow.hash.getValue(heroData.show) as RoleShow).photo;

				box.texture=AssetMgr.instance.getTexture("ui_gongyong_100yingxiongkuang_" + (heroData.quality - 1));
				texture=AssetMgr.instance.getTexture(photo);
				box.width=100;
				box.height=100;
				image=new Image(texture);
			}
			else if (type == 7)
			{
				texture=AssetMgr.instance.getTexture("ui_tubiao_zhuxianpilaozhi");
				image=new Image(texture);
			}
			else
			{
				var goods:Goods=Goods.goods.getValue(type);
				texture=AssetMgr.instance.getTexture(goods.picture);
				image=new Image(texture);
				box.texture=AssetMgr.instance.getTexture("ui_gongyong_90wupingkuang" + (goods.quality - 1));
			}
			text.text="x " + data.num;
			addChild(image);
			image.x=box.width / 4;
			image.y=box.height / 4;
			addChild(text);
		}
		private var state:Image;
		public var stuate:int;

		public function set stuat(value:int):void
		{
			stuate=value;
		/*var texture:Texture;

		if(value == 0)
		{
			texture = AssetMgr.instance.getTexture("");
		}
		else if(value == 1)
		{
			texture = AssetMgr.instance.getTexture("ui_gongyong_jianglilingqu");
		}
		else if(value == 2)
		{
			texture = AssetMgr.instance.getTexture("ui_reward_yilingqu");
		}
		if(state)
		{
			state .texture = texture;
		}
		else
		{
			state = new Image(texture);
			addChild(state);
			ObjectUtil.setToCenter(box,state);
		}*/
		}

		public function addStuat():void
		{
			var texture:Texture;
			stuate=2;
			texture=AssetMgr.instance.getTexture("ui_reward_yilingqu");
			state=new Image(texture);
			addChild(state);
			ObjectUtil.setToCenter(box, state);
		}
	}
}
