package game.view.arena.base
{
    import flash.geom.Rectangle;
    
    import feathers.controls.renderers.DefaultListItemRenderer;
    import feathers.display.Scale9Image;
    import feathers.textures.Scale9Textures;
    
    import game.manager.AssetMgr;
    
    import starling.display.Button;
    import starling.display.Image;
    import starling.text.TextField;
    import starling.textures.Texture;

    public class ConvertGoodsBase extends DefaultListItemRenderer
    {
        public var boxButton:Button;
        public var nameTxt:TextField;
        public var priceTxt:TextField;

        public function ConvertGoodsBase()
        {
            var ui_gongyong_jiugonggedi10Texture:Texture = AssetMgr.instance.getTexture('ui_gongyong_jiugonggedi');
            var ui_gongyong_jiugonggedi10Rect:Rectangle = new Rectangle(38,37,77,75);
            var ui_gongyong_jiugonggedi109ScaleTexture:Scale9Textures = new Scale9Textures(ui_gongyong_jiugonggedi10Texture,ui_gongyong_jiugonggedi10Rect);
            var ui_gongyong_jiugonggedi109Scale:Scale9Image = new Scale9Image(ui_gongyong_jiugonggedi109ScaleTexture);
            ui_gongyong_jiugonggedi109Scale.x = 1;
            ui_gongyong_jiugonggedi109Scale.y = 0;
            ui_gongyong_jiugonggedi109Scale.width = 125;
            ui_gongyong_jiugonggedi109Scale.height = 170;
            this.addChild(ui_gongyong_jiugonggedi109Scale);
            var boxTexture:Texture = AssetMgr.instance.getTexture('ui_button_wupinkuang');
            boxButton = new Button(boxTexture);
            boxButton.x = 11;
            boxButton.y = 32;
            boxButton.width = 107;
            boxButton.height = 110;
            this.addChild(boxButton);
            nameTxt = new TextField(122,30,'','',20,0xffffff,false);
            nameTxt.touchable = false;
            nameTxt.hAlign = 'center';
            nameTxt.x = 1;
            nameTxt.y = 5;
            this.addChild(nameTxt);
            var ui_pvp_rongyuzhibiaozhi17139Texture:Texture = AssetMgr.instance.getTexture('ui_pvp_rongyuzhibiaozhi');
            var ui_pvp_rongyuzhibiaozhi17139Image:Image = new Image(ui_pvp_rongyuzhibiaozhi17139Texture);
            ui_pvp_rongyuzhibiaozhi17139Image.x = 17;
            ui_pvp_rongyuzhibiaozhi17139Image.y = 139;
            ui_pvp_rongyuzhibiaozhi17139Image.width = 18;
            ui_pvp_rongyuzhibiaozhi17139Image.height = 25;
            ui_pvp_rongyuzhibiaozhi17139Image.touchable = false;
            this.addChild(ui_pvp_rongyuzhibiaozhi17139Image);
            priceTxt = new TextField(75,28,'','',18,0xffffff,false);
            priceTxt.touchable = false;
            priceTxt.hAlign = 'center';
            priceTxt.x = 35;
            priceTxt.y = 137;
            this.addChild(priceTxt);

        }
        override public function dispose():void
        {
            super.dispose();
            boxButton.dispose();
        
}

    }
}