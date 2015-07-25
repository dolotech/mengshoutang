package game.dialog {
    import com.dialog.Dialog;
    import com.utils.Assets;
    import com.utils.Constants;

    import starling.display.Button;
    import starling.display.Image;
    import starling.text.TextField;
    import starling.textures.Texture;
    import starling.textures.TextureSmoothing;

    public class MsgDlgBase extends Dialog {
        public var contentTxt:TextField;
        public var okButton:Button;
        public var titleTxt:TextField;

        public function MsgDlgBase() {
            var ui_zhibantishikuang_di00Texture:Texture = Assets.getTexture(Assets.MsgBg);
            var ui_zhibantishikuang_di00Image:Image = new Image(ui_zhibantishikuang_di00Texture);
            ui_zhibantishikuang_di00Image.x = 0;
            ui_zhibantishikuang_di00Image.y = 0;
            ui_zhibantishikuang_di00Image.width = 456;
            ui_zhibantishikuang_di00Image.height = 229;
            ui_zhibantishikuang_di00Image.smoothing = Constants.smoothing;
            ui_zhibantishikuang_di00Image.touchable = false;
            this.addQuiackChild(ui_zhibantishikuang_di00Image);
            contentTxt = new TextField(387, 80, '', '', 28, 0x3D2C1C, false);
            contentTxt.touchable = false;
            contentTxt.hAlign = 'center';
            contentTxt.x = 35;
            contentTxt.y = 80;
            this.addQuiackChild(contentTxt);
            var okTexture:Texture = Assets.getTexture(Assets.MsgBtn);
            okButton = new Button(okTexture);
            okButton.x = 159;
            okButton.y = 152;
            okButton.width = 150;
            okButton.height = 55;
            this.addQuiackChild(okButton);
            titleTxt = new TextField(236, 40, '', '', 28, 0x3D2C1C, false);
            titleTxt.touchable = false;
            titleTxt.hAlign = 'center';
            titleTxt.x = 111;
            titleTxt.y = 24;
            this.addQuiackChild(titleTxt);

        }

        override public function dispose():void {
            super.dispose();
            okButton.dispose();
            contentTxt.dispose();
            titleTxt.dispose();
        }

    }
}