/**
 * Created by Administrator on 2014/6/20.
 */
package game.view.goodsGuide
{
	import com.utils.Assets;
	import com.utils.Constants;
	import com.utils.ObjectUtil;
	import com.utils.TouchProxy;
	
	import game.data.HeroData;
	import game.hero.AnimationCreator;
	import game.manager.AssetMgr;
	import game.view.hero.HeroShow;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	
	import treefortress.spriter.SpriterClip;

	public class ObtainHeroAnimation extends Sprite
	{
//    private var _backgroud:Image;
//    private var _front:Image;
		private var _mask : Image;
		private var _heroAvatar : HeroShow;
		private var _animatio : SpriterClip;
		private static var _instance : ObtainHeroAnimation;
		private var _touch : TouchProxy;

		private var _card : ObainHeroEffectBase;

		public function ObtainHeroAnimation()
		{

		}

		private function click(e : Object) : void
		{
			this.removeFromParent();
		}

		public function init(heroID : int) : void
		{
			var heroData : HeroData = HeroData.hero.getValue(heroID);

			if (!_mask)
			{
				_touch = new TouchProxy(this);
				_touch.onClick.add(click);

				_mask = Assets.getImage(Assets.Alpha_Backgroud);
				_mask.width = Constants.FullScreenWidth;
				_mask.height = Constants.FullScreenHeight;
				_mask.alpha = 0.75;
				_mask.touchable = true;
				addQuiackChild(_mask);

				_animatio = AnimationCreator.instance.create("effect_037", AssetMgr.instance);
				_animatio.play("effect_037");
				_animatio.animation.looping = true;
				Starling.juggler.add(_animatio);
				addQuiackChild(_animatio);
				ObjectUtil.setToCenter(_mask, _animatio)

				_animatio.x = _mask.x + _mask.width * 0.5;
				_animatio.y = _mask.y + _mask.height * 0.5;

//            _backgroud = new Image(AssetMgr.instance.getTexture("ui_denglu_jiaosekapai1"));
//            addQuiackChild(_backgroud);
//            ObjectUtil.setToCenter(_mask,_backgroud)

				_card = new ObainHeroEffectBase();
				addQuiackChild(_card);
				ObjectUtil.setToCenter(_mask, _card)

				_heroAvatar = new HeroShow();
				_heroAvatar.scaleX = _heroAvatar.scaleY = 1.2;
				_heroAvatar.x = _card.width * 0.5;
				_heroAvatar.y = _card.height * 0.5 + 50;

				_card.addQuiackChildAt(_heroAvatar, _card.getChildIndex(_card.front));
			}
			_heroAvatar.updateHero(heroData);
			_card.nameTxt.text = heroData.name;
			_card.profession.texture = AssetMgr.instance.getTexture("ui_gongyong_zheyetubiao" + heroData.job);
		}


		public static function add(heroID : int) : void
		{
			var heroData : HeroData = HeroData.hero.getValue(heroID);

			if (heroData == null)
				return;

			if (_instance == null)
				_instance = new ObtainHeroAnimation();

			_instance.init(heroID);
			Starling.current.stage.addChild(_instance);
		}


		public static function remove() : void
		{
			_instance && _instance.dispose();
			_instance = null;
		}

		override public function dispose() : void
		{
			removeFromParent();
			_heroAvatar && _heroAvatar.dispose();
			_animatio.dispose();
			Starling.juggler.remove(_animatio);
			super.dispose();


		}
	}
}
