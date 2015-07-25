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

    public class EmailRenderItemBase extends DefaultListItemRenderer
    {
        public var tag_selected:Image;
        public var tag_normal:Image;
        public var box:Sprite;
        public var txt_name:TextField;
        public var txt_des2:TextField;
        public var txt_time:TextField;
        public var read:Image;
        public var txt_des1:TextField;
        public var txt_sender:TextField;
        public var newMail:Image;

        public function EmailRenderItemBase()
        {
            var texture:Texture;
            var textField:TextField;
            var input_txt:TextInput;
            var image:Image;
            var button:Button;
            var assetMgr:AssetMgr = AssetMgr.instance;
            texture = assetMgr.getTexture('ui_mail_envelope_2')
            tag_selected = new Image(texture);
            tag_selected.width = 315;
            tag_selected.height = 115;
            this.addQuiackChild(tag_selected);
            tag_selected.touchable = false;
            texture = assetMgr.getTexture('ui_mail_envelope_1')
            tag_normal = new Image(texture);
            tag_normal.width = 315;
            tag_normal.height = 115;
            this.addQuiackChild(tag_normal);
            tag_normal.touchable = false;
            box = new Sprite();
            box.x = 16;
            box.y = 14;
            box.width = 90;
            box.height = 90;
            this.addQuiackChild(box);
            box.name= 'box';
            texture =assetMgr.getTexture('ui_gongyong_90wupingkuang');
            image = new Image(texture);
            image.width = 90;
            image.height = 90;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            box.addQuiackChild(image);
            texture = assetMgr.getTexture('ui_button_mail')
            image = new Image(texture);
            image.name= 'icon';
            image.width = 89;
            image.height = 89;
            box.addQuiackChild(image);
            image.touchable = false;
            texture = assetMgr.getTexture('ui_gongyong_90wupingkuang0');
            button = new Button(texture);
            button.name= 'box';
            button.width = 90;
            button.height = 90;
            box.addQuiackChild(button);
            textField = new TextField(78,28,'','',21,0xFFFFFF,false);
            textField.touchable = false;
            textField.x = 1;
            textField.y = 58;
            textField.hAlign= 'right';
            textField.text= '';
            textField.name= 'txt_num';
            box.addQuiackChild(textField);
            txt_name = new TextField(139,30,'','',20,0xFFFF00,false);
            txt_name.touchable = false;
            txt_name.hAlign= 'center';
            txt_name.text= '';
            txt_name.x = 92;
            txt_name.y = 11;
            this.addQuiackChild(txt_name);
            txt_des2 = new TextField(114,28,'','',18,0xFFFFFF,false);
            txt_des2.touchable = false;
            txt_des2.hAlign= 'left';
            txt_des2.text= '剩余时间： ';
            txt_des2.x = 109;
            txt_des2.y = 82;
            this.addQuiackChild(txt_des2);
            txt_time = new TextField(94,28,'','',18,0xFFFFFF,false);
            txt_time.touchable = false;
            txt_time.hAlign= 'right';
            txt_time.text= '00:00:00';
            txt_time.x = 211;
            txt_time.y = 82;
            this.addQuiackChild(txt_time);
            texture = assetMgr.getTexture('ui_button_mail_ read')
            read = new Image(texture);
            read.x = 261;
            read.width = 61;
            read.height = 47;
            this.addQuiackChild(read);
            read.touchable = false;
            txt_des1 = new TextField(110,34,'','',20,0xFFFFFF,false);
            txt_des1.touchable = false;
            txt_des1.hAlign= 'left';
            txt_des1.text= '发件人：';
            txt_des1.x = 109;
            txt_des1.y = 44;
            this.addQuiackChild(txt_des1);
            txt_sender = new TextField(135,34,'','',20,0xFFFFFF,false);
            txt_sender.touchable = false;
            txt_sender.hAlign= 'center';
            txt_sender.text= '系统管理员';
            txt_sender.x = 174;
            txt_sender.y = 44;
            this.addQuiackChild(txt_sender);
            texture = assetMgr.getTexture('ui_button_mail_new')
            newMail = new Image(texture);
            newMail.width = 61;
            newMail.height = 43;
            this.addQuiackChild(newMail);
            newMail.touchable = false;
        }
        override public function dispose():void
        {
            box.dispose();
            super.dispose();
        
}
    }
}
