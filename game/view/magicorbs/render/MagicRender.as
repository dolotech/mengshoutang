package game.view.magicorbs.render
{
	import com.utils.TouchProxy;
	import com.view.base.event.EventType;

	import feathers.controls.renderers.DefaultListItemRenderer;

	import game.data.Goods;
	import game.hero.AnimationCreator;
	import game.manager.AssetMgr;
	import game.view.magicorbs.data.GetMagicOrbs;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.text.TextField;
	import starling.textures.Texture;

	import treefortress.spriter.SpriterClip;

	public class MagicRender extends DefaultListItemRenderer
	{
		private var _quality:Image;
		private var _quaDi:Image;
		private var _picture:Image;
		private var _txtImage:Image;
		private var _background:Image;
		private var txt_Number:TextField;
		private var _selectedImage:Image;
		private var _rockTween:RockTween;
		private var _lock:Image;

		private var sprite:Sprite;
		private var getMagicOrbs:GetMagicOrbs;

		public function MagicRender()
		{
			super();
			setSize(90, 90);

			var touch:TouchProxy=new TouchProxy(this);
			touch.onClick.add(selected);

			sprite=new Sprite();
			addChild(sprite);
		}

		private function selected(e:Touch):void
		{
			if (owner)
			{
				owner.dispatchEventWith(Event.SELECT, false, data);
				if (data)
				{
					getMagicOrbs=data as GetMagicOrbs;
					if (getMagicOrbs && getMagicOrbs.type == 0 && getMagicOrbs.gridLock)
					{
						owner.dispatchEventWith(Event.TRIGGERED, false, data);
					}
				}
			}
		}

		override public function set data(value:Object):void
		{
//            if(data)
//            {
//                if(value)
//                {
//                    var getMagicOrbs:GetMagicOrbs = value as GetMagicOrbs;
//                    if(data.gridLock == getMagicOrbs.gridLock
//                    && data.selected == getMagicOrbs.selected
//                    && data.rock == getMagicOrbs.rock
//                    && data.animation == getMagicOrbs.animation
//                    && data.pile == getMagicOrbs.pile)
//                    {
//                        super.data = value;
//                        return;
//                    }
//                }
//            }
			super.data=value;

			getMagicOrbs=value as GetMagicOrbs;
			_picture && _picture.removeFromParent();
			_quality && _quality.removeFromParent();
			_background && _background.removeFromParent();
			_quaDi && _quaDi.removeFromParent();
			_txtImage && _txtImage.removeFromParent();
			txt_Number && txt_Number.removeFromParent();
			_rockTween && _rockTween.stop();
			sprite.x=sprite.y=0;
			sprite.touchable=true;
			_lock && _lock.removeFromParent();

			if (getMagicOrbs && getMagicOrbs.type > 0)
			{
				var goods:Goods=Goods.goods.getValue(getMagicOrbs.type);
				var texture:Texture=AssetMgr.instance.getTexture("ui_gongyong_90wupingkuang" + (goods.quality - 1)); //背景框品质颜色
				var textureQ:Texture=AssetMgr.instance.getTexture("ui_gongyong_90wupingkuang");
//                var textureDi:Texture = AssetMgr.instance.getTexture("ui_gongyong_dengjitouming_di");

				if (!_quality)
				{
					_quality=new Image(texture);
				}
				else
				{
					_quality.texture=texture;
				}
				sprite.addQuiackChild(_quality);

				texture=AssetMgr.instance.getTexture(goods.picture);
				if (!_picture)
				{
					_quaDi=new Image(textureQ);
					_picture=new Image(texture);
//					_txtImage=new Image(textureDi);

				}
				else
				{
					_quaDi.texture=textureQ;
					_picture.texture=texture;
//					_txtImage.texture=textureDi;
				}
				sprite.addQuiackChildAt(_quaDi, 0);
				sprite.addQuiackChild(_picture);
//				sprite.addQuiackChild(_txtImage);
//				_txtImage.x=_picture.x + 35;
//				_txtImage.y=_picture.y + 50;

				updatePile(getMagicOrbs.level);

				if (getMagicOrbs && getMagicOrbs.rock)
				{
					if (!_rockTween)
					{
						_rockTween=new RockTween(sprite, false);
					}

					if (getMagicOrbs.rock)
					{
						_rockTween.rightRotation();
					}
					else
					{
						_rockTween.stop();
						sprite.x=sprite.y=0;
					}
				}
			}
			else if (getMagicOrbs && getMagicOrbs.type == 0 && getMagicOrbs.gridLock)
			{
				if (!_lock)
				{
					_lock=new Image(AssetMgr.instance.getTexture("ui_beibao_beibaoshangsuozhuangtai")); //锁

				}
				sprite.addQuiackChild(_lock);
			}
			else
			{
				texture=AssetMgr.instance.getTexture("ui_gongyong_90wupingkuang");
				if (!_background)
				{
					_background=new Image(texture);
				}
				else
				{
					_background.texture=texture;
				}
				sprite.addQuiackChild(_background);
				sprite.touchable=false;
			}

			if (getMagicOrbs && getMagicOrbs.animation && getMagicOrbs.type > 0)
			{
				initPlayerEffect(); // 获得宝珠上的特效
				getMagicOrbs.animation=false;
			}

			if (getMagicOrbs && getMagicOrbs.selected)
			{
				if (!_selectedImage)
				{
					_selectedImage=new Image(AssetMgr.instance.getTexture("ui_gongyong_kexuanzhuangtai")); // 钩
				}
				sprite.addQuiackChild(_selectedImage);
				_selectedImage.x=5;
				_selectedImage.y=5;
			}
			else
			{
				if (_selectedImage)
				{
					_selectedImage.removeFromParent();
				}
			}
		}

		private function updatePile(value:int):void
		{
			//宝珠堆叠数
//			if (!txt_Number && value > 0)
//			{
//				txt_Number = new TextField(50, 25, '', '', 20, 0xffffff, false);
//			}
//			
//			if(value > 0)
//			{
//				sprite.addQuiackChild(txt_Number);
//				txt_Number.touchable = false;
//				txt_Number.hAlign = 'center';
//				txt_Number.x = _quality.x + 40;
//				txt_Number.y = _quality.y + _quality.height - 29;
//				txt_Number.text = "x" + value;
//			}
//			else
//			{
//				txt_Number && txt_Number.removeFromParent();
//			}

			//宝珠等级
			if (!txt_Number && value > 0)
			{
				txt_Number=new TextField(50, 25, '', '', 20, 0xffffff, false);
			}

			if (value > 0)
			{
				sprite.addQuiackChild(txt_Number);
				txt_Number.touchable=false;
				txt_Number.hAlign='center';
				txt_Number.x=_quality.x + 35;
				txt_Number.y=_quality.y + _quality.height - 35;
				txt_Number.text="Lv " + value;
			}
			else
			{
				txt_Number && txt_Number.removeFromParent();
			}
		}

		// 获得宝珠时的特效
		private function initPlayerEffect():void
		{
			// 这是获得的宝珠在背包上的效果
			var _action:SpriterClip=AnimationCreator.instance.create("effect_025", AssetMgr.instance, true);
			_action.x=_picture.width >> 1;
			_action.y=_picture.width >> 1;
			_action.play("effect_025");
			addQuiackChild(_action);
		}

		private var selectIco:SpriterClip;

		override public function set isSelected(value:Boolean):void
		{
			super.isSelected=value;
			if (value)
			{
				if (!selectIco)
				{
					selectIco=AnimationCreator.instance.create("effect_012", AssetMgr.instance);
				}

				if (!selectIco.parent && getMagicOrbs.type > 0)
				{
					selectIco.play("effect_012");
					selectIco.animation.looping=true;
					Starling.juggler.add(selectIco);
					selectIco.x=_picture.width >> 1;
					selectIco.y=_picture.height >> 1;
					addChild(selectIco);
					selectIco.touchable=false;
				}
				owner && owner.dispatchEventWith(EventType.SELECTED_DEFAULT, false, data);
			}
			else
			{
				if (selectIco)
				{
					//if(owner && owner.selectedItem != data)
					{
						selectIco.stop();
						Starling.juggler.remove(selectIco);
						selectIco.removeFromParent();
					}
				}
			}
		}

		override public function dispose():void
		{
			_quality=null;
			_picture=null;
			_txtImage=null;
			_background=null;
			txt_Number=null;
			_selectedImage=null;
			_rockTween=null;
			_lock=null;

			sprite=null;
			getMagicOrbs=null;

			super.dispose();
		}
	}
}
