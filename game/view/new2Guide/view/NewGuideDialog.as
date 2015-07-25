package game.view.new2Guide.view
{
    import game.manager.AssetMgr;
    
    import starling.display.Button;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.text.TextField;
    import starling.textures.Texture;
    import com.utils.Constants;

    public class NewGuideDialog extends Sprite
    {
        public var txt_des:TextField;

        public function NewGuideDialog()
        {
            var texture:Texture;
            var textField:TextField;
            var image:Image;
            var button:Button;
            var assetMgr:AssetMgr = AssetMgr.instance;
            texture =assetMgr.getTexture('ui_yindaopaopao');
            image = new Image(texture);
            image.x = 0;
              image.y = 0;
            image.width = 400;
            image.height = 200;
            image.smoothing = Constants.smoothing;
            image.touchable = false;
            this.addQuiackChild(image);
            txt_des = new TextField(244,135,'','',20,0x000000,false);
            txt_des.touchable = false;
            txt_des.hAlign = 'left';
            txt_des.text = '';
            txt_des.x = 13;
              txt_des.y = 36;
            this.addQuiackChild(txt_des);

        }

    }
}