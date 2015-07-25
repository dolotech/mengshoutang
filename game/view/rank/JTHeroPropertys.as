package game.view.rank
{
	import com.langue.Langue;
	
	import game.data.HeroData;
	import game.view.rank.ui.JTUIHeroPropertyBackground;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import com.utils.Constants;
	
	public class JTHeroPropertys extends JTUIHeroPropertyBackground
	{
		private static var instance:JTHeroPropertys = null;
		private var heroSkill:JTHeroSkillPanel = null;
		private var heroPropertys:JTheroDetailPanel = null;
		private var heroInfo:HeroData = null;
		public function JTHeroPropertys()
		{
			super();
			initialize();
		}
		
		private function initialize():void
		{
			var titles:Array = Langue.getLans("lookSkillorAtt");
			var lookSkills:String = titles[1];
			var lookPropertys:String = titles[0];
			this.heroSkill = new JTHeroSkillPanel();
			heroSkill.txt_title = lookSkills;
			this.heroPropertys = new JTheroDetailPanel();
			this.heroPropertys.txt_title = lookPropertys;
			this.heroPropertys.x = (this.width - this.heroPropertys.width) / 2;
			this.heroPropertys.y = 5 * Constants.scale;
			this.heroSkill.x = (this.width - this.heroSkill.width) / 2;;
			this.heroSkill.y = 14 * Constants.scale;
			this.addChild(heroPropertys);
			this.txt_titleTxt.text = this.heroPropertys.txt_title;
			this.lookButton.addEventListener(Event.TRIGGERED, onChangePanelHandler);
		}
		
		private function onChangePanelHandler(e:Event):void
		{
			if (this.contains(heroPropertys))
			{
				this.removeChild(this.heroPropertys);
				this.addChild(this.heroSkill); 
				this.heroSkill.show(this.heroInfo);
				this.txt_titleTxt.text = this.heroSkill.txt_title;
			}
			else
			{
				this.removeChild(this.heroSkill);
				this.addChild(this.heroPropertys);
				this.heroPropertys.show(this.heroInfo);
				this.txt_titleTxt.text = this.heroPropertys.txt_title;
			}
			e.stopImmediatePropagation();
		}
		
		public function refresh(heroInfo:HeroData):void
		{
			this.heroInfo = heroInfo;
			if (this.contains(heroPropertys))
			{
				this.heroPropertys.show(this.heroInfo);
			}
			else
			{
				this.heroSkill.show(this.heroInfo);
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			this.heroInfo = null;
			this.heroSkill = null;
			this.heroPropertys = null;
		}
		
		public static function show(parent:Sprite, heroInfo:HeroData):void
		{
			if (!instance)
			{
				instance = new JTHeroPropertys();
				instance.x = 451.5;
				instance.y = 80.8;
				parent.addChild(instance);
			}
			instance.refresh(heroInfo);
		}
		
		public static function hide():void
		{
			if (instance)
			{
				instance.removeFromParent();
				instance.dispose();
				instance = null;
			}
		}
	}
}
import com.langue.Langue;

import game.data.HeroData;
import game.data.SkillData;
import game.view.rank.ui.JTUIHeroProperty;
import game.view.rank.ui.JTUIHeroSkill;

import starling.text.TextField;

class JTHeroSkillPanel extends JTUIHeroSkill
{
	public var txt_title:String = null;
	public function JTHeroSkillPanel()
	{
		skillTitleTxt.text = Langue.getLangue("heroSkill");
	}
	
	public function show(heroInfo:HeroData):void
	{
		if(!heroInfo) 
		{
			return;
		}
		var i:int = 0;
		var l:int = 3;
		for (i = 0; i < l; i++)
		{
			var index:int = i + 1;
			var skill_ID:int = heroInfo["skill" + index];
			var skillInfo:SkillData = SkillData.getSkill(skill_ID);
			var txt_skill:TextField = this["skill" + index + "Txt"] as TextField;
			var txt_caption:TextField = this["caption" + index + "Txt"] as TextField;
			if (skill_ID > 0)
			{
				txt_skill.text = skillInfo.name;
				txt_caption.text = skillInfo.desc;
			}
			else
			{
				txt_skill.text = "";
				txt_caption.text = "";
			}
			if (index != l)
			{
				continue;
			}
//			if(skill2Txt.text == "" && caption2Txt.text == "")
//			{
//				skill2Txt.text = skillInfo.desc;
//				caption2Txt.text = skillInfo.name;
//				skill3Txt.text = "";
//				caption3Txt.text = "";
//			}
		}
	}
}

class JTheroDetailPanel extends JTUIHeroProperty
{
	public var txt_title:String = null;
	public function JTheroDetailPanel()
	{
		var arr:Array = Langue.getLans("ENCHANTING_TYPE");
		skillTitleTxt.text = Langue.getLangue("heroAtt");
		defenseTxt.text = arr[2] + ":";
		punctureTxt.text = arr[3] + ":";
		hitTxt.text = arr[4] + ":";
		duckTxt.text = arr[5] + ":";
		CritTxt.text = arr[6] + ":";
		StrongstormTxt.text = arr[7] + ":";
		freeBurstTxt.text = arr[8] + ":";
		toughnessTxt.text = arr[9] + ":";
	}
	
	public function show(heroInfo:HeroData):void
	{
		attackTxt.text = heroInfo.attack  + "";
		hpTxt.text = heroInfo.hp  + "";
		defenseValueTxt.text = heroInfo.defend  + "";
		punctureValueTxt.text = heroInfo.puncture  + "";
		hitValueTxt.text = heroInfo.hit + "";
		duckValueTxt.text = heroInfo.dodge   + "";
		CritValueTxt..text = heroInfo.crit  + "";
		StrongstormValulTxt.text = heroInfo.critPercentage  + "";
		freeBurstValueTxt.text = heroInfo.anitCrit   + "";
		toughnessValueTxt.text = heroInfo.toughness + "";
	}
}