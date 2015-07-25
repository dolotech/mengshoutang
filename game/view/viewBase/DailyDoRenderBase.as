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

    public class DailyDoRenderBase extends DefaultListItemRenderer
    {
        public var ui_gongyong_hero_pub_9gongge_article00:Scale9Image;
        public var txt_title:TextField;
        public var txt_des1:TextField;
        public var txt_reward:TextField;
        public var btn_ok:Button;
        public var tag_finish:Image;
        public var tag_get:Image;
        public var tag_type:Image;

        public function DailyDoRenderBase()
        {
            var texture:Texture;
            var textField:TextField;
            var input_txt:TextInput;
            var image:Image;
            var button:Button;
            var assetMgr:AssetMgr = AssetMgr.instance;
            texture = assetMgr.getTexture('ui_gongyong_hero_pub_9gongge_article');
            var ui_gongyong_hero_pub_9gongge_article00Rect:Rectangle = new Rectangle(13,14,35,34);
            var ui_gongyong_hero_pub_9gongge_article009ScaleTexture:Scale9Textures = new Scale9Textures(texture,ui_gongyong_hero_pub_9gongge_article00Rect);
            ui_gongyong_hero_pub_9gongge_article00 = new Scale9Image(ui_gongyong_hero_pub_9gongge_article009ScaleTexture);
            ui_gongyong_hero_pub_9gongge_article00.width = 672;
            ui_gongyong_hero_pub_9gongge_article00.height = 107;
            this.addQuiackChild(ui_gongyong_hero_pub_9gongge_article00);
            txt_title = new TextField(487,36,'','',24,0xDEA345,false);
            txt_title.touchable = false;
            txt_title.hAlign= 'left';
            txt_title.text= '';
            txt_title.x = 11;
            txt_title.y = 13;
            this.addQuiackChild(txt_title);
            txt_des1 = new TextField(88,36,'','',24,0x66FF00,false);
            txt_des1.touchable = false;
            txt_des1.hAlign= 'left';
            txt_des1.text= '奖励：';
            txt_des1.x = 11;
            txt_des1.y = 56;
            this.addQuiackChild(txt_des1);
            txt_reward = new TextField(88,36,'','',24,0xFFFFFF,false);
            txt_reward.touchable = false;
            txt_reward.hAlign= 'left';
            txt_reward.text= '×5';
            txt_reward.x = 159;
            txt_reward.y = 56;
            this.addQuiackChild(txt_reward);
            texture = assetMgr.getTexture('ui_button_tiebaomutouanjian');
            btn_ok = new Button(texture);
            btn_ok.name= 'btn_ok';
            btn_ok.x = 498;
            btn_ok.y = 19;
            btn_ok.width = 156;
            btn_ok.height = 68;
            this.addQuiackChild(btn_ok);
            btn_ok.text= '前往';
            btn_ok.fontColor= 0xFFFF05;
            btn_ok.fontSize= 24;
            texture = assetMgr.getTexture('ui_reward_yilingqu')
            tag_finish = new Image(texture);
            tag_finish.x = 528;
            tag_finish.y = 30;
            tag_finish.width = 95;
            tag_finish.height = 40;
            this.addQuiackChild(tag_finish);
            tag_finish.touchable = false;
            texture = assetMgr.getTexture('ui_gongyong_jianglilingqu')
            tag_get = new Image(texture);
            tag_get.x = 528;
            tag_get.y = 30;
            tag_get.width = 95;
            tag_get.height = 39;
            this.addQuiackChild(tag_get);
            tag_get.touchable = false;
            texture = assetMgr.getTexture('ui_gongyong_zuanshi')
            tag_type = new Image(texture);
            tag_type.x = 98;
            tag_type.y = 47;
            tag_type.width = 46;
            tag_type.height = 44;
            this.addQuiackChild(tag_type);
            tag_type.touchable = false;
        }
        override public function dispose():void
        {
            btn_ok.dispose();
            super.dispose();
        
}
    }
}
