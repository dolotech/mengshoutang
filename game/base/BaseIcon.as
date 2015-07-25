package game.base
{
	import com.components.RollTips;
	import com.dialog.DialogMgr;
	import com.langue.Langue;

	import game.data.Goods;
	import game.data.IconData;
	import game.manager.AssetMgr;
	import game.view.goodsGuide.EquipInfoDlg;

	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;

	/**
	 * 图标基本类
	 * @author Samuel
	 *
	 */
	public class BaseIcon extends Sprite
	{
		/**数据*/
		private var _data:IconData=null;
		/**图片资源管理*/
		private var _asset:AssetMgr=AssetMgr.instance;


		public var groundImage:Image=null;

		public var qualityImage:Image=null;
		public var qualityButton:Button=null;


		public var heroSignImage:Image=null;
		public var iconImage:Image=null;

		public var levelDiImage:Image=null;

		public var text_Num:TextField=null;
		public var text_Name:TextField=null;

		public function BaseIcon(value:IconData)
		{
			_data=value;
			super();
			initView();
		}

		/**生成视图*/
		protected function initView():void
		{
			if (data == null)
				return;

			//背景底图
			if (data.GroundTrue != "")
			{
				if (groundImage == null)
				{
					groundImage=new Image(_asset.getTexture(data.GroundTrue));
					groundImage.touchable=false;
					addQuiackChildAt(groundImage, 0);
				}
				else
				{
					groundImage.texture=_asset.getTexture(data.GroundTrue);
				}
			}
			else
			{
				groundImage && groundImage.removeFromParent(true);
				groundImage=null;
			}


			//物品图标
			if (data.IconTrue != "")
			{
				if (iconImage == null)
				{
					iconImage=new Image(_asset.getTexture(data.IconTrue));
					addQuiackChild(iconImage);
				}
				else
				{
					iconImage.texture=_asset.getTexture(data.IconTrue);
				}
			}
			else
			{
				iconImage && iconImage.removeFromParent(true);
				iconImage=null;
			}


			//物品背景品质框
			if (data.QualityTrue != "")
			{

				if (qualityButton == null)
				{
					qualityButton=new Button(_asset.getTexture(data.QualityTrue));
					addQuiackChild(qualityButton);
				}
				else
				{
					qualityButton.upState=_asset.getTexture(data.QualityTrue);
				}

				if (qualityImage == null)
				{
					qualityImage=new Image(_asset.getTexture(data.QualityTrue));
					addQuiackChild(qualityImage);
				}
				else
				{
					qualityImage.texture=_asset.getTexture(data.QualityTrue);
				}
				qualityButton.visible=data.ButtonModel;
				qualityImage.visible=!data.ButtonModel;

			}
			else
			{
				qualityButton && qualityButton.removeFromParent(true);
				qualityButton=null;
				qualityImage && qualityImage.removeFromParent(true);
				qualityImage=null;
			}

//            //物品或者英雄背景图
//            if (data.LevelTrue != "")
//            {
//                if (levelDiImage == null)
//                {
//                    levelDiImage=new Image(_asset.getTexture(data.LevelTrue));
//                    addQuiackChild(levelDiImage);
//                    levelDiImage.touchable=false;
//                }
//                else
//                {
//                    levelDiImage.texture=_asset.getTexture(data.LevelTrue);
//                }
//            }
//            else
//            {
//                levelDiImage && levelDiImage.removeFromParent(true);
//                levelDiImage=null;
//            }

			//英雄等级品质
			if (data.HeroSignTrue != "")
			{
				if (heroSignImage == null)
				{
					heroSignImage=new Image(_asset.getTexture(data.HeroSignTrue));
					addChild(heroSignImage);
					heroSignImage.touchable=false;
				}
				else
				{
					heroSignImage.texture=_asset.getTexture(data.HeroSignTrue);
				}
			}
			else
			{
				heroSignImage && heroSignImage.removeFromParent(true);
				heroSignImage=null;
			}

			//物品数量
			if (data.Num != "")
			{
				if (text_Num == null)
				{
					text_Num=new TextField(100, 30, '', '', 21, 0xE6E5D1, false);
					addQuiackChild(text_Num);
					text_Num.touchable=false;
					text_Num.hAlign='left';
					text_Num.text= data.Num.toString();
				}
				else
				{
					text_Num.text=data.Num.toString();
				}
			}

			//物品名字
			if (data.Name != "")
			{
				if (text_Name == null)
				{
					text_Name=new TextField(140, 30, '', '', 16, 0xE6E5D1, false);
					addQuiackChild(text_Name);
					text_Name.touchable=false;
					text_Name.hAlign='center';
					text_Name.text=data.Name;
				}
				else
				{
					text_Name.text=data.Name;
				}
			}


			if (data.ButtonModel)
			{
				this.touchable=true;
				this.addEventListener(TouchEvent.TOUCH, clickHandler);
			}
			else
			{
				this.touchable=false;
			}

			adjustUI();
		}


		/**调整UI*/
		private function adjustUI():void
		{

			if (iconImage)
			{
				iconImage.x=((qualityImage != null ? qualityImage.width : 90) - iconImage.width) >> 1;
				iconImage.y=((qualityImage != null ? qualityImage.height : 90) - iconImage.height) >> 1;
			}

			if (levelDiImage)
			{
				levelDiImage.x=1;
				levelDiImage.y=53;
				levelDiImage.width=91;
				levelDiImage.height=33;
			}

			if (heroSignImage)
			{
				heroSignImage.x=40;
				heroSignImage.y=38;
			}

			if (text_Num)
			{

				text_Num.x=3;
				if (iconImage)
					text_Num.y=iconImage.y + (iconImage.height - text_Num.height);
				else
					text_Num.y=60;
			}

			if (text_Name)
			{
				if (iconImage)
				{
					text_Name.x=iconImage.x + (iconImage.width - text_Name.width) >> 1;
					text_Name.y=iconImage.y + (iconImage.height - text_Name.height) + 27;
				}
				else
				{
					text_Name.x=-26;
					text_Name.y=86;
				}
			}

		}


		/**点击回调函数*/
		private function clickHandler(e:TouchEvent):void
		{

			var touch:Touch=e.getTouch(stage);
			if (touch == null)
				return;
			switch (touch.phase)
			{
				case TouchPhase.BEGAN:
					switch (data.IconType)
					{
						case 0: //物品
							var itemData:Goods=Goods.goods.getValue(data.IconId);
							itemData.isPack=false;
							DialogMgr.instance.open(EquipInfoDlg, itemData);
							break;
						case 1: //英雄
							RollTips.add(Langue.getLangue("HERO_PROPERTY_INFO"));
							break;
						default:
							break;
					}
					break;
			}


		}

		/**更新数据*/
		public function updata(value:IconData):void
		{
			if (value != null)
			{
				_data=value;
				initView();
			}
			else
			{
				removeIcon();
			}
		}

		/**移除图标*/
		private function removeIcon():void
		{
			while (this.numChildren > 0)
			{
				this.getChildAt(0).removeFromParent(true);
			}
		}

		/**获取图标数据*/
		public function get data():IconData
		{
			return _data;
		}

		/**释放销毁*/
		override public function dispose():void
		{
			removeIcon();
			super.dispose();
			_data=null;
			text_Num=null;
			text_Name=null;
			qualityButton=null;
			qualityImage=null;
			heroSignImage=null;
			iconImage=null;
			levelDiImage=null;

		}
	}
}

