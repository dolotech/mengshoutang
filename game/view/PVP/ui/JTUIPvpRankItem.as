package game.view.PVP.ui {
    import com.utils.Constants;

    import game.base.JTSprite;
    import game.manager.AssetMgr;

    import starling.display.Button;
    import starling.display.Image;
    import starling.text.TextField;
    import starling.textures.Texture;

    public class JTUIPvpRankItem extends JTSprite {
        public var txt_name:TextField = null;
        public var txt_fight:TextField = null;
        public var txt_horn:TextField = null;
        public var txt_no:TextField = null;
        public var txt_head:Button = null;
        public var textField:TextField;
        public var btn_pk:Button = null;

        public function JTUIPvpRankItem() {
            var txture_ui_rongyupaizi_di10:Texture = AssetMgr.instance.getTexture('ui_rongyupaizi_di');
            var ui_rongyupaizi_di10img_2:Image = new Image(txture_ui_rongyupaizi_di10);
            ui_rongyupaizi_di10img_2.x = 1;
            ui_rongyupaizi_di10img_2.y = 0;
            ui_rongyupaizi_di10img_2.width = 325;
            ui_rongyupaizi_di10img_2.height = 103;
            ui_rongyupaizi_di10img_2.smoothing = Constants.smoothing;
            // ui_rongyupaizi_di10img_2.touchable = false;
            this.addQuiackChild(ui_rongyupaizi_di10img_2);
            var txture_ui_rongyupaizi_di5530:Texture = AssetMgr.instance.getTexture('ui_rongyupaizi_di');
            var ui_rongyupaizi_di5530img_3:Image = new Image(txture_ui_rongyupaizi_di5530);
            ui_rongyupaizi_di5530img_3.x = 553;
            ui_rongyupaizi_di5530img_3.y = 0;
            ui_rongyupaizi_di5530img_3.width = 325;
            ui_rongyupaizi_di5530img_3.height = 103;
            ui_rongyupaizi_di5530img_3.scaleX = -1;
            ui_rongyupaizi_di5530img_3.smoothing = Constants.smoothing;
            // ui_rongyupaizi_di5530img_3.touchable = false;
            this.addQuiackChild(ui_rongyupaizi_di5530img_3);
            var txture_ui_gongyong_name_di18213:Texture = AssetMgr.instance.getTexture('ui_gongyong_name_di');
            var ui_gongyong_name_di18213img_4:Image = new Image(txture_ui_gongyong_name_di18213);
            ui_gongyong_name_di18213img_4.x = 182;
            ui_gongyong_name_di18213img_4.y = 13;
            ui_gongyong_name_di18213img_4.width = 203;
            ui_gongyong_name_di18213img_4.height = 43;
            ui_gongyong_name_di18213img_4.smoothing = Constants.smoothing;
            //ui_gongyong_name_di18213img_4.touchable = false;
            this.addQuiackChild(ui_gongyong_name_di18213img_4);
            var txture_ui_gongyong_abattoir_paiming10310:Texture = AssetMgr.instance.getTexture('ui_gongyong_abattoir_paiming');
            var ui_gongyong_abattoir_paiming10310img_5:Image = new Image(txture_ui_gongyong_abattoir_paiming10310);
            ui_gongyong_abattoir_paiming10310img_5.x = 103;
            ui_gongyong_abattoir_paiming10310img_5.y = 10;
            ui_gongyong_abattoir_paiming10310img_5.width = 42;
            ui_gongyong_abattoir_paiming10310img_5.height = 42;
            ui_gongyong_abattoir_paiming10310img_5.smoothing = Constants.smoothing;
            // ui_gongyong_abattoir_paiming10310img_5.touchable = false;
            this.addQuiackChild(ui_gongyong_abattoir_paiming10310img_5);
            var txture_ui_gongyong_iocn_zhandouli11065:Texture = AssetMgr.instance.getTexture('ui_gongyong_iocn_zhandouli');
            var ui_gongyong_iocn_zhandouli11065img_6:Image = new Image(txture_ui_gongyong_iocn_zhandouli11065);
            ui_gongyong_iocn_zhandouli11065img_6.x = 110;
            ui_gongyong_iocn_zhandouli11065img_6.y = 65;
            ui_gongyong_iocn_zhandouli11065img_6.width = 32;
            ui_gongyong_iocn_zhandouli11065img_6.height = 28;
            ui_gongyong_iocn_zhandouli11065img_6.smoothing = Constants.smoothing;
            ui_gongyong_iocn_zhandouli11065img_6.touchable = false;
            this.addQuiackChild(ui_gongyong_iocn_zhandouli11065img_6);
            txt_name = new TextField(182, 30, '', '', 22, 0xE6D7B6, false);
            txt_name.touchable = false;
            txt_name.hAlign = 'center';
            txt_name.x = 191;
            txt_name.y = 20;
            this.addQuiackChild(txt_name);
            txt_fight = new TextField(110, 25, '', '', 16, 0xFFFFFF, false);
            txt_fight.touchable = false;
            txt_fight.hAlign = 'center';
            txt_fight.text = '123456';
            txt_fight.x = 140;
            txt_fight.y = 63;
            this.addQuiackChild(txt_fight);
            txt_horn = new TextField(116, 25, '', '', 16, 0xFFFFFF, false);
            txt_horn.touchable = false;
            txt_horn.hAlign = 'center';
            txt_horn.x = 316;
            txt_horn.y = 62;
            this.addQuiackChild(txt_horn);
            txt_no = new TextField(71, 25, '', '', 16, 0xFFC808, false);
            txt_no.touchable = false;
            txt_no.hAlign = 'center';
            txt_no.x = 88;
            txt_no.y = 19;
            this.addQuiackChild(txt_no);
            var txt_head_txture:Texture = AssetMgr.instance.getTexture('ui_gongyong_100yingxiongkuang_kong2');
            txt_head = new Button(txt_head_txture);
            txt_head.x = 9;
            txt_head.y = 7;
            var txture_ui_icon_city_vip97:Texture = AssetMgr.instance.getTexture('ui_icon_city_vip');
            var ui_icon_city_vip97img_7:Image = new Image(txture_ui_icon_city_vip97);
            ui_icon_city_vip97img_7.x = -9;
            ui_icon_city_vip97img_7.y = -6;
            ui_icon_city_vip97img_7.width = 65;
            ui_icon_city_vip97img_7.height = 65;
            ui_icon_city_vip97img_7.smoothing = Constants.smoothing;
            ui_icon_city_vip97img_7.touchable = false;
            txt_head.addQuiackChild(ui_icon_city_vip97img_7);
            ui_icon_city_vip97img_7.visible = false;
            textField = new TextField(48, 30, '', '', 20, 0xFFFFCC, false);
            textField.touchable = false;
            textField.hAlign = 'center';
            textField.x = -3;
            textField.y = 18;
            txt_head.addQuiackChild(textField);
            textField.name = 'txt_rank';
            textField.visible = false
            this.addQuiackChild(txt_head);
            var txture_ui_pvp_rongyuzhibiaozhi28858:Texture = AssetMgr.instance.getTexture('ui_pvp_rongyuzhibiaozhi');
            var ui_pvp_rongyuzhibiaozhi28858img_8:Image = new Image(txture_ui_pvp_rongyuzhibiaozhi28858);
            ui_pvp_rongyuzhibiaozhi28858img_8.x = 288;
            ui_pvp_rongyuzhibiaozhi28858img_8.y = 58;
            ui_pvp_rongyuzhibiaozhi28858img_8.width = 31;
            ui_pvp_rongyuzhibiaozhi28858img_8.height = 43;
            ui_pvp_rongyuzhibiaozhi28858img_8.smoothing = Constants.smoothing;
            ui_pvp_rongyuzhibiaozhi28858img_8.touchable = false;
            this.addQuiackChild(ui_pvp_rongyuzhibiaozhi28858img_8);
            var btn_pk_txture:Texture = AssetMgr.instance.getTexture('ui_button_abattoir_tiaozhan');
            btn_pk = new Button(btn_pk_txture);
            btn_pk.x = 466;
            btn_pk.y = 14;
            this.addQuiackChild(btn_pk);

        }

        override public function dispose():void {
            //   btn_pk.dispose();
            txt_head.dispose();
            super.dispose();

        }

    }
}
