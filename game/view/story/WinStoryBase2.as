package game.view.story
{
    import game.manager.AssetMgr;
    
    import starling.display.Button;
    import starling.display.Sprite;
    import starling.text.TextField;
    import starling.textures.Texture;

    public class WinStoryBase2 extends Sprite
    {
        public var bgButton:Button;
        public var nameTxt:TextField;
        public var captionTxt:TextField;

        public function WinStoryBase2()
        {
            var bgTexture:Texture = AssetMgr.instance.getTexture('story_words');
            bgButton = new Button(bgTexture);
            bgButton.x = 960;
              bgButton.y = 399;
            bgButton.width = 960;
            bgButton.height = 241;
            this.addQuiackChild(bgButton);
            nameTxt = new TextField(214,43,'','',35,0xffffff,false);
            nameTxt.touchable = false;
            nameTxt.hAlign = 'center';
            nameTxt.x = 623;
              nameTxt.y = 442;
            this.addQuiackChild(nameTxt);
            captionTxt = new TextField(849,106,'','',30,0x222222,false);
            captionTxt.touchable = false;
            captionTxt.hAlign = 'left';
            captionTxt.x = 21;
              captionTxt.y = 518;
            this.addQuiackChild(captionTxt);

        }
        override public function dispose():void
        {
            super.dispose();
            bgButton.dispose();
        
}

    }
}