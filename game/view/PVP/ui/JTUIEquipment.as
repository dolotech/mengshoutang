package game.view.PVP.ui {
    import com.utils.Constants;

    import game.base.JTSprite;
    import game.manager.AssetMgr;

    import starling.display.Button;
    import starling.display.Image;
    import starling.text.TextField;
    import starling.textures.Texture;

    public class JTUIEquipment extends JTSprite {
        public var btn_rectangle:Button = null;
        public var txt_name:TextField = null;
        public var txt_horn:TextField = null;
        public var btn_box:Button = null;

        public function JTUIEquipment() {
            var txture_ui_Buyingdiamond_paizi200:Texture = AssetMgr.instance.getTexture('ui_Buyingdiamond_paizi2');
            var ui_Buyingdiamond_paizi200img_2:Image = new Image(txture_ui_Buyingdiamond_paizi200);
            ui_Buyingdiamond_paizi200img_2.x = 0;
            ui_Buyingdiamond_paizi200img_2.y = 0;
            ui_Buyingdiamond_paizi200img_2.width = 178;
            ui_Buyingdiamond_paizi200img_2.height = 211;
            ui_Buyingdiamond_paizi200img_2.smoothing = Constants.smoothing;
            ui_Buyingdiamond_paizi200img_2.touchable = false;
            this.addQuiackChild(ui_Buyingdiamond_paizi200img_2);
            var btn_rectangle_txture:Texture = AssetMgr.instance.getTexture('ui_Buyingdiamond_paizi1');
            btn_rectangle = new Button(btn_rectangle_txture);
            btn_rectangle.x = 7;
            btn_rectangle.y = 2;
            this.addQuiackChild(btn_rectangle);
            txt_name = new TextField(150, 36, '', '', 20, 0xFFF025, false);
            txt_name.touchable = false;
            txt_name.hAlign = 'center';
            txt_name.text = '装备的名字';
            txt_name.x = 13;
            txt_name.y = 121;
            this.addQuiackChild(txt_name);
            txt_horn = new TextField(117, 28, '', '', 18, 0xE2BE9C, false);
            txt_horn.touchable = false;
            txt_horn.hAlign = 'center';
            txt_horn.text = '2154211';
            txt_horn.x = 30;
            txt_horn.y = 165;
            this.addQuiackChild(txt_horn);
            var txture_ui_pvp_rongyuzhibiaozhi18162:Texture = AssetMgr.instance.getTexture('ui_pvp_rongyuzhibiaozhi');
            var ui_pvp_rongyuzhibiaozhi18162img_3:Image = new Image(txture_ui_pvp_rongyuzhibiaozhi18162);
            ui_pvp_rongyuzhibiaozhi18162img_3.x = 18;
            ui_pvp_rongyuzhibiaozhi18162img_3.y = 162;
            ui_pvp_rongyuzhibiaozhi18162img_3.width = 25;
            ui_pvp_rongyuzhibiaozhi18162img_3.height = 35;
            ui_pvp_rongyuzhibiaozhi18162img_3.smoothing = Constants.smoothing;
            ui_pvp_rongyuzhibiaozhi18162img_3.touchable = false;
            this.addQuiackChild(ui_pvp_rongyuzhibiaozhi18162img_3);

            var quaImage:Image = new Image(AssetMgr.instance.getTexture("ui_gongyong_90wupingkuang"));
            this.addQuiackChild(quaImage);
            quaImage.x = 43;
            quaImage.y = 24;

            var btn_box_txture:Texture = AssetMgr.instance.getTexture('ui_gongyong_90wupingkuang');
            btn_box = new Button(btn_box_txture);
            btn_box.x = 43;
            btn_box.y = 24;
            this.addQuiackChild(btn_box);
        }

        override public function dispose():void {
            btn_rectangle.dispose();
            btn_box.dispose();
            super.dispose();

        }

    }
}
