package  game.view.viewBase
{
    import starling.display.Image;
    import game.manager.AssetMgr;
    import starling.display.Sprite;
    import starling.textures.Texture;
    import starling.text.TextField;
    import starling.display.Button;
    import flash.geom.Rectangle;
    import com.utils.Constants;
    import feathers.controls.TextInput;
    import feathers.display.Scale9Image;
    import feathers.textures.Scale9Textures;
    import feathers.controls.renderers.DefaultListItemRenderer;

    public class GoodsDropGuideRenderBase extends DefaultListItemRenderer
    {
        public var txt_isOpen:TextField;
        public var txt_des1:TextField;
        public var txt_drop:TextField;
        public var ui_gongyong_hero_pub_9gongge_article00:Scale9Image;
        public var ico_hero:Image;
        public var tag_goto:Button;
        public var txt_droptype:TextField;

        public function GoodsDropGuideRenderBase()
        {
            var texture:Texture;
            var textField:TextField;
            var input_txt:TextInput;
            var image:Image;
            var button:Button;
            var assetMgr:AssetMgr = AssetMgr.instance;
            txt_isOpen = new TextField(64,28,'','',16,0x66FF00,false);
            txt_isOpen.touchable = false;
            txt_isOpen.hAlign= 'left';
            txt_isOpen.text= '已开启';
            txt_isOpen.x = 117;
            txt_isOpen.y = 72;
            this.addQuiackChild(txt_isOpen);
            txt_des1 = new TextField(95,28,'','',18,0xFFFFFF,false);
            txt_des1.touchable = false;
            txt_des1.hAlign= 'left';
            txt_des1.text= '掉落位置：';
            txt_des1.x = 117;
            txt_des1.y = 3;
            this.addQuiackChild(txt_des1);
            txt_drop = new TextField(202,28,'','',18,0xFFFFFF,false);
            txt_drop.touchable = false;
            txt_drop.hAlign= 'left';
            txt_drop.text= '';
            txt_drop.x = 116;
            txt_drop.y = 37;
            this.addQuiackChild(txt_drop);
            texture = assetMgr.getTexture('ui_gongyong_hero_pub_9gongge_article');
            var ui_gongyong_hero_pub_9gongge_article00Rect:Rectangle = new Rectangle(17,19,27,22);
            var ui_gongyong_hero_pub_9gongge_article009ScaleTexture:Scale9Textures = new Scale9Textures(texture,ui_gongyong_hero_pub_9gongge_article00Rect);
            ui_gongyong_hero_pub_9gongge_article00 = new Scale9Image(ui_gongyong_hero_pub_9gongge_article009ScaleTexture);
            ui_gongyong_hero_pub_9gongge_article00.width = 111;
            ui_gongyong_hero_pub_9gongge_article00.height = 102;
            this.addQuiackChild(ui_gongyong_hero_pub_9gongge_article00);
            texture = assetMgr.getTexture('ui_zhuxian_bigboss_airenguowang')
            ico_hero = new Image(texture);
            ico_hero.x = 5;
            ico_hero.width = 100;
            ico_hero.height = 100;
            this.addQuiackChild(ico_hero);
            ico_hero.touchable = false;
            texture = assetMgr.getTexture('ui_wenzi_lijiqianwang');
            tag_goto = new Button(texture);
            tag_goto.name= 'tag_goto';
            tag_goto.x = 184;
            tag_goto.y = 70;
            tag_goto.width = 103;
            tag_goto.height = 29;
            this.addQuiackChild(tag_goto);
            txt_droptype = new TextField(95,28,'','',18,0x00FF00,false);
            txt_droptype.touchable = false;
            txt_droptype.hAlign= 'left';
            txt_droptype.text= '';
            txt_droptype.x = 209;
            txt_droptype.y = 3;
            this.addQuiackChild(txt_droptype);
        }
        override public function dispose():void
        {
            tag_goto.dispose();
            super.dispose();
        
}
    }
}
