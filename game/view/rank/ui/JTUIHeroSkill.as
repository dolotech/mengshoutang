package game.view.rank.ui
{
    import game.base.JTSprite;
    
    import starling.text.TextField;

    public class JTUIHeroSkill extends JTSprite
    {
        public var skill1Txt:TextField;
        public var skill2Txt:TextField;
        public var skill3Txt:TextField;
        public var caption1Txt:TextField;
        public var caption2Txt:TextField;
        public var caption3Txt:TextField;
        public var skillTitleTxt:TextField;

        public function JTUIHeroSkill()
        {
            skill1Txt = new TextField(200,35,'','',18,0xFF0000,false);
            skill1Txt.touchable = false;
            skill1Txt.hAlign = 'left';
            skill1Txt.x = 0;
              skill1Txt.y = 48;
            this.addQuiackChild(skill1Txt);
            skill2Txt = new TextField(200,35,'','',18,0x0066FF,false);
            skill2Txt.touchable = false;
            skill2Txt.hAlign = 'left';
            skill2Txt.x = 0;
              skill2Txt.y = 117;
            this.addQuiackChild(skill2Txt);
            skill3Txt = new TextField(200,35,'','',18,0x9900FF,false);
            skill3Txt.touchable = false;
            skill3Txt.hAlign = 'left';
            skill3Txt.x = 0;
              skill3Txt.y = 188;
            this.addQuiackChild(skill3Txt);
            caption1Txt = new TextField(225,60,'','',16,0x1A1A1A,false);
            caption1Txt.touchable = false;
            caption1Txt.hAlign = 'left';
            caption1Txt.x = 0;
              caption1Txt.y = 72;
            this.addQuiackChild(caption1Txt);
            caption2Txt = new TextField(225,60,'','',16,0x1A1A1A,false);
            caption2Txt.touchable = false;
            caption2Txt.hAlign = 'left';
            caption2Txt.x = 0;
              caption2Txt.y = 144;
            this.addQuiackChild(caption2Txt);
            caption3Txt = new TextField(225,60,'','',16,0x1A1A1A,false);
            caption3Txt.touchable = false;
            caption3Txt.hAlign = 'left';
            caption3Txt.x = 0;
              caption3Txt.y = 210;
            this.addQuiackChild(caption3Txt);
            skillTitleTxt = new TextField(151,37,'','',35,0x593F1F,false);
            skillTitleTxt.touchable = false;
            skillTitleTxt.hAlign = 'center';
            skillTitleTxt.x = 45;
              skillTitleTxt.y = 0;
            this.addQuiackChild(skillTitleTxt);

        }

    }
}