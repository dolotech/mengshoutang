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
    import com.dialog.Dialog;

    public class SelectServerDlgBase extends Dialog
    {
        public var btn_bg:Button;
        public var btn_registered:Button;
        public var tag_new:Image;
        public var btn_change:Button;
        public var btn_login:Button;
        public var tag_hot:Image;
        public var txt_servername:TextField;
        public var txt_des:TextField;

        public function SelectServerDlgBase()
        {
            super(false);
            var texture:Texture;
            var textField:TextField;
            var image:Image;
            var button:Button;;
            var assetMgr:AssetMgr = AssetMgr.instance;
            texture =assetMgr.getTexture('ui_denglubeijing_logo');
            image = new Image(texture);
            image.x = 62;
            image.width = 519;
            image.height = 398;
            image.smoothing= Constants.NONE;
            this.addQuiackChild(image);
            texture = assetMgr.getTexture('ui_district_transparent_bottom');
            btn_bg = new Button(texture);
            btn_bg.name= 'btn_bg';
            btn_bg.x = 89;
            btn_bg.y = 504;
            btn_bg.width = 517;
            btn_bg.height = 42;
            this.addQuiackChild(btn_bg);
            texture = assetMgr.getTexture('ui_yonghuzhuce_button2');
            btn_registered = new Button(texture);
            btn_registered.name= 'btn_registered';
            btn_registered.x = 208;
            btn_registered.y = 274;
            btn_registered.width = 254;
            btn_registered.height = 94;
            this.addQuiackChild(btn_registered);
            btn_registered.text= '快速登录';
            btn_registered.fontColor= 0xFFFFC9;
            btn_registered.fontSize= 34;
            texture = assetMgr.getTexture('ui_district_iocn_xinqu')
            tag_new = new Image(texture);
            tag_new.x = 431;
            tag_new.y = 486;
            tag_new.width = 61;
            tag_new.height = 47;
            this.addQuiackChild(tag_new);
            tag_new.touchable = false;
            texture = assetMgr.getTexture('ui_district_genghuanxuanqu');
            btn_change = new Button(texture);
            btn_change.name= 'btn_change';
            btn_change.x = 500;
            btn_change.y = 488;
            btn_change.width = 144;
            btn_change.height = 73;
            this.addQuiackChild(btn_change);
            texture = assetMgr.getTexture('ui_yonghuzhuce_button2');
            btn_login = new Button(texture);
            btn_login.name= 'btn_login';
            btn_login.x = 208;
            btn_login.y = 379;
            btn_login.width = 254;
            btn_login.height = 94;
            this.addQuiackChild(btn_login);
            btn_login.text= '老账号登录';
            btn_login.fontColor= 0xFFFFC9;
            btn_login.fontSize= 30;
            texture = assetMgr.getTexture('ui_district_iocn_huobao')
            tag_hot = new Image(texture);
            tag_hot.x = 431;
            tag_hot.y = 486;
            tag_hot.width = 61;
            tag_hot.height = 47;
            this.addQuiackChild(tag_hot);
            tag_hot.touchable = false;
            txt_servername = new TextField(254,44,'','',28,0xFFFFC9,false);
            txt_servername.touchable = false;
            txt_servername.hAlign= 'center';
            txt_servername.text= '';
            txt_servername.x = 202;
            txt_servername.y = 503;
            this.addQuiackChild(txt_servername);
            txt_des = new TextField(194,36,'','',24,0x00FB01,false);
            txt_des.touchable = false;
            txt_des.hAlign= 'left';
            txt_des.text= '当前所在大区';
            txt_des.y = 508;
            this.addQuiackChild(txt_des);
            init();
        }
        override public function dispose():void
        {
            btn_bg.dispose();
            btn_registered.dispose();
            btn_change.dispose();
            btn_login.dispose();
            super.dispose();
        
}
    }
}
