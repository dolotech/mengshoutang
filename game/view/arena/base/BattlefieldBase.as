package game.view.arena.base
{
    import flash.geom.Rectangle;
    
    import feathers.display.Scale9Image;
    import feathers.textures.Scale9Textures;
    
    import game.manager.AssetMgr;
    
    import starling.display.Sprite;
    import starling.text.TextField;
    import starling.textures.Texture;

    public class BattlefieldBase extends Sprite
    {
        public var youTxt:TextField;
        public var captionTxt:TextField;
        public var otherTxt:TextField;
        public var loseTxt:TextField;

        public function BattlefieldBase()
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
            youTxt = new TextField(74,46,'','',24,0xffffff,false);
            youTxt.touchable = false;
            youTxt.hAlign = 'left';
            youTxt.x = 12;
            youTxt.y = 12;
            this.addChild(youTxt);
            captionTxt = new TextField(369,46,'','',24,0xffffff,false);
            captionTxt.touchable = false;
            captionTxt.hAlign = 'left';
            captionTxt.x = 360;
            captionTxt.y = 13;
            this.addChild(captionTxt);
            otherTxt = new TextField(159,44,'','',30,0xffff00,false);
            otherTxt.touchable = false;
            otherTxt.hAlign = 'left';
            otherTxt.x = 89;
            otherTxt.y = 13;
            this.addChild(otherTxt);
            loseTxt = new TextField(104,44,'','',24,0xffffff,false);
            loseTxt.touchable = false;
            loseTxt.hAlign = 'left';
            loseTxt.x = 217;
            loseTxt.y = 13;
            this.addChild(loseTxt);

        }

    }
}