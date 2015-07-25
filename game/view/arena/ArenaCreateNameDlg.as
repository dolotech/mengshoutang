package game.view.arena
{
	import com.langue.PlayerName;
	import com.langue.WordFilter;
	import com.utils.StringUtil;
	
	import feathers.controls.Scroller;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.TiledColumnsLayout;
	import feathers.layout.TiledRowsLayout;
	
	import game.data.GamePhotoData;
	import game.manager.GameMgr;
	import game.net.message.RoleInfomationMessage;
	import game.view.viewBase.ArenaCreateNameDlgBase;
	
	import starling.events.Event;

	/**
	 * 竞技场注册
	 * @author hyy
	 *
	 */
	public class ArenaCreateNameDlg extends ArenaCreateNameDlgBase
	{
		private var picture : int;

		public function ArenaCreateNameDlg()
		{
			super();
		}

		override protected function init() : void
		{
			enableTween = true;
			_closeButton = btn_close;
			const listLayout : TiledColumnsLayout = new TiledColumnsLayout();
			listLayout.useSquareTiles = false;
			listLayout.useVirtualLayout = true;
			listLayout.tileVerticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_TOP;
			listLayout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
			list_hero.layout = listLayout;
			list_hero.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			list_hero.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			list_hero.itemRendererFactory = itemRendererFactory;

			function itemRendererFactory() : IListItemRenderer
			{
				const renderer : ArenaCreateNameRender = new ArenaCreateNameRender();
				renderer.setSize(122, 122);
				return renderer;
			}

			curr_hero.picture = GameMgr.instance.picture; //人物头像
			txt_input.maxChars = 10;
			clickBackroundClose();
		}

		override protected function show() : void
		{
			setToCenter();
			updateList();
//			txt_input.setFocus();
		}

		override protected function addListenerHandler() : void
		{
			super.addListenerHandler();
			this.addViewListener(list_hero, Event.CHANGE, onListClick);
			this.addViewListener(btn_random, Event.TRIGGERED, onRandom);
			this.addViewListener(btn_ok, Event.TRIGGERED, onOkClick);
			this.addViewListener(txt_input, FeathersEventType.FOCUS_IN, onGetFocusIn);
		}

		/**
		 * 更新列表
		 *
		 */
		private function updateList() : void
		{
			list_hero.dataProvider = new ListCollection(GamePhotoData.hashMapPhoto.values());
			list_hero.selectedIndex = 0;
		}


		/**
		 * 头像选择
		 * @param evt
		 *
		 */
		private function onListClick(evt : Event) : void
		{
			curr_hero.data = list_hero.selectedItem;
			picture = curr_hero.picture;
//			onGetFocusIn();
		}

		/**
		 * 随机名字
		 *
		 */
		private function onRandom() : void
		{
			var random : int = Math.random() * 2 + 1;
			var randmName : String;

			if (random == 1)
				randmName = PlayerName.instance.getBoyName();
			else if (random == 2)
				randmName = PlayerName.instance.getGirlName();

			txt_input.text = randmName;
//			Starling.juggler.delayCall(onGetFocusIn, 0.1);
		}

		private function onGetFocusIn() : void
		{
			txt_input.selectRange(0, txt_input.text.length);
			txt_input.setFocus();
		}

		private function onOkClick() : void
		{
			var name : String = StringUtil.trim(txt_input.text);
			var font_count : int = StringUtil.charCount(name);

			if (font_count < 2)
			{
				addTips("nameShort");
				return;
			}

			else if (font_count > 6)
			{
				addTips("nameLong");
				return;
			}

			else if (WordFilter.instance.filter(name).indexOf("**") >= 0)
			{
				addTips("nameNoHarmonious");
				return;
			}
			RoleInfomationMessage.sendArenaRegister(name, picture);
		}
	}
}