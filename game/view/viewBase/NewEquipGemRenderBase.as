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
    import feathers.controls.renderers.DefaultListItemRenderer;

    public class NewEquipGemRenderBase extends DefaultListItemRenderer
    {
        public var gemBg:Image;
        public var ico_gem:Image;
        public var txt_value:TextField;
        public var txt_name:TextField;
        public var txt_tips:TextField;

        public function NewEquipGemRenderBase()
        {
            var texture:Texture;
            var textField:TextField;
            var input_txt:TextInput;
            var image:Image;
            var button:Button;
            var assetMgr:AssetMgr = AssetMgr.instance;
            texture = assetMgr.getTexture('ui_gongyong_baoshikuang1')
            gemBg = new Image(texture);
            gemBg.width = 65;
            gemBg.height = 65;
            this.addQuiackChild(gemBg);
            gemBg.touchable = false;
            texture = assetMgr.getTexture('icon_1201')
            ico_gem = new Image(texture);
            ico_gem.x = 6;
            ico_gem.y = 4;
            ico_gem.width = 55;
            ico_gem.height = 55;
            this.addQuiackChild(ico_gem);
            ico_gem.touchable = false;
            txt_value = new TextField(85,28,'','',22,0x4EF80F,false);
            txt_value.touchable = false;
            txt_value.hAlign= 'right';
            txt_value.text= '';
            txt_value.x = 121;
            txt_value.y = 15;
            this.addQuiackChild(txt_value);
            txt_name = new TextField(68,36,'','',22,0xFFCC00,false);
            txt_name.touchable = false;
            txt_name.hAlign= 'center';
            txt_name.text= '';
            txt_name.x = 59;
            txt_name.y = 11;
            this.addQuiackChild(txt_name);
            txt_tips = new TextField(147,33,'','',22,0xFF0000,false);
            txt_tips.touchable = false;
            txt_tips.hAlign= 'center';
            txt_tips.text= '未镶嵌';
            txt_tips.x = 59;
            txt_tips.y = 13;
            this.addQuiackChild(txt_tips);
        }
    }
}
