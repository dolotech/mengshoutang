package  game.view.viewBase
{
    import com.dialog.Dialog;
    import com.utils.Constants;
    
    import flash.geom.Rectangle;
    
    import feathers.controls.List;
    import feathers.controls.TextInput;
    import feathers.display.Scale9Image;
    import feathers.textures.Scale9Textures;
    
    import game.manager.AssetMgr;
    
    import starling.display.Button;
    import starling.display.Image;
    import starling.text.TextField;
    import starling.textures.Texture;

    public class LoginRewardDlgBase extends Dialog
    {
        public var ui_Setup_button_switch336358:Scale9Image;
        public var Registration:TextField;
        public var text_currDayNum:TextField;
        public var Day:TextField;
        public var text_currDay:TextField;
        public var list_award:List;
        public var btn_day1:Button;
        public var btn_day2:Button;
        public var btn_day3:Button;
        public var btn_day4:Button;
        public var btn_day5:Button;
        public var btn_day7:Button;
        public var btn_day6:Button;
        public var closes:Button;

        public function LoginRewardDlgBase()
        {
            super(false);
            var texture:Texture;
            var textField:TextField;
            var input_txt:TextInput;
            var image:Image;
            var button:Button;;
            var assetMgr:AssetMgr = AssetMgr.instance;
            texture =assetMgr.getTexture('ui_wudixingyunxing_xingxing_goumaikuang2');
            image = new Image(texture);
            image.x = 86;
            image.y = 30;
            image.width = 753;
            image.height = 507;
            image.smoothing= Constants.NONE;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_Setup_title');
            image = new Image(texture);
            image.x = 260;
            image.width = 399;
            image.height = 104;
            image.smoothing= Constants.NONE;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_wudixingyunxing_xingxing_goumaikuang1');
            image = new Image(texture);
            image.y = 30;
            image.width = 102;
            image.height = 507;
            image.smoothing= Constants.NONE;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_Buyingdiamond_diamond_di');
            image = new Image(texture);
            image.x = 29;
            image.y = 76;
            image.width = 146;
            image.height = 37;
            image.smoothing= Constants.NONE;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_wudixingyunxing_xingxing_goumaikuang1');
            image = new Image(texture);
            image.x = 916;
            image.y = 30;
            image.width = 102;
            image.height = 507;
            image.scaleX = -1;;
            image.smoothing= Constants.NONE;
            this.addQuiackChild(image);
            texture = assetMgr.getTexture('ui_Setup_button_switch3');
            var ui_Setup_button_switch336358Rect:Rectangle = new Rectangle(54,26,107,52);
            var ui_Setup_button_switch3363589ScaleTexture:Scale9Textures = new Scale9Textures(texture,ui_Setup_button_switch336358Rect);
            ui_Setup_button_switch336358 = new Scale9Image(ui_Setup_button_switch3363589ScaleTexture);
            ui_Setup_button_switch336358.x = 36;
            ui_Setup_button_switch336358.y = 358;
            ui_Setup_button_switch336358.width = 848;
            ui_Setup_button_switch336358.height = 153;
            this.addQuiackChild(ui_Setup_button_switch336358);
            Registration = new TextField(314,41,'','',28,0x563300,false);
            Registration.touchable = false;
            Registration.hAlign= 'center';
            Registration.text= '签到';
            Registration.x = 302;
            Registration.y = 25;
            this.addQuiackChild(Registration);
            texture =assetMgr.getTexture('ui_Buyingdiamond_diamond_di');
            image = new Image(texture);
            image.x = 29;
            image.y = 76;
            image.width = 146;
            image.height = 37;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            this.addQuiackChild(image);
            text_currDayNum = new TextField(40,36,'','',24,0x04F632,false);
            text_currDayNum.touchable = false;
            text_currDayNum.hAlign= 'center';
            text_currDayNum.text= '';
            text_currDayNum.x = 108;
            text_currDayNum.y = 76;
            this.addQuiackChild(text_currDayNum);
            Day = new TextField(26,30,'','',18,0x04F632,false);
            Day.touchable = false;
            Day.hAlign= 'center';
            Day.text= '天';
            Day.x = 146;
            Day.y = 80;
            this.addQuiackChild(Day);
            text_currDay = new TextField(85,30,'','',18,0x04F632,false);
            text_currDay.touchable = false;
            text_currDay.hAlign= 'center';
            text_currDay.text= '当前登录';
            text_currDay.x = 29;
            text_currDay.y = 80;
            this.addQuiackChild(text_currDay);
            list_award = new List();
            list_award.x = 48;
            list_award.y = 363;
            list_award.width = 820;
            list_award.height = 140;
            this.addQuiackChild(list_award);
            texture = assetMgr.getTexture('ui_button_zhuxianfubenpaizidi');
            btn_day1 = new Button(texture);
            btn_day1.name= 'btn_day1';
            btn_day1.x = 19;
            btn_day1.y = 148;
            btn_day1.width = 124;
            btn_day1.height = 184;
            this.addQuiackChild(btn_day1);
            texture =assetMgr.getTexture('ui_button_zhuxianfubenpaizidi');
            image = new Image(texture);
            image.width = 162;
            image.height = 240;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            btn_day1.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_tubiao_zhuxianpilaozhi_xiao_jian');
            image = new Image(texture);
            image.x = 22;
            image.y = 19;
            image.width = 114;
            image.height = 34;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            btn_day1.addQuiackChild(image);
            texture = assetMgr.getTexture('ui_shangcheng_jinxiangzi1')
            image = new Image(texture);
            image.name= 'openBox';
            image.x = 13;
            image.y = 64;
            image.width = 127;
            image.height = 128;
            btn_day1.addQuiackChild(image);
            image.touchable = false;
            texture = assetMgr.getTexture('ui_shangcheng_jinxiangzi2')
            image = new Image(texture);
            image.name= 'closeBox1';
            image.x = 19;
            image.y = 96;
            image.width = 109;
            image.height = 96;
            btn_day1.addQuiackChild(image);
            image.touchable = false;
            texture = assetMgr.getTexture('ui_shangcheng_jinxiangzi')
            image = new Image(texture);
            image.name= 'closeBox';
            image.x = 19;
            image.y = 96;
            image.width = 109;
            image.height = 96;
            btn_day1.addQuiackChild(image);
            image.touchable = false;
            texture = assetMgr.getTexture('ui_world_nandusuo')
            image = new Image(texture);
            image.name= 'Lock';
            image.x = 42;
            image.y = 112;
            image.width = 59;
            image.height = 67;
            btn_day1.addQuiackChild(image);
            image.touchable = false;
            textField = new TextField(104,25,'','',21,0xFFFFCC,false);
            textField.touchable = false;
            textField.x = 26;
            textField.y = 25;
            textField.hAlign= 'center';
            textField.text= '第一天';
            textField.name= 'text_Day';
            btn_day1.addQuiackChild(textField);
            texture = assetMgr.getTexture('ui_gongyong_jianglilingqu')
            image = new Image(texture);
            image.name= 'CanReceive';
            image.x = 24;
            image.y = 97;
            image.width = 95;
            image.height = 39;
            btn_day1.addQuiackChild(image);
            image.touchable = false;
            texture = assetMgr.getTexture('ui_reward_yilingqu')
            image = new Image(texture);
            image.name= 'stopReceive';
            image.x = 24;
            image.y = 97;
            image.width = 95;
            image.height = 40;
            btn_day1.addQuiackChild(image);
            image.touchable = false;
            texture = assetMgr.getTexture('ui_button_zhuxianfubenpaizidi');
            btn_day2 = new Button(texture);
            btn_day2.name= 'btn_day2';
            btn_day2.x = 145;
            btn_day2.y = 148;
            btn_day2.width = 124;
            btn_day2.height = 184;
            this.addQuiackChild(btn_day2);
            texture =assetMgr.getTexture('ui_button_zhuxianfubenpaizidi');
            image = new Image(texture);
            image.width = 162;
            image.height = 240;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            btn_day2.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_tubiao_zhuxianpilaozhi_xiao_jian');
            image = new Image(texture);
            image.x = 22;
            image.y = 19;
            image.width = 114;
            image.height = 34;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            btn_day2.addQuiackChild(image);
            texture = assetMgr.getTexture('ui_shangcheng_jinxiangzi1')
            image = new Image(texture);
            image.name= 'openBox';
            image.x = 13;
            image.y = 64;
            image.width = 127;
            image.height = 128;
            btn_day2.addQuiackChild(image);
            image.touchable = false;
            texture = assetMgr.getTexture('ui_shangcheng_jinxiangzi2')
            image = new Image(texture);
            image.name= 'closeBox1';
            image.x = 19;
            image.y = 96;
            image.width = 109;
            image.height = 96;
            btn_day2.addQuiackChild(image);
            image.touchable = false;
            texture = assetMgr.getTexture('ui_shangcheng_jinxiangzi')
            image = new Image(texture);
            image.name= 'closeBox';
            image.x = 19;
            image.y = 96;
            image.width = 109;
            image.height = 96;
            btn_day2.addQuiackChild(image);
            image.touchable = false;
            texture = assetMgr.getTexture('ui_world_nandusuo')
            image = new Image(texture);
            image.name= 'Lock';
            image.x = 42;
            image.y = 112;
            image.width = 59;
            image.height = 67;
            btn_day2.addQuiackChild(image);
            image.touchable = false;
            textField = new TextField(104,25,'','',21,0xFFFFCC,false);
            textField.touchable = false;
            textField.x = 26;
            textField.y = 25;
            textField.hAlign= 'center';
            textField.text= '第一天';
            textField.name= 'text_Day';
            btn_day2.addQuiackChild(textField);
            texture = assetMgr.getTexture('ui_gongyong_jianglilingqu')
            image = new Image(texture);
            image.name= 'CanReceive';
            image.x = 24;
            image.y = 97;
            image.width = 95;
            image.height = 39;
            btn_day2.addQuiackChild(image);
            image.touchable = false;
            texture = assetMgr.getTexture('ui_reward_yilingqu')
            image = new Image(texture);
            image.name= 'stopReceive';
            image.x = 24;
            image.y = 97;
            image.width = 95;
            image.height = 40;
            btn_day2.addQuiackChild(image);
            image.touchable = false;
            texture = assetMgr.getTexture('ui_button_zhuxianfubenpaizidi');
            btn_day3 = new Button(texture);
            btn_day3.name= 'btn_day3';
            btn_day3.x = 271;
            btn_day3.y = 148;
            btn_day3.width = 124;
            btn_day3.height = 184;
            this.addQuiackChild(btn_day3);
            texture =assetMgr.getTexture('ui_button_zhuxianfubenpaizidi');
            image = new Image(texture);
            image.width = 162;
            image.height = 240;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            btn_day3.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_tubiao_zhuxianpilaozhi_xiao_jian');
            image = new Image(texture);
            image.x = 22;
            image.y = 19;
            image.width = 114;
            image.height = 34;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            btn_day3.addQuiackChild(image);
            texture = assetMgr.getTexture('ui_shangcheng_jinxiangzi1')
            image = new Image(texture);
            image.name= 'openBox';
            image.x = 13;
            image.y = 64;
            image.width = 127;
            image.height = 128;
            btn_day3.addQuiackChild(image);
            image.touchable = false;
            texture = assetMgr.getTexture('ui_shangcheng_jinxiangzi2')
            image = new Image(texture);
            image.name= 'closeBox1';
            image.x = 19;
            image.y = 96;
            image.width = 109;
            image.height = 96;
            btn_day3.addQuiackChild(image);
            image.touchable = false;
            texture = assetMgr.getTexture('ui_shangcheng_jinxiangzi')
            image = new Image(texture);
            image.name= 'closeBox';
            image.x = 19;
            image.y = 96;
            image.width = 109;
            image.height = 96;
            btn_day3.addQuiackChild(image);
            image.touchable = false;
            texture = assetMgr.getTexture('ui_world_nandusuo')
            image = new Image(texture);
            image.name= 'Lock';
            image.x = 42;
            image.y = 112;
            image.width = 59;
            image.height = 67;
            btn_day3.addQuiackChild(image);
            image.touchable = false;
            textField = new TextField(104,25,'','',21,0xFFFFCC,false);
            textField.touchable = false;
            textField.x = 26;
            textField.y = 25;
            textField.hAlign= 'center';
            textField.text= '第一天';
            textField.name= 'text_Day';
            btn_day3.addQuiackChild(textField);
            texture = assetMgr.getTexture('ui_gongyong_jianglilingqu')
            image = new Image(texture);
            image.name= 'CanReceive';
            image.x = 24;
            image.y = 97;
            image.width = 95;
            image.height = 39;
            btn_day3.addQuiackChild(image);
            image.touchable = false;
            texture = assetMgr.getTexture('ui_reward_yilingqu')
            image = new Image(texture);
            image.name= 'stopReceive';
            image.x = 24;
            image.y = 97;
            image.width = 95;
            image.height = 40;
            btn_day3.addQuiackChild(image);
            image.touchable = false;
            texture = assetMgr.getTexture('ui_button_zhuxianfubenpaizidi');
            btn_day4 = new Button(texture);
            btn_day4.name= 'btn_day4';
            btn_day4.x = 397;
            btn_day4.y = 148;
            btn_day4.width = 124;
            btn_day4.height = 184;
            this.addQuiackChild(btn_day4);
            texture =assetMgr.getTexture('ui_button_zhuxianfubenpaizidi');
            image = new Image(texture);
            image.width = 162;
            image.height = 240;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            btn_day4.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_tubiao_zhuxianpilaozhi_xiao_jian');
            image = new Image(texture);
            image.x = 22;
            image.y = 19;
            image.width = 114;
            image.height = 34;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            btn_day4.addQuiackChild(image);
            texture = assetMgr.getTexture('ui_shangcheng_jinxiangzi1')
            image = new Image(texture);
            image.name= 'openBox';
            image.x = 13;
            image.y = 64;
            image.width = 127;
            image.height = 128;
            btn_day4.addQuiackChild(image);
            image.touchable = false;
            texture = assetMgr.getTexture('ui_shangcheng_jinxiangzi2')
            image = new Image(texture);
            image.name= 'closeBox1';
            image.x = 19;
            image.y = 96;
            image.width = 109;
            image.height = 96;
            btn_day4.addQuiackChild(image);
            image.touchable = false;
            texture = assetMgr.getTexture('ui_shangcheng_jinxiangzi')
            image = new Image(texture);
            image.name= 'closeBox';
            image.x = 19;
            image.y = 96;
            image.width = 109;
            image.height = 96;
            btn_day4.addQuiackChild(image);
            image.touchable = false;
            texture = assetMgr.getTexture('ui_world_nandusuo')
            image = new Image(texture);
            image.name= 'Lock';
            image.x = 42;
            image.y = 112;
            image.width = 59;
            image.height = 67;
            btn_day4.addQuiackChild(image);
            image.touchable = false;
            textField = new TextField(104,25,'','',21,0xFFFFCC,false);
            textField.touchable = false;
            textField.x = 26;
            textField.y = 25;
            textField.hAlign= 'center';
            textField.text= '第一天';
            textField.name= 'text_Day';
            btn_day4.addQuiackChild(textField);
            texture = assetMgr.getTexture('ui_gongyong_jianglilingqu')
            image = new Image(texture);
            image.name= 'CanReceive';
            image.x = 24;
            image.y = 97;
            image.width = 95;
            image.height = 39;
            btn_day4.addQuiackChild(image);
            image.touchable = false;
            texture = assetMgr.getTexture('ui_reward_yilingqu')
            image = new Image(texture);
            image.name= 'stopReceive';
            image.x = 24;
            image.y = 97;
            image.width = 95;
            image.height = 40;
            btn_day4.addQuiackChild(image);
            image.touchable = false;
            texture = assetMgr.getTexture('ui_button_zhuxianfubenpaizidi');
            btn_day5 = new Button(texture);
            btn_day5.name= 'btn_day5';
            btn_day5.x = 524;
            btn_day5.y = 148;
            btn_day5.width = 124;
            btn_day5.height = 184;
            this.addQuiackChild(btn_day5);
            texture =assetMgr.getTexture('ui_button_zhuxianfubenpaizidi');
            image = new Image(texture);
            image.width = 162;
            image.height = 240;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            btn_day5.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_tubiao_zhuxianpilaozhi_xiao_jian');
            image = new Image(texture);
            image.x = 22;
            image.y = 19;
            image.width = 114;
            image.height = 34;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            btn_day5.addQuiackChild(image);
            texture = assetMgr.getTexture('ui_shangcheng_jinxiangzi1')
            image = new Image(texture);
            image.name= 'openBox';
            image.x = 13;
            image.y = 64;
            image.width = 127;
            image.height = 128;
            btn_day5.addQuiackChild(image);
            image.touchable = false;
            texture = assetMgr.getTexture('ui_shangcheng_jinxiangzi2')
            image = new Image(texture);
            image.name= 'closeBox1';
            image.x = 19;
            image.y = 96;
            image.width = 109;
            image.height = 96;
            btn_day5.addQuiackChild(image);
            image.touchable = false;
            texture = assetMgr.getTexture('ui_shangcheng_jinxiangzi')
            image = new Image(texture);
            image.name= 'closeBox';
            image.x = 19;
            image.y = 96;
            image.width = 109;
            image.height = 96;
            btn_day5.addQuiackChild(image);
            image.touchable = false;
            texture = assetMgr.getTexture('ui_world_nandusuo')
            image = new Image(texture);
            image.name= 'Lock';
            image.x = 42;
            image.y = 112;
            image.width = 59;
            image.height = 67;
            btn_day5.addQuiackChild(image);
            image.touchable = false;
            textField = new TextField(104,25,'','',21,0xFFFFCC,false);
            textField.touchable = false;
            textField.x = 26;
            textField.y = 25;
            textField.hAlign= 'center';
            textField.text= '第一天';
            textField.name= 'text_Day';
            btn_day5.addQuiackChild(textField);
            texture = assetMgr.getTexture('ui_gongyong_jianglilingqu')
            image = new Image(texture);
            image.name= 'CanReceive';
            image.x = 24;
            image.y = 97;
            image.width = 95;
            image.height = 39;
            btn_day5.addQuiackChild(image);
            image.touchable = false;
            texture = assetMgr.getTexture('ui_reward_yilingqu')
            image = new Image(texture);
            image.name= 'stopReceive';
            image.x = 24;
            image.y = 97;
            image.width = 95;
            image.height = 40;
            btn_day5.addQuiackChild(image);
            image.touchable = false;
            texture = assetMgr.getTexture('ui_button_zhuxianfubenpaizidi');
            btn_day7 = new Button(texture);
            btn_day7.name= 'btn_day7';
            btn_day7.x = 776;
            btn_day7.y = 148;
            btn_day7.width = 124;
            btn_day7.height = 184;
            this.addQuiackChild(btn_day7);
            texture =assetMgr.getTexture('ui_button_zhuxianfubenpaizidi');
            image = new Image(texture);
            image.width = 162;
            image.height = 240;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            btn_day7.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_tubiao_zhuxianpilaozhi_xiao_jian');
            image = new Image(texture);
            image.x = 22;
            image.y = 19;
            image.width = 114;
            image.height = 34;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            btn_day7.addQuiackChild(image);
            texture = assetMgr.getTexture('ui_shangcheng_jinxiangzi1')
            image = new Image(texture);
            image.name= 'openBox';
            image.x = 13;
            image.y = 64;
            image.width = 127;
            image.height = 128;
            btn_day7.addQuiackChild(image);
            image.touchable = false;
            texture = assetMgr.getTexture('ui_shangcheng_jinxiangzi2')
            image = new Image(texture);
            image.name= 'closeBox1';
            image.x = 19;
            image.y = 96;
            image.width = 109;
            image.height = 96;
            btn_day7.addQuiackChild(image);
            image.touchable = false;
            texture = assetMgr.getTexture('ui_shangcheng_jinxiangzi')
            image = new Image(texture);
            image.name= 'closeBox';
            image.x = 19;
            image.y = 96;
            image.width = 109;
            image.height = 96;
            btn_day7.addQuiackChild(image);
            image.touchable = false;
            texture = assetMgr.getTexture('ui_world_nandusuo')
            image = new Image(texture);
            image.name= 'Lock';
            image.x = 42;
            image.y = 112;
            image.width = 59;
            image.height = 67;
            btn_day7.addQuiackChild(image);
            image.touchable = false;
            textField = new TextField(104,25,'','',21,0xFFFFCC,false);
            textField.touchable = false;
            textField.x = 26;
            textField.y = 25;
            textField.hAlign= 'center';
            textField.text= '第一天';
            textField.name= 'text_Day';
            btn_day7.addQuiackChild(textField);
            texture = assetMgr.getTexture('ui_gongyong_jianglilingqu')
            image = new Image(texture);
            image.name= 'CanReceive';
            image.x = 24;
            image.y = 97;
            image.width = 95;
            image.height = 39;
            btn_day7.addQuiackChild(image);
            image.touchable = false;
            texture = assetMgr.getTexture('ui_reward_yilingqu')
            image = new Image(texture);
            image.name= 'stopReceive';
            image.x = 24;
            image.y = 97;
            image.width = 95;
            image.height = 40;
            btn_day7.addQuiackChild(image);
            image.touchable = false;
            texture = assetMgr.getTexture('ui_button_zhuxianfubenpaizidi');
            btn_day6 = new Button(texture);
            btn_day6.name= 'btn_day6';
            btn_day6.x = 650;
            btn_day6.y = 148;
            btn_day6.width = 124;
            btn_day6.height = 184;
            this.addQuiackChild(btn_day6);
            texture =assetMgr.getTexture('ui_button_zhuxianfubenpaizidi');
            image = new Image(texture);
            image.width = 162;
            image.height = 240;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            btn_day6.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_tubiao_zhuxianpilaozhi_xiao_jian');
            image = new Image(texture);
            image.x = 22;
            image.y = 19;
            image.width = 114;
            image.height = 34;
            image.touchable = false;
            image.smoothing= Constants.smoothing;
            btn_day6.addQuiackChild(image);
            texture = assetMgr.getTexture('ui_shangcheng_jinxiangzi1')
            image = new Image(texture);
            image.name= 'openBox';
            image.x = 13;
            image.y = 64;
            image.width = 127;
            image.height = 128;
            btn_day6.addQuiackChild(image);
            image.touchable = false;
            texture = assetMgr.getTexture('ui_shangcheng_jinxiangzi2')
            image = new Image(texture);
            image.name= 'closeBox1';
            image.x = 19;
            image.y = 96;
            image.width = 109;
            image.height = 96;
            btn_day6.addQuiackChild(image);
            image.touchable = false;
            texture = assetMgr.getTexture('ui_shangcheng_jinxiangzi')
            image = new Image(texture);
            image.name= 'closeBox';
            image.x = 19;
            image.y = 96;
            image.width = 109;
            image.height = 96;
            btn_day6.addQuiackChild(image);
            image.touchable = false;
            texture = assetMgr.getTexture('ui_world_nandusuo')
            image = new Image(texture);
            image.name= 'Lock';
            image.x = 42;
            image.y = 112;
            image.width = 59;
            image.height = 67;
            btn_day6.addQuiackChild(image);
            image.touchable = false;
            textField = new TextField(104,25,'','',21,0xFFFFCC,false);
            textField.touchable = false;
            textField.x = 26;
            textField.y = 25;
            textField.hAlign= 'center';
            textField.text= '第一天';
            textField.name= 'text_Day';
            btn_day6.addQuiackChild(textField);
            texture = assetMgr.getTexture('ui_gongyong_jianglilingqu')
            image = new Image(texture);
            image.name= 'CanReceive';
            image.x = 24;
            image.y = 97;
            image.width = 95;
            image.height = 39;
            btn_day6.addQuiackChild(image);
            image.touchable = false;
            texture = assetMgr.getTexture('ui_reward_yilingqu')
            image = new Image(texture);
            image.name= 'stopReceive';
            image.x = 24;
            image.y = 97;
            image.width = 95;
            image.height = 40;
            btn_day6.addQuiackChild(image);
            image.touchable = false;
            texture = assetMgr.getTexture('ui_Buyingdiamond_button_guanbi');
            closes = new Button(texture);
            closes.name= 'closes';
            closes.x = 835;
            closes.y = 58;
            closes.width = 61;
            closes.height = 60;
            this.addQuiackChild(closes);
            init();
        }
        override public function dispose():void
        {
            list_award.dispose();
            btn_day1.dispose();
            btn_day2.dispose();
            btn_day3.dispose();
            btn_day4.dispose();
            btn_day5.dispose();
            btn_day7.dispose();
            btn_day6.dispose();
            closes.dispose();
            super.dispose();
        
}
    }
}
