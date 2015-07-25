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
    import com.dialog.Dialog;

    public class HeroDialogBase extends Dialog
    {
        public var closeBtn:Button;
        public var text_diamond:TextField;
        public var text_coin:TextField;

        public function HeroDialogBase()
        {
            super(false);
            var texture:Texture;
            var textField:TextField;
            var input_txt:TextInput;
            var image:Image;
            var button:Button;
            var assetMgr:AssetMgr = AssetMgr.instance;
            texture =assetMgr.getTexture('ui_wudixingyunxing_xingxing_goumaikuang1');
            image = new Image(texture);
            image.x = 14;
            image.y = 26;
            image.width = 102;
            image.height = 491;
            image.smoothing= Constants.NONE;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_wudixingyunxing_xingxing_goumaikuang2');
            image = new Image(texture);
            image.x = 104;
            image.y = 26;
            image.width = 759;
            image.height = 491;
            image.smoothing= Constants.NONE;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_wudixingyunxing_xingxing_goumaikuang1');
            image = new Image(texture);
            image.x = 946;
            image.y = 26;
            image.width = 102;
            image.height = 491;
            image.scaleX = -1;
            image.smoothing= Constants.NONE;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_gongyong_guaijiaoshitou1');
            image = new Image(texture);
            image.x = 934;
            image.y = 524;
            image.width = 904;
            image.height = 21;
            image.scaleX = -11.298385620117188;
            image.smoothing= Constants.NONE;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_gongyong_guaijiaoshitou1');
            image = new Image(texture);
            image.x = 934;
            image.y = 641;
            image.width = 904;
            image.height = 21;
            image.scaleX = -11.298385620117188;
            image.smoothing= Constants.NONE;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_gongyong_hero_kuang_zhuangshi');
            image = new Image(texture);
            image.x = 889;
            image.y = 518;
            image.width = 71;
            image.height = 148;
            image.smoothing= Constants.NONE;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_gongyong_hero_kuang_zhuangshi');
            image = new Image(texture);
            image.x = 71;
            image.y = 518;
            image.width = 71;
            image.height = 148;
            image.scaleX = -1;
            image.smoothing= Constants.NONE;
            this.addQuiackChild(image);
            texture = assetMgr.getTexture('ui_gongyong_lianziguanbianniu');
            closeBtn = new Button(texture);
            closeBtn.name= 'closeBtn';
            closeBtn.x = 850;
            closeBtn.y = -28;
            closeBtn.width = 87;
            closeBtn.height = 156;
            this.addQuiackChild(closeBtn);
            texture =assetMgr.getTexture('ui_gongyong_jinbibaiziwenzidi');
            image = new Image(texture);
            image.x = 692;
            image.y = 42;
            image.width = 154;
            image.height = 43;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_gongyong_jinbibaiziwenzidi');
            image = new Image(texture);
            image.x = 692;
            image.y = 80;
            image.width = 154;
            image.height = 43;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_gongyong_money');
            image = new Image(texture);
            image.x = 679;
            image.y = 81;
            image.width = 40;
            image.height = 40;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_gongyong_zuanshi');
            image = new Image(texture);
            image.x = 678;
            image.y = 37;
            image.width = 46;
            image.height = 44;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            this.addQuiackChild(image);
            text_diamond = new TextField(160,31,'','',21,0xFFFFFF,false);
            text_diamond.touchable = false;
            text_diamond.hAlign= 'right';
            text_diamond.text= '9999999';
            text_diamond.x = 678;
            text_diamond.y = 47;
            this.addQuiackChild(text_diamond);
            text_coin = new TextField(162,31,'','',21,0xFFFFFF,false);
            text_coin.touchable = false;
            text_coin.hAlign= 'right';
            text_coin.text= '9999999';
            text_coin.x = 677;
            text_coin.y = 86;
            this.addQuiackChild(text_coin);
            init();
        }
        override public function dispose():void
        {
            closeBtn.dispose();
            super.dispose();
        
}
    }
}
