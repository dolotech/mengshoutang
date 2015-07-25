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
    import feathers.controls.renderers.DefaultListItemRenderer;

    public class ShowServerRenderBase extends DefaultListItemRenderer
    {
        public var btn_bg:Button;
        public var txt_name:TextField;
        public var tag_new:Image;
        public var tag_hot:Image;
        public var tag_afterOpen:Image;

        public function ShowServerRenderBase()
        {
            var texture:Texture;
            var textField:TextField;
            var image:Image;
            var button:Button;;
            var assetMgr:AssetMgr = AssetMgr.instance;
            texture = assetMgr.getTexture('ui_button_tiebaomutouanjian_chang');
            btn_bg = new Button(texture);
            btn_bg.name= 'btn_bg';
            btn_bg.y = 10;
            btn_bg.width = 219;
            btn_bg.height = 62;
            this.addQuiackChild(btn_bg);
            txt_name = new TextField(202,36,'','',24,0xFFF9C5,false);
            txt_name.touchable = false;
            txt_name.hAlign= 'center';
            txt_name.text= '';
            txt_name.x = 6;
            txt_name.y = 21;
            this.addQuiackChild(txt_name);
            texture = assetMgr.getTexture('ui_district_iocn_xinqu')
            tag_new = new Image(texture);
            tag_new.x = 165;
            tag_new.width = 61;
            tag_new.height = 47;
            this.addQuiackChild(tag_new);
            tag_new.touchable = false;
            texture = assetMgr.getTexture('ui_district_iocn_huobao')
            tag_hot = new Image(texture);
            tag_hot.x = 165;
            tag_hot.width = 61;
            tag_hot.height = 47;
            this.addQuiackChild(tag_hot);
            tag_hot.touchable = false;
            texture = assetMgr.getTexture('ui_district_iocn_jijiangkaifang')
            tag_afterOpen = new Image(texture);
            tag_afterOpen.x = 138;
            tag_afterOpen.width = 96;
            tag_afterOpen.height = 60;
            this.addQuiackChild(tag_afterOpen);
            tag_afterOpen.touchable = false;
        }
        override public function dispose():void
        {
            btn_bg.dispose();
            super.dispose();
        
}
    }
}
