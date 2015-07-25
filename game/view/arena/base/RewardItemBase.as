package game.view.arena.base
{
    import flash.geom.Rectangle;
    
    import feathers.display.Scale9Image;
    import feathers.textures.Scale9Textures;
    
    import game.manager.AssetMgr;
    
    import starling.display.Sprite;
    import starling.text.TextField;
    import starling.textures.Texture;

    public class RewardItemBase extends Sprite
    {
        public var beTxt:TextField;
        public var captionTxt:TextField;
        public var myNameTxt:TextField;
        public var otherNameTxt:TextField;

        public function RewardItemBase()
        {
            var ui_gongyong_jiugonggedi00Texture:Texture = AssetMgr.instance.getTexture('ui_gongyong_jiugonggedi');
            var ui_gongyong_jiugonggedi00Rect:Rectangle = new Rectangle(38,37,77,75);
            var ui_gongyong_jiugonggedi009ScaleTexture:Scale9Textures = new Scale9Textures(ui_gongyong_jiugonggedi00Texture,ui_gongyong_jiugonggedi00Rect);
            var ui_gongyong_jiugonggedi009Scale:Scale9Image = new Scale9Image(ui_gongyong_jiugonggedi009ScaleTexture);
            ui_gongyong_jiugonggedi009Scale.x = 0;
            ui_gongyong_jiugonggedi009Scale.y = 0;
            ui_gongyong_jiugonggedi009Scale.width = 841;
            ui_gongyong_jiugonggedi009Scale.height = 63;
            this.addChild(ui_gongyong_jiugonggedi009Scale);
            beTxt = new TextField(39,46,'','',24,0xffffff,false);
            beTxt.touchable = false;
            beTxt.hAlign = 'left';
            beTxt.x = 153;
            beTxt.y = 9;
            this.addChild(beTxt);
            captionTxt = new TextField(329,44,'','',20,0xffffff,false);
            captionTxt.touchable = false;
            captionTxt.hAlign = 'left';
            captionTxt.x = 364;
            captionTxt.y = 9;
            this.addChild(captionTxt);
            myNameTxt = new TextField(172,47,'','',24,0xffff00,false);
            myNameTxt.touchable = false;
            myNameTxt.hAlign = 'left';
            myNameTxt.x = 20;
            myNameTxt.y = 8;
            this.addChild(myNameTxt);
            otherNameTxt = new TextField(172,47,'','',24,0xffff00,false);
            otherNameTxt.touchable = false;
            otherNameTxt.hAlign = 'left';
            otherNameTxt.x = 183;
            otherNameTxt.y = 8;
            this.addChild(otherNameTxt);

        }

    }
}