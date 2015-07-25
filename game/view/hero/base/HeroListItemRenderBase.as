package game.view.hero.base
{
	import feathers.controls.renderers.DefaultListItemRenderer;

	import game.manager.AssetMgr;

	import starling.display.Button;
	import starling.display.Image;
	import starling.text.TextField;
	import starling.textures.Texture;

	public class HeroListItemRenderBase extends DefaultListItemRenderer
	{
		public var boxButton:Button;
		public var qualityImage:Image;
		public var qualityDi:Image=null;
		public var lvImage:Image;
		public var textLv:TextField=null;

		public function HeroListItemRenderBase()
		{
			qualityDi=new Image(AssetMgr.instance.getTexture('ui_gongyong_100yingxiongkuang_kong1'));
			this.addQuiackChild(qualityDi);

			var boxTexture:Texture=AssetMgr.instance.getTexture('ui_gongyong_100yingxiongkuang_5');
			boxButton=new Button(boxTexture);
			boxButton.width=100;
			boxButton.height=100;
			this.addQuiackChild(boxButton);

			var qualityTexture:Texture=AssetMgr.instance.getTexture('ui_hero_yingxiongpinzhi_03');
			qualityImage=new Image(qualityTexture);
			qualityImage.x=61;
			qualityImage.y=61;
			qualityImage.width=38;
			qualityImage.height=38;
			this.addQuiackChild(qualityImage);

			textLv=new TextField(48, 32, '', '', 21, 0xFFFFFF, false);
			textLv.touchable=false;
			textLv.hAlign='center';
			textLv.text='';
			textLv.x=5;
			textLv.y=6;
			this.addQuiackChild(textLv);

//			var lvTexture:Texture=AssetMgr.instance.getTexture('ui_shuzi_lv');
//			lvImage=new Image(lvTexture);
//			lvImage.x=-3;
//			lvImage.y=9;
//			lvImage.width=30;
//			lvImage.height=24;
//			this.addQuiackChild(lvImage);
		}

		override public function dispose():void
		{
			super.dispose();
			boxButton.dispose();
		}
	}
}
