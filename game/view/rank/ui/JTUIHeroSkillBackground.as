package game.view.rank.ui {
    import com.utils.Constants;

    import game.base.JTSprite;
    import game.manager.AssetMgr;

    import starling.display.Button;
    import starling.display.Image;
    import starling.text.TextField;
    import starling.textures.Texture;

    public class JTUIHeroSkillBackground extends JTSprite {
        public var lookButton:Button;
        public var txt_stateTxt:TextField;

        public function JTUIHeroSkillBackground() {
            var ui_gongyong_zhiwanzidi532405Texture:Texture = AssetMgr.instance.getTexture('ui_gongyong_zhiwanzidi');
            var ui_gongyong_zhiwanzidi532405Image:Image = new Image(ui_gongyong_zhiwanzidi532405Texture);
            ui_gongyong_zhiwanzidi532405Image.x = 532;
            ui_gongyong_zhiwanzidi532405Image.y = 405;
            ui_gongyong_zhiwanzidi532405Image.width = 309;
            ui_gongyong_zhiwanzidi532405Image.height = 151;
            ui_gongyong_zhiwanzidi532405Image.scaleY = -1;
            ui_gongyong_zhiwanzidi532405Image.smoothing = Constants.smoothing;
            ui_gongyong_zhiwanzidi532405Image.touchable = false;
            this.addQuiackChild(ui_gongyong_zhiwanzidi532405Image);
            var ui_gongyong_bumangdi_shangbianyikuaitie611401Texture:Texture = AssetMgr.instance.getTexture('ui_gongyong_bumangdi_shangbianyikuaitie');
            var ui_gongyong_bumangdi_shangbianyikuaitie611401Image:Image = new Image(ui_gongyong_bumangdi_shangbianyikuaitie611401Texture);
            ui_gongyong_bumangdi_shangbianyikuaitie611401Image.x = 611;
            ui_gongyong_bumangdi_shangbianyikuaitie611401Image.y = 401;
            ui_gongyong_bumangdi_shangbianyikuaitie611401Image.width = 30;
            ui_gongyong_bumangdi_shangbianyikuaitie611401Image.height = 21;
            ui_gongyong_bumangdi_shangbianyikuaitie611401Image.scaleY = -1;
            ui_gongyong_bumangdi_shangbianyikuaitie611401Image.smoothing = Constants.smoothing;
            ui_gongyong_bumangdi_shangbianyikuaitie611401Image.touchable = false;
            this.addQuiackChild(ui_gongyong_bumangdi_shangbianyikuaitie611401Image);
            var lookTexture:Texture = AssetMgr.instance.getTexture('ui_button_shuxingchakananniu');
            lookButton = new Button(lookTexture);
            lookButton.x = 624;
            lookButton.y = 400;
            this.addQuiackChild(lookButton);
            var ui_gongyong_bumangdi_shangbianyikuaitie773401Texture:Texture = AssetMgr.instance.getTexture('ui_gongyong_bumangdi_shangbianyikuaitie');
            var ui_gongyong_bumangdi_shangbianyikuaitie773401Image:Image = new Image(ui_gongyong_bumangdi_shangbianyikuaitie773401Texture);
            ui_gongyong_bumangdi_shangbianyikuaitie773401Image.x = 773;
            ui_gongyong_bumangdi_shangbianyikuaitie773401Image.y = 401;
            ui_gongyong_bumangdi_shangbianyikuaitie773401Image.width = 30;
            ui_gongyong_bumangdi_shangbianyikuaitie773401Image.height = 21;
            ui_gongyong_bumangdi_shangbianyikuaitie773401Image.scaleX = -1;
            ui_gongyong_bumangdi_shangbianyikuaitie773401Image.scaleY = -1;
            ui_gongyong_bumangdi_shangbianyikuaitie773401Image.smoothing = Constants.smoothing;
            ui_gongyong_bumangdi_shangbianyikuaitie773401Image.touchable = false;
            this.addQuiackChild(ui_gongyong_bumangdi_shangbianyikuaitie773401Image);
            var ui_gongyong_zhiwanzidi532106Texture:Texture = AssetMgr.instance.getTexture('ui_gongyong_zhiwanzidi');
            var ui_gongyong_zhiwanzidi532106Image:Image = new Image(ui_gongyong_zhiwanzidi532106Texture);
            ui_gongyong_zhiwanzidi532106Image.x = 532;
            ui_gongyong_zhiwanzidi532106Image.y = 106;
            ui_gongyong_zhiwanzidi532106Image.width = 309;
            ui_gongyong_zhiwanzidi532106Image.height = 151;
            ui_gongyong_zhiwanzidi532106Image.smoothing = Constants.smoothing;
            ui_gongyong_zhiwanzidi532106Image.touchable = false;
            this.addQuiackChild(ui_gongyong_zhiwanzidi532106Image);
            var ui_gongyong_zhiwanzidi1539113Texture:Texture = AssetMgr.instance.getTexture('ui_gongyong_zhiwanzidi1');
            var ui_gongyong_zhiwanzidi1539113Image:Image = new Image(ui_gongyong_zhiwanzidi1539113Texture);
            ui_gongyong_zhiwanzidi1539113Image.x = 539;
            ui_gongyong_zhiwanzidi1539113Image.y = 113;
            ui_gongyong_zhiwanzidi1539113Image.width = 21;
            ui_gongyong_zhiwanzidi1539113Image.height = 33;
            ui_gongyong_zhiwanzidi1539113Image.smoothing = Constants.smoothing;
            ui_gongyong_zhiwanzidi1539113Image.touchable = false;
            this.addQuiackChild(ui_gongyong_zhiwanzidi1539113Image);
            var ui_gongyong_zhiwanzidi1835113Texture:Texture = AssetMgr.instance.getTexture('ui_gongyong_zhiwanzidi1');
            var ui_gongyong_zhiwanzidi1835113Image:Image = new Image(ui_gongyong_zhiwanzidi1835113Texture);
            ui_gongyong_zhiwanzidi1835113Image.x = 835;
            ui_gongyong_zhiwanzidi1835113Image.y = 113;
            ui_gongyong_zhiwanzidi1835113Image.width = 21;
            ui_gongyong_zhiwanzidi1835113Image.height = 33;
            ui_gongyong_zhiwanzidi1835113Image.scaleX = -1;
            ui_gongyong_zhiwanzidi1835113Image.smoothing = Constants.smoothing;
            ui_gongyong_zhiwanzidi1835113Image.touchable = false;
            this.addQuiackChild(ui_gongyong_zhiwanzidi1835113Image);
            txt_stateTxt = new TextField(102, 30, '', '', 18, 0x191919, false);
            txt_stateTxt.touchable = false;
            txt_stateTxt.hAlign = 'center';
            txt_stateTxt.x = 641;
            txt_stateTxt.y = 407;
            this.addQuiackChild(txt_stateTxt);

        }

        override public function dispose():void {
            lookButton.dispose();
            super.dispose();

        }

    }
}