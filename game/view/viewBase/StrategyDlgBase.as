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
    import feathers.display.Scale9Image;
    import feathers.textures.Scale9Textures;
    import com.dialog.Dialog;
    import com.utils.Constants;

    public class StrategyDlgBase extends Dialog
    {
        public var ui_gongyong_di_9gongge351039Scale:Scale9Image;
        public var tab_1:TabButton;
        public var btn_close:Button;
        public var tab_2:TabButton;
        public var list_btn:List;
        public var tabMenu:TabMenu;

        public function StrategyDlgBase()
        {
            super(false);
            var texture:Texture;
            var textField:TextField;
            var image:Image;
            var button:Button;;
            var assetMgr:AssetMgr = AssetMgr.instance;
            texture =assetMgr.getTexture('ui_wudixingyunxing_xingxing_goumaikuang1');
            image = new Image(texture);
            image.width = 102;
            image.height = 457;
            image.smoothing= Constants.NONE;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_wudixingyunxing_xingxing_goumaikuang2');
            image = new Image(texture);
            image.x = 87;
            image.width = 635;
            image.height = 457;
            image.smoothing= Constants.NONE;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_wudixingyunxing_xingxing_goumaikuang1');
            image = new Image(texture);
            image.x = 810;
            image.width = 102;
            image.height = 457;
            image.scaleX = -1;;
            image.smoothing= Constants.NONE;
            this.addQuiackChild(image);
            texture = assetMgr.getTexture('ui_gongyong_di_9gongge');
            var ui_gongyong_di_9gongge35103Rect:Rectangle = new Rectangle(21,21,43,41);
            var ui_gongyong_di_9gongge351039ScaleTexture:Scale9Textures = new Scale9Textures(texture,ui_gongyong_di_9gongge35103Rect);
            ui_gongyong_di_9gongge351039Scale = new Scale9Image(ui_gongyong_di_9gongge351039ScaleTexture);
            ui_gongyong_di_9gongge351039Scale.x = 35;
            ui_gongyong_di_9gongge351039Scale.y = 103;
            ui_gongyong_di_9gongge351039Scale.width = 737;
            ui_gongyong_di_9gongge351039Scale.height = 326;
            this.addQuiackChild(ui_gongyong_di_9gongge351039Scale);
            tab_1 = new TabButton(assetMgr.getTexture('ui_button_tiebaomutouanjian'),assetMgr.getTexture('ui_button_tiebaomutouanjian_liang'));
            tab_1.x = 31;
            tab_1.y = 31;
            this.addQuiackChild(tab_1);
            tab_1.text= '富人攻略';
            tab_1.fontColor= 0xFFE7D0;
            tab_1.fontSize= 28;
            texture = assetMgr.getTexture('ui_Buyingdiamond_button_guanbi');
            btn_close = new Button(texture);
            btn_close.name= 'btn_close';
            btn_close.x = 732;
            btn_close.y = 23;
            btn_close.width = 61;
            btn_close.height = 60;
            this.addQuiackChild(btn_close);
            tab_2 = new TabButton(assetMgr.getTexture('ui_button_tiebaomutouanjian'),assetMgr.getTexture('ui_button_tiebaomutouanjian_liang'));
            tab_2.x = 192;
            tab_2.y = 31;
            this.addQuiackChild(tab_2);
            tab_2.text= '强人指南';
            tab_2.fontColor= 0xFFE7D0;
            tab_2.fontSize= 28;
            list_btn = new List();
            list_btn.x = 40;
            list_btn.y = 120;
            list_btn.width = 720;
            list_btn.height = 300;
            this.addQuiackChild(list_btn);
            tabMenu = new TabMenu([tab_1,tab_2]);
            tabMenu.x = 32;
            tabMenu.y = 30;
            this.addQuiackChild(tabMenu);
            init();
        }
        override public function dispose():void
        {
            tab_1.dispose();
            btn_close.dispose();
            tab_2.dispose();
            list_btn.dispose();
            tabMenu.dispose();
            super.dispose();
        
}
    }
}
