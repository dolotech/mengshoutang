package game.view.arena.base
{
    import com.view.View;
    
    import flash.geom.Rectangle;
    
    import feathers.display.Scale9Image;
    import feathers.textures.Scale9Textures;
    
    import game.manager.AssetMgr;
    
    import starling.display.Image;
    import starling.text.TextField;
    import starling.textures.Texture;

    public class RankBase extends View
    {
        public var cdTxt:TextField;
        public var awardImage:Image;
        public var receiveTxt:TextField;

        public function RankBase()
        {
            var ui_gongyong_jiugonggedi63212Texture:Texture = AssetMgr.instance.getTexture('ui_gongyong_jiugonggedi');
            var ui_gongyong_jiugonggedi63212Rect:Rectangle = new Rectangle(38,37,77,75);
            var ui_gongyong_jiugonggedi632129ScaleTexture:Scale9Textures = new Scale9Textures(ui_gongyong_jiugonggedi63212Texture,ui_gongyong_jiugonggedi63212Rect);
            var ui_gongyong_jiugonggedi632129Scale:Scale9Image = new Scale9Image(ui_gongyong_jiugonggedi632129ScaleTexture);
            ui_gongyong_jiugonggedi632129Scale.x = 63;
            ui_gongyong_jiugonggedi632129Scale.y = 212;
            ui_gongyong_jiugonggedi632129Scale.width = 169;
            ui_gongyong_jiugonggedi632129Scale.height = 245;
            this.addChild(ui_gongyong_jiugonggedi632129Scale);
            var ui_shangcheng_tiexiangzi71231Texture:Texture = AssetMgr.instance.getTexture('ui_shangcheng_tiexiangzi');
            var ui_shangcheng_tiexiangzi71231Image:Image = new Image(ui_shangcheng_tiexiangzi71231Texture);
            ui_shangcheng_tiexiangzi71231Image.x = 71;
            ui_shangcheng_tiexiangzi71231Image.y = 231;
            ui_shangcheng_tiexiangzi71231Image.width = 148;
            ui_shangcheng_tiexiangzi71231Image.height = 127;
            ui_shangcheng_tiexiangzi71231Image.touchable = false;
            this.addChild(ui_shangcheng_tiexiangzi71231Image);
            cdTxt = new TextField(144,46,'','',32,0xff0000,false);
            cdTxt.touchable = false;
            cdTxt.hAlign = 'center';
            cdTxt.x = 77;
            cdTxt.y = 375;
            this.addChild(cdTxt);
            var awardTexture:Texture = AssetMgr.instance.getTexture('ui_gongyong_jingpinxiangzi');
            awardImage = new Image(awardTexture);
            awardImage.x = 133;
            awardImage.y = 272;
            awardImage.width = 73;
            awardImage.height = 75;
            this.addChild(awardImage);
            receiveTxt = new TextField(146,70,'','',38,0x66ff00,false);
            receiveTxt.touchable = false;
            receiveTxt.hAlign = 'center';
            receiveTxt.x = 73;
            receiveTxt.y = 283;
            this.addChild(receiveTxt);

        }

    }
}