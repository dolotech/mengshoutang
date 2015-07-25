package game.view.replacePhotoList
{
import com.dialog.Dialog;

import feathers.controls.List;

import game.manager.AssetMgr;

import starling.display.Button;
import starling.display.Image;
import starling.text.TextField;
import starling.textures.Texture;
import com.utils.Constants;

    public class GamePhotoDlgBase extends Dialog
    {
        public var b1:Image;
        public var list_bag:List;
        public var txt_name:TextField;

        public function GamePhotoDlgBase()
        {
            super(false);
            var texture:Texture;
            var textField:TextField;
            var image:Image;
            var button:Button;
            var assetMgr:AssetMgr = AssetMgr.instance;
            texture = assetMgr.getTexture('ui_wudixingyunxing_xingxing_goumaikuang2');
            b1 = new Image(texture);
            b1.x = 80;
              b1.y = 0;
            b1.width = 473;
            b1.height = 391;
            this.addQuiackChild(b1);
            texture =assetMgr.getTexture('ui_wudixingyunxing_xingxing_goumaikuang1');
            image = new Image(texture);
            image.x = 0;
              image.y = 0;
            image.width = 102;
            image.height = 391;
            image.smoothing = Constants.NONE;
            image.touchable = false;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_wudixingyunxing_xingxing_goumaikuang1');
            image = new Image(texture);
            image.x = 642;
              image.y = 0;
            image.width = 102;
            image.height = 391;
            image.scaleX = -1;
            image.smoothing = Constants.NONE;
            image.touchable = false;
            this.addQuiackChild(image);
            list_bag = new List();
            list_bag.x = 12;
              list_bag.y = 60;
            list_bag.width = 620;
            list_bag.height = 320;
            this.addQuiackChild(list_bag);
            txt_name = new TextField(230,41,'','',28,0xFFFF00,false);
            txt_name.touchable = false;
            txt_name.hAlign = 'center';
            txt_name.text = '';
            txt_name.x = 195;
              txt_name.y = 17;
            this.addQuiackChild(txt_name);

            init()
        }
        override public function dispose():void
        {
            list_bag.dispose();
            super.dispose();
        
}

    }
}