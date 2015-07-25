package game.view.activity.base.AllGiftsBase {
    import com.utils.Constants;
    import com.view.View;

    import game.manager.AssetMgr;

    import starling.display.Button;
    import starling.display.Image;
    import starling.text.TextField;
    import starling.textures.Texture;

    public class FriendCodeBase extends View {
        public var youCodeTxt:TextField;
        public var codeTxt:TextField;
        public var contentTxt:TextField;
        public var herosTxt:TextField;
        public var receiveButton:Button;

        public function FriendCodeBase() {
            var ui_activities_diamond_search_kuang2024Texture:Texture = AssetMgr.instance.getTexture('ui_activities_diamond_search_kuang2');
            var ui_activities_diamond_search_kuang2024Image:Image = new Image(ui_activities_diamond_search_kuang2024Texture);
            ui_activities_diamond_search_kuang2024Image.x = 0;
            ui_activities_diamond_search_kuang2024Image.y = 24;
            ui_activities_diamond_search_kuang2024Image.width = 318;
            ui_activities_diamond_search_kuang2024Image.height = 307;
            ui_activities_diamond_search_kuang2024Image.smoothing = Constants.smoothing;
            ui_activities_diamond_search_kuang2024Image.touchable = false;
            this.addQuiackChild(ui_activities_diamond_search_kuang2024Image);
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
            var ui_activities_diamond_search_kuang100Texture:Texture = AssetMgr.instance.getTexture('ui_activities_diamond_search_kuang1');
            var ui_activities_diamond_search_kuang100Image:Image = new Image(ui_activities_diamond_search_kuang100Texture);
            ui_activities_diamond_search_kuang100Image.x = 0;
            ui_activities_diamond_search_kuang100Image.y = 0;
            ui_activities_diamond_search_kuang100Image.width = 318;
            ui_activities_diamond_search_kuang100Image.height = 28;
            ui_activities_diamond_search_kuang100Image.smoothing = Constants.smoothing;
            ui_activities_diamond_search_kuang100Image.touchable = false;
            this.addQuiackChild(ui_activities_diamond_search_kuang100Image);
            var ui_activities_diamond_search_yaoqingyonghu501Texture:Texture = AssetMgr.instance.getTexture('ui_activities_diamond_search_yaoqingyonghu');
            var ui_activities_diamond_search_yaoqingyonghu501Image:Image = new Image(ui_activities_diamond_search_yaoqingyonghu501Texture);
            ui_activities_diamond_search_yaoqingyonghu501Image.x = 50;
            ui_activities_diamond_search_yaoqingyonghu501Image.y = 1;
            ui_activities_diamond_search_yaoqingyonghu501Image.width = 209;
            ui_activities_diamond_search_yaoqingyonghu501Image.height = 114;
            ui_activities_diamond_search_yaoqingyonghu501Image.smoothing = Constants.smoothing;
            ui_activities_diamond_search_yaoqingyonghu501Image.touchable = false;
            this.addQuiackChild(ui_activities_diamond_search_yaoqingyonghu501Image);
            var ui_gongyong_toumingdimingzikuang120168Texture:Texture = AssetMgr.instance.getTexture('ui_gongyong_toumingdimingzikuang');
            var ui_gongyong_toumingdimingzikuang120168Image:Image = new Image(ui_gongyong_toumingdimingzikuang120168Texture);
            ui_gongyong_toumingdimingzikuang120168Image.x = 120;
            ui_gongyong_toumingdimingzikuang120168Image.y = 168;
            ui_gongyong_toumingdimingzikuang120168Image.width = 176;
            ui_gongyong_toumingdimingzikuang120168Image.height = 56;
            ui_gongyong_toumingdimingzikuang120168Image.smoothing = Constants.smoothing;
            ui_gongyong_toumingdimingzikuang120168Image.touchable = false;
            this.addQuiackChild(ui_gongyong_toumingdimingzikuang120168Image);
            youCodeTxt = new TextField(132, 38, '', '', 20, 0xffcc99, false);
            youCodeTxt.touchable = false;
            youCodeTxt.hAlign = 'center';
            youCodeTxt.x = 9;
            youCodeTxt.y = 181;
            this.addQuiackChild(youCodeTxt);
            codeTxt = new TextField(156, 35, '', '', 20, 0xffffff, false);
            codeTxt.touchable = false;
            codeTxt.hAlign = 'center';
            codeTxt.x = 126;
            codeTxt.y = 179;
            this.addQuiackChild(codeTxt);
            contentTxt = new TextField(285, 70, '', '', 20, 0xffff99, false);
            contentTxt.touchable = false;
            contentTxt.hAlign = 'center';
            contentTxt.x = 7;
            contentTxt.y = 99;
            this.addQuiackChild(contentTxt);
            herosTxt = new TextField(164, 24, '', '', 20, 0xffffff, false);
            herosTxt.touchable = false;
            herosTxt.hAlign = 'center';
            herosTxt.x = 64;
            herosTxt.y = 218;
            this.addQuiackChild(herosTxt);
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