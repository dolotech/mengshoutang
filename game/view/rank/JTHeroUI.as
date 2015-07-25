package game.view.rank
{
	import game.base.JTSprite;
	import game.common.JTLogger;
	import game.data.HeroData;
	import game.view.hero.HeroShow;

	import starling.display.Sprite;

	/**
	 * 英雄的UI形像
	 * @author Administrator
	 *
	 */
	public class JTHeroUI extends JTSprite
	{
		private var heroInfo:HeroData=null;
		private var animation:HeroShow=null;
		private static var _instance:JTHeroUI=null;

		public function JTHeroUI()
		{
			super();
			animation=new HeroShow();
			animation.scaleX=animation.scaleY=1.3;
			this.addChild(animation);
		}

		public function refreshAnimation(info:HeroData):void
		{
			if (!info)
			{
				JTLogger.error();
			}

			if (this.heroInfo == info)
			{
				return;
			}
			this.destory();
			this.heroInfo=info;
			animation.updateHero(info);
			animation.updataWeapon();
		}

		private function destory():void
		{
		}

		public static function show(parent:Sprite, info:HeroData, x:Number=559, y:Number=406):void
		{
			if (!_instance)
			{
				_instance=new JTHeroUI();
				_instance.x=x + 150;
				_instance.y=y + 280;
				parent.addChild(_instance);
			}
			_instance.refreshAnimation(info);
		}

		public static function getInstance():JTHeroUI
		{
			return _instance;
		}

		public static function instance(parent:Sprite, info:HeroData, x:Number=559, y:Number=406):JTHeroUI
		{
			var heroUI:JTHeroUI=new JTHeroUI();
			heroUI.refreshAnimation(info);
			heroUI.x=x;
			heroUI.y=y;
			parent.addChild(heroUI);
			return heroUI;
		}

		public static function hide():void
		{
			if (_instance)
			{
				_instance.removeFromParent();
				_instance.dispose();
				_instance=null;
			}
		}

		override public function dispose():void
		{
			super.dispose();
			this.destory();
			this.animation && animation.stop();
			this.heroInfo=null;
			this.animation=null;
		}
	}
}
