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
    import feathers.controls.List;
    import com.dialog.Dialog;

    public class NewLostViewBase extends Dialog
    {
        public var list_item:List;
        public var btn_replay:Button;
        public var btn_return:Button;

        public function NewLostViewBase()
        {
            super(false);
            var texture:Texture;
            var textField:TextField;
            var input_txt:TextInput;
            var image:Image;
            var button:Button;
            var assetMgr:AssetMgr = AssetMgr.instance;
            list_item = new List();
            list_item.y = 218;
            list_item.width = 662;
            list_item.height = 340;
            this.addQuiackChild(list_item);
            texture = assetMgr.getTexture('ui_button_chongfu_iocn');
            btn_replay = new Button(texture);
            btn_replay.name= 'btn_replay';
            btn_replay.x = 739;
            btn_replay.y = 264;
            btn_replay.width = 109;
            btn_replay.height = 103;
            this.addQuiackChild(btn_replay);
            texture = assetMgr.getTexture('ui_button_fanhui_iocn');
            btn_return = new Button(texture);
            btn_return.name= 'btn_return';
            btn_return.x = 742;
            btn_return.y = 428;
            btn_return.width = 109;
            btn_return.height = 103;
            this.addQuiackChild(btn_return);
            texture =assetMgr.getTexture('ui_jiesuan_hengtiao');
            image = new Image(texture);
            image.x = 12;
            image.y = 206;
            image.width = 627;
            image.height = 3;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            this.addQuiackChild(image);
            init();
        }
        override public function dispose():void
        {
            list_item.dispose();
            btn_replay.dispose();
            btn_return.dispose();
            super.dispose();
        
}
    }
}
