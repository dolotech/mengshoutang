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

    public class WinHeroIcoRenderBase extends DefaultListItemRenderer
    {
        public var exp:Image;
        public var txt_exp:TextField;

        public function WinHeroIcoRenderBase()
        {
            var texture:Texture;
            var textField:TextField;
            var input_txt:TextInput;
            var image:Image;
            var button:Button;
            var assetMgr:AssetMgr = AssetMgr.instance;
            texture =assetMgr.getTexture('ui_jiesuan_jingyantiao_di');
            image = new Image(texture);
            image.x = 8;
            image.y = 100;
            image.width = 100;
            image.height = 20;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            this.addQuiackChild(image);
            texture = assetMgr.getTexture('ui_jiesuan_jingyantiao1')
            exp = new Image(texture);
            exp.x = 10;
            exp.y = 105;
            exp.width = 96;
            exp.height = 10;
            this.addQuiackChild(exp);
            exp.touchable = false;
            txt_exp = new TextField(114,36,'','',20,0xFFCC66,false);
            txt_exp.touchable = false;
            txt_exp.hAlign= 'center';
            txt_exp.text= '';
            txt_exp.y = 122;
            this.addQuiackChild(txt_exp);
        }
    }
}
