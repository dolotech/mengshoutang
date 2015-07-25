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
    import com.view.View;

    public class EmbattleGridBase extends View
    {
        public var empty_ico:Image;
        public var btn_add:Button;

        public function EmbattleGridBase()
        {
            super(false);
            var texture:Texture;
            var textField:TextField;
            var input_txt:TextInput;
            var image:Image;
            var button:Button;
            var assetMgr:AssetMgr = AssetMgr.instance;
            texture = assetMgr.getTexture('ui_gongyong_dianquanheng_di')
            empty_ico = new Image(texture);
            empty_ico.width = 120;
            empty_ico.height = 90;
            this.addQuiackChild(empty_ico);
            empty_ico.touchable = false;
            texture = assetMgr.getTexture('ui_wenzi_tianjiayingxiong');
            btn_add = new Button(texture);
            btn_add.name= 'btn_add';
            btn_add.x = 20;
            btn_add.y = 30;
            btn_add.width = 79;
            btn_add.height = 18;
            this.addQuiackChild(btn_add);
            init();
        }
        override public function dispose():void
        {
            btn_add.dispose();
            super.dispose();
        
}
    }
}
