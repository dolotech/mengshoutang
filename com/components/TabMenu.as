package com.components
{
	import starling.display.Sprite;
	import starling.events.Event;

	/**
	 * 标签菜单
	 * @author Michael
	 *
	 */
	public class TabMenu extends Sprite
	{
		private var _tabBtns : *;
		private var _selectedButton : TabButton;
		private var _selectedIndex : int;

		public function TabMenu(buttons : *)
		{
			tabBtns = buttons;
			addEventListener(Event.TRIGGERED, onClick);
		}

		public function get selectedIndex() : int
		{
			return _selectedIndex;
		}

		public function set selectedIndex(value : int) : void
		{
			_selectedIndex = value;
			var btn : TabButton = _tabBtns[_selectedIndex];
			setSelect(btn);
		}

		public function get tabBtns() : *
		{
			return _tabBtns;
		}

		/**
		 * 设置标签菜单的标签按钮
		 * @param value
		 *
		 */
		public function set tabBtns(value :*) : void
		{
			_tabBtns = value;

			if (_tabBtns == null)
			{
				return;
			}
			var len : int = _tabBtns.length;

			for (var i : int = 0; i < len; i++)
			{
				var button : TabButton = _tabBtns[i];

				if (button.parent == this)
					continue;

				if (i == 0)
				{
					this.x = button.x;
					this.y = button.y;
				}
				button.x = button.x - x;
				button.y = button.y - y;
				addChild(button);
			}
		}

		public function get selectedButton() : TabButton
		{
			return _selectedButton;
		}

		public function set selectedButton(value : TabButton) : void
		{
			setSelect(value);
		}


		private function onClick(e : Event) : void
		{
			if (!touchable)
			{
				return;
			}
			setSelect(e.target as TabButton);
		}

		private var isAutoClick : Boolean = false;

		private function setSelect(tabBtn : TabButton) : void
		{
			if (!isAutoClick)
			{
				if (_selectedButton == tabBtn)
				{
					return;
				}
			}

			if (_selectedButton)
			{
				_selectedButton.selected = false;
			}
			_selectedButton = tabBtn;
			_selectedIndex = _tabBtns.indexOf(_selectedButton);
			_selectedButton.selected = true;
			this.dispatchEventWith(Event.CHANGE, true);
		}

		public function registerAutoClick() : void
		{
			this.isAutoClick = true;
		}

	}
}
