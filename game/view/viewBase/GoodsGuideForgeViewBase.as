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
    import feathers.display.Scale9Image;
    import feathers.textures.Scale9Textures;
    import game.view.goodsGuide.view.GoodsGuideGrid;
    import com.view.View;

    public class GoodsGuideForgeViewBase extends View
    {
        public var ui_Setup_button_switch31529:Scale9Image;
        public var grid:GoodsGuideGrid;
        public var btn_ok:Button;
        public var list_equip:List;
        public var view_drop:Sprite;
        public var list_drop:List;

        public function GoodsGuideForgeViewBase()
        {
            super(false);
            var texture:Texture;
            var textField:TextField;
            var input_txt:TextInput;
            var image:Image;
            var button:Button;
            var assetMgr:AssetMgr = AssetMgr.instance;
            texture =assetMgr.getTexture('ui_wudixingyunxing_xingxing_goumaikuang1');
            image = new Image(texture);
            image.width = 102;
            image.height = 446;
            image.smoothing= Constants.NONE;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_wudixingyunxing_xingxing_goumaikuang2');
            image = new Image(texture);
            image.x = 79;
            image.width = 216;
            image.height = 446;
            image.smoothing= Constants.NONE;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_wudixingyunxing_xingxing_goumaikuang1');
            image = new Image(texture);
            image.x = 350;
            image.width = 102;
            image.height = 446;
            image.scaleX = -1;
            image.smoothing= Constants.NONE;
            this.addQuiackChild(image);
            texture = assetMgr.getTexture('ui_Setup_button_switch3');
            var ui_Setup_button_switch31529Rect:Rectangle = new Rectangle(54,26,107,52);
            var ui_Setup_button_switch315299ScaleTexture:Scale9Textures = new Scale9Textures(texture,ui_Setup_button_switch31529Rect);
            ui_Setup_button_switch31529 = new Scale9Image(ui_Setup_button_switch315299ScaleTexture);
            ui_Setup_button_switch31529.x = 15;
            ui_Setup_button_switch31529.y = 29;
            ui_Setup_button_switch31529.width = 318;
            ui_Setup_button_switch31529.height = 400;
            this.addQuiackChild(ui_Setup_button_switch31529);
            grid = new GoodsGuideGrid();
            grid.x = 127;
            grid.y = 42;
            this.addQuiackChild(grid);
            texture = assetMgr.getTexture('ui_button_gongyong_big');
            btn_ok = new Button(texture);
            btn_ok.name= 'btn_ok';
            btn_ok.x = 25;
            btn_ok.y = 375;
            btn_ok.width = 305;
            btn_ok.height = 57;
            this.addQuiackChild(btn_ok);
            btn_ok.text= '合成';
            btn_ok.fontColor= 0xFF9900;
            btn_ok.fontSize= 24;
            list_equip = new List();
            list_equip.x = 21;
            list_equip.y = 198;
            list_equip.width = 310;
            list_equip.height = 100;
            this.addQuiackChild(list_equip);
            view_drop = new Sprite();
            view_drop.x = 21;
            view_drop.y = 129;
            view_drop.width = 317;
            view_drop.height = 294;
            this.addQuiackChild(view_drop);
            view_drop.name= 'view_drop';
            texture = assetMgr.getTexture('ui_gongyong_hero_pub_9gongge_article');
            var bg_listRect:Rectangle = new Rectangle(17,19,27,22);
            var bg_list9ScaleTexture:Scale9Textures = new Scale9Textures(texture,bg_listRect);
            var bg_list : Scale9Image = new Scale9Image(bg_list9ScaleTexture);
            bg_list.y = 19;
            bg_list.width = 312;
            bg_list.height = 275;
            view_drop.addQuiackChild(bg_list);
            texture = assetMgr.getTexture('ui_gongyong_hero_pub_9gongge_article1')
            image = new Image(texture);
            image.name= 'tag';
            image.x = 177;
            image.width = 42;
            image.height = 19;
            view_drop.addQuiackChild(image);
            image.touchable = false;
            list_drop = new List();
            list_drop.x = -5;
            list_drop.y = 25;
            list_drop.width = 310;
            list_drop.height = 258;
            view_drop.addQuiackChild(list_drop);
            init();
        }
        override public function dispose():void
        {
            grid.dispose();
            btn_ok.dispose();
            list_equip.dispose();
            list_drop.dispose();
            view_drop.dispose();
            super.dispose();
        
}
    }
}
