package game.view.activity.base.AllGiftsBase {
    import com.dialog.Dialog;
    import com.utils.Constants;

    import flash.geom.Rectangle;
    import flash.text.StageText;

    import game.manager.AssetMgr;

    import starling.core.Starling;
    import starling.display.Button;
    import starling.display.Image;
    import starling.text.TextField;
    import starling.textures.Texture;

    public class InputCodeBase extends Dialog {
        public var bgSkinImage:Image;
        public var inputUseCodeTxt:TextField;
        public var noButton:Button;
        public var yesButton:Button;
        public var inputCodeTxt:StageText;

        public function InputCodeBase() {
            var ui_wudixingyunxing_xingxing_goumaikuang100Texture:Texture = AssetMgr.instance.getTexture('ui_wudixingyunxing_xingxing_goumaikuang1');
            var ui_wudixingyunxing_xingxing_goumaikuang100Image:Image = new Image(ui_wudixingyunxing_xingxing_goumaikuang100Texture);
            ui_wudixingyunxing_xingxing_goumaikuang100Image.x = 0;
            ui_wudixingyunxing_xingxing_goumaikuang100Image.y = 0;
            ui_wudixingyunxing_xingxing_goumaikuang100Image.width = 102;
            ui_wudixingyunxing_xingxing_goumaikuang100Image.height = 391;
            ui_wudixingyunxing_xingxing_goumaikuang100Image.smoothing = Constants.smoothing;
            ui_wudixingyunxing_xingxing_goumaikuang100Image.touchable = false;
            this.addQuiackChild(ui_wudixingyunxing_xingxing_goumaikuang100Image);
            var ui_wudixingyunxing_xingxing_goumaikuang2900Texture:Texture = AssetMgr.instance.getTexture('ui_wudixingyunxing_xingxing_goumaikuang2');
            var ui_wudixingyunxing_xingxing_goumaikuang2900Image:Image = new Image(ui_wudixingyunxing_xingxing_goumaikuang2900Texture);
            ui_wudixingyunxing_xingxing_goumaikuang2900Image.x = 90;
            ui_wudixingyunxing_xingxing_goumaikuang2900Image.y = 0;
            ui_wudixingyunxing_xingxing_goumaikuang2900Image.width = 399;
            ui_wudixingyunxing_xingxing_goumaikuang2900Image.height = 391;
            ui_wudixingyunxing_xingxing_goumaikuang2900Image.smoothing = Constants.smoothing;
            ui_wudixingyunxing_xingxing_goumaikuang2900Image.touchable = false;
            this.addQuiackChild(ui_wudixingyunxing_xingxing_goumaikuang2900Image);
            var bgSkinTexture:Texture = AssetMgr.instance.getTexture('ui_yonghuzhuce_wenbentiao');
            bgSkinImage = new Image(bgSkinTexture);
            bgSkinImage.x = 130;
            bgSkinImage.y = 212;
            bgSkinImage.width = 311;
            bgSkinImage.height = 48;
            this.addQuiackChild(bgSkinImage);
            var ui_wudixingyunxing_xingxing_goumaikuang15760Texture:Texture = AssetMgr.instance.getTexture('ui_wudixingyunxing_xingxing_goumaikuang1');
            var ui_wudixingyunxing_xingxing_goumaikuang15760Image:Image = new Image(ui_wudixingyunxing_xingxing_goumaikuang15760Texture);
            ui_wudixingyunxing_xingxing_goumaikuang15760Image.x = 576;
            ui_wudixingyunxing_xingxing_goumaikuang15760Image.y = 0;
            ui_wudixingyunxing_xingxing_goumaikuang15760Image.width = 102;
            ui_wudixingyunxing_xingxing_goumaikuang15760Image.height = 391;
            ui_wudixingyunxing_xingxing_goumaikuang15760Image.scaleX = -1;
            ui_wudixingyunxing_xingxing_goumaikuang15760Image.smoothing = Constants.smoothing;
            ui_wudixingyunxing_xingxing_goumaikuang15760Image.touchable = false;
            this.addQuiackChild(ui_wudixingyunxing_xingxing_goumaikuang15760Image);
            var ui_activities_diamond_search_yaoqingma16132Texture:Texture = AssetMgr.instance.getTexture('ui_activities_diamond_search_yaoqingma');
            var ui_activities_diamond_search_yaoqingma16132Image:Image = new Image(ui_activities_diamond_search_yaoqingma16132Texture);
            ui_activities_diamond_search_yaoqingma16132Image.x = 161;
            ui_activities_diamond_search_yaoqingma16132Image.y = 32;
            ui_activities_diamond_search_yaoqingma16132Image.width = 216;
            ui_activities_diamond_search_yaoqingma16132Image.height = 76;
            ui_activities_diamond_search_yaoqingma16132Image.smoothing = Constants.smoothing;
            ui_activities_diamond_search_yaoqingma16132Image.touchable = false;
            this.addQuiackChild(ui_activities_diamond_search_yaoqingma16132Image);
            inputUseCodeTxt = new TextField(570, 54, '', '', 34, 0xebb521, false);
            inputUseCodeTxt.touchable = false;
            inputUseCodeTxt.hAlign = 'center';
            inputUseCodeTxt.x = 6;
            inputUseCodeTxt.y = 138;
            this.addQuiackChild(inputUseCodeTxt);
            var noTexture:Texture = AssetMgr.instance.getTexture('ui_button_tiebaomutouanjian');
            noButton = new Button(noTexture);
            noButton.x = 333;
            noButton.y = 298;
            this.addQuiackChild(noButton);
            var lableTxt:TextField;
            lableTxt = new TextField(160, 54, '', '', 30, 0xffffcc, false);
            lableTxt.touchable = false;
            lableTxt.hAlign = 'center';
            lableTxt.x = -5;
            lableTxt.y = 12;
            noButton.addQuiackChild(lableTxt);
            lableTxt.name = 'lable';
            var yesTexture:Texture = AssetMgr.instance.getTexture('ui_button_tiebaomutouanjian');
            yesButton = new Button(yesTexture);
            yesButton.x = 95;
            yesButton.y = 298;
            this.addQuiackChild(yesButton);
            lableTxt = new TextField(160, 54, '', '', 30, 0xffffcc, false);
            lableTxt.touchable = false;
            lableTxt.hAlign = 'center';
            lableTxt.x = -5;
            lableTxt.y = 12;
            yesButton.addQuiackChild(lableTxt);
            lableTxt.name = 'lable';
            inputCodeTxt = new StageText();
            inputCodeTxt.fontSize = 28 * Starling.contentScaleFactor;
            inputCodeTxt.text = '';
            inputCodeTxt.color = 0xebb521;
            inputCodeTxt.stage = Starling.current.nativeStage;
            var starlingViewPort:Rectangle = Starling.current.viewPort;
            var stageTextViewPort:Rectangle = inputCodeTxt.viewPort;
            if (!stageTextViewPort) {
                stageTextViewPort = new Rectangle();
            }
            stageTextViewPort.x = Math.round(starlingViewPort.x + (136 * Starling.contentScaleFactor));
            stageTextViewPort.y = Math.round(starlingViewPort.y + (218 * Starling.contentScaleFactor));
            stageTextViewPort.width = 295;
            stageTextViewPort.height = 38;
            inputCodeTxt.viewPort = stageTextViewPort;
            inputCodeTxt.viewPort = stageTextViewPort;
            inputCodeTxt.maxChars = 0;

        }

        override public function dispose():void {
            noButton.dispose();
            yesButton.dispose();
            inputCodeTxt.stage = null;
            inputCodeTxt.dispose();
            super.dispose();

        }

    }
}