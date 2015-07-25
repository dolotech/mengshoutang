package game.view.rank.ui {
    import com.utils.Constants;

    import game.base.JTSprite;
    import game.manager.AssetMgr;

    import starling.display.Button;
    import starling.display.Image;
    import starling.text.TextField;
    import starling.textures.Texture;

    public class JTUIRankItem extends JTSprite {
        public var txt_head:Button = null;
        public var txt_item_name:TextField = null;
        public var txt_rank_info:TextField = null;
        public var txt_rank:TextField = null;
        public var textField:TextField;
        public var ui_tubiao_duanwei343318img_NaN:Image;

        public function JTUIRankItem() {
            var txture_ui_rongyupaizi_di00:Texture = AssetMgr.instance.getTexture('ui_rongyupaizi_di');
            var ui_rongyupaizi_di00img_NaN:Image = new Image(txture_ui_rongyupaizi_di00);
            ui_rongyupaizi_di00img_NaN.x = 0;
            ui_rongyupaizi_di00img_NaN.y = 0;
            ui_rongyupaizi_di00img_NaN.width = 325;
            ui_rongyupaizi_di00img_NaN.height = 103;
            ui_rongyupaizi_di00img_NaN.smoothing = Constants.smoothing;
            //	ui_rongyupaizi_di00img_NaN.touchable = false;
            this.addQuiackChild(ui_rongyupaizi_di00img_NaN);
            var txture_ui_rongyupaizi_di6410:Texture = AssetMgr.instance.getTexture('ui_rongyupaizi_di');
            var ui_rongyupaizi_di6410img_NaN:Image = new Image(txture_ui_rongyupaizi_di6410);
            ui_rongyupaizi_di6410img_NaN.x = 641;
            ui_rongyupaizi_di6410img_NaN.y = 0;
            ui_rongyupaizi_di6410img_NaN.width = 325;
            ui_rongyupaizi_di6410img_NaN.height = 103;
            ui_rongyupaizi_di6410img_NaN.scaleX = -1;
            ui_rongyupaizi_di6410img_NaN.smoothing = Constants.smoothing;
            //ui_rongyupaizi_di6410img_NaN.touchable = false;
            this.addQuiackChild(ui_rongyupaizi_di6410img_NaN);
            var txt_head_txture:Texture = AssetMgr.instance.getTexture('ui_gongyong_100yingxiongkuang_kong2');
            txt_head = new Button(txt_head_txture);
            txt_head.x = 126;
            txt_head.y = 7;
            var txture_ui_icon_city_vip97:Texture = AssetMgr.instance.getTexture('ui_icon_city_vip');
            var ui_icon_city_vip97img_NaN:Image = new Image(txture_ui_icon_city_vip97);
            ui_icon_city_vip97img_NaN.x = -9;
            ui_icon_city_vip97img_NaN.y = -6;
            ui_icon_city_vip97img_NaN.width = 65;
            ui_icon_city_vip97img_NaN.height = 65;
            ui_icon_city_vip97img_NaN.smoothing = Constants.smoothing;
            //ui_icon_city_vip97img_NaN.touchable = false;
            txt_head.addQuiackChild(ui_icon_city_vip97img_NaN);
            ui_icon_city_vip97img_NaN.visible = false;
            textField = new TextField(48, 30, '', '', 20, 0xFFFFCC, false);
            textField.touchable = false;
            textField.hAlign = 'center';
            textField.x = -3;
            textField.y = 18;
            txt_head.addQuiackChild(textField);
            textField.name = 'txt_rank';
            textField.visible = false;
            this.addQuiackChild(txt_head);
            var txture_ui_tubiao_duanwei343318:Texture = AssetMgr.instance.getTexture('ui_wudixingyunxing_xingxing');
            ui_tubiao_duanwei343318img_NaN = new Image(txture_ui_tubiao_duanwei343318);
            ui_tubiao_duanwei343318img_NaN.x = 433;
            ui_tubiao_duanwei343318img_NaN.y = 18;
            ui_tubiao_duanwei343318img_NaN.width = 69;
            ui_tubiao_duanwei343318img_NaN.height = 67;
            ui_tubiao_duanwei343318img_NaN.smoothing = Constants.smoothing;
            //ui_tubiao_duanwei343318img_NaN.touchable = false;
            this.addQuiackChild(ui_tubiao_duanwei343318img_NaN);
            txt_item_name = new TextField(211, 50, '', '', 30, 0xFFEC48, false);
            txt_item_name.touchable = false;
            txt_item_name.hAlign = 'center';
            txt_item_name.x = 217;
            txt_item_name.y = 31;
            this.addQuiackChild(txt_item_name);
            txt_rank_info = new TextField(130, 33, '', '', 22, 0xFFFFFF, false);
            txt_rank_info.touchable = false;
            txt_rank_info.hAlign = 'center';
            txt_rank_info.x = 503;
            txt_rank_info.y = 38;
            this.addQuiackChild(txt_rank_info);
            txt_rank = new TextField(126, 36, '', '', 24, 0xFFFFFF, false);
            txt_rank.touchable = false;
            txt_rank.hAlign = 'center';
            txt_rank.x = 0;
            txt_rank.y = 36;
            this.addQuiackChild(txt_rank);

        }

        override public function dispose():void {
            txt_head.dispose();
            super.dispose();

        }

    }
}