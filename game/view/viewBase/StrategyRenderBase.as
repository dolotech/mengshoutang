package  game.view.viewBase
{
    import starling.display.Image;
    import game.manager.AssetMgr;
    import starling.display.Sprite;
    import starling.textures.Texture;
    import starling.text.TextField;
    import starling.display.Button;
    import flash.geom.Rectangle;
    import feathers.display.Scale9Image;
    import feathers.textures.Scale9Textures;
    import feathers.controls.renderers.DefaultListItemRenderer;
    import com.utils.Constants;

    public class StrategyRenderBase extends DefaultListItemRenderer
    {
        public var bg9Scale:Scale9Image;
        public var txt_name:TextField;
        public var txt_des:TextField;
        public var btn_go:Button;
        public var star_0:Image;
        public var star_1:Image;
        public var star_2:Image;
        public var star_3:Image;
        public var star_4:Image;

        public function StrategyRenderBase()
        {
            var texture:Texture;
            var textField:TextField;
            var image:Image;
            var button:Button;;
            var assetMgr:AssetMgr = AssetMgr.instance;
            texture = assetMgr.getTexture('ui_gongyong_xianrenzhilu_di_9gongge');
            var bgRect:Rectangle = new Rectangle(49,48,40,40);
            var bg9ScaleTexture:Scale9Textures = new Scale9Textures(texture,bgRect);
            bg9Scale = new Scale9Image(bg9ScaleTexture);
            bg9Scale.width = 223;
            bg9Scale.height = 292;
            this.addQuiackChild(bg9Scale);
            texture =assetMgr.getTexture('ui_gongyong_husexingxing');
            image = new Image(texture);
            image.x = 144;
            image.y = 212;
            image.width = 27;
            image.height = 25;
            image.smoothing= Constants.smoothing;
            image.touchable = false;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_gongyong_husexingxing');
            image = new Image(texture);
            image.x = 43;
            image.y = 212;
            image.width = 27;
            image.height = 25;
            image.smoothing= Constants.smoothing;
            image.touchable = false;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_gongyong_husexingxing');
            image = new Image(texture);
            image.x = 68;
            image.y = 212;
            image.width = 27;
            image.height = 25;
            image.smoothing= Constants.smoothing;
            image.touchable = false;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_gongyong_husexingxing');
            image = new Image(texture);
            image.x = 93;
            image.y = 212;
            image.width = 27;
            image.height = 25;
            image.smoothing= Constants.smoothing;
            image.touchable = false;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_gongyong_husexingxing');
            image = new Image(texture);
            image.x = 118;
            image.y = 212;
            image.width = 27;
            image.height = 25;
            image.smoothing= Constants.smoothing;
            image.touchable = false;
            this.addQuiackChild(image);
            txt_name = new TextField(213,36,'','',24,0xF8DEBD,false);
            txt_name.touchable = false;
            txt_name.hAlign= 'center';
            txt_name.text= '';
            txt_name.x = 5;
            txt_name.y = 15;
            this.addQuiackChild(txt_name);
            txt_des = new TextField(176,140,'','',20,0xF8DEBD,false);
            txt_des.touchable = false;
            txt_des.hAlign= 'left';
            txt_des.text= '';
            txt_des.x = 22;
            txt_des.y = 65;
            this.addQuiackChild(txt_des);
            texture = assetMgr.getTexture('ui_wenzi_lijiqianwang');
            btn_go = new Button(texture);
            btn_go.name= 'btn_go';
            btn_go.x = 57;
            btn_go.y = 248;
            btn_go.width = 103;
            btn_go.height = 29;
            this.addQuiackChild(btn_go);
            texture = assetMgr.getTexture('ui_wudixingyunxing_xingxing')
            star_0 = new Image(texture);
            star_0.x = 42;
            star_0.y = 212;
            star_0.width = 28;
            star_0.height = 26;
            this.addQuiackChild(star_0);
            star_0.touchable = false;
            texture = assetMgr.getTexture('ui_wudixingyunxing_xingxing')
            star_1 = new Image(texture);
            star_1.x = 68;
            star_1.y = 212;
            star_1.width = 28;
            star_1.height = 26;
            this.addQuiackChild(star_1);
            star_1.touchable = false;
            texture = assetMgr.getTexture('ui_wudixingyunxing_xingxing')
            star_2 = new Image(texture);
            star_2.x = 93;
            star_2.y = 212;
            star_2.width = 28;
            star_2.height = 26;
            this.addQuiackChild(star_2);
            star_2.touchable = false;
            texture = assetMgr.getTexture('ui_wudixingyunxing_xingxing')
            star_3 = new Image(texture);
            star_3.x = 118;
            star_3.y = 212;
            star_3.width = 28;
            star_3.height = 26;
            this.addQuiackChild(star_3);
            star_3.touchable = false;
            texture = assetMgr.getTexture('ui_wudixingyunxing_xingxing')
            star_4 = new Image(texture);
            star_4.x = 144;
            star_4.y = 212;
            star_4.width = 28;
            star_4.height = 26;
            this.addQuiackChild(star_4);
            star_4.touchable = false;
        }
        override public function dispose():void
        {
            btn_go.dispose();
            super.dispose();
        
}
    }
}
