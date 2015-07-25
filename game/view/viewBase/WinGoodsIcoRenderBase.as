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

    public class WinGoodsIcoRenderBase extends DefaultListItemRenderer
    {
        public var icon:Image;
        public var icon_quality:Image;

        public function WinGoodsIcoRenderBase()
        {
            var texture:Texture;
            var textField:TextField;
            var input_txt:TextInput;
            var image:Image;
            var button:Button;
            var assetMgr:AssetMgr = AssetMgr.instance;
            texture =assetMgr.getTexture('ui_gongyong_90wupingkuang');
            image = new Image(texture);
            image.width = 90;
            image.height = 90;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            this.addQuiackChild(image);
            texture = assetMgr.getTexture('ui_button_mail')
            icon = new Image(texture);
            icon.x = 1;
            icon.y = 1;
            icon.width = 89;
            icon.height = 89;
            this.addQuiackChild(icon);
            icon.touchable = false;
            texture = assetMgr.getTexture('ui_gongyong_90wupingkuang0')
            icon_quality = new Image(texture);
            icon_quality.width = 90;
            icon_quality.height = 90;
            this.addQuiackChild(icon_quality);
            icon_quality.touchable = false;
        }
    }
}
