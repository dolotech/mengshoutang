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

    public class SkillDesDialogBase extends Dialog
    {
        public var ui_Setup_button_switch36091:Scale9Image;
        public var ui_Setup_button_switch360209:Scale9Image;
        public var skilName:TextField;
        public var skillTypeTitle:TextField;
        public var skillDesTitle:TextField;
        public var skillType:TextField;
        public var skillDes:TextField;
        public var icon:Image;

        public function SkillDesDialogBase()
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
            image.x = 35;
            image.width = 100;
            image.height = 457;
            image.smoothing= Constants.NONE;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_wudixingyunxing_xingxing_goumaikuang2');
            image = new Image(texture);
            image.x = 74;
            image.width = 297;
            image.height = 457;
            image.smoothing= Constants.NONE;
            this.addQuiackChild(image);
            texture =assetMgr.getTexture('ui_wudixingyunxing_xingxing_goumaikuang1');
            image = new Image(texture);
            image.x = 413;
            image.width = 100;
            image.height = 457;
            image.scaleX = -0.984375;
            image.smoothing= Constants.NONE;
            this.addQuiackChild(image);
            texture = assetMgr.getTexture('ui_Setup_button_switch3');
            var ui_Setup_button_switch36091Rect:Rectangle = new Rectangle(14,20,180,69);
            var ui_Setup_button_switch360919ScaleTexture:Scale9Textures = new Scale9Textures(texture,ui_Setup_button_switch36091Rect);
            ui_Setup_button_switch36091 = new Scale9Image(ui_Setup_button_switch360919ScaleTexture);
            ui_Setup_button_switch36091.x = 60;
            ui_Setup_button_switch36091.y = 91;
            ui_Setup_button_switch36091.width = 334;
            ui_Setup_button_switch36091.height = 113;
            this.addQuiackChild(ui_Setup_button_switch36091);
            texture = assetMgr.getTexture('ui_Setup_button_switch3');
            var ui_Setup_button_switch360209Rect:Rectangle = new Rectangle(14,20,180,69);
            var ui_Setup_button_switch3602099ScaleTexture:Scale9Textures = new Scale9Textures(texture,ui_Setup_button_switch360209Rect);
            ui_Setup_button_switch360209 = new Scale9Image(ui_Setup_button_switch3602099ScaleTexture);
            ui_Setup_button_switch360209.x = 60;
            ui_Setup_button_switch360209.y = 209;
            ui_Setup_button_switch360209.width = 334;
            ui_Setup_button_switch360209.height = 219;
            this.addQuiackChild(ui_Setup_button_switch360209);
            skilName = new TextField(256,52,'','',36,0xFFFFFF,false);
            skilName.touchable = false;
            skilName.hAlign= 'center';
            skilName.text= '技能名字';
            skilName.x = 96;
            skilName.y = 27;
            this.addQuiackChild(skilName);
            skillTypeTitle = new TextField(130,36,'','',24,0xFFFFFF,false);
            skillTypeTitle.touchable = false;
            skillTypeTitle.hAlign= 'left';
            skillTypeTitle.text= '技能类型：';
            skillTypeTitle.x = 171;
            skillTypeTitle.y = 105;
            this.addQuiackChild(skillTypeTitle);
            skillDesTitle = new TextField(116,41,'','',28,0xFFFFFF,false);
            skillDesTitle.touchable = false;
            skillDesTitle.hAlign= 'left';
            skillDesTitle.text= '描述：';
            skillDesTitle.x = 83;
            skillDesTitle.y = 218;
            this.addQuiackChild(skillDesTitle);
            skillType = new TextField(215,38,'','',24,0xFFFFFF,false);
            skillType.touchable = false;
            skillType.hAlign= 'left';
            skillType.text= '群体技能（觉醒）';
            skillType.x = 171;
            skillType.y = 147;
            this.addQuiackChild(skillType);
            skillDes = new TextField(296,149,'','',24,0xFFFFFF,false);
            skillDes.touchable = false;
            skillDes.hAlign= 'left';
            skillDes.text= '这是一个很牛逼的技能，你知道这个技能有多牛逼么？就是不告诉你，慢慢猜哈哈哈哈';
            skillDes.x = 84;
            skillDes.y = 262;
            this.addQuiackChild(skillDes);
            texture = assetMgr.getTexture('icon_skill_1')
            icon = new Image(texture);
            icon.x = 79;
            icon.y = 108;
            icon.width = 80;
            icon.height = 80;
            this.addQuiackChild(icon);
            icon.touchable = false;
            init();
        }
    }
}
