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

    public class GoodsGuideListRenderBase extends DefaultListItemRenderer
    {
        public var tag_selected:Scale9Image;
        public var tag_normal:Scale9Image;
        public var txt_name:TextField;
        public var txt_des1:TextField;
        public var txt_drop:TextField;
        public var txt_get:TextField;
        public var txt_part:TextField;
        public var tag_bg:Image;
        public var ico_equip:Button;
        public var ico_quality:Image;
        public var txt_level:TextField;
        public var txt_strengthen:TextField;

        public function GoodsGuideListRenderBase()
        {
            var texture:Texture;
            var textField:TextField;
            var input_txt:TextInput;
            var image:Image;
            var button:Button;
            var assetMgr:AssetMgr = AssetMgr.instance;
            texture = assetMgr.getTexture('ui_gongyong_hero_pub_9gongge_article2');
            var tag_selectedRect:Rectangle = new Rectangle(30,32,24,23);
            var tag_selected9ScaleTexture:Scale9Textures = new Scale9Textures(texture,tag_selectedRect);
            tag_selected = new Scale9Image(tag_selected9ScaleTexture);
            tag_selected.x = -10;
            tag_selected.y = -10;
            tag_selected.width = 318;
            tag_selected.height = 126;
            this.addQuiackChild(tag_selected);
            texture = assetMgr.getTexture('ui_gongyong_hero_pub_9gongge_article');
            var tag_normalRect:Rectangle = new Rectangle(17,19,27,22);
            var tag_normal9ScaleTexture:Scale9Textures = new Scale9Textures(texture,tag_normalRect);
            tag_normal = new Scale9Image(tag_normal9ScaleTexture);
            tag_normal.width = 298;
            tag_normal.height = 106;
            this.addQuiackChild(tag_normal);
            txt_name = new TextField(185,36,'','',24,0x33FF00,false);
            txt_name.touchable = false;
            txt_name.hAlign= 'left';
            txt_name.text= '';
            txt_name.x = 107;
            txt_name.y = 10;
            this.addQuiackChild(txt_name);
            txt_des1 = new TextField(59,28,'','',18,0xFFFFFF,false);
            txt_des1.touchable = false;
            txt_des1.hAlign= 'left';
            txt_des1.text= '部位：';
            txt_des1.x = 107;
            txt_des1.y = 44;
            this.addQuiackChild(txt_des1);
            txt_drop = new TextField(90,28,'','',18,0xFFFFFF,false);
            txt_drop.touchable = false;
            txt_drop.hAlign= 'left';
            txt_drop.text= '';
            txt_drop.x = 107;
            txt_drop.y = 73;
            this.addQuiackChild(txt_drop);
            txt_get = new TextField(82,28,'','',18,0xFFFF99,false);
            txt_get.touchable = false;
            txt_get.hAlign= 'left';
            txt_get.text= '获得途径';
            txt_get.x = 207;
            txt_get.y = 73;
            this.addQuiackChild(txt_get);
            txt_part = new TextField(59,28,'','',18,0xFFFFFF,false);
            txt_part.touchable = false;
            txt_part.hAlign= 'left';
            txt_part.text= '';
            txt_part.x = 158;
            txt_part.y = 44;
            this.addQuiackChild(txt_part);
            texture = assetMgr.getTexture('ui_hero_chenghaozhuangbei_kuang')
            tag_bg = new Image(texture);
            tag_bg.width = 105;
            tag_bg.height = 103;
            this.addQuiackChild(tag_bg);
            tag_bg.touchable = false;
            texture =assetMgr.getTexture('ui_gongyong_90wupingkuang');
            image = new Image(texture);
            image.x = 7;
            image.y = 10;
            image.width = 90;
            image.height = 90;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            this.addQuiackChild(image);
            texture = assetMgr.getTexture('icon_300010');
            ico_equip = new Button(texture);
            ico_equip.name= 'ico_equip';
            ico_equip.x = 8;
            ico_equip.y = 8;
            ico_equip.width = 90;
            ico_equip.height = 90;
            this.addQuiackChild(ico_equip);
            texture = assetMgr.getTexture('ui_gongyong_90wupingkuang0')
            ico_quality = new Image(texture);
            ico_quality.x = 8;
            ico_quality.y = 10;
            ico_quality.width = 89;
            ico_quality.height = 86;
            this.addQuiackChild(ico_quality);
            ico_quality.touchable = false;
            txt_level = new TextField(100,30,'','',20,0xFFFFFF,false);
            txt_level.touchable = false;
            txt_level.hAlign= 'center';
            txt_level.text= '';
            txt_level.x = 1;
            txt_level.y = 10;
            this.addQuiackChild(txt_level);
            txt_strengthen = new TextField(52,30,'','',18,0xFFFFFF,false);
            txt_strengthen.touchable = false;
            txt_strengthen.hAlign= 'center';
            txt_strengthen.text= '';
            txt_strengthen.x = 12;
            txt_strengthen.y = 58;
            this.addQuiackChild(txt_strengthen);
        }
        override public function dispose():void
        {
            ico_equip.dispose();
            super.dispose();
        
}
    }
}
