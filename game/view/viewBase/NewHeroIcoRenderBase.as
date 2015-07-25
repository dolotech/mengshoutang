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
    import feathers.controls.renderers.DefaultListItemRenderer;

    public class NewHeroIcoRenderBase extends DefaultListItemRenderer
    {
        public var tag_bg:Image;
        public var btn_bg:Button;
        public var ico_head:Image;
        public var tag_battle:Image;
        public var img_tag:Image;
        public var txt_desopen:TextField;
        public var textLv:TextField;
        public var txt_open:TextField;

        public function NewHeroIcoRenderBase()
        {
            var texture:Texture;
            var textField:TextField;
            var input_txt:TextInput;
            var image:Image;
            var button:Button;
            var assetMgr:AssetMgr = AssetMgr.instance;
            texture = assetMgr.getTexture('ui_gongyong_100yingxiongkuang_kong')
            tag_bg = new Image(texture);
            tag_bg.x = 2;
            tag_bg.width = 101;
            tag_bg.height = 100;
            this.addQuiackChild(tag_bg);
            tag_bg.touchable = false;
            texture = assetMgr.getTexture('ui_gongyong_100yingxiongkuang_0');
            btn_bg = new Button(texture);
            btn_bg.name= 'btn_bg';
            btn_bg.x = 2;
            btn_bg.width = 100;
            btn_bg.height = 100;
            this.addQuiackChild(btn_bg);
            texture = assetMgr.getTexture('icon_102045')
            ico_head = new Image(texture);
            ico_head.x = 6;
            ico_head.y = 5;
            ico_head.width = 89;
            ico_head.height = 89;
            this.addQuiackChild(ico_head);
            ico_head.touchable = false;
            texture = assetMgr.getTexture('ui_gongyong_kexuanzhuangtai')
            tag_battle = new Image(texture);
            tag_battle.x = 64;
            tag_battle.y = 45;
            tag_battle.width = 42;
            tag_battle.height = 42;
            this.addQuiackChild(tag_battle);
            tag_battle.touchable = false;
            texture = assetMgr.getTexture('ui_gongyong_zheyetubiao1')
            img_tag = new Image(texture);
            img_tag.x = 70;
            img_tag.width = 34;
            img_tag.height = 34;
            this.addQuiackChild(img_tag);
            img_tag.touchable = false;
            txt_desopen = new TextField(104,33,'','',22,0xFFFFFF,false);
            txt_desopen.touchable = false;
            txt_desopen.hAlign= 'center';
            txt_desopen.text= '扩充';
            txt_desopen.x = -1;
            txt_desopen.y = 13;
            this.addQuiackChild(txt_desopen);
            textLv = new TextField(48,32,'','',21,0xFFFFFF,false);
            textLv.touchable = false;
            textLv.hAlign= 'left';
            textLv.text= '';
            textLv.x = 11;
            textLv.y = 6;
            this.addQuiackChild(textLv);
            txt_open = new TextField(104,33,'','',22,0xFFFFFF,false);
            txt_open.touchable = false;
            txt_open.hAlign= 'center';
            txt_open.text= '0/0';
            txt_open.x = -1;
            txt_open.y = 50;
            this.addQuiackChild(txt_open);
        }
        override public function dispose():void
        {
            btn_bg.dispose();
            super.dispose();
        
}
    }
}
