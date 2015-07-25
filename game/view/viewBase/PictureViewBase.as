package  game.view.viewBase
{
    import starling.display.Image;
    import game.manager.AssetMgr;
    import starling.display.Sprite;
    import starling.textures.Texture;
    import starling.text.TextField;
    import starling.display.Button;
    import flash.geom.Rectangle;
    import com.components.TabMenu;
    import com.components.TabButton;
    import feathers.controls.List;
    import com.components.TabMenu;
    import com.dialog.Dialog;
    import com.utils.Constants;

    public class PictureViewBase extends Dialog
    {
        public var txt_title:TextField;
        public var btn_close:Button;
        public var txt_count:TextField;
        public var tab_1:TabButton;
        public var tabMenu:TabMenu;
        public var list_pic:List;

        public function PictureViewBase()
        {
            super(false);
            var texture:Texture;
            var textField:TextField;
            var image:Image;
            var button:Button;;
            var assetMgr:AssetMgr = AssetMgr.instance;
            texture =assetMgr.getTexture('ui_wudixingyunxing_xingxing_goumaikuang2');
            image = new Image(texture);
            image.x = 91;
            image.y = 24;
            image.width = 682;
            image.height = 451;
            image.smoothing= Constants.NONE;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_wudixingyunxing_xingxing_goumaikuang1');
            image = new Image(texture);
            image.x = 833;
            image.y = 24;
            image.width = 102;
            image.height = 451;
            image.scaleX = -1;;
            image.smoothing= Constants.NONE;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_wudixingyunxing_xingxing_goumaikuang1');
            image = new Image(texture);
            image.x = 22;
            image.y = 24;
            image.width = 102;
            image.height = 451;
            image.smoothing= Constants.NONE;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_Setup_title');
            image = new Image(texture);
            image.x = 230;
            image.width = 399;
            image.height = 104;
            image.smoothing= Constants.smoothing;
            image.touchable = false;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_Buyingdiamond_diamond_di');
            image = new Image(texture);
            image.x = 59;
            image.y = 53;
            image.width = 146;
            image.height = 37;
            image.smoothing= Constants.smoothing;
            image.touchable = false;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_tubiao_rongyufenleianniu_yingxiong');
            image = new Image(texture);
            image.x = 36;
            image.y = 39;
            image.width = 60;
            image.height = 57;
            image.smoothing= Constants.smoothing;
            image.touchable = false;
            this.addQuiackChild(image);
            txt_title = new TextField(226,46,'','',38,0x363F3A,false);
            txt_title.touchable = false;
            txt_title.hAlign= 'center';
            txt_title.text= '图 鉴';
            txt_title.x = 318;
            txt_title.y = 17;
            this.addQuiackChild(txt_title);
            texture = assetMgr.getTexture('ui_Buyingdiamond_button_guanbi');
            btn_close = new Button(texture);
            btn_close.name= 'btn_close';
            btn_close.x = 757;
            btn_close.y = 42;
            btn_close.width = 61;
            btn_close.height = 60;
            this.addQuiackChild(btn_close);
            txt_count = new TextField(119,30,'','',20,0xFFF6E3,false);
            txt_count.touchable = false;
            txt_count.hAlign= 'center';
            txt_count.text= '';
            txt_count.x = 85;
            txt_count.y = 56;
            this.addQuiackChild(txt_count);
            tab_1 = new TabButton(assetMgr.getTexture('ui_Setup_button_tiebian_li'),assetMgr.getTexture('ui_Setup_button_tiebian_li'));
            tab_1.y = 85;
            this.addQuiackChild(tab_1);
            tab_1.text= '英         雄';
            tab_1.fontColor= 0xFFF6E3;
            tab_1.fontSize= 20;
            tabMenu = new TabMenu([tab_1]);
            tabMenu.x = 1;
            tabMenu.y = 84;
            this.addQuiackChild(tabMenu);
            list_pic = new List();
            list_pic.x = 77;
            list_pic.y = 115;
            list_pic.width = 690;
            list_pic.height = 310;
            this.addQuiackChild(list_pic);
            init();
        }
        override public function dispose():void
        {
            btn_close.dispose();
            tab_1.dispose();
            tabMenu.dispose();
            list_pic.dispose();
            super.dispose();
        
}
    }
}
