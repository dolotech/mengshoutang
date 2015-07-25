package  game.view.viewBase
{
    import com.dialog.Dialog;
    
    import flash.geom.Rectangle;
    
    import feathers.controls.List;
    import feathers.controls.TextInput;
    import feathers.display.Scale9Image;
    import feathers.textures.Scale9Textures;
    
    import game.manager.AssetMgr;
    import game.view.arena.ArenaCreateNameRender;
    
    import starling.display.Button;
    import starling.display.Image;
    import starling.text.TextField;
    import starling.textures.Texture;
    import com.utils.Constants;

    public class ArenaCreateNameDlgBase extends Dialog
    {
        public var btn_ok:Button;
        public var txt_title:TextField;
        public var ui_gongyong_di_9gongge351189Scale:Scale9Image;
        public var ui_gongyong_di_9gongge2491189Scale:Scale9Image;
        public var ui_gongyong_di_9gongge373869Scale:Scale9Image;
        public var txt_des:TextField;
        public var txt_des1:TextField;
        public var curr_hero:ArenaCreateNameRender;
        public var txt_input:TextInput;
        public var btn_close:Button;
        public var btn_random:Button;
        public var list_hero:List;

        public function ArenaCreateNameDlgBase()
        {
            super(false);
            var texture:Texture;
            var textField:TextField;
            var image:Image;
            var button:Button;;
            var assetMgr:AssetMgr = AssetMgr.instance;
            texture =assetMgr.getTexture('ui_wudixingyunxing_xingxing_goumaikuang2');
            image = new Image(texture);
            image.x = 66;
            image.y = 38;
            image.width = 662;
            image.height = 489;
            image.smoothing= Constants.NONE;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_wudixingyunxing_xingxing_goumaikuang1');
            image = new Image(texture);
            image.x = 786;
            image.y = 38;
            image.width = 99;
            image.height = 489;
            image.scaleX = -0.9703826904296875;;
            image.smoothing= Constants.NONE;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_wudixingyunxing_xingxing_goumaikuang1');
            image = new Image(texture);
            image.y = 38;
            image.width = 99;
            image.height = 489;
            image.smoothing= Constants.NONE;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_Setup_title');
            image = new Image(texture);
            image.x = 194;
            image.width = 399;
            image.height = 104;
            image.smoothing= Constants.smoothing;
            image.touchable = false;
            this.addQuiackChild(image);
            texture = assetMgr.getTexture('ui_button_tiebaomutouanjian');
            btn_ok = new Button(texture);
            btn_ok.name= 'btn_ok';
            btn_ok.x = 326;
            btn_ok.y = 452;
            btn_ok.width = 150;
            btn_ok.height = 64;
            this.addQuiackChild(btn_ok);
            btn_ok.text= '确定';
            btn_ok.fontColor= 0xFFFFCC;
            btn_ok.fontSize= 24;
            txt_title = new TextField(294,41,'','',28,0x3D3125,false);
            txt_title.touchable = false;
            txt_title.hAlign= 'center';
            txt_title.text= '竞技场注册';
            txt_title.x = 246;
            txt_title.y = 21;
            this.addQuiackChild(txt_title);
            texture = assetMgr.getTexture('ui_gongyong_di_9gongge');
            var ui_gongyong_di_9gongge35118Rect:Rectangle = new Rectangle(21,21,43,41);
            var ui_gongyong_di_9gongge351189ScaleTexture:Scale9Textures = new Scale9Textures(texture,ui_gongyong_di_9gongge35118Rect);
            ui_gongyong_di_9gongge351189Scale = new Scale9Image(ui_gongyong_di_9gongge351189ScaleTexture);
            ui_gongyong_di_9gongge351189Scale.x = 35;
            ui_gongyong_di_9gongge351189Scale.y = 118;
            ui_gongyong_di_9gongge351189Scale.width = 203;
            ui_gongyong_di_9gongge351189Scale.height = 256;
            this.addQuiackChild(ui_gongyong_di_9gongge351189Scale);
            texture = assetMgr.getTexture('ui_gongyong_di_9gongge');
            var ui_gongyong_di_9gongge249118Rect:Rectangle = new Rectangle(21,21,43,41);
            var ui_gongyong_di_9gongge2491189ScaleTexture:Scale9Textures = new Scale9Textures(texture,ui_gongyong_di_9gongge249118Rect);
            ui_gongyong_di_9gongge2491189Scale = new Scale9Image(ui_gongyong_di_9gongge2491189ScaleTexture);
            ui_gongyong_di_9gongge2491189Scale.x = 249;
            ui_gongyong_di_9gongge2491189Scale.y = 118;
            ui_gongyong_di_9gongge2491189Scale.width = 496;
            ui_gongyong_di_9gongge2491189Scale.height = 256;
            this.addQuiackChild(ui_gongyong_di_9gongge2491189Scale);
            texture = assetMgr.getTexture('ui_gongyong_di_9gongge');
            var ui_gongyong_di_9gongge37386Rect:Rectangle = new Rectangle(21,21,43,41);
            var ui_gongyong_di_9gongge373869ScaleTexture:Scale9Textures = new Scale9Textures(texture,ui_gongyong_di_9gongge37386Rect);
            ui_gongyong_di_9gongge373869Scale = new Scale9Image(ui_gongyong_di_9gongge373869ScaleTexture);
            ui_gongyong_di_9gongge373869Scale.x = 37;
            ui_gongyong_di_9gongge373869Scale.y = 386;
            ui_gongyong_di_9gongge373869Scale.width = 707;
            ui_gongyong_di_9gongge373869Scale.height = 60;
            this.addQuiackChild(ui_gongyong_di_9gongge373869Scale);
            txt_des = new TextField(196,36,'','',24,0xF0BA8E,false);
            txt_des.touchable = false;
            txt_des.hAlign= 'center';
            txt_des.text= '选择您的头像';
            txt_des.x = 36;
            txt_des.y = 142;
            this.addQuiackChild(txt_des);
            txt_des1 = new TextField(187,36,'','',24,0xFFFFCC,false);
            txt_des1.touchable = false;
            txt_des1.hAlign= 'right';
            txt_des1.text= '输入角色名：';
            txt_des1.x = 54;
            txt_des1.y = 400;
            this.addQuiackChild(txt_des1);
            texture =assetMgr.getTexture('ui_yonghuzhuce_wenbentiao');
            image = new Image(texture);
            image.x = 248;
            image.y = 392;
            image.width = 311;
            image.height = 48;
            image.smoothing= Constants.smoothing;
            image.touchable = false;
            this.addQuiackChild(image);
            curr_hero = new ArenaCreateNameRender();
            curr_hero.x = 74;
            curr_hero.y = 207;
            this.addQuiackChild(curr_hero);
            txt_input = new TextInput();
            txt_input.textEditorProperties.fontSize = 36;
            txt_input.textEditorProperties.color = 0xFFFFFF;
            txt_input.x = 258;
            txt_input.y = 404;
            txt_input.width = 296;
            txt_input.height = 31;
            this.addQuiackChild(txt_input);
            texture = assetMgr.getTexture('ui_Buyingdiamond_button_guanbi');
            btn_close = new Button(texture);
            btn_close.name= 'btn_close';
            btn_close.x = 711;
            btn_close.y = 56;
            btn_close.width = 61;
            btn_close.height = 60;
            this.addQuiackChild(btn_close);
            texture = assetMgr.getTexture('ui_pvp_zhucesuijiming');
            btn_random = new Button(texture);
            btn_random.name= 'btn_random';
            btn_random.x = 581;
            btn_random.y = 388;
            btn_random.width = 52;
            btn_random.height = 51;
            this.addQuiackChild(btn_random);
            list_hero = new List();
            list_hero.x = 252;
            list_hero.y = 122;
            list_hero.width = 488;
            list_hero.height = 246;
            this.addQuiackChild(list_hero);
            init();
        }
        override public function dispose():void
        {
            btn_ok.dispose();
            curr_hero.dispose();
            txt_input.dispose();
            btn_close.dispose();
            btn_random.dispose();
            list_hero.dispose();
            super.dispose();
        
}
    }
}
