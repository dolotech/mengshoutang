package game.view.luckyStar
{
    import game.manager.AssetMgr;

    import starling.display.Image;
    import starling.display.Sprite;
    import starling.text.TextField;
    import starling.textures.Texture;

    public class LastItemBase extends Sprite
    {
        public var awardTxt:TextField;
        public var nameTxt:TextField;

        public function LastItemBase()
        {
            var ui_xingyunxing_wenzidi134Texture:Texture=AssetMgr.instance.getTexture('ui_xingyunxing_wenzidi1');
            var ui_xingyunxing_wenzidi134Image:Image=new Image(ui_xingyunxing_wenzidi134Texture);
            ui_xingyunxing_wenzidi134Image.x=3;
            ui_xingyunxing_wenzidi134Image.y=4;
            ui_xingyunxing_wenzidi134Image.width=293;
            ui_xingyunxing_wenzidi134Image.height=28;
            ui_xingyunxing_wenzidi134Image.touchable=false;
            this.addChild(ui_xingyunxing_wenzidi134Image);
            awardTxt=new TextField(164, 37, '', '', 18, 0xffffff, false);
            awardTxt.touchable=false;
            awardTxt.hAlign='center';
            awardTxt.x=136;
            awardTxt.y=0;
            this.addChild(awardTxt);
            nameTxt=new TextField(150, 31, '', '', 18, 0xffffff, false);
            nameTxt.touchable=false;
            nameTxt.hAlign='center';
            nameTxt.x=0;
            nameTxt.y=3;
            this.addChild(nameTxt);

        }

    }
}
