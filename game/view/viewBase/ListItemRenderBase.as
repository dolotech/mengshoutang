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

    public class ListItemRenderBase extends Sprite
    {
        public var icon:Image;
        public var title:TextField;
        public var caption:TextField;
        public var goodsIcon:Image;
        public var quality:Image;
        public var values:TextField;
        public var okReceive:Image;

        public function ListItemRenderBase()
        {
            var texture:Texture;
            var textField:TextField;
            var input_txt:TextInput;
            var image:Image;
            var button:Button;
            var assetMgr:AssetMgr = AssetMgr.instance;
            texture =assetMgr.getTexture('ui_rongyupaizi_di');
            image = new Image(texture);
            image.width = 325;
            image.height = 103;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            this.addQuiackChild(image);
            texture = assetMgr.getTexture('ui_tubiao_rongyu1')
            icon = new Image(texture);
            icon.x = 14;
            icon.y = 5;
            icon.width = 98;
            icon.height = 89;
            this.addQuiackChild(icon);
            icon.touchable = false;
            texture =assetMgr.getTexture('ui_rongyupaizi_di');
            image = new Image(texture);
            image.x = 641;
            image.width = 325;
            image.height = 103;
            image.scaleX = -1;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            this.addQuiackChild(image);
            title = new TextField(323,44,'','',28,0xFFFF00,false);
            title.touchable = false;
            title.hAlign= 'center';
            title.text= '一代宗师';
            title.x = 165;
            title.y = 8;
            this.addQuiackChild(title);
            caption = new TextField(424,35,'','',20,0xFFFFFF,false);
            caption.touchable = false;
            caption.hAlign= 'center';
            caption.text= '这里白色字体';
            caption.x = 115;
            caption.y = 56;
            this.addQuiackChild(caption);
            texture =assetMgr.getTexture('ui_gongyong_90wupingkuang');
            image = new Image(texture);
            image.x = 542;
            image.y = 5;
            image.width = 90;
            image.height = 90;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            this.addQuiackChild(image);
            texture = assetMgr.getTexture('icon_10101')
            goodsIcon = new Image(texture);
            goodsIcon.x = 543;
            goodsIcon.y = 5;
            goodsIcon.width = 89;
            goodsIcon.height = 89;
            this.addQuiackChild(goodsIcon);
            goodsIcon.touchable = false;
            texture = assetMgr.getTexture('ui_gongyong_90wupingkuang0')
            quality = new Image(texture);
            quality.x = 542;
            quality.y = 6;
            quality.width = 90;
            quality.height = 90;
            this.addQuiackChild(quality);
            quality.touchable = false;
            values = new TextField(100,33,'','',16,0xFFFFFF,false);
            values.touchable = false;
            values.hAlign= 'right';
            values.text= 'x100';
            values.x = 526;
            values.y = 62;
            this.addQuiackChild(values);
            texture = assetMgr.getTexture('ui_gongyong_jianglilingqu')
            okReceive = new Image(texture);
            okReceive.x = 549;
            okReceive.y = 26;
            okReceive.width = 77;
            okReceive.height = 32;
            this.addQuiackChild(okReceive);
            okReceive.touchable = false;
        }
    }
}
