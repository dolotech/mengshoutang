package game.view.arena.base
{
    import flash.geom.Rectangle;
    
    import feathers.display.Scale9Image;
    import feathers.textures.Scale9Textures;
    
    import game.manager.AssetMgr;
    
    import starling.display.Sprite;
    import starling.text.TextField;
    import starling.textures.Texture;

    public class RankItemBase extends Sprite
    {
        public var noTxt:TextField;
        public var nameTxt:TextField;
        public var expTxt:TextField;
        public var FightingTxt:TextField;

        public function RankItemBase()
        {
            var ui_gongyong_jiugonggedi00Texture:Texture = AssetMgr.instance.getTexture('ui_gongyong_jiugonggedi');
            var ui_gongyong_jiugonggedi00Rect:Rectangle = new Rectangle(38,37,77,75);
            var ui_gongyong_jiugonggedi009ScaleTexture:Scale9Textures = new Scale9Textures(ui_gongyong_jiugonggedi00Texture,ui_gongyong_jiugonggedi00Rect);
            var ui_gongyong_jiugonggedi009Scale:Scale9Image = new Scale9Image(ui_gongyong_jiugonggedi009ScaleTexture);
            ui_gongyong_jiugonggedi009Scale.x = 0;
            ui_gongyong_jiugonggedi009Scale.y = 0;
            ui_gongyong_jiugonggedi009Scale.width = 657;
            ui_gongyong_jiugonggedi009Scale.height = 66;
            this.addChild(ui_gongyong_jiugonggedi009Scale);
            noTxt = new TextField(101,46,'','',32,0xffffff,false);
            noTxt.touchable = false;
            noTxt.hAlign = 'left';
            noTxt.x = 14;
            noTxt.y = 9;
            this.addChild(noTxt);
            nameTxt = new TextField(236,46,'','',32,0xffffff,false);
            nameTxt.touchable = false;
            nameTxt.hAlign = 'center';
            nameTxt.x = 135;
            nameTxt.y = 9;
            this.addChild(nameTxt);
            expTxt = new TextField(110,46,'','',28,0xffffff,false);
            expTxt.touchable = false;
            expTxt.hAlign = 'center';
            expTxt.x = 403;
            expTxt.y = 9;
            this.addChild(expTxt);
            FightingTxt = new TextField(110,46,'','',28,0xffffff,false);
            FightingTxt.touchable = false;
            FightingTxt.hAlign = 'center';
            FightingTxt.x = 534;
            FightingTxt.y = 9;
            this.addChild(FightingTxt);

        }

    }
}