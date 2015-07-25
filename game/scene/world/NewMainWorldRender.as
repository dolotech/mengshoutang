package game.scene.world
{
	import com.view.Clickable;
	import com.view.base.event.EventType;
	import com.view.base.event.ViewDispatcher;

	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;

	import feathers.controls.renderers.DefaultListItemRenderer;

	import game.data.MainLineData;
	import game.hero.AnimationCreator;
	import game.manager.AssetMgr;
	import game.manager.GameMgr;
	import game.view.viewBase.map_world_0Base;
	import game.view.viewBase.map_world_1000Base;
	import game.view.viewBase.map_world_10Base;
	import game.view.viewBase.map_world_11Base;
	import game.view.viewBase.map_world_1Base;
	import game.view.viewBase.map_world_2Base;
	import game.view.viewBase.map_world_3Base;
	import game.view.viewBase.map_world_4Base;
	import game.view.viewBase.map_world_5Base;
	import game.view.viewBase.map_world_6Base;
	import game.view.viewBase.map_world_7Base;
	import game.view.viewBase.map_world_8Base;
	import game.view.viewBase.map_world_9Base;

	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;

	import treefortress.spriter.SpriterClip;

	/**
	 * 主线地图
	 * @author hyy
	 *
	 */
	public class NewMainWorldRender extends DefaultListItemRenderer
	{
		private var effect_arrow:SpriterClip;
		private static var dic:Dictionary=new Dictionary(true);
		private static const tmpArr:Array=[map_world_1000Base, map_world_0Base, map_world_1Base, map_world_2Base, map_world_3Base, map_world_4Base, map_world_5Base, map_world_6Base, map_world_7Base, map_world_8Base, map_world_9Base, map_world_10Base, map_world_11Base];
		private var container:Sprite;
		private var container_map:NewMapRender;

		public function NewMainWorldRender()
		{
			super();
			container=new Sprite();
			addChild(container);
			ViewDispatcher.instance.addEventListener(EventType.UPDATE_SELECTED_MAINLINE, onSelected);
		}

		override public function set data(value:Object):void
		{
			super.data=value;

			if (value == null)
				return;
			var mainData:MainLineData=value as MainLineData;
			var len:int=mainData.chapterScope.length;

			if (dic[mainData.chapterID] == null)
			{
				var resClass:Class=getDefinitionByName("game.view.viewBase::map_world_" + (mainData.chapterID - 1) + "Base") as Class;
				var map:NewMapRender=new resClass();
//                map.flatten();
				var button:DisplayObject;
				dic[mainData.chapterID]=map;
				map.getChildByName("view_bg").touchable=false;

				for (var i:int=0; i < len; i++)
				{
					button=map.getChildByName("tag_" + (i + mainData.startIndex));
					button.x-=button.width * .5;
					button.y-=button.height * .5;
				}
			}
			container_map && container_map.removeFromParent();
			container_map=dic[mainData.chapterID];
			container_map.addClickFun(onHideBottomHandler);
			addChildAt(container_map, 0);

			var child:NewMainTag;
			var childData:MainLineData;

			while (container.numChildren)
				container.removeChildAt(0, true);

			var guide_btn:Button;
			var tollgateID:int=GameMgr.instance.tollgateID;

			for (i=0; i < len; i++)
			{
				childData=mainData.chapterScope[i];
				child=new NewMainTag(childData, container_map.getChildByName("tag_" + (i + mainData.startIndex)) as Button);
				container.addChild(child);

				if (childData.pointID == tollgateID)
					guide_btn=child.button;
			}

			if (guide_btn)
			{
				if (effect_arrow == null)
					effect_arrow=AnimationCreator.instance.create("effect_034", AssetMgr.instance);

				effect_arrow.play("effect_034");
				effect_arrow.animation.looping=true;
				effect_arrow.x=guide_btn.x + guide_btn.width * .5;
				effect_arrow.y=guide_btn.y;
				this.addChild(effect_arrow);
			}
			else if (effect_arrow)
			{
				effect_arrow.stop();
				effect_arrow.removeFromParent();
			}
		}

		private function onHideBottomHandler(view:Clickable):void
		{
			ViewDispatcher.dispatch(EventType.MAINLINE_HIDDEN);
		}

		private function onSelected(evt:Event, obj:Object):void
		{
			if (obj.data != data)
				return;
			var child:NewMainTag=container.getChildAt(obj.index) as NewMainTag;
			child.selected=true;
		}


		public function getMapByIndex(value:int):NewMainTag
		{
			return container.getChildAt(value) as NewMainTag;
		}

		public static function disDic():void
		{
			for (var key:String in dic)
			{
                var map:NewMapRender =dic[key];
				if(map)
                {
                    map.removeFromParent();
                    map.dispose();
                }
                 delete dic[key]
            }
		}

		override public function dispose():void
		{

//			while (container && container.numChildren > 0)
//			{
//				container.getChildAt(0).removeFromParent(true);
//			}

			container_map && container_map.removeFromParent();
			effect_arrow && effect_arrow.removeFromParent(true);
//			container=null;
			effect_arrow=null;
			ViewDispatcher.instance.removeEventListener(EventType.UPDATE_SELECTED_MAINLINE, onSelected);

            super.dispose();
		}
	}
}
