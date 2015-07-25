package game.view.magicorbs.render
{
    import com.utils.Constants;
    
    import feathers.controls.List;
    import feathers.controls.renderers.DefaultListItemRenderer;
    
    import game.manager.AssetMgr;
    
    import starling.display.Button;
    import starling.display.Image;
    import starling.text.TextField;
    import starling.textures.Texture;

    public class GetOrbList extends DefaultListItemRenderer
    {
        public var list_orb:List;

        public function GetOrbList()
        {
            var texture:Texture;
            var textField:TextField;
            var image:Image;
            var button:Button;
            var assetMgr:AssetMgr = AssetMgr.instance;
            list_orb = new List();
            list_orb.x = 0;
              list_orb.y = 145;
            list_orb.width = 960;
            list_orb.height = 250;
            this.addQuiackChild(list_orb);
            texture =assetMgr.getTexture('ui_gongyong_prompt_di');
            image = new Image(texture);
            image.x = 205;
              image.y = 145;
            image.width = 550;
            image.height = 303;
            image.smoothing = Constants.smoothing;
            image.touchable = false;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_wenzi_huodexinwupin');
            image = new Image(texture);
            image.x = 396;
              image.y = 343;
            image.width = 174;
            image.height = 35;
            image.smoothing = Constants.smoothing;
            image.touchable = false;
            this.addQuiackChild(image);

        }
        override public function dispose():void
        {
            list_orb.dispose();
            super.dispose();
        
}

    }
}