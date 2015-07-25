package game.view.tipPanel {
    import com.utils.Constants;

    import game.manager.AssetMgr;

    import starling.display.Button;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.text.TextField;
    import starling.textures.Texture;

    public class TipPanelVerifyBase extends Sprite {
        public var b1Image:Image;
        public var captionTxt:TextField;
        public var titleTxt:TextField;
        public var cancelButton:Button;
        public var okButton:Button;

        public function TipPanelVerifyBase() {
            var b1Texture:Texture = AssetMgr.instance.getTexture('ui_wudixingyunxing_xingxing_goumaikuang2');
            b1Image = new Image(b1Texture);
            b1Image.x = 339;
            b1Image.y = 177;
            b1Image.width = 302;
            b1Image.height = 301;
            this.addQuiackChild(b1Image);
            var ui_wudixingyunxing_xingxing_goumaikuang1268177Texture:Texture = AssetMgr.instance.getTexture('ui_wudixingyunxing_xingxing_goumaikuang1');
            var ui_wudixingyunxing_xingxing_goumaikuang1268177Image:Image = new Image(ui_wudixingyunxing_xingxing_goumaikuang1268177Texture);
            ui_wudixingyunxing_xingxing_goumaikuang1268177Image.x = 268;
            ui_wudixingyunxing_xingxing_goumaikuang1268177Image.y = 177;
            ui_wudixingyunxing_xingxing_goumaikuang1268177Image.width = 79;
            ui_wudixingyunxing_xingxing_goumaikuang1268177Image.height = 301;
            ui_wudixingyunxing_xingxing_goumaikuang1268177Image.smoothing = Constants.smoothing;
            ui_wudixingyunxing_xingxing_goumaikuang1268177Image.touchable = false;
            this.addQuiackChild(ui_wudixingyunxing_xingxing_goumaikuang1268177Image);
            var ui_wudixingyunxing_xingxing_goumaikuang1710177Texture:Texture = AssetMgr.instance.getTexture('ui_wudixingyunxing_xingxing_goumaikuang1');
            var ui_wudixingyunxing_xingxing_goumaikuang1710177Image:Image = new Image(ui_wudixingyunxing_xingxing_goumaikuang1710177Texture);
            ui_wudixingyunxing_xingxing_goumaikuang1710177Image.x = 710;
            ui_wudixingyunxing_xingxing_goumaikuang1710177Image.y = 177;
            ui_wudixingyunxing_xingxing_goumaikuang1710177Image.width = 79;
            ui_wudixingyunxing_xingxing_goumaikuang1710177Image.height = 301;
            ui_wudixingyunxing_xingxing_goumaikuang1710177Image.scaleX = -0.7703399658203125;
            ui_wudixingyunxing_xingxing_goumaikuang1710177Image.smoothing = Constants.smoothing;
            ui_wudixingyunxing_xingxing_goumaikuang1710177Image.touchable = false;
            this.addQuiackChild(ui_wudixingyunxing_xingxing_goumaikuang1710177Image);
            captionTxt = new TextField(394, 84, '', '', 30, 0xffffff, false);
            captionTxt.touchable = false;
            captionTxt.hAlign = 'left';
            captionTxt.x = 292;
            captionTxt.y = 295;
            this.addQuiackChild(captionTxt);
            titleTxt = new TextField(394, 62, '', '', 45, 0xffffff, false);
            titleTxt.touchable = false;
            titleTxt.hAlign = 'center';
            titleTxt.x = 293;
            titleTxt.y = 227;
            this.addQuiackChild(titleTxt);
            var cancelTexture:Texture = AssetMgr.instance.getTexture('ui_button_tiebaomutouanjian');
            cancelButton = new Button(cancelTexture);
            cancelButton.x = 299;
            cancelButton.y = 390;
            cancelButton.width = 156;
            cancelButton.height = 68;
            this.addQuiackChild(cancelButton);
            var okTexture:Texture = AssetMgr.instance.getTexture('ui_button_tiebaomutouanjian');
            okButton = new Button(okTexture);
            okButton.x = 506;
            okButton.y = 390;
            okButton.width = 156;
            okButton.height = 68;
            this.addQuiackChild(okButton);

        }

        override public function dispose():void {
            super.dispose();
            cancelButton.dispose();
            okButton.dispose();

        }

    }
}