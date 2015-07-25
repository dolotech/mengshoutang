package game.view.embattle
{
	import com.view.View;

	import game.data.HeroData;
	import game.data.Val;
	import game.manager.GameMgr;
	import game.manager.HeroDataMgr;

	import starling.animation.IAnimatable;
	import starling.core.Starling;

	/**
	 * 布阵索引
	 * @author hyy
	 *
	 */
	public class EmBattleIndexView extends View
	{
		private var list:Vector.<EmBattleIndexGrid>=new Vector.<EmBattleIndexGrid>();
		private var animaiton:IAnimatable;
		private var tag:Boolean;

		public function EmBattleIndexView(isAutoInit:Boolean=true)
		{
			super(isAutoInit);
			this.touchable=false;
			var render:EmBattleIndexGrid;

			for (var i:int=0; i < Val.SEAT_COUNT * 2; i++)
			{
				render=new EmBattleIndexGrid();
				addChild(render);
				list.push(render);
			}
		}

		override protected function show():void
		{
			updateView();
		}

		private function updateView():void
		{
			var len:int=Val.SEAT_COUNT * 2;

			for (var i:int=0; i < len; i++)
			{
				tag ? list[i].showIndex() : list[i].showTag();
			}
			tag=!tag;
			animaiton=Starling.juggler.delayCall(updateView, 2);
		}

		public function updateSeat():void
		{
			var heroMgr:HeroDataMgr=HeroDataMgr.instance;
			var tmp_hero:Array=[];
			heroMgr.hash.eachValue(heroFun);
			heroMgr.battleHeros.eachValue(heroFun);

			function heroFun(data:HeroData):void
			{
				if (data.seat > 0 && data.id > 0)
					tmp_hero.push(data);
			}

			tmp_hero.sortOn("seat", Array.NUMERIC);
			var tmp_list:Array=[];
			var heroData:HeroData;

			for (var i:int=0; i < Val.SEAT_COUNT; i++)
			{
				heroData=getData(i + 11);
				heroData && tmp_list.push(heroData);
				heroData=getData(i + 21);
				heroData && tmp_list.push(heroData);
			}

			if (GameMgr.instance.tollgateData)
			{
				tmp_list=tmp_list.concat(GameMgr.instance.tollgateData.helpHeroList);
			}

			for (i=0; i < Val.SEAT_COUNT * 2; i++)
			{
				list[i].updateView(tmp_list[i], i + 1);
				tag ? list[i].showIndex() : list[i].showTag();
			}

			function getData(seat:int):HeroData
			{
				var len:int=tmp_hero.length;
				var curr_data:HeroData;

				for (var j:int=0; j < len; j++)
				{
					curr_data=tmp_hero[j];

					if (curr_data.seat == seat)
						return curr_data;
				}
				return null;
			}
		}

		override public function dispose():void
		{
			super.dispose();
			Starling.juggler.remove(animaiton);
			list.length=0;
		}
	}
}
import flash.geom.Point;

import game.common.JTLogger;
import game.data.HeroData;
import game.fight.Position;
import game.manager.AssetMgr;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;

class EmBattleIndexGrid extends Sprite
{
	private var img_bg:Image;
	private var text:TextField;
	private var heroData:HeroData;

	public function EmBattleIndexGrid()
	{
		img_bg=new Image(AssetMgr.instance.getTexture("ui_gongyong_zheyetubiao5"));
		text=new TextField(50, 40, "", "", 26, 0x00ffff);
		text.y=3;
		addChild(img_bg);
		addChild(text);
	}


	public function updateView(data:HeroData, index:int):void
	{
		visible=data != null;

		if (!visible)
			return;
		heroData=data;
		text.text=index + "";
		var point:Point=Position.instance.getPoint(heroData.seat);
		x=point.x - img_bg.width * .5;
		y=point.y - 155;
	}


	public function showIndex():void
	{
		if (heroData == null)
			return;
		text.visible=true;
		img_bg.texture=AssetMgr.instance.getTexture("ui_gongyong_zheyetubiao5");
	}

	public function showTag():void
	{
		if (heroData == null)
			return;

		if (heroData.job == 0)
		{
			JTLogger.warn("职位错误")
			heroData.job=1;
		}
		img_bg.texture=AssetMgr.instance.getTexture("ui_gongyong_zheyetubiao" + heroData.job);
		text.visible=false;
	}

	override public function dispose():void
	{
		super.dispose();
		heroData=null;
	}

}


