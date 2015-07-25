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

    public class BoosViewBase extends View
    {
        public var bossName:TextField;
        public var bossHead:Button;

        public function BoosViewBase()
        {
            super(false);
            var texture:Texture;
            var textField:TextField;
            var input_txt:TextInput;
            var image:Image;
            var button:Button;
            var assetMgr:AssetMgr = AssetMgr.instance;
            texture =assetMgr.getTexture('ui_zhandou_xuetiao_dadi');
            image = new Image(texture);
            image.x = 436;
            image.y = 13;
            image.width = 213;
            image.height = 82;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            this.addQuiackChild(image);
            bossName = new TextField(312,36,'','',20,0xFFFFFF,false);
            bossName.touchable = false;
            bossName.hAlign= 'center';
            bossName.text= '关卡名字读表';
            bossName.x = 390;
            bossName.y = 16;
            this.addQuiackChild(bossName);
            texture =assetMgr.getTexture('ui_zhandou_xuetiao_hong');
            image = new Image(texture);
            image.x = 10;
            image.y = 46;
            image.width = 614;
            image.height = 24;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            this.addQuiackChild(image);
            texture = assetMgr.getTexture('ui_zhandou_xuetiao_dadi1');
            bossHead = new Button(texture);
            bossHead.name= 'bossHead';
            bossHead.x = 609;
            bossHead.y = -17;
            bossHead.width = 117;
            bossHead.height = 123;
            this.addQuiackChild(bossHead);
            texture =assetMgr.getTexture('ui_zhandou_xuetiao_dadi1');
            image = new Image(texture);
            image.width = 117;
            image.height = 123;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            bossHead.addQuiackChild(image);
            texture = assetMgr.getTexture('1')
            image = new Image(texture);
            image.name= 'bossIcon';
            image.x = 23;
            image.y = 25;
            image.width = 89;
            image.height = 89;
            bossHead.addQuiackChild(image);
            image.touchable = false;
            texture =assetMgr.getTexture('ui_zhandou_xuetiao_dadi2');
            image = new Image(texture);
            image.width = 117;
            image.height = 123;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            bossHead.addQuiackChild(image);
            init();
        }
        override public function dispose():void
        {
            bossHead.dispose();
            super.dispose();
        
}
    }
}
