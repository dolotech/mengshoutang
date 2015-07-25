package game.uils
{
	import flash.text.TextFormat;

	import feathers.controls.ScrollText;
	import feathers.controls.TextInput;
	import feathers.events.FeathersEventType;

	import game.data.Goods;
	import game.data.HeroData;
	import game.net.data.c.CChatSend;
	import game.view.viewBase.GmViewBase;

	import starling.display.Sprite;
	import starling.events.Event;

	/**
	 * 后台管理工具
	 * @author hyy
	 *
	 */
	public class GmView extends GmViewBase
	{
		private var scrollBar : ScrollText;
		private var input_filter : TextInput;
		private var input_num : TextInput;
		private var input_type : TextInput;
		private var input_quality : TextInput;
		private var filter : String = "";
		private var excuteFun : Function;

		public function GmView()
		{
			super();
		}

		override protected function init() : void
		{
			scrollBar = new ScrollText();
			scrollBar.x = info.x;
			scrollBar.y = info.y;
			scrollBar.width = info.width;
			scrollBar.height = info.height;

			var textFormat : TextFormat = new TextFormat(info.fontName, info.fontSize, info.color);
			scrollBar.textFormat = textFormat;
			addChild(scrollBar);

			clickBackroundClose();
			input_num = view_num.getChildByName("txt_input") as TextInput;
			input_type = view_type.getChildByName("txt_input") as TextInput;
			input_quality = view_quality.getChildByName("txt_input") as TextInput;
			input_filter = txt_filter;
			input_num.restrict = input_type.restrict = "0-9";
			input_num.maxChars = input_type.maxChars = 9;
			input_quality.maxChars = 1;
			input_quality.restrict = "1-7";
			btn_ok.visible = view_type.visible = view_quality.visible = view_num.visible = false;
		}


		override protected function show() : void
		{
			setToCenter();
		}

		override protected function addListenerHandler() : void
		{
			super.addListenerHandler();
			this.addViewListener(btn_lookgoods, Event.TRIGGERED, onLookGoods);
			this.addViewListener(btn_lookHero, Event.TRIGGERED, onLookHero);
			this.addViewListener(btn_lookEquip, Event.TRIGGERED, onLookEquip);
			this.addViewListener(btn_lookGem, Event.TRIGGERED, onLookGem);
			this.addViewListener(btn_lookjingjie, Event.TRIGGERED, onLookJingjie);
			this.addViewListener(btn_lookstrengthen, Event.TRIGGERED, onLookStrengthen);
			this.addViewListener(btn_ok, Event.TRIGGERED, onSendMsg);
			this.addViewListener(tabMenu_hero, Event.CHANGE, onClick);
			this.addViewListener(input_type, FeathersEventType.FOCUS_IN, onFocusIn);
			this.addViewListener(input_quality, FeathersEventType.FOCUS_IN, onFocusIn);
			this.addViewListener(input_num, FeathersEventType.FOCUS_IN, onFocusIn);
			this.addViewListener(input_filter, Event.CHANGE, onFilterChange);
		}

		private function onFilterChange() : void
		{
			filter = input_filter.text;
			excuteFun && excuteFun();
		}

		private function onFocusIn(event : Event) : void
		{
			var text : TextInput = event.currentTarget as TextInput;
			text.text = "";
		}

		private function onClick(event : Event) : void
		{
			var msg : String = "";
			var id : int = int(input_type.text);
			var quality : int = int(input_quality.text);
			var num : int = int(input_num.text);
			var setInput : Sprite;
			view_type.visible = view_quality.visible = view_num.visible = false;

			switch (tabMenu_hero.selectedButton)
			{
				//加经验
				case tab_exp:
					setInput = view_num;
					break;
				//加金币
				case tab_money:
					setInput = view_num;
					break;
				//加钻石
				case tab_diamond:
					setInput = view_num;
					break;
				//设置当前关卡
				case tab_guan:
					setInput = view_num;
					break;
				//加疲劳
				case tab_tired:
					setInput = view_num;
					break;
				//送物品
				case tab_goods:
					setInput = view_type;
					view_num.visible = true;
					input_num.text = "";
					break;
				//英雄
				case tab_hero:
					setInput = view_type;
					view_quality.visible = true;
					input_quality.text = "1";
					break;
				//vip
				case tab_vip:
					setInput = view_num;
					break;
                default :
                    break;
			}

			if (setInput)
			{
				setInput.visible = true;
				var txt : TextInput = setInput.getChildByName("txt_input") as TextInput;
				txt.text = "";
				txt.setFocus();
				btn_ok.visible = true;
			}
		}

		/**
		 * 查询英雄
		 *
		 */
		private function onLookHero() : void
		{
			excuteFun = onLookHero;
			var str : String = "";
			var index : int = 0;
			HeroData.hero.eachValue(fun);
			function fun(hero : HeroData) : void
			{
				str += changeName(hero.name, 8) + hero.type + " ";

				if (filter != "" && hero.name.indexOf(filter) == -1)
					return;
				
				if (++index % 3 == 0)
					str += "\n";
			}
			scrollBar.text = str;
		}

		/**
		 * 查询材料
		 *
		 */
		private function onLookGoods() : void
		{
			excuteFun = onLookGoods;
			findGoods(8, 3, 1)
		}

		/**
		 * 查看强化石
		 *
		 */
		private function onLookStrengthen() : void
		{
			excuteFun = onLookStrengthen;
			findGoods(8, 3, 2, 1)
		}

		/**
		 * 查看宝珠
		 *
		 */
		private function onLookGem() : void
		{
			excuteFun = onLookGem;
			findGoods(8, 3, 2, 4);
		}

		/**
		 * 查看净化石
		 *
		 */
		private function onLookJingjie() : void
		{
			excuteFun = onLookJingjie;
			findGoods(8, 3, 2, 6);
		}

		/**
		 * 查看装备
		 *
		 */
		private function onLookEquip() : void
		{
			excuteFun = onLookEquip;
			findGoods(6, 3, 5, -1, 8);
		}

		private function findGoods(nameLen : int = 5, num : int = 3, tab : int = -1, sort : int = -1, typeLen : int = -1) : void
		{
			var text : String = "";
			var index : int = 0;
			Goods.goods.eachValue(fun);

			function fun(goods : Goods) : void
			{
				if (tab > 0 && goods.tab != tab)
					return;

				if (sort > 0 && goods.sort != sort)
					return;

				if (filter != "" && goods.name.indexOf(filter) == -1)
					return;
				text += changeName(goods.name, nameLen) + "  " + (typeLen > 0 ? changeType(goods.type + "", typeLen) : goods.type) + "     ";

				if (++index % num == 0)
					text += "\n";
			}
			scrollBar.text = text;
		}

		private function changeName(name : String, num : int) : String
		{
			var len : int = name.length;

			for (var i : int = len; i < num; i++)
			{
				name += "    ";
			}
			return name;
		}

		private function changeType(name : String, num : int) : String
		{
			var len : int = name.length;

			for (var i : int = len; i < num; i++)
			{
				name += " ";
			}
			return name;
		}

		private function sendMsg(message : String) : void
		{
			var cmd : CChatSend = new CChatSend();
			cmd.content = message;
			cmd.type = 1;
			sendMessage(cmd);
		}

		private function onSendMsg() : void
		{
			var msg : String = "";
			var id : int = int(input_type.text);
			var quality : int = int(input_quality.text);
			var num : int = int(input_num.text);

			if (view_quality.visible && quality == 0)
			{
				addTips("请输入品质!");
				return;
			}

			if (view_num.visible && num == 0)
			{
				addTips("请输入数量!");
				return;
			}

			switch (tabMenu_hero.selectedButton)
			{
				//加经验
				case tab_exp:
					msg += "#exp " + num;
					break;
				//加金币
				case tab_money:
					msg += "#gold " + num;
					break;
				//加钻石
				case tab_diamond:
					msg += "#diamond " + num;
					break;
				//设置当前关卡
				case tab_guan:
					msg += "#tollgate " + num;
					break;
				//加疲劳
				case tab_tired:
					msg += "#power " + num;
					break;
				//送物品
				case tab_goods:
					if (Goods.goods.getValue(id) == null)
					{
						addTips("没有此物品");
						return;
					}
					msg += "#item " + id + " " + num;
					break;
				//英雄
				case tab_hero:
					if (HeroData.hero.getValue(id) == null)
					{
						addTips("没有此英雄");
						return;
					}
					msg += "#hero " + id + " " + quality;
					break;
				//vip
				case tab_vip:
					msg += "#vip " + num;
					break;
                default :
                    break;
			}
			scrollBar.text = msg + "发送成功\n" + scrollBar.text;
			sendMsg(msg);
		}
	}
}