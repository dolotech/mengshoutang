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
    import feathers.controls.List;
    import feathers.display.Scale9Image;
    import feathers.textures.Scale9Textures;
    import com.dialog.Dialog;

    public class ShowServerListDlgBase extends Dialog
    {
        public var ui_district_transparent_bottom101589Scale:Scale9Image;
        public var ui_district_transparent_bottom1009Scale:Scale9Image;
        public var txt_des1:TextField;
        public var txt_des2:TextField;
        public var list_server:List;
        public var list_login:List;

        public function ShowServerListDlgBase()
        {
            super(false);
            var texture:Texture;
            var textField:TextField;
            var image:Image;
            var button:Button;;
            var assetMgr:AssetMgr = AssetMgr.instance;
            texture = assetMgr.getTexture('ui_district_transparent_bottom1');
            var ui_district_transparent_bottom10158Rect:Rectangle = new Rectangle(41,35,82,70);
            var ui_district_transparent_bottom101589ScaleTexture:Scale9Textures = new Scale9Textures(texture,ui_district_transparent_bottom10158Rect);
            ui_district_transparent_bottom101589Scale = new Scale9Image(ui_district_transparent_bottom101589ScaleTexture);
            ui_district_transparent_bottom101589Scale.y = 158;
            ui_district_transparent_bottom101589Scale.width = 733;
            ui_district_transparent_bottom101589Scale.height = 368;
            this.addQuiackChild(ui_district_transparent_bottom101589Scale);
            texture = assetMgr.getTexture('ui_district_transparent_bottom1');
            var ui_district_transparent_bottom100Rect:Rectangle = new Rectangle(41,35,82,70);
            var ui_district_transparent_bottom1009ScaleTexture:Scale9Textures = new Scale9Textures(texture,ui_district_transparent_bottom100Rect);
            ui_district_transparent_bottom1009Scale = new Scale9Image(ui_district_transparent_bottom1009ScaleTexture);
            ui_district_transparent_bottom1009Scale.width = 733;
            ui_district_transparent_bottom1009Scale.height = 127;
            this.addQuiackChild(ui_district_transparent_bottom1009Scale);
            txt_des1 = new TextField(294,36,'','',24,0xF9CC11,false);
            txt_des1.touchable = false;
            txt_des1.hAlign= 'left';
            txt_des1.text= '最近登录过的服务器:';
            txt_des1.x = 25;
            txt_des1.y = 8;
            this.addQuiackChild(txt_des1);
            txt_des2 = new TextField(294,36,'','',24,0xF9CC11,false);
            txt_des2.touchable = false;
            txt_des2.hAlign= 'left';
            txt_des2.text= '服务器列表:';
            txt_des2.x = 25;
            txt_des2.y = 172;
            this.addQuiackChild(txt_des2);
            list_server = new List();
            list_server.x = 27;
            list_server.y = 220;
            list_server.width = 685;
            list_server.height = 260;
            this.addQuiackChild(list_server);
            list_login = new List();
            list_login.x = 27;
            list_login.y = 43;
            list_login.width = 685;
            list_login.height = 70;
            this.addQuiackChild(list_login);
            init();
        }
        override public function dispose():void
        {
            list_server.dispose();
            list_login.dispose();
            super.dispose();
        
}
    }
}
