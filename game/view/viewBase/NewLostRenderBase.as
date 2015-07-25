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

    public class NewLostRenderBase extends DefaultListItemRenderer
    {
        public var ui_gongyong_hero_pub_9gongge_article00:Scale9Image;
        public var txt_des:TextField;
        public var btn_ok:Button;
        public var icon:Image;
        public var txt_level:TextField;

        public function NewLostRenderBase()
        {
            var texture:Texture;
            var textField:TextField;
            var input_txt:TextInput;
            var image:Image;
            var button:Button;
            var assetMgr:AssetMgr = AssetMgr.instance;
            texture = assetMgr.getTexture('ui_gongyong_hero_pub_9gongge_article');
            var ui_gongyong_hero_pub_9gongge_article00Rect:Rectangle = new Rectangle(17,19,27,22);
            var ui_gongyong_hero_pub_9gongge_article009ScaleTexture:Scale9Textures = new Scale9Textures(texture,ui_gongyong_hero_pub_9gongge_article00Rect);
            ui_gongyong_hero_pub_9gongge_article00 = new Scale9Image(ui_gongyong_hero_pub_9gongge_article009ScaleTexture);
            ui_gongyong_hero_pub_9gongge_article00.width = 662;
            ui_gongyong_hero_pub_9gongge_article00.height = 156;
            this.addQuiackChild(ui_gongyong_hero_pub_9gongge_article00);
            txt_des = new TextField(349,104,'','',25,0xFFFFFF,false);
            txt_des.touchable = false;
            txt_des.hAlign= 'left';
            txt_des.text= '';
            txt_des.x = 147;
            txt_des.y = 28;
            this.addQuiackChild(txt_des);
            texture = assetMgr.getTexture('ui_button_tiebaomutouanjian');
            btn_ok = new Button(texture);
            btn_ok.name= 'btn_ok';
            btn_ok.x = 495;
            btn_ok.y = 43;
            btn_ok.width = 150;
            btn_ok.height = 64;
            this.addQuiackChild(btn_ok);
            btn_ok.text= '前往';
            btn_ok.fontColor= 0xFFCC66;
            btn_ok.fontSize= 26;
            texture = assetMgr.getTexture('ui_gongyong_100yingxiongkuang_2')
            icon = new Image(texture);
            icon.x = 35;
            icon.y = 28;
            icon.width = 100;
            icon.height = 100;
            this.addQuiackChild(icon);
            icon.touchable = false;
            txt_level = new TextField(61,30,'','',20,0xFFCC66,false);
            txt_level.touchable = false;
            txt_level.hAlign= 'right';
            txt_level.text= '';
            txt_level.x = 65;
            txt_level.y = 93;
            this.addQuiackChild(txt_level);
        }
        override public function dispose():void
        {
            btn_ok.dispose();
            super.dispose();
        
}
    }
}
