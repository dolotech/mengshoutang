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
    import com.view.View;

    public class BattleViewBases extends View
    {
        public var Bg:Image;
        public var angerBar_0:Sprite;
        public var angerBar_4:Sprite;
        public var angerBar_3:Sprite;
        public var angerBar_2:Sprite;
        public var angerBar_1:Sprite;
        public var heroIcon_1:Image;
        public var heroIcon_4:Image;
        public var heroIcon_3:Image;
        public var heroIcon_0:Image;
        public var heroQuality_0:Image;
        public var heroIcon_2:Image;
        public var heroQuality_2:Image;
        public var heroQuality_3:Image;
        public var heroQuality_4:Image;
        public var heroQuality_1:Image;
        public var textPoints_4:TextField;
        public var textPoints_3:TextField;
        public var textPoints_2:TextField;
        public var textPoints_1:TextField;
        public var textPoints_0:TextField;

        public function BattleViewBases()
        {
            super(false);
            var texture:Texture;
            var textField:TextField;
            var input_txt:TextInput;
            var image:Image;
            var button:Button;
            var assetMgr:AssetMgr = AssetMgr.instance;
            texture = assetMgr.getTexture('ui_zhandou_yingxiongtouxiangkuang')
            Bg = new Image(texture);
            Bg.y = -20;
            Bg.width = 751;
            Bg.height = 169;
            this.addQuiackChild(Bg);
            Bg.touchable = false;
            texture =assetMgr.getTexture('ui_jiesuan_jingyantiao_di');
            image = new Image(texture);
            image.x = 61;
            image.y = 107;
            image.width = 100;
            image.height = 24;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            this.addQuiackChild(image);
            angerBar_0 = new Sprite();
            angerBar_0.x = 64;
            angerBar_0.y = 113;
            angerBar_0.width = 95;
            angerBar_0.height = 11;
            this.addQuiackChild(angerBar_0);
            angerBar_0.name= 'angerBar_0';
            texture = assetMgr.getTexture('ui_zhandou_nuqitiao')
            image = new Image(texture);
            image.name= 'angerBar';
            image.width = 95;
            image.height = 11;
            angerBar_0.addQuiackChild(image);
            image.touchable = false;
            texture =assetMgr.getTexture('ui_jiesuan_jingyantiao_di');
            image = new Image(texture);
            image.x = 592;
            image.y = 107;
            image.width = 100;
            image.height = 24;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_jiesuan_jingyantiao_di');
            image = new Image(texture);
            image.x = 459;
            image.y = 107;
            image.width = 100;
            image.height = 24;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_jiesuan_jingyantiao_di');
            image = new Image(texture);
            image.x = 194;
            image.y = 107;
            image.width = 100;
            image.height = 24;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_jiesuan_jingyantiao_di');
            image = new Image(texture);
            image.x = 327;
            image.y = 107;
            image.width = 100;
            image.height = 24;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            this.addQuiackChild(image);
            angerBar_4 = new Sprite();
            angerBar_4.x = 594;
            angerBar_4.y = 113;
            angerBar_4.width = 95;
            angerBar_4.height = 11;
            this.addQuiackChild(angerBar_4);
            angerBar_4.name= 'angerBar_4';
            texture = assetMgr.getTexture('ui_zhandou_nuqitiao')
            image = new Image(texture);
            image.name= 'angerBar';
            image.width = 95;
            image.height = 11;
            angerBar_4.addQuiackChild(image);
            image.touchable = false;
            angerBar_3 = new Sprite();
            angerBar_3.x = 462;
            angerBar_3.y = 113;
            angerBar_3.width = 95;
            angerBar_3.height = 11;
            this.addQuiackChild(angerBar_3);
            angerBar_3.name= 'angerBar_3';
            texture = assetMgr.getTexture('ui_zhandou_nuqitiao')
            image = new Image(texture);
            image.name= 'angerBar';
            image.width = 95;
            image.height = 11;
            angerBar_3.addQuiackChild(image);
            image.touchable = false;
            angerBar_2 = new Sprite();
            angerBar_2.x = 329;
            angerBar_2.y = 113;
            angerBar_2.width = 95;
            angerBar_2.height = 11;
            this.addQuiackChild(angerBar_2);
            angerBar_2.name= 'angerBar_2';
            texture = assetMgr.getTexture('ui_zhandou_nuqitiao')
            image = new Image(texture);
            image.name= 'angerBar';
            image.width = 95;
            image.height = 11;
            angerBar_2.addQuiackChild(image);
            image.touchable = false;
            angerBar_1 = new Sprite();
            angerBar_1.x = 197;
            angerBar_1.y = 113;
            angerBar_1.width = 95;
            angerBar_1.height = 11;
            this.addQuiackChild(angerBar_1);
            angerBar_1.name= 'angerBar_1';
            texture = assetMgr.getTexture('ui_zhandou_nuqitiao')
            image = new Image(texture);
            image.name= 'angerBar';
            image.width = 95;
            image.height = 11;
            angerBar_1.addQuiackChild(image);
            image.touchable = false;
            texture =assetMgr.getTexture('ui_gongyong_100yingxiongkuang_kong1');
            image = new Image(texture);
            image.x = 60;
            image.y = -2;
            image.width = 100;
            image.height = 100;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_gongyong_100yingxiongkuang_kong1');
            image = new Image(texture);
            image.x = 326;
            image.y = -2;
            image.width = 100;
            image.height = 100;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_gongyong_100yingxiongkuang_kong1');
            image = new Image(texture);
            image.x = 193;
            image.y = -2;
            image.width = 100;
            image.height = 100;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_gongyong_100yingxiongkuang_kong1');
            image = new Image(texture);
            image.x = 459;
            image.y = -2;
            image.width = 100;
            image.height = 100;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_gongyong_100yingxiongkuang_kong1');
            image = new Image(texture);
            image.x = 591;
            image.y = -2;
            image.width = 100;
            image.height = 100;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            this.addQuiackChild(image);
            texture = assetMgr.getTexture('ui_gongyong_100yingxiongkuang_kong')
            heroIcon_1 = new Image(texture);
            heroIcon_1.x = 194;
            heroIcon_1.y = -2;
            heroIcon_1.width = 100;
            heroIcon_1.height = 100;
            this.addQuiackChild(heroIcon_1);
            heroIcon_1.touchable = false;
            texture = assetMgr.getTexture('ui_gongyong_100yingxiongkuang_kong')
            heroIcon_4 = new Image(texture);
            heroIcon_4.x = 591;
            heroIcon_4.y = -2;
            heroIcon_4.width = 100;
            heroIcon_4.height = 100;
            this.addQuiackChild(heroIcon_4);
            heroIcon_4.touchable = false;
            texture = assetMgr.getTexture('ui_gongyong_100yingxiongkuang_kong')
            heroIcon_3 = new Image(texture);
            heroIcon_3.x = 459;
            heroIcon_3.y = -2;
            heroIcon_3.width = 100;
            heroIcon_3.height = 100;
            this.addQuiackChild(heroIcon_3);
            heroIcon_3.touchable = false;
            texture = assetMgr.getTexture('ui_gongyong_100yingxiongkuang_kong')
            heroIcon_0 = new Image(texture);
            heroIcon_0.x = 62;
            heroIcon_0.y = -2;
            heroIcon_0.width = 100;
            heroIcon_0.height = 100;
            this.addQuiackChild(heroIcon_0);
            heroIcon_0.touchable = false;
            texture = assetMgr.getTexture('ui_gongyong_100yingxiongkuang_0')
            heroQuality_0 = new Image(texture);
            heroQuality_0.x = 62;
            heroQuality_0.y = -1;
            heroQuality_0.width = 100;
            heroQuality_0.height = 100;
            this.addQuiackChild(heroQuality_0);
            heroQuality_0.touchable = false;
            texture = assetMgr.getTexture('ui_gongyong_100yingxiongkuang_kong')
            heroIcon_2 = new Image(texture);
            heroIcon_2.x = 326;
            heroIcon_2.y = -2;
            heroIcon_2.width = 100;
            heroIcon_2.height = 100;
            this.addQuiackChild(heroIcon_2);
            heroIcon_2.touchable = false;
            texture = assetMgr.getTexture('ui_gongyong_100yingxiongkuang_0')
            heroQuality_2 = new Image(texture);
            heroQuality_2.x = 326;
            heroQuality_2.y = -1;
            heroQuality_2.width = 100;
            heroQuality_2.height = 100;
            this.addQuiackChild(heroQuality_2);
            heroQuality_2.touchable = false;
            texture = assetMgr.getTexture('ui_gongyong_100yingxiongkuang_0')
            heroQuality_3 = new Image(texture);
            heroQuality_3.x = 459;
            heroQuality_3.y = -2;
            heroQuality_3.width = 100;
            heroQuality_3.height = 100;
            this.addQuiackChild(heroQuality_3);
            heroQuality_3.touchable = false;
            texture = assetMgr.getTexture('ui_gongyong_100yingxiongkuang_0')
            heroQuality_4 = new Image(texture);
            heroQuality_4.x = 591;
            heroQuality_4.width = 100;
            heroQuality_4.height = 100;
            this.addQuiackChild(heroQuality_4);
            heroQuality_4.touchable = false;
            texture = assetMgr.getTexture('ui_gongyong_100yingxiongkuang_0')
            heroQuality_1 = new Image(texture);
            heroQuality_1.x = 194;
            heroQuality_1.y = -2;
            heroQuality_1.width = 100;
            heroQuality_1.height = 100;
            this.addQuiackChild(heroQuality_1);
            heroQuality_1.touchable = false;
            textPoints_4 = new TextField(80,80,'','',18,0xFFFFCC,false);
            textPoints_4.touchable = false;
            textPoints_4.hAlign= 'center';
            textPoints_4.text= '通关第264关开启';
            textPoints_4.x = 601;
            textPoints_4.y = 8;
            this.addQuiackChild(textPoints_4);
            textPoints_3 = new TextField(80,80,'','',18,0xFFFFCC,false);
            textPoints_3.touchable = false;
            textPoints_3.hAlign= 'center';
            textPoints_3.text= '通关第264关开启';
            textPoints_3.x = 469;
            textPoints_3.y = 8;
            this.addQuiackChild(textPoints_3);
            textPoints_2 = new TextField(80,80,'','',18,0xFFFFCC,false);
            textPoints_2.touchable = false;
            textPoints_2.hAlign= 'center';
            textPoints_2.text= '通关第264关开启';
            textPoints_2.x = 337;
            textPoints_2.y = 8;
            this.addQuiackChild(textPoints_2);
            textPoints_1 = new TextField(80,80,'','',18,0xFFFFCC,false);
            textPoints_1.touchable = false;
            textPoints_1.hAlign= 'center';
            textPoints_1.text= '通关第264关开启';
            textPoints_1.x = 205;
            textPoints_1.y = 8;
            this.addQuiackChild(textPoints_1);
            textPoints_0 = new TextField(80,80,'','',18,0xFFFFCC,false);
            textPoints_0.touchable = false;
            textPoints_0.hAlign= 'center';
            textPoints_0.text= '通关第264关开启';
            textPoints_0.x = 73;
            textPoints_0.y = 8;
            this.addQuiackChild(textPoints_0);
            init();
        }
        override public function dispose():void
        {
            angerBar_0.dispose();
            angerBar_4.dispose();
            angerBar_3.dispose();
            angerBar_2.dispose();
            angerBar_1.dispose();
            super.dispose();
        
}
    }
}