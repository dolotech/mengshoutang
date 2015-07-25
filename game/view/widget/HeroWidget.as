package game.view.widget
{
	import game.data.HeroData;
	import game.data.RoleShow;
	import game.manager.AssetMgr;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.TouchEvent;
	import starling.textures.Texture;

	/**
	 * 英雄图标
	 * @author Administrator
	 */
	public class HeroWidget extends Widget
	{
		/**
		 *
		 * @param data
		 * @param dragable
		 * @param tips
		 */
		public function HeroWidget(data:HeroData=null, dragable:Boolean=true)
		{
			setHeroData(data, dragable);
		}

		private var level:Sprite;
		private var pinzhi:Image;
		private var _photo:Image;
		private var _bg:Image;

		private var _heroData:HeroData;

		/**
		 *
		 * @return
		 */
		public function get heroData():HeroData
		{
			return _heroData;
		}

		override public function dispose():void
		{
			super.dispose();
		}

		public function setHeroData(heroData:HeroData, dragable:Boolean=true):void
		{
			_heroData=heroData;
			_bg && _bg.removeFromParent();
			if (_heroData)
			{
				var texture:Texture=AssetMgr.instance.getTexture("ui_gongyong_100yingxiongkuang_" + (heroData.quality - 1));
				if (!_bg) //替换人物框皮肤，如果品质为567
				{
					_bg=new Image(texture);

				}
				else
				{
					if (texture != _bg.texture)
						_bg.texture=texture;
				}

				addChild(_bg);

				var roleShow:RoleShow=RoleShow.hash.getValue(heroData.show) as RoleShow;
				this.texture=AssetMgr.instance.getTexture("" + roleShow.photo);
				if (!_photo)
				{
					_photo=new Image(this.texture);
					addChild(_photo);
				}
				else
				{
					_photo.texture=this.texture;
				}

//            level && level.removeFromParent(true);
//            level = GraphicsNumber.instance().getNumber(_heroData.level + 1, "ui_shuzi_");
//            level.touchable = false;
//            addChild(level);
//            level.x = _photo.x;
//            level.y = _photo.y;

				if (pinzhi)
				{
					pinzhi.texture=AssetMgr.instance.getTexture("ui_hero_yingxiongpinzhi_0" + (7 - _heroData.quality + 1));
				}
				else
				{
					pinzhi=new Image(AssetMgr.instance.getTexture("ui_hero_yingxiongpinzhi_0" + (7 - _heroData.quality + 1)));
					pinzhi.touchable=false;
					addChild(pinzhi);
					pinzhi.x=level.x + _photo.width - pinzhi.width;
					pinzhi.y=level.y + _photo.height - pinzhi.height;
				}


				if (dragable)
				{
					this.addEventListener(TouchEvent.TOUCH, onRenderTouchedHandler);
				}
			}
		}

	}
}
