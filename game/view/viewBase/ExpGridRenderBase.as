package  game.view.viewBase
{
    import starling.display.Image;
    import game.manager.AssetMgr;
    import starling.display.Sprite;
    import starling.textures.Texture;
    import starling.text.TextField;
    import starling.display.Button;
    import flash.geom.Rectangle;
    import com.utils.Constants;
    import feathers.controls.TextInput;
    import feathers.display.Scale9Image;
    import feathers.textures.Scale9Textures;
    import feathers.controls.renderers.DefaultListItemRenderer;

    public class ExpGridRenderBase extends DefaultListItemRenderer
    {
        public var ui_gongyong_di_9gongge00:Scale9Image;
        public var icon:Button;
        public var txt_add:TextField;
        public var txt_count:TextField;

        public function ExpGridRenderBase()
        {
            var texture:Texture;
            var textField:TextField;
            var input_txt:TextInput;
            var image:Image;
            var button:Button;;
            var assetMgr:AssetMgr = AssetMgr.instance;
            texture = assetMgr.getTexture('ui_gongyong_di_9gongge');
            var ui_gongyong_di_9gongge00Rect:Rectangle = new Rectangle(21,21,43,41);
            var ui_gongyong_di_9gongge009ScaleTexture:Scale9Textures = new Scale9Textures(texture,ui_gongyong_di_9gongge00Rect);
            ui_gongyong_di_9gongge00 = new Scale9Image(ui_gongyong_di_9gongge009ScaleTexture);
            ui_gongyong_di_9gongge00.width = 116;
            ui_gongyong_di_9gongge00.height = 109;
            this.addQuiackChild(ui_gongyong_di_9gongge00);
            texture = assetMgr.getTexture('icon_31');
            icon = new Button(texture);
            icon.name= 'icon';
            icon.x = 14;
            icon.y = 20;
            icon.width = 89;
            icon.height = 89;
            this.addQuiackChild(icon);
            txt_add = new TextField(107,31,'','',22,0xD01562,false);
            txt_add.touchable = false;
            txt_add.hAlign= 'left';
            txt_add.text= '+9999999';
            txt_add.x = 4;
            txt_add.y = 3;
            this.addQuiackChild(txt_add);
            txt_count = new TextField(107,31,'','',24,0xFFFFFF,false);
            txt_count.touchable = false;
            txt_count.hAlign= 'right';
            txt_count.text= '';
            txt_count.x = 4;
            txt_count.y = 75;
            this.addQuiackChild(txt_count);
        }
        override public function dispose():void
        {
            icon.dispose();
            super.dispose();
        
}
    }
}
