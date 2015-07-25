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

    public class TavernSkillBase extends Sprite
    {
        public var bg:Button;
        public var skillName1:TextField;
        public var skillDetail1:TextField;
        public var skillName2:TextField;
        public var skillName3:TextField;
        public var skillDetail3:TextField;
        public var skillDetail2:TextField;
        public var skillTitle:TextField;

        public function TavernSkillBase()
        {
            var texture:Texture;
            var textField:TextField;
            var input_txt:TextInput;
            var image:Image;
            var button:Button;
            var assetMgr:AssetMgr = AssetMgr.instance;
            texture = assetMgr.getTexture('ui_gongyong_heisetongmingding50');
            bg = new Button(texture);
            bg.name= 'bg';
            bg.width = 257;
            bg.height = 344;
            this.addQuiackChild(bg);
            skillName1 = new TextField(168,35,'','',24,0x00FF00,false);
            skillName1.touchable = false;
            skillName1.hAlign= 'left';
            skillName1.text= '剑刃风暴';
            skillName1.x = 11;
            skillName1.y = 38;
            this.addQuiackChild(skillName1);
            skillDetail1 = new TextField(245,63,'','',18,0xFFFFFF,false);
            skillDetail1.touchable = false;
            skillDetail1.hAlign= 'left';
            skillDetail1.text= '群体伤害，对附近所有敌人造成 大量伤害。';
            skillDetail1.x = 10;
            skillDetail1.y = 74;
            this.addQuiackChild(skillDetail1);
            skillName2 = new TextField(165,35,'','',24,0xFF00FF,false);
            skillName2.touchable = false;
            skillName2.hAlign= 'left';
            skillName2.text= '剑刃风暴';
            skillName2.x = 10;
            skillName2.y = 140;
            this.addQuiackChild(skillName2);
            skillName3 = new TextField(168,37,'','',24,0xFFFF00,false);
            skillName3.touchable = false;
            skillName3.hAlign= 'left';
            skillName3.text= '剑刃风暴';
            skillName3.x = 11;
            skillName3.y = 235;
            this.addQuiackChild(skillName3);
            skillDetail3 = new TextField(245,72,'','',18,0xFFFFFF,false);
            skillDetail3.touchable = false;
            skillDetail3.hAlign= 'left';
            skillDetail3.text= '群体伤害，对附近所有敌人造成 大量伤害。';
            skillDetail3.x = 10;
            skillDetail3.y = 272;
            this.addQuiackChild(skillDetail3);
            skillDetail2 = new TextField(245,58,'','',18,0xFFFFFF,false);
            skillDetail2.touchable = false;
            skillDetail2.hAlign= 'left';
            skillDetail2.text= '群体伤害，对附近所有敌人造成 大量伤害。';
            skillDetail2.x = 10;
            skillDetail2.y = 177;
            this.addQuiackChild(skillDetail2);
            skillTitle = new TextField(168,37,'','',28,0xFFFFCC,false);
            skillTitle.touchable = false;
            skillTitle.hAlign= 'center';
            skillTitle.text= '英雄技能';
            skillTitle.x = 52;
            this.addQuiackChild(skillTitle);
        }
        override public function dispose():void
        {
            bg.dispose();
            super.dispose();
        
}
    }
}
