package  game.view.viewBase
{
    import starling.display.Image;
    import game.manager.AssetMgr;
    import starling.display.Sprite;
    import starling.textures.Texture;
    import starling.text.TextField;
    import starling.display.Button;
    import flash.geom.Rectangle;
    import com.utils.Constants;
    import feathers.controls.TextInput;
    import com.view.View;

    public class MagicObrGetViewBase extends View
    {
        public var button5:Button;
        public var button1:Button;
        public var button2:Button;
        public var txt2:TextField;
        public var mask1:Image;
        public var button3:Button;
        public var txt3:TextField;
        public var button4:Button;
        public var onArrow1:Image;
        public var up1:Image;
        public var onArrow4:Image;
        public var up4:Image;
        public var txt5:TextField;
        public var onArrow3:Image;
        public var onArrow2:Image;
        public var txt1:TextField;
        public var mask2:Image;
        public var txt4:TextField;
        public var mask3:Image;
        public var btn_automatic:Button;
        public var txt6:TextField;
        public var mask4:Image;
        public var up2:Image;
        public var up3:Image;
        public var btn_sell:Button;
        public var cancel:Button;
        public var text_over:TextField;

        public function MagicObrGetViewBase()
        {
            super(false);
            var texture:Texture;
            var textField:TextField;
            var input_txt:TextInput;
            var image:Image;
            var button:Button;
            var assetMgr:AssetMgr = AssetMgr.instance;
            texture = assetMgr.getTexture('ui_button_baozhuhuoquanniu5');
            button5 = new Button(texture);
            button5.name= 'button5';
            button5.x = 644;
            button5.y = 512;
            button5.width = 96;
            button5.height = 104;
            this.addQuiackChild(button5);
            texture = assetMgr.getTexture('ui_button_baozhuhuoquanniu1');
            button1 = new Button(texture);
            button1.name= 'button1';
            button1.x = 33;
            button1.y = 513;
            button1.width = 96;
            button1.height = 104;
            this.addQuiackChild(button1);
            texture = assetMgr.getTexture('ui_button_baozhuhuoquanniu2');
            button2 = new Button(texture);
            button2.name= 'button2';
            button2.x = 185;
            button2.y = 514;
            button2.width = 96;
            button2.height = 104;
            this.addQuiackChild(button2);
            txt2 = new TextField(63,25,'','',20,0xFFFFFF,false);
            txt2.touchable = false;
            txt2.hAlign= 'center';
            txt2.text= '';
            txt2.x = 211;
            txt2.y = 587;
            this.addQuiackChild(txt2);
            texture = assetMgr.getTexture('ui_button_baozhuhuoquanniu_yinying')
            mask1 = new Image(texture);
            mask1.x = 185;
            mask1.y = 511;
            mask1.width = 96;
            mask1.height = 104;
            this.addQuiackChild(mask1);
            mask1.touchable = false;
            texture = assetMgr.getTexture('ui_button_baozhuhuoquanniu3');
            button3 = new Button(texture);
            button3.name= 'button3';
            button3.x = 338;
            button3.y = 513;
            button3.width = 96;
            button3.height = 104;
            this.addQuiackChild(button3);
            txt3 = new TextField(63,25,'','',20,0xFFFFFF,false);
            txt3.touchable = false;
            txt3.hAlign= 'center';
            txt3.text= '';
            txt3.x = 365;
            txt3.y = 587;
            this.addQuiackChild(txt3);
            texture = assetMgr.getTexture('ui_button_baozhuhuoquanniu4');
            button4 = new Button(texture);
            button4.name= 'button4';
            button4.x = 491;
            button4.y = 513;
            button4.width = 96;
            button4.height = 104;
            this.addQuiackChild(button4);
            texture = assetMgr.getTexture('ui_zhuangshi_baozhuhuoqu_jiantou2')
            onArrow1 = new Image(texture);
            onArrow1.x = 136;
            onArrow1.y = 540;
            onArrow1.width = 43;
            onArrow1.height = 39;
            this.addQuiackChild(onArrow1);
            onArrow1.touchable = false;
            texture = assetMgr.getTexture('ui_zhuangshi_baozhuhuoqu_jiantou1')
            up1 = new Image(texture);
            up1.x = 139;
            up1.y = 543;
            up1.width = 37;
            up1.height = 33;
            this.addQuiackChild(up1);
            up1.touchable = false;
            texture = assetMgr.getTexture('ui_zhuangshi_baozhuhuoqu_jiantou2')
            onArrow4 = new Image(texture);
            onArrow4.x = 596;
            onArrow4.y = 540;
            onArrow4.width = 43;
            onArrow4.height = 39;
            this.addQuiackChild(onArrow4);
            onArrow4.touchable = false;
            texture = assetMgr.getTexture('ui_zhuangshi_baozhuhuoqu_jiantou1')
            up4 = new Image(texture);
            up4.x = 600;
            up4.y = 543;
            up4.width = 37;
            up4.height = 33;
            this.addQuiackChild(up4);
            up4.touchable = false;
            txt5 = new TextField(63,25,'','',20,0xFFFFFF,false);
            txt5.touchable = false;
            txt5.hAlign= 'center';
            txt5.text= '';
            txt5.x = 669;
            txt5.y = 587;
            this.addQuiackChild(txt5);
            texture = assetMgr.getTexture('ui_zhuangshi_baozhuhuoqu_jiantou2')
            onArrow3 = new Image(texture);
            onArrow3.x = 440;
            onArrow3.y = 540;
            onArrow3.width = 43;
            onArrow3.height = 39;
            this.addQuiackChild(onArrow3);
            onArrow3.touchable = false;
            texture = assetMgr.getTexture('ui_zhuangshi_baozhuhuoqu_jiantou2')
            onArrow2 = new Image(texture);
            onArrow2.x = 289;
            onArrow2.y = 540;
            onArrow2.width = 43;
            onArrow2.height = 39;
            this.addQuiackChild(onArrow2);
            onArrow2.touchable = false;
            txt1 = new TextField(63,25,'','',20,0xFFFFFF,false);
            txt1.touchable = false;
            txt1.hAlign= 'center';
            txt1.text= '';
            txt1.x = 57;
            txt1.y = 587;
            this.addQuiackChild(txt1);
            texture = assetMgr.getTexture('ui_button_baozhuhuoquanniu_yinying')
            mask2 = new Image(texture);
            mask2.x = 338;
            mask2.y = 513;
            mask2.width = 96;
            mask2.height = 104;
            this.addQuiackChild(mask2);
            mask2.touchable = false;
            txt4 = new TextField(63,25,'','',20,0xFFFFFF,false);
            txt4.touchable = false;
            txt4.hAlign= 'center';
            txt4.text= '';
            txt4.x = 517;
            txt4.y = 587;
            this.addQuiackChild(txt4);
            texture = assetMgr.getTexture('ui_button_baozhuhuoquanniu_yinying')
            mask3 = new Image(texture);
            mask3.x = 491;
            mask3.y = 513;
            mask3.width = 96;
            mask3.height = 104;
            this.addQuiackChild(mask3);
            mask3.touchable = false;
            texture = assetMgr.getTexture('ui_butten_sifanganniu');
            btn_automatic = new Button(texture);
            btn_automatic.name= 'btn_automatic';
            btn_automatic.x = 783;
            btn_automatic.y = 512;
            btn_automatic.width = 105;
            btn_automatic.height = 108;
            this.addQuiackChild(btn_automatic);
            txt6 = new TextField(74,72,'','',24,0xFFFFCC,false);
            txt6.touchable = false;
            txt6.hAlign= 'center';
            txt6.text= '';
            txt6.x = 799;
            txt6.y = 527;
            this.addQuiackChild(txt6);
            texture = assetMgr.getTexture('ui_button_baozhuhuoquanniu_yinying')
            mask4 = new Image(texture);
            mask4.x = 644;
            mask4.y = 513;
            mask4.width = 96;
            mask4.height = 104;
            this.addQuiackChild(mask4);
            mask4.touchable = false;
            texture = assetMgr.getTexture('ui_zhuangshi_baozhuhuoqu_jiantou1')
            up2 = new Image(texture);
            up2.x = 293;
            up2.y = 543;
            up2.width = 37;
            up2.height = 33;
            this.addQuiackChild(up2);
            up2.touchable = false;
            texture = assetMgr.getTexture('ui_zhuangshi_baozhuhuoqu_jiantou1')
            up3 = new Image(texture);
            up3.x = 444;
            up3.y = 543;
            up3.width = 37;
            up3.height = 33;
            this.addQuiackChild(up3);
            up3.touchable = false;
            texture = assetMgr.getTexture('ui_button_xinshanchuanniu');
            btn_sell = new Button(texture);
            btn_sell.name= 'btn_sell';
            btn_sell.x = 784;
            btn_sell.y = 410;
            btn_sell.width = 92;
            btn_sell.height = 79;
            this.addQuiackChild(btn_sell);
            texture = assetMgr.getTexture('ui_button_quxiaoanniu');
            cancel = new Button(texture);
            cancel.name= 'cancel';
            cancel.x = 670;
            cancel.y = 445;
            cancel.width = 69;
            cancel.height = 44;
            this.addQuiackChild(cancel);
            text_over = new TextField(81,26,'','',16,0xFEF4CC,false);
            text_over.touchable = false;
            text_over.hAlign= 'center';
            text_over.text= '';
            text_over.x = 787;
            text_over.y = 457;
            this.addQuiackChild(text_over);
            init();
        }
        override public function dispose():void
        {
            button5.dispose();
            button1.dispose();
            button2.dispose();
            button3.dispose();
            button4.dispose();
            btn_automatic.dispose();
            btn_sell.dispose();
            cancel.dispose();
            super.dispose();
        
}
    }
}
