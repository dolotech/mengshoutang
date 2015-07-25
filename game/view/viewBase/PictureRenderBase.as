package  game.view.viewBase
{
    import starling.display.Image;
    import game.manager.AssetMgr;
    import starling.display.Sprite;
    import starling.textures.Texture;
    import starling.text.TextField;
    import starling.display.Button;
    import flash.geom.Rectangle;
    import feathers.controls.renderers.DefaultListItemRenderer;

    public class PictureRenderBase extends DefaultListItemRenderer
    {
        public var ico_bg:Image;
        public var txt_name:TextField;
        public var ico_hero:Button;
        public var ico_no:Image;
        public var tag:Image;

        public function PictureRenderBase()
        {
            var texture:Texture;
            var textField:TextField;
            var image:Image;
            var button:Button;;
            var assetMgr:AssetMgr = AssetMgr.instance;
            texture = assetMgr.getTexture('ui_gongyong_100yingxiongkuang_kong1')
            ico_bg = new Image(texture);
            ico_bg.width = 101;
            ico_bg.height = 100;
            this.addQuiackChild(ico_bg);
            ico_bg.touchable = false;
            txt_name = new TextField(115,30,'','',20,0xBA6A15,false);
            txt_name.touchable = false;
            txt_name.hAlign= 'center';
            txt_name.text= '英雄的名字';
            txt_name.x = -6;
            txt_name.y = 101;
            this.addQuiackChild(txt_name);
            texture = assetMgr.getTexture('photo_513');
            ico_hero = new Button(texture);
            ico_hero.name= 'ico_hero';
            ico_hero.x = -1;
            ico_hero.y = -1;
            ico_hero.width = 100;
            ico_hero.height = 100;
            this.addQuiackChild(ico_hero);
            texture = assetMgr.getTexture('ui_atlas_bottom_hero_zhezhao')
            ico_no = new Image(texture);
            ico_no.width = 101;
            ico_no.height = 101;
            this.addQuiackChild(ico_no);
            ico_no.touchable = false;
            texture = assetMgr.getTexture('ui_zhuxian_zhandoutongguan_new')
            tag = new Image(texture);
            tag.x = -8;
            tag.y = -10;
            tag.width = 52;
            tag.height = 52;
            this.addQuiackChild(tag);
            tag.touchable = false;
        }
        override public function dispose():void
        {
            ico_hero.dispose();
            super.dispose();
        
}
    }
}
