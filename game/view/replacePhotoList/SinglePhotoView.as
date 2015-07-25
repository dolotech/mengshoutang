package game.view.replacePhotoList
{
    import feathers.controls.renderers.DefaultListItemRenderer;
    
    import game.manager.AssetMgr;
    
    import starling.display.Button;
    import starling.display.Image;
    import starling.text.TextField;
    import starling.textures.Texture;
    import com.utils.Constants;

    public class SinglePhotoView extends DefaultListItemRenderer
    {
        public var btn_photo:Button;
		public var imagePh : Image;
		public var imageVip : Image;
		public var txt_Level : TextField;

        public function SinglePhotoView()
        {
            super();
            var texture:Texture;
            var assetMgr:AssetMgr = AssetMgr.instance;
            texture = assetMgr.getTexture('ui_city_head1');
            btn_photo = new Button(texture);
            btn_photo.x = -3;
              btn_photo.y = 0;
            btn_photo.width = 121;
            btn_photo.height = 122;
            this.addQuiackChild(btn_photo);
            texture =assetMgr.getTexture('ui_pvp_renwutouxiang1');
			imagePh = new Image(texture);
			imagePh.x = 12;
			imagePh.y = 10;
			imagePh.width = 100;
			imagePh.height = 100;
			imagePh.scaleX = 1;
			imagePh.smoothing = Constants.NONE;
			imagePh.touchable = false;
            btn_photo.addQuiackChild(imagePh);
            texture =assetMgr.getTexture('ui_icon_city_vip');
			imageVip = new Image(texture);
			imageVip.x = -3;
			imageVip.y = -4;
			imageVip.width = 65;
			imageVip.height = 65;
			imageVip.smoothing = Constants.NONE;
			imageVip.touchable = false;
            btn_photo.addQuiackChild(imageVip);
			txt_Level = new TextField(43,30,'','',20,0xFFFF00,false);
			txt_Level.touchable = false;
			txt_Level.hAlign = 'center';
			txt_Level.x = 3;
			txt_Level.y = 19;
            btn_photo.addQuiackChild(txt_Level);
			txt_Level.text = '0';
			txt_Level.name = 'txt_Level';
        }
        override public function dispose():void
        {
            btn_photo.dispose();
            super.dispose();
        
}

    }
}