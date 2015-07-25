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
    import feathers.controls.List;
    import feathers.display.Scale9Image;
    import feathers.textures.Scale9Textures;
    import com.view.View;

    public class GoodsGuideListBase extends View
    {
        public var ui_Setup_button_switch31529:Scale9Image;
        public var list_equip:List;

        public function GoodsGuideListBase()
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
            image.height = 446;
            image.smoothing= Constants.NONE;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_wudixingyunxing_xingxing_goumaikuang2');
            image = new Image(texture);
            image.x = 79;
            image.width = 216;
            image.height = 446;
            image.smoothing= Constants.NONE;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_wudixingyunxing_xingxing_goumaikuang1');
            image = new Image(texture);
            image.x = 350;
            image.width = 102;
            image.height = 446;
            image.scaleX = -1;
            image.smoothing= Constants.NONE;
            this.addQuiackChild(image);
            texture = assetMgr.getTexture('ui_Setup_button_switch3');
            var ui_Setup_button_switch31529Rect:Rectangle = new Rectangle(54,26,107,52);
            var ui_Setup_button_switch315299ScaleTexture:Scale9Textures = new Scale9Textures(texture,ui_Setup_button_switch31529Rect);
            ui_Setup_button_switch31529 = new Scale9Image(ui_Setup_button_switch315299ScaleTexture);
            ui_Setup_button_switch31529.x = 15;
            ui_Setup_button_switch31529.y = 29;
            ui_Setup_button_switch31529.width = 318;
            ui_Setup_button_switch31529.height = 400;
            this.addQuiackChild(ui_Setup_button_switch31529);
            list_equip = new List();
            list_equip.x = 19;
            list_equip.y = 30;
            list_equip.width = 310;
            list_equip.height = 388;
            this.addQuiackChild(list_equip);
            init();
        }
        override public function dispose():void
        {
            list_equip.dispose();
            super.dispose();
        
}
    }
}
