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
    import com.dialog.Dialog;

    public class WelfareViewBase extends Dialog
    {
        public var ui_gongyong_di_9gongge28119:Scale9Image;
        public var txt_title:TextField;
        public var btn_close:Button;
        public var btn_first:Button;
        public var btn_lucky:Button;
        public var btn_share:Button;
        public var btn_rank:Button;
        public var btn_new:Button;
        public var btn_vip:Button;
        public var btn_month:Button;
        public var btn_sign:Button;
        public var btn_reward:Button;

        public function WelfareViewBase()
        {
            super(false);
            var texture:Texture;
            var textField:TextField;
            var input_txt:TextInput;
            var image:Image;
            var button:Button;
            var assetMgr:AssetMgr = AssetMgr.instance;
            texture =assetMgr.getTexture('ui_wudixingyunxing_xingxing_goumaikuang2');
            image = new Image(texture);
            image.x = 78;
            image.y = 30;
            image.width = 544;
            image.height = 373;
            image.smoothing= Constants.NONE;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_wudixingyunxing_xingxing_goumaikuang1');
            image = new Image(texture);
            image.x = 708;
            image.y = 30;
            image.width = 96;
            image.height = 373;
            image.scaleX = -0.9395599365234375;
            image.smoothing= Constants.NONE;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_wudixingyunxing_xingxing_goumaikuang1');
            image = new Image(texture);
            image.y = 30;
            image.width = 96;
            image.height = 373;
            image.smoothing= Constants.NONE;
            this.addQuiackChild(image);
            texture = assetMgr.getTexture('ui_gongyong_di_9gongge');
            var ui_gongyong_di_9gongge28119Rect:Rectangle = new Rectangle(21,21,43,41);
            var ui_gongyong_di_9gongge281199ScaleTexture:Scale9Textures = new Scale9Textures(texture,ui_gongyong_di_9gongge28119Rect);
            ui_gongyong_di_9gongge28119 = new Scale9Image(ui_gongyong_di_9gongge281199ScaleTexture);
            ui_gongyong_di_9gongge28119.x = 28;
            ui_gongyong_di_9gongge28119.y = 119;
            ui_gongyong_di_9gongge28119.width = 650;
            ui_gongyong_di_9gongge28119.height = 251;
            this.addQuiackChild(ui_gongyong_di_9gongge28119);
            texture =assetMgr.getTexture('ui_Setup_title');
            image = new Image(texture);
            image.x = 158;
            image.width = 399;
            image.height = 104;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            this.addQuiackChild(image);
            txt_title = new TextField(294,41,'','',28,0x3D3125,false);
            txt_title.touchable = false;
            txt_title.hAlign= 'center';
            txt_title.text= '福   利';
            txt_title.x = 211;
            txt_title.y = 21;
            this.addQuiackChild(txt_title);
            texture = assetMgr.getTexture('ui_Buyingdiamond_button_guanbi');
            btn_close = new Button(texture);
            btn_close.name= 'btn_close';
            btn_close.x = 631;
            btn_close.y = 42;
            btn_close.width = 61;
            btn_close.height = 60;
            this.addQuiackChild(btn_close);
            texture = assetMgr.getTexture('ui_button_city_shouchong');
            btn_first = new Button(texture);
            btn_first.name= 'btn_first';
            btn_first.x = 73;
            btn_first.y = 152;
            btn_first.width = 65;
            btn_first.height = 65;
            this.addQuiackChild(btn_first);
            texture = assetMgr.getTexture('ui_button_city_choujiang');
            btn_lucky = new Button(texture);
            btn_lucky.name= 'btn_lucky';
            btn_lucky.x = 197;
            btn_lucky.y = 152;
            btn_lucky.width = 65;
            btn_lucky.height = 65;
            this.addQuiackChild(btn_lucky);
            texture = assetMgr.getTexture('ui_button_city_fenxiang');
            btn_share = new Button(texture);
            btn_share.name= 'btn_share';
            btn_share.x = 321;
            btn_share.y = 152;
            btn_share.width = 65;
            btn_share.height = 65;
            this.addQuiackChild(btn_share);
            texture = assetMgr.getTexture('ui_button_city_paihang');
            btn_rank = new Button(texture);
            btn_rank.name= 'btn_rank';
            btn_rank.x = 445;
            btn_rank.y = 152;
            btn_rank.width = 65;
            btn_rank.height = 65;
            this.addQuiackChild(btn_rank);
            texture = assetMgr.getTexture('ui_button_city_xinshou');
            btn_new = new Button(texture);
            btn_new.name= 'btn_new';
            btn_new.x = 569;
            btn_new.y = 152;
            btn_new.width = 65;
            btn_new.height = 65;
            this.addQuiackChild(btn_new);
            texture = assetMgr.getTexture('ui_button_city_viplibao');
            btn_vip = new Button(texture);
            btn_vip.name= 'btn_vip';
            btn_vip.x = 73;
            btn_vip.y = 272;
            btn_vip.width = 65;
            btn_vip.height = 65;
            this.addQuiackChild(btn_vip);
            texture = assetMgr.getTexture('ui_iocn_month_card');
            btn_month = new Button(texture);
            btn_month.name= 'btn_month';
            btn_month.x = 197;
            btn_month.y = 272;
            btn_month.width = 65;
            btn_month.height = 65;
            this.addQuiackChild(btn_month);
            texture = assetMgr.getTexture('ui_button_city_qiandao');
            btn_sign = new Button(texture);
            btn_sign.name= 'btn_sign';
            btn_sign.x = 321;
            btn_sign.y = 272;
            btn_sign.width = 65;
            btn_sign.height = 65;
            this.addQuiackChild(btn_sign);
            texture = assetMgr.getTexture('ui_button_city_chengjiu');
            btn_reward = new Button(texture);
            btn_reward.name= 'btn_reward';
            btn_reward.x = 445;
            btn_reward.y = 272;
            btn_reward.width = 65;
            btn_reward.height = 65;
            this.addQuiackChild(btn_reward);
            init();
        }
        override public function dispose():void
        {
            btn_close.dispose();
            btn_first.dispose();
            btn_lucky.dispose();
            btn_share.dispose();
            btn_rank.dispose();
            btn_new.dispose();
            btn_vip.dispose();
            btn_month.dispose();
            btn_sign.dispose();
            btn_reward.dispose();
            super.dispose();
        
}
    }
}
