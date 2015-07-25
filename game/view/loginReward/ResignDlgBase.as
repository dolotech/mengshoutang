package game.view.loginReward {
    import com.dialog.Dialog;
    import com.utils.Assets;
    import com.utils.Constants;

    import game.manager.AssetMgr;

    import starling.display.Button;
    import starling.display.Image;
    import starling.text.TextField;
    import starling.textures.Texture;

    public class ResignDlgBase extends Dialog {
        public var txt_info:TextField;
        public var btn_ok:Button;
        public var txt_title:TextField;
        public var btn_close:Button;
        public var txt_close:TextField;
        public var txt_ok:TextField;

        public function ResignDlgBase() {
            var texture:Texture;
            var textField:TextField;
            var image:Image;
            var assetMgr:AssetMgr = AssetMgr.instance;
            texture = Assets.getTexture(Assets.MsgBg);
            image = new Image(texture);
            image.x = 0;
            image.y = 0;
            image.width = 456;
            image.height = 229;
            image.smoothing = Constants.smoothing;
            image.touchable = false;
            this.addQuiackChild(image);
            txt_info = new TextField(387, 80, '', '', 28, 0x3D2C1C, false);
            txt_info.touchable = false;
            txt_info.hAlign = 'center';
            txt_info.text = '本。关卡战斗结算请求';
            txt_info.x = 35;
            txt_info.y = 84;
            this.addQuiackChild(txt_info);
            texture = Assets.getTexture(Assets.MsgBtn);
            btn_ok = new Button(texture);
            btn_ok.x = 260;
            btn_ok.y = 178;
            this.addQuiackChild(btn_ok);
            txt_title = new TextField(236, 40, '', '', 28, 0x3D2C1C, false);
            txt_title.touchable = false;
            txt_title.hAlign = 'center';
            txt_title.text = '卡战斗结算';
            txt_title.x = 111;
            txt_title.y = 24;
            this.addQuiackChild(txt_title);
            texture = Assets.getTexture(Assets.MsgBtn);
            btn_close = new Button(texture);
            btn_close.x = 51;
            btn_close.y = 178;
            this.addQuiackChild(btn_close);
            txt_close = new TextField(104, 36, '', '', 24, 0xE7FFCA, false);
            txt_close.touchable = false;
            txt_close.hAlign = 'center';
            txt_close.text = '返 回';
            txt_close.x = 74;
            txt_close.y = 187;
            this.addQuiackChild(txt_close);
            txt_ok = new TextField(180, 36, '', '', 24, 0xE7FFCA, false);
            txt_ok.touchable = false;
            txt_ok.hAlign = 'center';
            txt_ok.text = '确 定';
            txt_ok.x = 245;
            txt_ok.y = 187;
            this.addQuiackChild(txt_ok);

            init()
        }

        override public function dispose():void {
            btn_ok.dispose();
            btn_close.dispose();
            super.dispose();

        }

    }
}