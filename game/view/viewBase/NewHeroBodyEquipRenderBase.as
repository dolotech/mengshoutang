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

    public class NewHeroBodyEquipRenderBase extends DefaultListItemRenderer
    {
        public var tag_bg:Button;
        public var tag_equip:Image;
        public var ico_equip:Image;
        public var txt_level:TextField;
        public var tag_add:Image;

        public function NewHeroBodyEquipRenderBase()
        {
            var texture:Texture;
            var textField:TextField;
            var input_txt:TextInput;
            var image:Image;
            var button:Button;
            var assetMgr:AssetMgr = AssetMgr.instance;
            texture =assetMgr.getTexture('ui_gongyong_90wupingkuang');
            image = new Image(texture);
            image.width = 90;
            image.height = 90;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            this.addQuiackChild(image);
            texture = assetMgr.getTexture('ui_gongyong_90wupingkuang0');
            tag_bg = new Button(texture);
            tag_bg.name= 'tag_bg';
            tag_bg.x = 1;
            tag_bg.width = 90;
            tag_bg.height = 90;
            this.addQuiackChild(tag_bg);
            texture = assetMgr.getTexture('ui_yingxiongshengdian_wuqikuangbiaozhi1')
            tag_equip = new Image(texture);
            tag_equip.x = 18;
            tag_equip.y = 11;
            tag_equip.width = 61;
            tag_equip.height = 72;
            this.addQuiackChild(tag_equip);
            tag_equip.touchable = false;
            texture = assetMgr.getTexture('icon_20001')
            ico_equip = new Image(texture);
            ico_equip.x = 3;
            ico_equip.y = 1;
            ico_equip.width = 89;
            ico_equip.height = 89;
            this.addQuiackChild(ico_equip);
            ico_equip.touchable = false;
            txt_level = new TextField(48,28,'','',18,0xFFFFFF,false);
            txt_level.touchable = false;
            txt_level.hAlign= 'left';
            txt_level.text= '';
            txt_level.x = 6;
            txt_level.y = 59;
            this.addQuiackChild(txt_level);
            texture = assetMgr.getTexture('ui_gongyong_lvjiahao')
            tag_add = new Image(texture);
            tag_add.x = 61;
            tag_add.y = 59;
            tag_add.width = 18;
            tag_add.height = 20;
            this.addQuiackChild(tag_add);
            tag_add.touchable = false;
        }
        override public function dispose():void
        {
            tag_bg.dispose();
            super.dispose();
        
}
    }
}
