package game.view.rank.ui {
    import com.utils.Constants;

    import game.base.JTSprite;
    import game.manager.AssetMgr;

    import starling.display.Button;
    import starling.display.Image;
    import starling.text.TextField;
    import starling.textures.Texture;

    public class JTUIHeroPropertyBackground extends JTSprite {
        public var lookButton:Button;
        public var txt_titleTxt:TextField;

        public function JTUIHeroPropertyBackground() {
            var ui_gongyong_zhiwanzidi0300Texture:Texture = AssetMgr.instance.getTexture('ui_gongyong_zhiwanzidi');
            var ui_gongyong_zhiwanzidi0300Image:Image = new Image(ui_gongyong_zhiwanzidi0300Texture);
            ui_gongyong_zhiwanzidi0300Image.x = 0;
            ui_gongyong_zhiwanzidi0300Image.y = 300;
            ui_gongyong_zhiwanzidi0300Image.width = 309;
            ui_gongyong_zhiwanzidi0300Image.height = 151;
            ui_gongyong_zhiwanzidi0300Image.scaleY = -1;
            ui_gongyong_zhiwanzidi0300Image.smoothing = Constants.smoothing;
            ui_gongyong_zhiwanzidi0300Image.touchable = false;
            this.addQuiackChild(ui_gongyong_zhiwanzidi0300Image);
            var ui_gongyong_bumangdi_shangbianyikuaitie79295Texture:Texture = AssetMgr.instance.getTexture('ui_gongyong_bumangdi_shangbianyikuaitie');
            var ui_gongyong_bumangdi_shangbianyikuaitie79295Image:Image = new Image(ui_gongyong_bumangdi_shangbianyikuaitie79295Texture);
            ui_gongyong_bumangdi_shangbianyikuaitie79295Image.x = 79;
            ui_gongyong_bumangdi_shangbianyikuaitie79295Image.y = 295;
            ui_gongyong_bumangdi_shangbianyikuaitie79295Image.width = 30;
            ui_gongyong_bumangdi_shangbianyikuaitie79295Image.height = 21;
            ui_gongyong_bumangdi_shangbianyikuaitie79295Image.scaleY = -1;
            ui_gongyong_bumangdi_shangbianyikuaitie79295Image.smoothing = Constants.smoothing;
            ui_gongyong_bumangdi_shangbianyikuaitie79295Image.touchable = false;
            this.addQuiackChild(ui_gongyong_bumangdi_shangbianyikuaitie79295Image);
            var lookTexture:Texture = AssetMgr.instance.getTexture('ui_button_shuxingchakananniu');
            lookButton = new Button(lookTexture);
            lookButton.x = 92;
            lookButton.y = 294;
            this.addQuiackChild(lookButton);
            var ui_gongyong_bumangdi_shangbianyikuaitie241295Texture:Texture = AssetMgr.instance.getTexture('ui_gongyong_bumangdi_shangbianyikuaitie');
            var ui_gongyong_bumangdi_shangbianyikuaitie241295Image:Image = new Image(ui_gongyong_bumangdi_shangbianyikuaitie241295Texture);
            ui_gongyong_bumangdi_shangbianyikuaitie241295Image.x = 241;
            ui_gongyong_bumangdi_shangbianyikuaitie241295Image.y = 295;
            ui_gongyong_bumangdi_shangbianyikuaitie241295Image.width = 30;
            ui_gongyong_bumangdi_shangbianyikuaitie241295Image.height = 21;
            ui_gongyong_bumangdi_shangbianyikuaitie241295Image.scaleX = -1;
            ui_gongyong_bumangdi_shangbianyikuaitie241295Image.scaleY = -1;
            ui_gongyong_bumangdi_shangbianyikuaitie241295Image.smoothing = Constants.smoothing;
            ui_gongyong_bumangdi_shangbianyikuaitie241295Image.touchable = false;
            this.addQuiackChild(ui_gongyong_bumangdi_shangbianyikuaitie241295Image);
            var ui_gongyong_zhiwanzidi00Texture:Texture = AssetMgr.instance.getTexture('ui_gongyong_zhiwanzidi');
            var ui_gongyong_zhiwanzidi00Image:Image = new Image(ui_gongyong_zhiwanzidi00Texture);
            ui_gongyong_zhiwanzidi00Image.x = 0;
            ui_gongyong_zhiwanzidi00Image.y = 0;
            ui_gongyong_zhiwanzidi00Image.width = 309;
            ui_gongyong_zhiwanzidi00Image.height = 151;
            ui_gongyong_zhiwanzidi00Image.smoothing = Constants.smoothing;
            ui_gongyong_zhiwanzidi00Image.touchable = false;
            this.addQuiackChild(ui_gongyong_zhiwanzidi00Image);
            var ui_gongyong_zhiwanzidi177Texture:Texture = AssetMgr.instance.getTexture('ui_gongyong_zhiwanzidi1');
            var ui_gongyong_zhiwanzidi177Image:Image = new Image(ui_gongyong_zhiwanzidi177Texture);
            ui_gongyong_zhiwanzidi177Image.x = 7;
            ui_gongyong_zhiwanzidi177Image.y = 7;
            ui_gongyong_zhiwanzidi177Image.width = 21;
            ui_gongyong_zhiwanzidi177Image.height = 33;
            ui_gongyong_zhiwanzidi177Image.smoothing = Constants.smoothing;
            ui_gongyong_zhiwanzidi177Image.touchable = false;
            this.addQuiackChild(ui_gongyong_zhiwanzidi177Image);
            var ui_gongyong_zhiwanzidi13037Texture:Texture = AssetMgr.instance.getTexture('ui_gongyong_zhiwanzidi1');
            var ui_gongyong_zhiwanzidi13037Image:Image = new Image(ui_gongyong_zhiwanzidi13037Texture);
            ui_gongyong_zhiwanzidi13037Image.x = 303;
            ui_gongyong_zhiwanzidi13037Image.y = 7;
            ui_gongyong_zhiwanzidi13037Image.width = 21;
            ui_gongyong_zhiwanzidi13037Image.height = 33;
            ui_gongyong_zhiwanzidi13037Image.scaleX = -1;
            ui_gongyong_zhiwanzidi13037Image.smoothing = Constants.smoothing;
            ui_gongyong_zhiwanzidi13037Image.touchable = false;
            this.addQuiackChild(ui_gongyong_zhiwanzidi13037Image);
            var ui_gongyong_zhiwanzidi_wenzikuang7015Texture:Texture = AssetMgr.instance.getTexture('ui_gongyong_zhiwanzidi_wenzikuang');
            var ui_gongyong_zhiwanzidi_wenzikuang7015Image:Image = new Image(ui_gongyong_zhiwanzidi_wenzikuang7015Texture);
            ui_gongyong_zhiwanzidi_wenzikuang7015Image.x = 70;
            ui_gongyong_zhiwanzidi_wenzikuang7015Image.y = 15;
            ui_gongyong_zhiwanzidi_wenzikuang7015Image.width = 26;
            ui_gongyong_zhiwanzidi_wenzikuang7015Image.height = 36;
            ui_gongyong_zhiwanzidi_wenzikuang7015Image.smoothing = Constants.smoothing;
            ui_gongyong_zhiwanzidi_wenzikuang7015Image.touchable = false;
            this.addQuiackChild(ui_gongyong_zhiwanzidi_wenzikuang7015Image);
            var ui_gongyong_zhiwanzidi_wenzikuang18115Texture:Texture = AssetMgr.instance.getTexture('ui_gongyong_zhiwanzidi_wenzikuang1');
            var ui_gongyong_zhiwanzidi_wenzikuang18115Image:Image = new Image(ui_gongyong_zhiwanzidi_wenzikuang18115Texture);
            ui_gongyong_zhiwanzidi_wenzikuang18115Image.x = 81;
            ui_gongyong_zhiwanzidi_wenzikuang18115Image.y = 15;
            ui_gongyong_zhiwanzidi_wenzikuang18115Image.width = 158;
            ui_gongyong_zhiwanzidi_wenzikuang18115Image.height = 36;
            ui_gongyong_zhiwanzidi_wenzikuang18115Image.smoothing = Constants.smoothing;
            ui_gongyong_zhiwanzidi_wenzikuang18115Image.touchable = false;
            this.addQuiackChild(ui_gongyong_zhiwanzidi_wenzikuang18115Image);
            var ui_gongyong_zhiwanzidi_wenzikuang25315Texture:Texture = AssetMgr.instance.getTexture('ui_gongyong_zhiwanzidi_wenzikuang');
            var ui_gongyong_zhiwanzidi_wenzikuang25315Image:Image = new Image(ui_gongyong_zhiwanzidi_wenzikuang25315Texture);
            ui_gongyong_zhiwanzidi_wenzikuang25315Image.x = 253;
            ui_gongyong_zhiwanzidi_wenzikuang25315Image.y = 15;
            ui_gongyong_zhiwanzidi_wenzikuang25315Image.width = 26;
            ui_gongyong_zhiwanzidi_wenzikuang25315Image.height = 36;
            ui_gongyong_zhiwanzidi_wenzikuang25315Image.scaleX = -1.09063720703125;
            ui_gongyong_zhiwanzidi_wenzikuang25315Image.smoothing = Constants.smoothing;
            ui_gongyong_zhiwanzidi_wenzikuang25315Image.touchable = false;
            this.addQuiackChild(ui_gongyong_zhiwanzidi_wenzikuang25315Image);
            txt_titleTxt = new TextField(102, 30, '', '', 18, 0x191919, false);
            txt_titleTxt.touchable = false;
            txt_titleTxt.hAlign = 'center';
            txt_titleTxt.x = 109;
            txt_titleTxt.y = 300;
            this.addQuiackChild(txt_titleTxt);

        }

        override public function dispose():void {
            lookButton.dispose();
            super.dispose();

        }

    }
}