package game.view.goodsGuide.view
{
	import com.langue.Langue;
	import com.utils.ObjectUtil;
	import com.view.base.event.EventType;
	
	import flash.geom.Rectangle;
	
	import feathers.controls.Scroller;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.TiledColumnsLayout;
	import feathers.layout.TiledRowsLayout;
	
	import game.data.ForgeData;
	import game.data.Goods;
	import game.hero.AnimationCreator;
	import game.manager.AssetMgr;
	import game.manager.GameMgr;
	import game.net.data.IData;
	import game.net.data.s.SForge;
	import game.net.data.vo.forgeDoneIds;
	import game.net.message.EquipMessage;
	import game.view.goodsGuide.ObtainHeroAnimation;
	import game.view.goodsGuide.render.GoodsDropGuideRender;
	import game.view.viewBase.GoodsGuideForgeViewBase;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	
	import treefortress.spriter.SpriterClip;

	/**
	 * 合成界面
	 * @author hyy
	 *
	 */
	public class GoodsGuideForgeView extends GoodsGuideForgeViewBase
	{
		private var curr_forgeData : ForgeData;
		private var container : Sprite;

		public function GoodsGuideForgeView()
		{
			super();
			container = new Sprite();
			addChild(container);
			container.x = 18;
			container.y = 130;
			container.addChild(view_drop);
			view_drop.x = view_drop.y = 0;
			container.clipRect = new Rectangle(0, 0, 310, 300);
			grid.touchable = false;
			container.visible = false;
			
			const listLayout : TiledColumnsLayout = new TiledColumnsLayout();
			listLayout.useSquareTiles = false;
			listLayout.useVirtualLayout = true;
			listLayout.tileVerticalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_LEFT;
			listLayout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
			list_equip.layout = listLayout;
			list_equip.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			list_equip.itemRendererFactory = itemRendererFactory;
			
			function itemRendererFactory() : IListItemRenderer
			{
				const renderer : GoodsGuideGrid = new GoodsGuideGrid();
				renderer.scaleX = renderer.scaleY = 0.7;
				renderer.setSize(110, 130);
				return renderer;
			}
			
			const listdropLayout : TiledRowsLayout = new TiledRowsLayout();
			listdropLayout.useSquareTiles = false;
			listdropLayout.useVirtualLayout = true;
			listdropLayout.tileVerticalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_LEFT;
			listdropLayout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
			list_drop.layout = listdropLayout;
			list_drop.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			list_drop.itemRendererFactory = itemDropRendererFactory;
			
			function itemDropRendererFactory() : IListItemRenderer
			{
				const renderer : GoodsDropGuideRender = new GoodsDropGuideRender();
				renderer.setSize(286, 102);
				return renderer;
			}
		}

		public function set data(goods : Goods) : void
		{
			this.curr_forgeData = ForgeData.hash.getValue(goods.type);
			grid.data = goods;
			grid.txt_name.text = goods.name;
			if (goods.tab == 2 && goods.sort == 4)　{
				grid.txt_level.text = goods.level + Langue.getLangue("level"); //获取宝珠的等级
			} else {
				grid.txt_level.visible = "";
			}
			list_equip.dataProvider = new ListCollection(curr_forgeData.getForgeList());

			container.visible = false;
			btn_ok.visible = true;
			grid.visible = true;
			list_equip.y = 198;
		}

		override protected function addListenerHandler() : void
		{
			this.addViewListener(btn_ok, Event.TRIGGERED, onClick);
			this.addContextListener(EventType.NOTIFY_FORGE_EQUIP, onForgeNotify);
			this.addContextListener(EventType.SELECTED_GOODS_GUIDE, onChange);
			this.addContextListener(SForge.CMD + "", handleSForgeNotification);
		}


		public function handleSForgeNotification(event : Event, sforge : SForge) : void
		{
			var props : Vector.<IData> = sforge.ids;
			var len : int = props.length;

			for (var i : int = 0; i < len; ++i)
			{
				var forgeDoneData : forgeDoneIds = props[i] as forgeDoneIds;

				if (0 == forgeDoneData.type)
				{
					var animatio : SpriterClip = AnimationCreator.instance.create("effect_020", AssetMgr.instance);
					animatio.play("effect_020");
					animatio.animation.looping = false;
					Starling.juggler.add(animatio);
					ObjectUtil.setToCenter(grid, animatio);
					animatio.x = 180;
					animatio.y = 135;
					addQuiackChild(animatio);

					animatio.animationComplete.addOnce(function(sp : SpriterClip) : void
						{
							sp.stop();
							Starling.juggler.remove(sp);
							sp.dispose();
							ObtainHeroAnimation.add(forgeDoneData.id);
						})
				}
			}

		}


		/**
		 * 合成返回
		 *
		 */
		private function onForgeNotify() : void
		{
			list_equip.dataViewPort.dataProvider_refreshItemHandler();
		}

		private function onChange(evt : Event, render : GoodsGuideGrid) : void
		{
			var tag : DisplayObject = view_drop.getChildByName("tag");
			tag.x = render.x + render.width * .5 - tag.width * .5;
			var goods : Goods = render.data as Goods;
			list_drop.dataProvider = new ListCollection(goods.getDropLocationList());
			container.visible = true;

			if (!btn_ok.visible)
				return;
			btn_ok.visible = false;
			grid.visible = false;
			view_drop.y = 325;
			tween(list_equip, 0.2, {y: 40});
			tween(view_drop, 0.2, {y: 0});
		}

		private function onClick() : void
		{
			var tip_msg : String = getTipMsg();

			if (tip_msg != "")
			{
				addTips(tip_msg);
				return;
			}
			curr_forgeData.unEquip();
			EquipMessage.sendForgeGoods(curr_forgeData.id);
		}

		/**
		 * 获得提示信息
		 * @return
		 *
		 */
		public function getTipMsg() : String
		{
			if (!curr_forgeData)
				return getLangue("SELECTED_FORAGE_PROP");

			if (curr_forgeData.moneyTyep == 1 && GameMgr.instance.coin < curr_forgeData.price)
				return getLangue("notEnoughCoin");

			if (curr_forgeData.moneyTyep == 2 && GameMgr.instance.diamond < curr_forgeData.price)
				return getLangue("diamendNotEnough");

			if (!curr_forgeData.isCanForge)
				return getLangue("NOT_ENOUGH");
			return "";
		}

		override public function dispose() : void
		{
			ObtainHeroAnimation.remove();
			super.dispose();
			curr_forgeData = null;
		}
		
	}
}