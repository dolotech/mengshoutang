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
    import feathers.display.Scale9Image;
    import feathers.textures.Scale9Textures;
    import com.dialog.Dialog;

    public class DailyDoViewBase extends Dialog
    {
        public var ui_gongyong_di_9gongge33123:Scale9Image;
        public var txt_title:TextField;
        public var btn_close:Button;
        public var list_task:List;

        public function DailyDoViewBase()
        {
            super(false);
            var texture:Texture;
            var textField:TextField;
            var input_txt:TextInput;
            var image:Image;
            var button:Button;
            var assetMgr:AssetMgr = AssetMgr.instance;
            texture =assetMgr.getTexture('ui_wudixingyunxing_xingxing_goumaikuang2');
            image = new Image(texture);
            image.x = 83;
            image.y = 20;
            image.width = 579;
            image.height = 422;
            image.smoothing= Constants.NONE;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_wudixingyunxing_xingxing_goumaikuang1');
            image = new Image(texture);
            image.x = 753;
            image.y = 20;
            image.width = 102;
            image.height = 422;
            image.scaleX = -1;
            image.smoothing= Constants.NONE;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_wudixingyunxing_xingxing_goumaikuang1');
            image = new Image(texture);
            image.y = 20;
            image.width = 102;
            image.height = 422;
            image.smoothing= Constants.NONE;
            this.addQuiackChild(image);
            texture = assetMgr.getTexture('ui_gongyong_di_9gongge');
            var ui_gongyong_di_9gongge33123Rect:Rectangle = new Rectangle(21,21,43,41);
            var ui_gongyong_di_9gongge331239ScaleTexture:Scale9Textures = new Scale9Textures(texture,ui_gongyong_di_9gongge33123Rect);
            ui_gongyong_di_9gongge33123 = new Scale9Image(ui_gongyong_di_9gongge331239ScaleTexture);
            ui_gongyong_di_9gongge33123.x = 33;
            ui_gongyong_di_9gongge33123.y = 123;
            ui_gongyong_di_9gongge33123.width = 690;
            ui_gongyong_di_9gongge33123.height = 271;
            this.addQuiackChild(ui_gongyong_di_9gongge33123);
            texture =assetMgr.getTexture('ui_Setup_title');
            image = new Image(texture);
            image.x = 181;
            image.width = 399;
            image.height = 104;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            this.addQuiackChild(image);
            txt_title = new TextField(294,41,'','',28,0x3D3125,false);
            txt_title.touchable = false;
            txt_title.hAlign= 'center';
            txt_title.text= '每日必做';
            txt_title.x = 233;
            txt_title.y = 21;
            this.addQuiackChild(txt_title);
            texture = assetMgr.getTexture('ui_Buyingdiamond_button_guanbi');
            btn_close = new Button(texture);
            btn_close.name= 'btn_close';
            btn_close.x = 676;
            btn_close.y = 42;
            btn_close.width = 61;
            btn_close.height = 60;
            this.addQuiackChild(btn_close);
            list_task = new List();
            list_task.x = 42;
            list_task.y = 128;
            list_task.width = 670;
            list_task.height = 258;
            this.addQuiackChild(list_task);
            init();
        }
        override public function dispose():void
        {
            btn_close.dispose();
            list_task.dispose();
            super.dispose();
        
}
    }
}
