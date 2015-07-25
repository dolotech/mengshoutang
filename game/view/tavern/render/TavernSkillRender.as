package game.view.tavern.render
{
    import com.langue.Langue;

    import game.data.HeroData;
    import game.data.SkillData;
    import game.view.viewBase.TavernSkillBase;

    import starling.events.Event;

    public class TavernSkillRender extends TavernSkillBase
    {
        public function TavernSkillRender()
        {
            super();
            skillTitle.text=Langue.getLangue("heroSkill");
            bg.downState=null;
            bg.addEventListener(Event.TRIGGERED, onVisible);
        }

        private function onVisible(e:Event):void
        {
            this.visible=false;
        }

        public function set data(heroData:HeroData):void
        {

            if (!heroData)
            {
                this.visible=false;
                return;
            }

            if (heroData.skill1 > 0)
            {
                var skillData1:SkillData=SkillData.getSkill(heroData.skill1);
                skillName1.text=skillData1.name;
                skillName1.border=false;
                skillDetail1.text=skillData1.desc;
            }
            else
            {
                skillName1.text=skillDetail1.text=""
            }

            if (heroData.skill2 > 0)
            {
                var skillData2:SkillData=SkillData.getSkill(heroData.skill2);
                skillName2.text=skillData2.name;
                skillDetail2.text=skillData2.desc;
            }
            else
            {
                skillName2.text=skillDetail2.text=""
            }

            if (heroData.skill3 > 0)
            {
                var skillData3:SkillData=SkillData.getSkill(heroData.skill3);
                skillName3.text=skillData3.name;
                skillDetail3.text=skillData3.desc;
            }
            else
            {
                skillName3.text=skillDetail3.text=""
            }
        }
    }
}
