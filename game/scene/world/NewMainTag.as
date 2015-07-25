package game.scene.world
{
	import com.components.RollTips;
	import com.langue.Langue;
	import com.view.base.event.EventType;
	import com.view.base.event.ViewDispatcher;

	import game.data.MainLineData;
	import game.data.TollgateData;
	import game.hero.AnimationCreator;
	import game.manager.AssetMgr;
	import game.manager.GameMgr;

	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;

	import treefortress.spriter.SpriterClip;

	public class NewMainTag extends Sprite
	{
		private static const boss_type:Array=["", "ui_zhuxian_wenhao", "ui_zhuxian_boss_wenhao", "ui_zhuxian_bigboss_wenhao"]
		private static const boss_animation:Array=["", "effect_031_xiao", "effect_031_zhong", "effect_031_da"]
		public static var select_effect:SpriterClip;
		public var button:Button;
		private var data:MainLineData;
		private var star_list:Array=[];
		public var isOpen:Boolean;
		public var isPass:Boolean;

		public function NewMainTag(data:MainLineData, button:Button)
		{
			this.data=data;
			this.button=button;
			super();
			init();
			addListenerHandler();
		}

		protected function init():void
		{
			if (data.boss_type > 1)
			{
				var star_img:Image;
				var tmp_pos:Array=[-50, 0, 50];
				var tmp_height:int=button.height;

				for (var i:int=0; i < 3; i++)
				{
					star_img=new Image(AssetMgr.instance.getTexture("ui_fright_star"))
					star_list.push(star_img);
					star_img.y=i % 2 == 1 ? tmp_height : tmp_height - 20;
					star_img.scaleX=star_img.scaleY=(data.boss_type == 2 ? 0.3 : 0.4);
					star_img.x=button.width * .5 - star_img.width * .5 + tmp_pos[i];
					addChild(star_img);
				}
			}

			updateView();
		}

		protected function addListenerHandler():void
		{
			button.removeEventListeners(Event.TRIGGERED);
			button.addEventListener(Event.TRIGGERED, onClick);
			ViewDispatcher.instance.addEventListener(EventType.UPDATE_MAINLINE_STAR, onUpdateStar);
		}

		private function updateView():void
		{
			isOpen=data.pointID <= GameMgr.instance.tollgateID;

			if (data.id < 1000 && data.boss_type == 1 && GameMgr.instance.tollgateID > data.pointID)
				isPass=true;
			visible=data.pointID <= GameMgr.instance.tollgateID + 1;
			button.upState=AssetMgr.instance.getTexture(isOpen ? data.points_ico : (data.id > 1000 ? (data.points_ico + "_off") : boss_type[data.boss_type]));
			x=button.x;
			y=button.y;
			onUpdateStar();
		}

		private function onUpdateStar():void
		{
			if (data.boss_type > 1)
			{
				var tollgateData:TollgateData=data.tollgateData;

				for (var i:int=0; i < 3; i++)
				{
					star_list[i].visible=data.boss_type == 3 && isOpen && !isPass;

					if (tollgateData)
						star_list[i].texture=AssetMgr.instance.getTexture("ui_fright_star" + ((tollgateData.nightmare_star & Math.pow(2, i)) == 0 ? "1" : ""));
				}
			}
		}

		private function onClick(evt:Event):void
		{
			var lastPoint:MainLineData=MainLineData.getPoint(data.pointID - 1);
			!isOpen && RollTips.addLangue(Langue.getLangue("onOpen") + (lastPoint ? lastPoint.pointName : ""));
			isPass && RollTips.addLangue("onPass");
			selected=true;
		}

		public function set selected(value:Boolean):void
		{
			if (!value || !isOpen || isPass)
				return;

			if (select_effect == null)
				select_effect=AnimationCreator.instance.create("effect_031", AssetMgr.instance);
			select_effect.play(boss_animation[data.boss_type])
			select_effect.animation.looping=true;
			select_effect.x=button.x + button.width * .5;
			select_effect.y=button.y + button.height * .5;
			button.parent.addChildAt(select_effect, button.parent.getChildIndex(button) - 1);
			ViewDispatcher.dispatch(EventType.SELECTED_MAINLINE, TollgateData.hash.getValue(button.name.replace("tag_", "")));
		}

		override public function dispose():void
		{
			button && button.removeEventListener(Event.TRIGGERED, onClick);
			ViewDispatcher.instance.removeEventListener(EventType.UPDATE_MAINLINE_STAR, onUpdateStar);
			select_effect && select_effect.removeFromParent();
			super.dispose();
		}
	}
}
