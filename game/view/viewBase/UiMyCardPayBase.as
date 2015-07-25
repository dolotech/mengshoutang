package game.view.viewBase
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
    import feathers.controls.TextInput;
    import com.dialog.Dialog;

    public class UiMyCardPayBase extends Dialog
    {
        public var txt_input1:TextInput;
        public var txt_input2:TextInput;
        public var btn_ok:Button;
        public var btn_cancel:Button;

        public function UiMyCardPayBase()
        {
            super(true);
            var texture:Texture;
            var textField:TextField;
            var input_txt:TextInput;
            var image:Image;
            var button:Button;
            var assetMgr:AssetMgr=AssetMgr.instance;
            texture=assetMgr.getTexture('ui_kahaoshurudi');
            image=new Image(texture);
            image.width=664;
            image.height=303;
            image.smoothing=Constants.smoothing;
            this.addQuiackChild(image);
            txt_input1=new TextInput();
            txt_input1.textEditorProperties.fontSize=36;
            txt_input1.text='';
            txt_input1.textEditorProperties.color=0xFFFFFF;
            txt_input1.x=184;
            txt_input1.y=49;
            txt_input1.width=402;
            txt_input1.height=52;
            this.addQuiackChild(txt_input1);
            txt_input2=new TextInput();
            txt_input2.textEditorProperties.fontSize=36;
            txt_input2.text='';
            txt_input2.textEditorProperties.color=0xFFFFFF;
            txt_input2.x=184;
            txt_input2.y=125;
            txt_input2.width=402;
            txt_input2.height=52;
            this.addQuiackChild(txt_input2);
            texture=assetMgr.getTexture('ui_button_tiebaomutouanjian');
            btn_ok=new Button(texture);
            btn_ok.name='btn_ok';
            btn_ok.x=129;
            btn_ok.y=206;
            btn_ok.width=150;
            btn_ok.height=64;
            this.addQuiackChild(btn_ok);
            btn_ok.text='确定';
            btn_ok.fontColor=0xFFFFFF;
            btn_ok.fontSize=30;
            texture=assetMgr.getTexture('ui_button_tiebaomutouanjian');
            btn_cancel=new Button(texture);
            btn_cancel.name='btn_cancel';
            btn_cancel.x=397;
            btn_cancel.y=206;
            btn_cancel.width=150;
            btn_cancel.height=64;
            this.addQuiackChild(btn_cancel);
            btn_cancel.text='取消';
            btn_cancel.fontColor=0xFFFFFF;
            btn_cancel.fontSize=30;
            init();
        }

        override public function dispose():void
        {
            txt_input1.dispose();
            txt_input2.dispose();
            btn_ok.dispose();
            btn_cancel.dispose();
            super.dispose();

        }
    }
}
