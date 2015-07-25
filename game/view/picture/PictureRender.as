package game.view.picture
{


	import game.data.HeroData;
	import game.data.RoleShow;
	import game.data.Val;
	import game.manager.AssetMgr;
	import game.view.viewBase.PictureRenderBase;

	import starling.filters.ColorMatrixFilter;

	public class PictureRender extends PictureRenderBase
	{
		public function PictureRender()
		{
			super();
		}

		override public function set data(value : Object) : void
		{
			super.data = value;
			var heroData : HeroData = value as HeroData;

			if (heroData == null)
				return;
			txt_name.text = heroData.name;

			//人物头像
			ico_hero.upState = ico_hero.downState = AssetMgr.instance.getTexture((RoleShow.hash.getValue(heroData.show) as RoleShow).photo);
			tag.visible = heroData.isNew == 1;
			ico_no.visible = !heroData.isGet;
			ico_hero.filter = new ColorMatrixFilter(ico_no.visible ? Val.filter : null);
		}

		override public function set isSelected(value : Boolean) : void
		{
			super.isSelected = value;
		}
	}
}