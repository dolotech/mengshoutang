package game.view.activity.base.AllGiftsBase {
    import com.utils.Constants;
    import com.view.View;

    import game.manager.AssetMgr;

    import starling.display.Button;
    import starling.display.Image;
    import starling.text.TextField;
    import starling.textures.Texture;

    public class FriendLoginBase extends View {
        public var parImage:Image;
        public var r3Image:Image;
        public var text3Txt:TextField;
        public var r2Image:Image;
        public var text2Txt:TextField;
        public var r1Image:Image;
        public var text1Txt:TextField;
        public var contentTxt:TextField;
        public var r4Image:Image;
        public var text4Txt:TextField;
        public var receiveButton:Button;

        public function FriendLoginBase() {
            var ui_activities_diamond_search_kuang2024Texture:Texture = AssetMgr.instance.getTexture('ui_activities_diamond_search_kuang2');
            var ui_activities_diamond_search_kuang2024Image:Image = new Image(ui_activities_diamond_search_kuang2024Texture);
            ui_activities_diamond_search_kuang2024Image.x = 0;
            ui_activities_diamond_search_kuang2024Image.y = 24;
            ui_activities_diamond_search_kuang2024Image.width = 318;
            ui_activities_diamond_search_kuang2024Image.height = 307;
            ui_activities_diamond_search_kuang2024Image.smoothing = Constants.smoothing;
            ui_activities_diamond_search_kuang2024Image.touchable = false;
            this.addQuiackChild(ui_activities_diamond_search_kuang2024Image);
            var ui_activities_diamond_search_kuang100Texture:Texture = AssetMgr.instance.getTexture('ui_activities_diamond_search_kuang1');
            var ui_activities_diamond_search_kuang100Image:Image = new Image(ui_activities_diamond_search_kuang100Texture);
            ui_activities_diamond_search_kuang100Image.x = 0;
            ui_activities_diamond_search_kuang100Image.y = 0;
            ui_activities_diamond_search_kuang100Image.width = 318;
            ui_activities_diamond_search_kuang100Image.height = 28;
            ui_activities_diamond_search_kuang100Image.smoothing = Constants.smoothing;
            ui_activities_diamond_search_kuang100Image.touchable = false;
            this.addQuiackChild(ui_activities_diamond_search_kuang100Image);
            var ui_activities_diamond_search_kuang30321Texture:Texture = AssetMgr.instance.getTexture('ui_activities_diamond_search_kuang3');
            var ui_activities_diamond_search_kuang30321Image:Image = new Image(ui_activities_diamond_search_kuang30321Texture);
            ui_activities_diamond_search_kuang30321Image.x = 0;
            ui_activities_diamond_search_kuang30321Image.y = 321;
            ui_activities_diamond_search_kuang30321Image.width = 318;
            ui_activities_diamond_search_kuang30321Image.height = 64;
            ui_activities_diamond_search_kuang30321Image.smoothing = Constants.smoothing;
            ui_activities_diamond_search_kuang30321Image.touchable = false;
            this.addQuiackChild(ui_activities_diamond_search_kuang30321Image);
            var ui_activities_diamond_search_kuang40240Texture:Texture = AssetMgr.instance.getTexture('ui_activities_diamond_search_kuang4');
            var ui_activities_diamond_search_kuang40240Image:Image = new Image(ui_activities_diamond_search_kuang40240Texture);
            ui_activities_diamond_search_kuang40240Image.x = 0;
            ui_activities_diamond_search_kuang40240Image.y = 240;
            ui_activities_diamond_search_kuang40240Image.width = 318;
            ui_activities_diamond_search_kuang40240Image.height = 23;
            ui_activities_diamond_search_kuang40240Image.smoothing = Constants.smoothing;
            ui_activities_diamond_search_kuang40240Image.touchable = false;
            this.addQuiackChild(ui_activities_diamond_search_kuang40240Image);
            var ui_activities_diamond_search_denglu466Texture:Texture = AssetMgr.instance.getTexture('ui_activities_diamond_search_denglu');
            var ui_activities_diamond_search_denglu466Image:Image = new Image(ui_activities_diamond_search_denglu466Texture);
            ui_activities_diamond_search_denglu466Image.x = 46;
            ui_activities_diamond_search_denglu466Image.y = 6;
            ui_activities_diamond_search_denglu466Image.width = 209;
            ui_activities_diamond_search_denglu466Image.height = 114;
            ui_activities_diamond_search_denglu466Image.smoothing = Constants.smoothing;
            ui_activities_diamond_search_denglu466Image.touchable = false;
            this.addQuiackChild(ui_activities_diamond_search_denglu466Image);
            var ui_activities_diamond_search_denglu121181Texture:Texture = AssetMgr.instance.getTexture('ui_activities_diamond_search_denglu1');
            var ui_activities_diamond_search_denglu121181Image:Image = new Image(ui_activities_diamond_search_denglu121181Texture);
            ui_activities_diamond_search_denglu121181Image.x = 21;
            ui_activities_diamond_search_denglu121181Image.y = 181;
            ui_activities_diamond_search_denglu121181Image.width = 264;
            ui_activities_diamond_search_denglu121181Image.height = 56;
            ui_activities_diamond_search_denglu121181Image.smoothing = Constants.smoothing;
            ui_activities_diamond_search_denglu121181Image.touchable = false;
            this.addQuiackChild(ui_activities_diamond_search_denglu121181Image);
            var parTexture:Texture = AssetMgr.instance.getTexture('ui_activities_diamond_search_denglu2');
            parImage = new Image(parTexture);
            parImage.x = 43;
            parImage.y = 205;
            parImage.width = 190;
            parImage.height = 10;
            this.addQuiackChild(parImage);
            var r3Texture:Texture = AssetMgr.instance.getTexture('ui_activities_diamond_search_denglu4');
            r3Image = new Image(r3Texture);
            r3Image.x = 147;
            r3Image.y = 192;
            r3Image.width = 36;
            r3Image.height = 37;
            this.addQuiackChild(r3Image);
            text3Txt = new TextField(47, 34, '', '', 20, 0xec5b2b, false);
            text3Txt.touchable = false;
            text3Txt.hAlign = 'center';
            text3Txt.x = 140;
            text3Txt.y = 194;
            this.addQuiackChild(text3Txt);
            var r2Texture:Texture = AssetMgr.instance.getTexture('ui_activities_diamond_search_denglu4');
            r2Image = new Image(r2Texture);
            r2Image.x = 84;
            r2Image.y = 192;
            r2Image.width = 36;
            r2Image.height = 37;
            this.addQuiackChild(r2Image);
            text2Txt = new TextField(46, 34, '', '', 20, 0xec5b2b, false);
            text2Txt.touchable = false;
            text2Txt.hAlign = 'center';
            text2Txt.x = 79;
            text2Txt.y = 195;
            this.addQuiackChild(text2Txt);
            var r1Texture:Texture = AssetMgr.instance.getTexture('ui_activities_diamond_search_denglu4');
            r1Image = new Image(r1Texture);
            r1Image.x = 26;
            r1Image.y = 191;
            r1Image.width = 36;
            r1Image.height = 37;
            this.addQuiackChild(r1Image);
            text1Txt = new TextField(44, 34, '', '', 20, 0xec5b2b, false);
            text1Txt.touchable = false;
            text1Txt.hAlign = 'center';
            text1Txt.x = 21;
            text1Txt.y = 195;
            this.addQuiackChild(text1Txt);
            contentTxt = new TextField(270, 75, '', '', 20, 0xffff99, false);
            contentTxt.touchable = false;
            contentTxt.hAlign = 'center';
            contentTxt.x = 15;
            contentTxt.y = 105;
            this.addQuiackChild(contentTxt);
            var r4Texture:Texture = AssetMgr.instance.getTexture('ui_activities_diamond_search_denglu4');
            r4Image = new Image(r4Texture);
            r4Image.x = 233;
            r4Image.y = 185;
            r4Image.width = 47;
            r4Image.height = 48;
            this.addQuiackChild(r4Image);
            text4Txt = new TextField(48, 34, '', '', 20, 0xec5b2b, false);
            text4Txt.touchable = false;
            text4Txt.hAlign = 'center';
            text4Txt.x = 231;
            text4Txt.y = 194;
            this.addQuiackChild(text4Txt);
            var receiveTexture:Texture = AssetMgr.instance.getTexture('ui_button_tiebaomutouanjian');
            receiveButton = new Button(receiveTexture);
            receiveButton.x = 133;
            receiveButton.y = 275;
            this.addQuiackChild(receiveButton);
            var lableTxt:TextField;
            lableTxt = new TextField(160, 54, '', '', 30, 0xffffcc, false);
            lableTxt.touchable = false;
            lableTxt.hAlign = 'center';
            lableTxt.x = -5;
            lableTxt.y = 12;
            receiveButton.addQuiackChild(lableTxt);
            lableTxt.name = 'lable';

        }

        override public function dispose():void {
            receiveButton.dispose();
            super.dispose();

        }

    }
}