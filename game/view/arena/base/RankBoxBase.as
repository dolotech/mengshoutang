package game.view.arena.base
{
    import com.view.View;
    
    import flash.geom.Rectangle;
    
    import feathers.display.Scale9Image;
    import feathers.textures.Scale9Textures;
    
    import game.manager.AssetMgr;
    
    import starling.display.Button;
    import starling.display.Image;
    import starling.text.TextField;
    import starling.textures.Texture;

    public class RankBoxBase extends View
    {
        public var boxButton:Button;
        public var awardImage:Image;
        public var receiveTxt:TextField;

        public function RankBoxBase()
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
            var boxTexture:Texture = AssetMgr.instance.getTexture('ui_shangcheng_tiexiangzi');
            boxButton = new Button(boxTexture);
            boxButton.x = 71;
            boxButton.y = 255;
            boxButton.width = 148;
            boxButton.height = 127;
            this.addChild(boxButton);
            var awardTexture:Texture = AssetMgr.instance.getTexture('ui_gongyong_jingpinxiangzi');
            awardImage = new Image(awardTexture);
            awardImage.x = 133;
            awardImage.y = 284;
            awardImage.width = 73;
            awardImage.height = 75;
            this.addChild(awardImage);
            receiveTxt = new TextField(146,70,'','',38,0x66ff00,false);
            receiveTxt.touchable = false;
            receiveTxt.hAlign = 'center';
            receiveTxt.x = 73;
            receiveTxt.y = 306;
            this.addChild(receiveTxt);

        }
        override public function dispose():void
        {
            super.dispose();
            boxButton.dispose();
        
}

    }
}