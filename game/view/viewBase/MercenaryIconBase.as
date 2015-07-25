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

    public class MercenaryIconBase extends DefaultListItemRenderer
    {
        public var qualitybg:Button;
        public var imageIcon:Image;
        public var lockImage:Image;
        public var txt_1:TextField;
        public var txt_3:TextField;
        public var txt_2:TextField;

        public function MercenaryIconBase()
        {
            var texture:Texture;
            var textField:TextField;
            var input_txt:TextInput;
            var image:Image;
            var button:Button;
            var assetMgr:AssetMgr = AssetMgr.instance;
            texture =assetMgr.getTexture('ui_gongyong_90wupingkuang');
            image = new Image(texture);
            image.width = 100;
            image.height = 100;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            this.addQuiackChild(image);
            texture = assetMgr.getTexture('ui_gongyong_100yingxiongkuang_0');
            qualitybg = new Button(texture);
            qualitybg.name= 'qualitybg';
            qualitybg.width = 100;
            qualitybg.height = 100;
            this.addQuiackChild(qualitybg);
            texture = assetMgr.getTexture('photo_519')
            imageIcon = new Image(texture);
            imageIcon.width = 100;
            imageIcon.height = 100;
            this.addQuiackChild(imageIcon);
            imageIcon.touchable = false;
            texture = assetMgr.getTexture('ui_world_nandusuo')
            lockImage = new Image(texture);
            lockImage.x = 21;
            lockImage.y = 16;
            lockImage.width = 59;
            lockImage.height = 67;
            this.addQuiackChild(lockImage);
            lockImage.touchable = false;
            txt_1 = new TextField(100,26,'','',20,0xFF0000,false);
            txt_1.touchable = false;
            txt_1.hAlign= 'center';
            txt_1.text= '101关';
            txt_1.y = 6;
            this.addQuiackChild(txt_1);
            txt_3 = new TextField(100,26,'','',20,0xFF0000,false);
            txt_3.touchable = false;
            txt_3.hAlign= 'center';
            txt_3.text= '解锁';
            txt_3.y = 74;
            this.addQuiackChild(txt_3);
            txt_2 = new TextField(100,26,'','',20,0x00FF00,false);
            txt_2.touchable = false;
            txt_2.hAlign= 'center';
            txt_2.text= '已购买';
            txt_2.y = 6;
            this.addQuiackChild(txt_2);
        }
        override public function dispose():void
        {
            qualitybg.dispose();
            super.dispose();
        
}
    }
}
