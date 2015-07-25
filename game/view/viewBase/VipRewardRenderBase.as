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

    public class VipRewardRenderBase extends DefaultListItemRenderer
    {
        public var txt_name:TextField;
        public var ico_goods:Image;
        public var ico_bg:Image;
        public var txt_count:TextField;

        public function VipRewardRenderBase()
        {
            var texture:Texture;
            var textField:TextField;
            var input_txt:TextInput;
            var image:Image;
            var button:Button;
            var assetMgr:AssetMgr = AssetMgr.instance;
            texture =assetMgr.getTexture('ui_gongyong_xingyunchoujiangkuang');
            image = new Image(texture);
            image.width = 124;
            image.height = 126;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            this.addQuiackChild(image);
            txt_name = new TextField(104,28,'','',18,0xFFFFCC,false);
            txt_name.touchable = false;
            txt_name.hAlign= 'center';
            txt_name.text= '物品的名字';
            txt_name.x = 12;
            txt_name.y = 131;
            this.addQuiackChild(txt_name);
            texture =assetMgr.getTexture('ui_gongyong_90wupingkuang');
            image = new Image(texture);
            image.x = 16;
            image.y = 18;
            image.width = 90;
            image.height = 90;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            this.addQuiackChild(image);
            texture = assetMgr.getTexture('icon_002')
            ico_goods = new Image(texture);
            ico_goods.x = 16;
            ico_goods.y = 18;
            ico_goods.width = 89;
            ico_goods.height = 89;
            this.addQuiackChild(ico_goods);
            ico_goods.touchable = false;
            texture = assetMgr.getTexture('ui_gongyong_90wupingkuang0')
            ico_bg = new Image(texture);
            ico_bg.x = 16;
            ico_bg.y = 18;
            ico_bg.width = 90;
            ico_bg.height = 90;
            this.addQuiackChild(ico_bg);
            ico_bg.touchable = false;
            txt_count = new TextField(80,28,'','',18,0xFFFFFF,false);
            txt_count.touchable = false;
            txt_count.hAlign= 'right';
            txt_count.text= '';
            txt_count.x = 17;
            txt_count.y = 73;
            this.addQuiackChild(txt_count);
        }
    }
}
