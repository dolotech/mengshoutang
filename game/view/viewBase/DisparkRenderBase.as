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
    import com.view.View;

    public class DisparkRenderBase extends View
    {
        public var ui_gongyong_hero_pub_9gongge_article90:Scale9Image;
        public var txtContent:TextField;
        public var newBtn:Image;

        public function DisparkRenderBase()
        {
            super(false);
            var texture:Texture;
            var textField:TextField;
            var input_txt:TextInput;
            var image:Image;
            var button:Button;
            var assetMgr:AssetMgr = AssetMgr.instance;
            texture = assetMgr.getTexture('ui_gongyong_hero_pub_9gongge_article');
            var ui_gongyong_hero_pub_9gongge_article90Rect:Rectangle = new Rectangle(17,19,27,22);
            var ui_gongyong_hero_pub_9gongge_article909ScaleTexture:Scale9Textures = new Scale9Textures(texture,ui_gongyong_hero_pub_9gongge_article90Rect);
            ui_gongyong_hero_pub_9gongge_article90 = new Scale9Image(ui_gongyong_hero_pub_9gongge_article909ScaleTexture);
            ui_gongyong_hero_pub_9gongge_article90.x = 9;
            ui_gongyong_hero_pub_9gongge_article90.width = 380;
            ui_gongyong_hero_pub_9gongge_article90.height = 45;
            this.addQuiackChild(ui_gongyong_hero_pub_9gongge_article90);
            txtContent = new TextField(330,28,'','',22,0xFFFFFF,false);
            txtContent.touchable = false;
            txtContent.hAlign= 'center';
            txtContent.text= '';
            txtContent.x = 53;
            txtContent.y = 9;
            this.addQuiackChild(txtContent);
            texture = assetMgr.getTexture('ui_renwu_new1')
            newBtn = new Image(texture);
            newBtn.x = 12;
            newBtn.y = -6;
            newBtn.width = 52;
            newBtn.height = 52;
            this.addQuiackChild(newBtn);
            newBtn.touchable = false;
            init();
        }
    }
}
