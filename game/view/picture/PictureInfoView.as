package game.view.picture
{
	import com.langue.Langue;

	import game.data.HeroData;
	import game.data.RoleShow;
	import game.data.SkillData;
	import game.manager.AssetMgr;
	import game.view.viewBase.PictureInfoViewBase;

	import starling.utils.VAlign;
	import com.utils.Constants;


	/**
	 * 英雄详细信息
	 * @author hyy
	 *
	 */
	public class PictureInfoView extends PictureInfoViewBase
	{
		public var heroData : HeroData;

		public function PictureInfoView()
		{
			super();
		}

		override protected function init() : void
		{
			enableTween=true;
			//子对象不可点击
			setTouchState(this);
			this.touchable = true;
			scaleX = scaleY = Constants.scale;
            //点击关闭界面
			clickBackroundClose();
		}

		override protected function show() : void
		{
			setToCenter();
			udpateView();
		}

		private function udpateView() : void
		{
			if (heroData == null)
			{
				warn("图鉴缺少英雄数据", this);
				return;
			}
			ico_hero.upState = ico_hero.downState = AssetMgr.instance.getTexture((RoleShow.hash.getValue(heroData.show) as RoleShow).photo);
			txt_weapon.text = Langue.getLans("Equip_type")[heroData.weapon - 1];
			txt_name.text = heroData.name;
			txt_pos.text = Langue.getLans("hero_job")[heroData.job - 1];
			txt_born.text = heroData.get_type;
			txt_des.text = heroData.des;

			//星星级别
			for (var i : int = 1; i <= 5; i++)
			{
				this["stars" + i].visible = i <= heroData.get_hard;
			}

			//更新技能
			updateSkillText(heroData.skill1, 1);
			updateSkillText(heroData.skill2, 2);
			updateSkillText(heroData.skill3, 3);
		}

		private function updateSkillText(skillId : int, index : int) : void
		{
			var skillData : SkillData = SkillData.getSkill(skillId);
			this["txt_skill" + index].text = skillData ? skillData.desc : "";
			this["txt_skill" + index].vAlign = VAlign.TOP;
			this["txt_skillName" + index].text = skillData ? skillData.name : "";
		}

		override public function close() : void
		{
			this.removeFromParent();
			background.removeFromParent();
		}
	}
}