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
    import feathers.controls.renderers.DefaultListItemRenderer;

    public class GoodsGuideGridBase extends DefaultListItemRenderer
    {
        public var txt_name:TextField;
        public var ico_equip:Button;
        public var ico_quality:Image;
        public var txt_level:TextField;

        public function GoodsGuideGridBase()
        {
            var texture:Texture;
            var textField:TextField;
            var input_txt:TextInput;
            var image:Image;
            var button:Button;
            var assetMgr:AssetMgr = AssetMgr.instance;
            texture =assetMgr.getTexture('ui_button_wupinkuang');
            image = new Image(texture);
            image.width = 100;
            image.height = 99;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            this.addQuiackChild(image);
            txt_name = new TextField(163,30,'','',20,0xFFFFFF,false);
            txt_name.touchable = false;
            txt_name.hAlign= 'center';
            txt_name.text= '';
            txt_name.x = -34;
            txt_name.y = 100;
            this.addQuiackChild(txt_name);
            texture =assetMgr.getTexture('ui_gongyong_90wupingkuang');
            image = new Image(texture);
            image.x = 3;
            image.y = 7;
            image.width = 90;
            image.height = 90;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            this.addQuiackChild(image);
            texture = assetMgr.getTexture('icon_300010');
            ico_equip = new Button(texture);
            ico_equip.name= 'ico_equip';
            ico_equip.x = 4;
            ico_equip.y = 3;
            ico_equip.width = 90;
            ico_equip.height = 90;
            this.addQuiackChild(ico_equip);
            texture = assetMgr.getTexture('ui_gongyong_90wupingkuang0')
            ico_quality = new Image(texture);
            ico_quality.x = 4;
            ico_quality.y = 6;
            ico_quality.width = 89;
            ico_quality.height = 86;
            this.addQuiackChild(ico_quality);
            ico_quality.touchable = false;
            txt_level = new TextField(100,30,'','',20,0xFFFFFF,false);
            txt_level.touchable = false;
            txt_level.hAlign= 'center';
            txt_level.text= '';
            this.addQuiackChild(txt_level);
        }
        override public function dispose():void
        {
            ico_equip.dispose();
            super.dispose();
        
}
    }
}
