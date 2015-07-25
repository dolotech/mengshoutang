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
    import feathers.controls.List;
    import com.dialog.Dialog;

    public class NewWinViewBase extends Dialog
    {
        public var txt_gold:TextField;
        public var btn_replay:Button;
        public var btn_return:Button;
        public var list_hero:List;
        public var list_goods:List;

        public function NewWinViewBase()
        {
            super(false);
            var texture:Texture;
            var textField:TextField;
            var input_txt:TextInput;
            var image:Image;
            var button:Button;
            var assetMgr:AssetMgr = AssetMgr.instance;
            texture =assetMgr.getTexture('ui_jiesuanxinxitiao');
            image = new Image(texture);
            image.y = 198;
            image.width = 600;
            image.height = 76;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_gongyong_jinbi1');
            image = new Image(texture);
            image.x = 40;
            image.y = 217;
            image.width = 52;
            image.height = 43;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            this.addQuiackChild(image);
            txt_gold = new TextField(220,48,'','',30,0x663300,false);
            txt_gold.touchable = false;
            txt_gold.hAlign= 'left';
            txt_gold.text= '+9999999';
            txt_gold.x = 114;
            txt_gold.y = 216;
            this.addQuiackChild(txt_gold);
            texture =assetMgr.getTexture('ui_jiesuan_hengtiao');
            image = new Image(texture);
            image.x = 6;
            image.y = 465;
            image.width = 627;
            image.height = 3;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            this.addQuiackChild(image);
            texture = assetMgr.getTexture('ui_button_chongfu_iocn');
            btn_replay = new Button(texture);
            btn_replay.name= 'btn_replay';
            btn_replay.x = 663;
            btn_replay.y = 186;
            btn_replay.width = 109;
            btn_replay.height = 103;
            this.addQuiackChild(btn_replay);
            texture = assetMgr.getTexture('ui_button_fanhui_iocn');
            btn_return = new Button(texture);
            btn_return.name= 'btn_return';
            btn_return.x = 663;
            btn_return.y = 468;
            btn_return.width = 109;
            btn_return.height = 103;
            this.addQuiackChild(btn_return);
            list_hero = new List();
            list_hero.x = 6;
            list_hero.y = 290;
            list_hero.width = 600;
            list_hero.height = 170;
            this.addQuiackChild(list_hero);
            list_goods = new List();
            list_goods.x = 6;
            list_goods.y = 476;
            list_goods.width = 600;
            list_goods.height = 90;
            this.addQuiackChild(list_goods);
            init();
        }
        override public function dispose():void
        {
            btn_replay.dispose();
            btn_return.dispose();
            list_hero.dispose();
            list_goods.dispose();
            super.dispose();
        
}
    }
}
