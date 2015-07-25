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

    public class TavernDialogBase extends Dialog
    {
        public var btn_close:Button;
        public var text_diamond:TextField;
        public var text_coin:TextField;

        public function TavernDialogBase()
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
            image.width = 102;
            image.height = 636;
            image.smoothing= Constants.NONE;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_wudixingyunxing_xingxing_goumaikuang2');
            image = new Image(texture);
            image.x = 69;
            image.width = 787;
            image.height = 636;
            image.smoothing= Constants.NONE;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_wudixingyunxing_xingxing_goumaikuang1');
            image = new Image(texture);
            image.x = 949;
            image.width = 102;
            image.height = 636;
            image.scaleX = -1;
            image.smoothing= Constants.NONE;
            this.addQuiackChild(image);
            texture = assetMgr.getTexture('ui_gongyong_lianziguanbianniu');
            btn_close = new Button(texture);
            btn_close.name= 'btn_close';
            btn_close.x = 843;
            btn_close.y = -70;
            btn_close.width = 87;
            btn_close.height = 156;
            this.addQuiackChild(btn_close);
            texture =assetMgr.getTexture('ui_gongyong_jinbibaiziwenzidi');
            image = new Image(texture);
            image.x = 513;
            image.y = 27;
            image.width = 154;
            image.height = 43;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_gongyong_jinbibaiziwenzidi');
            image = new Image(texture);
            image.x = 685;
            image.y = 26;
            image.width = 154;
            image.height = 43;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_gongyong_money');
            image = new Image(texture);
            image.x = 672;
            image.y = 27;
            image.width = 40;
            image.height = 40;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_gongyong_zuanshi');
            image = new Image(texture);
            image.x = 499;
            image.y = 26;
            image.width = 46;
            image.height = 44;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            this.addQuiackChild(image);
            text_diamond = new TextField(159,31,'','',21,0xFFFFFF,false);
            text_diamond.touchable = false;
            text_diamond.hAlign= 'right';
            text_diamond.text= '9999999';
            text_diamond.x = 500;
            text_diamond.y = 33;
            this.addQuiackChild(text_diamond);
            text_coin = new TextField(157,31,'','',21,0xFFFFFF,false);
            text_coin.touchable = false;
            text_coin.hAlign= 'right';
            text_coin.text= '9999999';
            text_coin.x = 675;
            text_coin.y = 33;
            this.addQuiackChild(text_coin);
            init();
        }
        override public function dispose():void
        {
            btn_close.dispose();
            super.dispose();
        
}
    }
}
