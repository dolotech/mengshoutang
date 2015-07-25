package game.view.luckyStar
{
    import game.manager.AssetMgr;
    
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.text.TextField;
    import starling.textures.Texture;

    public class RichItemBase extends Sprite
    {
        public var starTxt:TextField;
        public var valuesTxt:TextField;
        public var nameTxt:TextField;

        public function RichItemBase()
        {
            var ui_xingyunxing_wenzidi450Texture:Texture = AssetMgr.instance.getTexture('ui_xingyunxing_wenzidi4');
            var ui_xingyunxing_wenzidi450Image:Image = new Image(ui_xingyunxing_wenzidi450Texture);
            ui_xingyunxing_wenzidi450Image.x = 5;
            ui_xingyunxing_wenzidi450Image.y = 0;
            ui_xingyunxing_wenzidi450Image.width = 297;
            ui_xingyunxing_wenzidi450Image.height = 29;
            ui_xingyunxing_wenzidi450Image.touchable = false;
            this.addChild(ui_xingyunxing_wenzidi450Image);
            starTxt = new TextField(63,25,'','',16,0xcccccc,false);
            starTxt.touchable = false;
            starTxt.hAlign = 'center';
            starTxt.x = 143;
            starTxt.y = 1;
            this.addChild(starTxt);
            valuesTxt = new TextField(93,26,'','',16,0xcccccc,false);
            valuesTxt.touchable = false;
            valuesTxt.hAlign = 'center';
            valuesTxt.x = 216;
            valuesTxt.y = 1;
            this.addChild(valuesTxt);
            nameTxt = new TextField(138,25,'','',16,0xcccccc,false);
            nameTxt.touchable = false;
            nameTxt.hAlign = 'center';
            nameTxt.x = 0;
            nameTxt.y = 1;
            this.addChild(nameTxt);

        }

    }
}