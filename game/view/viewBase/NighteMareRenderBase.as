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
    import feathers.display.Scale9Image;
    import feathers.textures.Scale9Textures;
    import feathers.controls.renderers.DefaultListItemRenderer;

    public class NighteMareRenderBase extends DefaultListItemRenderer
    {
        public var ui_gongyong_di_9gongge202:Scale9Image;
        public var icon:Image;
        public var txt_tag:TextField;
        public var txt_count:TextField;
        public var txt_needCount:TextField;
        public var txt_name:TextField;

        public function NighteMareRenderBase()
        {
            var texture:Texture;
            var textField:TextField;
            var input_txt:TextInput;
            var image:Image;
            var button:Button;
            var assetMgr:AssetMgr = AssetMgr.instance;
            texture = assetMgr.getTexture('ui_gongyong_di_9gongge');
            var ui_gongyong_di_9gongge202Rect:Rectangle = new Rectangle(21,21,43,41);
            var ui_gongyong_di_9gongge2029ScaleTexture:Scale9Textures = new Scale9Textures(texture,ui_gongyong_di_9gongge202Rect);
            ui_gongyong_di_9gongge202 = new Scale9Image(ui_gongyong_di_9gongge2029ScaleTexture);
            ui_gongyong_di_9gongge202.x = 20;
            ui_gongyong_di_9gongge202.y = 2;
            ui_gongyong_di_9gongge202.width = 85;
            ui_gongyong_di_9gongge202.height = 82;
            this.addQuiackChild(ui_gongyong_di_9gongge202);
            texture = assetMgr.getTexture('icon_113001')
            icon = new Image(texture);
            icon.x = 19;
            icon.y = -3;
            icon.width = 90;
            icon.height = 90;
            this.addQuiackChild(icon);
            icon.touchable = false;
            txt_tag = new TextField(104,30,'','',20,0xD31600,false);
            txt_tag.touchable = false;
            txt_tag.hAlign= 'right';
            txt_tag.text= '';
            this.addQuiackChild(txt_tag);
            txt_count = new TextField(70,36,'','',24,0xAF0F17,false);
            txt_count.touchable = false;
            txt_count.hAlign= 'right';
            txt_count.text= '';
            txt_count.x = 1;
            txt_count.y = 48;
            this.addQuiackChild(txt_count);
            txt_needCount = new TextField(64,36,'','',24,0xFFFFFF,false);
            txt_needCount.touchable = false;
            txt_needCount.hAlign= 'left';
            txt_needCount.text= '';
            txt_needCount.x = 75;
            txt_needCount.y = 48;
            this.addQuiackChild(txt_needCount);
            txt_name = new TextField(142,36,'','',24,0xFFFFFF,false);
            txt_name.touchable = false;
            txt_name.hAlign= 'center';
            txt_name.text= '';
            txt_name.x = -9;
            txt_name.y = 84;
            this.addQuiackChild(txt_name);
        }
    }
}
