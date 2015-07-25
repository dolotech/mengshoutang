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
    import com.dialog.Dialog;

    public class TaskDialogBase extends Dialog
    {
        public var taskBg1:Scale9Image;
        public var taskTitle:TextField;
        public var taskBg2:Scale9Image;
        public var closeBtn:Button;
        public var taskPass:Image;
        public var taskContent:TextField;
        public var taskMb:TextField;
        public var taskRward:TextField;
        public var taskButton:Button;
        public var operBtnTxt:TextField;

        public function TaskDialogBase()
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
            image.y = 18;
            image.width = 86;
            image.height = 551;
            image.smoothing= Constants.NONE;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_wudixingyunxing_xingxing_goumaikuang2');
            image = new Image(texture);
            image.x = 76;
            image.y = 18;
            image.width = 660;
            image.height = 551;
            image.smoothing= Constants.NONE;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_wudixingyunxing_xingxing_goumaikuang1');
            image = new Image(texture);
            image.x = 800;
            image.y = 18;
            image.width = 86;
            image.height = 551;
            image.scaleX = -0.84661865234375;
            image.smoothing= Constants.NONE;
            this.addQuiackChild(image);
            texture = assetMgr.getTexture('ui_gongyong_di_9gongge');
            var taskBg1Rect:Rectangle = new Rectangle(21,21,43,41);
            var taskBg19ScaleTexture:Scale9Textures = new Scale9Textures(texture,taskBg1Rect);
            taskBg1 = new Scale9Image(taskBg19ScaleTexture);
            taskBg1.x = 18;
            taskBg1.y = 120;
            taskBg1.width = 244;
            taskBg1.height = 427;
            this.addQuiackChild(taskBg1);
            texture =assetMgr.getTexture('ui_Setup_title');
            image = new Image(texture);
            image.x = 206;
            image.width = 399;
            image.height = 104;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            this.addQuiackChild(image);
            taskTitle = new TextField(294,46,'','',32,0xFFFFFF,false);
            taskTitle.touchable = false;
            taskTitle.hAlign= 'center';
            taskTitle.text= '史诗乐章';
            taskTitle.x = 259;
            taskTitle.y = 14;
            this.addQuiackChild(taskTitle);
            texture = assetMgr.getTexture('ui_gongyong_hero_pub_9gongge_article');
            var taskBg2Rect:Rectangle = new Rectangle(13,14,35,34);
            var taskBg29ScaleTexture:Scale9Textures = new Scale9Textures(texture,taskBg2Rect);
            taskBg2 = new Scale9Image(taskBg29ScaleTexture);
            taskBg2.x = 270;
            taskBg2.y = 102;
            taskBg2.width = 517;
            taskBg2.height = 279;
            this.addQuiackChild(taskBg2);
            texture = assetMgr.getTexture('ui_Buyingdiamond_button_guanbi');
            closeBtn = new Button(texture);
            closeBtn.name= 'closeBtn';
            closeBtn.x = 731;
            closeBtn.y = 30;
            closeBtn.width = 61;
            closeBtn.height = 60;
            this.addQuiackChild(closeBtn);
            texture = assetMgr.getTexture('ui_renwu_pass')
            taskPass = new Image(texture);
            taskPass.x = 535;
            taskPass.y = 127;
            taskPass.width = 230;
            taskPass.height = 230;
            this.addQuiackChild(taskPass);
            taskPass.touchable = false;
            taskContent = new TextField(473,202,'','',24,0xFFFFFF,false);
            taskContent.touchable = false;
            taskContent.hAlign= 'left';
            taskContent.text= '';
            taskContent.x = 301;
            taskContent.y = 113;
            this.addQuiackChild(taskContent);
            taskMb = new TextField(139,46,'','',28,0xFFFFFF,false);
            taskMb.touchable = false;
            taskMb.hAlign= 'left';
            taskMb.text= '任务目标:';
            taskMb.x = 299;
            taskMb.y = 317;
            this.addQuiackChild(taskMb);
            taskRward = new TextField(138,41,'','',28,0xFFFFFF,false);
            taskRward.touchable = false;
            taskRward.hAlign= 'left';
            taskRward.text= '任务奖励:';
            taskRward.x = 299;
            taskRward.y = 399;
            this.addQuiackChild(taskRward);
            texture = assetMgr.getTexture('ui_button_gongyong_big');
            taskButton = new Button(texture);
            taskButton.name= 'taskButton';
            taskButton.x = 293;
            taskButton.y = 480;
            taskButton.width = 464;
            taskButton.height = 64;
            this.addQuiackChild(taskButton);
            operBtnTxt = new TextField(242,46,'','',28,0xFFFFFF,false);
            operBtnTxt.touchable = false;
            operBtnTxt.hAlign= 'center';
            operBtnTxt.text= '';
            operBtnTxt.x = 413;
            operBtnTxt.y = 489;
            this.addQuiackChild(operBtnTxt);
            init();
        }
        override public function dispose():void
        {
            closeBtn.dispose();
            taskButton.dispose();
            super.dispose();
        
}
    }
}
