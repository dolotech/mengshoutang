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

    public class NewEquipRenderBase extends DefaultListItemRenderer
    {
        public var ico_equip:Image;
        public var tag_bg:Button;
        public var txt_name:TextField;
        public var tag_isEquip:Image;
        public var txt_count:TextField;
        public var txt_needLevel:TextField;
        public var txt_get:TextField;
        public var tag_fusion:Image;
        public var tag_selected:Image;

        public function NewEquipRenderBase()
        {
            var texture:Texture;
            var textField:TextField;
            var input_txt:TextInput;
            var image:Image;
            var button:Button;
            var assetMgr:AssetMgr = AssetMgr.instance;
            texture =assetMgr.getTexture('ui_gongyong_90wupingkuang');
            image = new Image(texture);
            image.y = -1;
            image.width = 90;
            image.height = 90;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            this.addQuiackChild(image);
            texture = assetMgr.getTexture('icon_20001')
            ico_equip = new Image(texture);
            ico_equip.x = 2;
            ico_equip.y = 2;
            ico_equip.width = 89;
            ico_equip.height = 89;
            this.addQuiackChild(ico_equip);
            ico_equip.touchable = false;
            texture = assetMgr.getTexture('ui_gongyong_90wupingkuang0');
            tag_bg = new Button(texture);
            tag_bg.name= 'tag_bg';
            tag_bg.width = 90;
            tag_bg.height = 90;
            this.addQuiackChild(tag_bg);
            txt_name = new TextField(140,28,'','',18,0xFFFFCC,false);
            txt_name.touchable = false;
            txt_name.hAlign= 'center';
            txt_name.text= '';
            txt_name.x = -24;
            txt_name.y = 92;
            this.addQuiackChild(txt_name);
            texture = assetMgr.getTexture('ui_wenzi_yizhuangbei')
            tag_isEquip = new Image(texture);
            tag_isEquip.x = 7;
            tag_isEquip.y = 7;
            tag_isEquip.width = 24;
            tag_isEquip.height = 24;
            this.addQuiackChild(tag_isEquip);
            tag_isEquip.touchable = false;
            txt_count = new TextField(72,30,'','',20,0xFFFFCC,false);
            txt_count.touchable = false;
            txt_count.hAlign= 'left';
            txt_count.text= '';
            txt_count.x = 8;
            txt_count.y = 55;
            this.addQuiackChild(txt_count);
            txt_needLevel = new TextField(80,36,'','',24,0xFF0000,false);
            txt_needLevel.touchable = false;
            txt_needLevel.hAlign= 'center';
            txt_needLevel.text= '';
            txt_needLevel.x = 7;
            txt_needLevel.y = 1;
            this.addQuiackChild(txt_needLevel);
            txt_get = new TextField(80,30,'','',16,0x00FF00,false);
            txt_get.touchable = false;
            txt_get.hAlign= 'center';
            txt_get.text= '';
            txt_get.x = 6;
            txt_get.y = 34;
            this.addQuiackChild(txt_get);
            texture = assetMgr.getTexture('ui_strengthen_jianglilingqu')
            tag_fusion = new Image(texture);
            tag_fusion.x = 28;
            tag_fusion.y = -5;
            tag_fusion.width = 71;
            tag_fusion.height = 51;
            this.addQuiackChild(tag_fusion);
            tag_fusion.touchable = false;
            texture = assetMgr.getTexture('ui_gongyong_kexuanzhuangtai')
            tag_selected = new Image(texture);
            tag_selected.x = 7;
            tag_selected.y = 7;
            tag_selected.width = 76;
            tag_selected.height = 75;
            this.addQuiackChild(tag_selected);
            tag_selected.touchable = false;
        }
        override public function dispose():void
        {
            tag_bg.dispose();
            super.dispose();
        
}
    }
}
