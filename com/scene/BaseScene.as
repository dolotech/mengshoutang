package com.scene
{
import com.utils.Assets;
import com.utils.Constants;
import com.view.View;

import game.hero.AnimationCreator;
import game.manager.AssetMgr;

import game.view.new2Guide.interfaces.INewGuideView;
	import game.view.viewGuide.interfaces.IViewGuideView;

import starling.animation.Transitions;

import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;

import treefortress.spriter.SpriterClip;

public class BaseScene extends View implements IScene, INewGuideView, IViewGuideView
	{
		public function BaseScene(isAutoInit : Boolean = true)
		{
			super(isAutoInit);
		}

		override protected function addToStageHandler(evt : Event) : void
		{
			super.addToStageHandler(evt);
		}

		public function set data(value : Object) : void
		{

		}

		public function get data() : Object
		{
			return null;
		}

		private var _mask : Quad;
		public function showSwap() : void
		{
//			_mask = Assets.getImage(Assets.Alpha_Backgroud);
//			_mask.width = Constants.FullScreenWidth / Constants.scale;
//			_mask.height = Constants.FullScreenHeight / Constants.scale;
////
//			addChild(_mask);
//			Starling.current.juggler.tween(_mask, 1, {alpha: 0, onComplete: onComplete,transition: Transitions.EASE_OUT_BACK});
////
//			function onComplete(obj:Object=null) : void
//			{
//				if (_mask.parent)
//                    _mask.parent.removeChild(_mask);
//				Starling.current.juggler.removeTweens(_mask);
//			}

            swapAnimation = AnimationCreator.instance.create("loadingzhouyou",AssetMgr.instance,true);
//            swapAnimation.animationComplete.addOnce(onComplete);
            swapAnimation.play("loadingzhouyou");



		}

        public var swapAnimation:SpriterClip;

		override public function dispose() : void
		{
			Starling.juggler.removeTweens(_mask);
			this.removeFromParent();
			super.dispose();
		}



		/**
		 * 新手引导
		 * @param name
		 * @return
		 *
		 */
		public function getGuideDisplay(name : String) : *
		{
			var tmp_names : Array = name.split(",");
			var len : int = tmp_names.length;

			var child : DisplayObject = this;

			for (var i : int = 0; i < len; i++)
			{
				child = child[tmp_names[i]];
			}

			if (child is Button)
			{
				Button(child).addEventListener(Event.TRIGGERED, onBtn_click);

				function onBtn_click() : void
				{
					Button(child).removeEventListener(Event.TRIGGERED, onBtn_click);
					guideBtnClick(child as Button);
				}
			}
			return child;
		}

		protected function guideBtnClick(btn : Button) : void
		{

		}

		public function executeGuideFun(name : String) : void
		{

		}

		public function getViewGuideDisplay(name : String) : *
		{

		}

		public function executeViewGuideFun(name : String) : void
		{

		}

	}
}