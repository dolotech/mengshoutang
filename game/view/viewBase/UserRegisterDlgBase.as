package  game.view.viewBase
{
    import starling.display.Image;
    import game.manager.AssetMgr;
    import starling.display.Sprite;
    import starling.textures.Texture;
    import starling.text.TextField;
    import starling.display.Button;
    import flash.geom.Rectangle;
    import feathers.controls.TextInput;
    import com.dialog.Dialog;
    import com.utils.Constants;

    public class UserRegisterDlgBase extends Dialog
    {
        public var txt_tip:TextField;
        public var btn_cancel:Button;
        public var btn_ok:Button;
        public var userRegistTitle:TextField;
        public var userName:Image;
        public var password:Image;
        public var repeatPassword:Image;
        public var txt_error:TextField;
        public var input_user:TextInput;
        public var input_pwd1:TextInput;
        public var input_pwd2:TextInput;
        public var tag0:Image;
        public var tag1:Image;
        public var tag2:Image;

        public function UserRegisterDlgBase()
        {
            super(false);
            var texture:Texture;
            var textField:TextField;
            var image:Image;
            var button:Button;;
            var assetMgr:AssetMgr = AssetMgr.instance;
            texture =assetMgr.getTexture('ui_dengludi_muban');
            image = new Image(texture);
            image.x = 14;
            image.y = 78;
            image.width = 419;
            image.height = 66;
            image.smoothing= Constants.smoothing;
            image.touchable = false;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_dengludi_muban');
            image = new Image(texture);
            image.x = 14;
            image.y = 142;
            image.width = 419;
            image.height = 66;
            image.smoothing= Constants.smoothing;
            image.touchable = false;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_dengludi_muban');
            image = new Image(texture);
            image.x = 14;
            image.y = 207;
            image.width = 419;
            image.height = 66;
            image.smoothing= Constants.smoothing;
            image.touchable = false;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_dengludi_muban');
            image = new Image(texture);
            image.x = 14;
            image.y = 271;
            image.width = 419;
            image.height = 66;
            image.smoothing= Constants.smoothing;
            image.touchable = false;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_dengludi_muban');
            image = new Image(texture);
            image.x = 14;
            image.y = 335;
            image.width = 419;
            image.height = 66;
            image.smoothing= Constants.smoothing;
            image.touchable = false;
            this.addQuiackChild(image);
            txt_tip = new TextField(349,70,'','',20,0xE0D1B0,false);
            txt_tip.touchable = false;
            txt_tip.hAlign= 'center';
            txt_tip.text= '';
            txt_tip.x = 56;
            txt_tip.y = 145;
            this.addQuiackChild(txt_tip);
            texture = assetMgr.getTexture('ui_yonghuzhuce_button1');
            btn_cancel = new Button(texture);
            btn_cancel.name= 'btn_cancel';
            btn_cancel.x = 38;
            btn_cancel.y = 389;
            btn_cancel.width = 172;
            btn_cancel.height = 94;
            this.addQuiackChild(btn_cancel);
            btn_cancel.text= '返回';
            btn_cancel.fontColor= 0xFFA200;
            btn_cancel.fontSize= 34;
            texture = assetMgr.getTexture('ui_yonghuzhuce_button1');
            btn_ok = new Button(texture);
            btn_ok.name= 'btn_ok';
            btn_ok.x = 237;
            btn_ok.y = 389;
            btn_ok.width = 172;
            btn_ok.height = 94;
            this.addQuiackChild(btn_ok);
            btn_ok.text= '确定';
            btn_ok.fontColor= 0xFFA200;
            btn_ok.fontSize= 34;
            texture =assetMgr.getTexture('ui_dengludi_paizi');
            image = new Image(texture);
            image.x = 12;
            image.width = 423;
            image.height = 65;
            image.smoothing= Constants.smoothing;
            image.touchable = false;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_dengludi_tietiao1');
            image = new Image(texture);
            image.x = 5;
            image.y = 75;
            image.width = 16;
            image.height = 312;
            image.smoothing= Constants.smoothing;
            image.touchable = false;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_dengludi_tietiao2');
            image = new Image(texture);
            image.x = 16;
            image.y = 65;
            image.width = 415;
            image.height = 18;
            image.smoothing= Constants.smoothing;
            image.touchable = false;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_dengludi_yuankuang');
            image = new Image(texture);
            image.x = 379;
            image.y = 219;
            image.width = 42;
            image.height = 42;
            image.smoothing= Constants.smoothing;
            image.touchable = false;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_dengludi_yuankuang');
            image = new Image(texture);
            image.x = 379;
            image.y = 284;
            image.width = 42;
            image.height = 42;
            image.smoothing= Constants.smoothing;
            image.touchable = false;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_dengludi_tietiao2');
            image = new Image(texture);
            image.x = 16;
            image.y = 387;
            image.width = 415;
            image.height = 18;
            image.smoothing= Constants.smoothing;
            image.touchable = false;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_dengludi_guagou');
            image = new Image(texture);
            image.x = 38;
            image.y = 387;
            image.width = 26;
            image.height = 21;
            image.smoothing= Constants.smoothing;
            image.touchable = false;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_dengludi_tietiao1');
            image = new Image(texture);
            image.x = 425;
            image.y = 75;
            image.width = 16;
            image.height = 312;
            image.smoothing= Constants.smoothing;
            image.touchable = false;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_dengludi_guaijiao');
            image = new Image(texture);
            image.x = 443;
            image.y = 407;
            image.width = 32;
            image.height = 33;
            image.scaleX = -1;;
            image.scaleY = -1;;
            image.smoothing= Constants.smoothing;
            image.touchable = false;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_dengludi_guaijiao');
            image = new Image(texture);
            image.y = 407;
            image.width = 32;
            image.height = 33;
            image.scaleY = -1;;
            image.smoothing= Constants.smoothing;
            image.touchable = false;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_dengludi_guaijiao');
            image = new Image(texture);
            image.x = 443;
            image.y = 63;
            image.width = 32;
            image.height = 33;
            image.scaleX = -1;;
            image.smoothing= Constants.smoothing;
            image.touchable = false;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_dengludi_guaijiao');
            image = new Image(texture);
            image.y = 63;
            image.width = 32;
            image.height = 33;
            image.smoothing= Constants.smoothing;
            image.touchable = false;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_dengludi_guagou');
            image = new Image(texture);
            image.x = 408;
            image.y = 387;
            image.width = 26;
            image.height = 21;
            image.scaleX = -1;;
            image.smoothing= Constants.smoothing;
            image.touchable = false;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_dengludi_guagou');
            image = new Image(texture);
            image.x = 239;
            image.y = 387;
            image.width = 26;
            image.height = 21;
            image.smoothing= Constants.smoothing;
            image.touchable = false;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_dengludi_guagou');
            image = new Image(texture);
            image.x = 208;
            image.y = 387;
            image.width = 26;
            image.height = 21;
            image.scaleX = -1;;
            image.smoothing= Constants.smoothing;
            image.touchable = false;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_dengludi_yuankuang');
            image = new Image(texture);
            image.x = 379;
            image.y = 94;
            image.width = 42;
            image.height = 42;
            image.smoothing= Constants.smoothing;
            image.touchable = false;
            this.addQuiackChild(image);
            userRegistTitle = new TextField(272,57,'','',40,0xFFFECF,false);
            userRegistTitle.touchable = false;
            userRegistTitle.hAlign= 'center';
            userRegistTitle.text= '用户注册';
            userRegistTitle.x = 88;
            userRegistTitle.y = 4;
            this.addQuiackChild(userRegistTitle);
            texture = assetMgr.getTexture('ui_yonghuzhuce_wenbentiao')
            userName = new Image(texture);
            userName.x = 66;
            userName.y = 87;
            userName.width = 311;
            userName.height = 48;
            this.addQuiackChild(userName);
            userName.touchable = false;
            texture = assetMgr.getTexture('ui_yonghuzhuce_wenbentiao')
            password = new Image(texture);
            password.x = 66;
            password.y = 216;
            password.width = 311;
            password.height = 48;
            this.addQuiackChild(password);
            password.touchable = false;
            texture = assetMgr.getTexture('ui_yonghuzhuce_wenbentiao')
            repeatPassword = new Image(texture);
            repeatPassword.x = 66;
            repeatPassword.y = 279;
            repeatPassword.width = 311;
            repeatPassword.height = 48;
            this.addQuiackChild(repeatPassword);
            repeatPassword.touchable = false;
            txt_error = new TextField(390,40,'','',20,0xE8201B,false);
            txt_error.touchable = false;
            txt_error.hAlign= 'center';
            txt_error.text= '';
            txt_error.x = 32;
            txt_error.y = 345;
            this.addQuiackChild(txt_error);
            input_user = new TextInput();
            input_user.textEditorProperties.fontSize = 30;
            input_user.text = '';
            input_user.textEditorProperties.color = 0xFFF6EA;
            input_user.x = 70;
            input_user.y = 92;
            input_user.width = 302;
            input_user.height = 37;
            this.addQuiackChild(input_user);
            input_pwd1 = new TextInput();
            input_pwd1.textEditorProperties.fontSize = 30;
            input_pwd1.text = '';
            input_pwd1.textEditorProperties.color = 0xFFF6EA;
            input_pwd1.x = 70;
            input_pwd1.y = 222;
            input_pwd1.width = 302;
            input_pwd1.height = 37;
            this.addQuiackChild(input_pwd1);
            input_pwd2 = new TextInput();
            input_pwd2.textEditorProperties.fontSize = 30;
            input_pwd2.text = '';
            input_pwd2.textEditorProperties.color = 0xFFF6EA;
            input_pwd2.x = 70;
            input_pwd2.y = 287;
            input_pwd2.width = 302;
            input_pwd2.height = 37;
            this.addQuiackChild(input_pwd2);
            texture = assetMgr.getTexture('ui_yonghuzhuce_yuanquan2')
            tag0 = new Image(texture);
            tag0.x = 386;
            tag0.y = 100;
            tag0.width = 30;
            tag0.height = 29;
            this.addQuiackChild(tag0);
            tag0.touchable = false;
            texture = assetMgr.getTexture('ui_yonghuzhuce_yuanquan2')
            tag1 = new Image(texture);
            tag1.x = 386;
            tag1.y = 225;
            tag1.width = 30;
            tag1.height = 29;
            this.addQuiackChild(tag1);
            tag1.touchable = false;
            texture = assetMgr.getTexture('ui_yonghuzhuce_yuanquan2')
            tag2 = new Image(texture);
            tag2.x = 386;
            tag2.y = 290;
            tag2.width = 30;
            tag2.height = 29;
            this.addQuiackChild(tag2);
            tag2.touchable = false;
            init();
        }
        override public function dispose():void
        {
            btn_cancel.dispose();
            btn_ok.dispose();
            input_user.dispose();
            input_pwd1.dispose();
            input_pwd2.dispose();
            super.dispose();
        
}
    }
}
