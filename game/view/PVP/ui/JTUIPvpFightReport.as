package game.view.PVP.ui {
    import com.utils.Constants;

    import game.base.JTSprite;
    import game.manager.AssetMgr;

    import starling.display.Button;
    import starling.display.Image;
    import starling.text.TextField;
    import starling.textures.Texture;

    public class JTUIPvpFightReport extends JTSprite {
        public var btn_pk:Button = null;
        public var txt_about:TextField = null;

        public function JTUIPvpFightReport() {
            var txture_ui_gongyong_dingzimutiao700:Texture = AssetMgr.instance.getTexture('ui_gongyong_dingzimutiao');
            var ui_gongyong_dingzimutiao700img_2:Image = new Image(txture_ui_gongyong_dingzimutiao700);
            ui_gongyong_dingzimutiao700img_2.x = 70;
            ui_gongyong_dingzimutiao700img_2.y = 0;
            ui_gongyong_dingzimutiao700img_2.width = 478;
            ui_gongyong_dingzimutiao700img_2.height = 66;
            ui_gongyong_dingzimutiao700img_2.smoothing = Constants.smoothing;
            ui_gongyong_dingzimutiao700img_2.touchable = false;
            this.addQuiackChild(ui_gongyong_dingzimutiao700img_2);
            var txture_ui_gongyong_dingzimutiao4780:Texture = AssetMgr.instance.getTexture('ui_gongyong_dingzimutiao');
            var ui_gongyong_dingzimutiao4780img_3:Image = new Image(txture_ui_gongyong_dingzimutiao4780);
            ui_gongyong_dingzimutiao4780img_3.x = 478;
            ui_gongyong_dingzimutiao4780img_3.y = 0;
            ui_gongyong_dingzimutiao4780img_3.width = 478;
            ui_gongyong_dingzimutiao4780img_3.height = 66;
            ui_gongyong_dingzimutiao4780img_3.scaleX = -0.923370361328125;
            ui_gongyong_dingzimutiao4780img_3.smoothing = Constants.smoothing;
            ui_gongyong_dingzimutiao4780img_3.touchable = false;
            this.addQuiackChild(ui_gongyong_dingzimutiao4780img_3);
            var btn_pk_txture:Texture = AssetMgr.instance.getTexture('ui_tubiao_rongyufenleianniu_jingji');
            btn_pk = new Button(btn_pk_txture);
            btn_pk.x = 446;
            btn_pk.y = 3;
            this.addQuiackChild(btn_pk);
            var txture_ui_wenzi_fuchou44929:Texture = AssetMgr.instance.getTexture('ui_wenzi_fuchou');
            var ui_wenzi_fuchou44929img_4:Image = new Image(txture_ui_wenzi_fuchou44929);
            ui_wenzi_fuchou44929img_4.x = 449;
            ui_wenzi_fuchou44929img_4.y = 29;
            ui_wenzi_fuchou44929img_4.width = 58;
            ui_wenzi_fuchou44929img_4.height = 35;
            ui_wenzi_fuchou44929img_4.smoothing = Constants.smoothing;
            ui_wenzi_fuchou44929img_4.touchable = false;
            this.addQuiackChild(ui_wenzi_fuchou44929img_4);
            txt_about = new TextField(408, 59, '', '', 18, 0xEED6BE, false);
            txt_about.touchable = false;
            txt_about.hAlign = 'left';
            txt_about.isHtml = true;
            txt_about.x = 56;
            txt_about.y = 5;
            this.addQuiackChild(txt_about);

        }

        override public function dispose():void {
            btn_pk.dispose();
            super.dispose();

        }

    }
}