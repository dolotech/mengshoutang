package  game.view.viewBase
{
    import starling.display.Image;
    import game.manager.AssetMgr;
    import starling.display.Sprite;
    import starling.textures.Texture;
    import starling.text.TextField;
    import starling.display.Button;
    import flash.geom.Rectangle;
    import feathers.controls.renderers.DefaultListItemRenderer;
    import com.utils.Constants;

    public class ArenaCreateNameRenderBase extends DefaultListItemRenderer
    {
        public var ico_hero:Button;

        public function ArenaCreateNameRenderBase()
        {
            var texture:Texture;
            var textField:TextField;
            var image:Image;
            var button:Button;;
            var assetMgr:AssetMgr = AssetMgr.instance;
            texture = assetMgr.getTexture('ui_pvp_renwutouxiang0');
            ico_hero = new Button(texture);
            ico_hero.name= 'ico_hero';
            ico_hero.x = 10;
            ico_hero.y = 11;
            ico_hero.width = 100;
            ico_hero.height = 100;
            this.addQuiackChild(ico_hero);
            texture =assetMgr.getTexture('ui_city_head1');
            image = new Image(texture);
            image.width = 122;
            image.height = 122;
            image.smoothing= Constants.smoothing;
            image.touchable = false;
            this.addQuiackChild(image);
        }
        override public function dispose():void
        {
            ico_hero.dispose();
            super.dispose();
        
}
    }
}
