package com.components
{
	import com.dialog.DialogMgr;
	import com.langue.Langue;
	import com.utils.Assets;
	import com.utils.Constants;
	import com.view.View;

	import game.common.JTFastBuyComponent;
	import game.data.MainLineData;
	import game.view.vip.VipDlg;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.text.TextField;

	/**
	 * 提醒信息
	 * @author yangyang
	 *
	 */
	public class RollTips extends View
	{
		private static var tips : RollTips;

		public static function addNoOpenInfo(id : int) : void
		{
			var main : MainLineData = MainLineData.getPoint(id);
			RollTips.add(Langue.getLangue("NoPvp").replace("*", "[" + main.pointName + "]"));
		}

		public static function add(info : String, color : int = 0xfaff7e) : RollTips
		{
			//钻石不足
			if (info == Langue.getLangue("diamendNotEnough"))
			{
				DialogMgr.instance.open(VipDlg, VipDlg.CHARGE);
			}
			else if (info.indexOf(Langue.getLangue("notEnoughCoin")) >= 0)
			{
				DialogMgr.instance.open(JTFastBuyComponent, JTFastBuyComponent.FAST_BUY_MONEY);
			}

			if (tips == null)
			{
				tips = new RollTips();
				tips.scaleX = tips.scaleY = Constants.scale;
			}
			tips.addInfo(info, color);
			return tips;
		}

		public static function addLangue(info : String, color : int = 0xfaff7e) : RollTips
		{
			var msg : String = Langue.getLangue(info);

			if (msg == null || msg == "")
				msg = info;
			return add(msg, color);
		}

		/**
		 *
		 * @param info 国际化关键key
		 * @param color 颜色
		 * @return
		 *
		 */
		public static function showTips(info : String, color : int = 0xfaff7e) : RollTips
		{
			if (tips == null)
			{
				tips = new RollTips();
				tips.scaleX = tips.scaleY = Constants.scale;
			}
			tips.addInfo(Langue.getLangue(info), color);
			return tips;
		}

		public function RollTips()
		{
			bg = Assets.getImage(Assets.RollTipsBG)
			txt_tips = new TextField(500, 68, '', 'myFont', 32, 0xffffff, false);
			txt_tips.autoScale = true;

			addChild(bg);
			addChild(txt_tips);
			setTouchState(this, false);
		}

		/**
		 * 文字停留时间
		 */
		public var delayTime : Number = 1.5;
		/**
		 * 文字位移
		 */
		public var distance : int = 20;
		public var txt_tips : TextField;
		private var bg : Image;

		public function addInfo(info : String, color : int = 0xfaff7e) : void
		{
			this.alpha = 0;
			txt_tips.text = info;
			txt_tips.color = color;


			bg.width = txt_tips.width;
			bg.height = txt_tips.height;
			this.x = 0.5 * (Constants.FullScreenWidth - this.width);
			this.y = 0.5 * (Constants.FullScreenHeight - this.height);

			Starling.juggler.removeTweens(this);
			Starling.juggler.tween(this, 0.2, {y: this.y - distance, alpha: 1, onComplete: onComplete});
			Starling.current.stage.addChild(this);
		}

		private function onComplete() : void
		{
			Starling.juggler.tween(this, 0.3, {alpha: 0, delay: delayTime, onComplete: onfinish});
		}

		private function onfinish() : void
		{
			this.removeFromParent();
		}

		override public function dispose() : void
		{
			txt_tips.dispose();
			bg.dispose();
			super.dispose();
		}

	}
}