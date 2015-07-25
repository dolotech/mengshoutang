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

    public class NewStrengthenGridBase extends DefaultListItemRenderer
    {
        public var tag:Image;
        public var txt_name:TextField;
        public var ico_goods:Image;

        public function NewStrengthenGridBase()
        {
            var texture:Texture;
            var textField:TextField;
            var input_txt:TextInput;
            var image:Image;
            var button:Button;
            var assetMgr:AssetMgr = AssetMgr.instance;
            texture =assetMgr.getTexture('ui_gongyong_100yingxiongkuang_kong2');
            image = new Image(texture);
            image.width = 92;
            image.height = 91;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            this.addQuiackChild(image);
            texture = assetMgr.getTexture('ui_text_intensify2')
            tag = new Image(texture);
            tag.x = 16;
            tag.y = 36;
            tag.width = 59;
            tag.height = 19;
            this.addQuiackChild(tag);
            tag.touchable = false;
            txt_name = new TextField(108,28,'','',18,0xFFFFCC,false);
            txt_name.touchable = false;
            txt_name.hAlign= 'center';
            txt_name.text= '';
            txt_name.x = -8;
            txt_name.y = 90;
            this.addQuiackChild(txt_name);
            texture = assetMgr.getTexture('icon_20001')
            ico_goods = new Image(texture);
            ico_goods.width = 89;
            ico_goods.height = 89;
            this.addQuiackChild(ico_goods);
            ico_goods.touchable = false;
        }
    }
}
