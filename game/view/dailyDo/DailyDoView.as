package game.view.dailyDo
{
	import com.view.base.event.EventType;

	import feathers.controls.Scroller;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.TiledRowsLayout;

	import game.data.Attain;
	import game.dialog.ShowLoader;
	import game.manager.GameMgr;
	import game.net.data.s.SAttain_get;
	import game.net.data.s.SAttain_send;
	import game.net.data.s.SAttaintoday_send;
	import game.net.data.vo.AttainInfo;
	import game.view.achievement.data.AchievementData;
	import game.view.viewBase.DailyDoViewBase;

	import starling.events.Event;

	/**
	 * 每日必做
	 * @author hyy
	 *
	 */
	public class DailyDoView extends DailyDoViewBase
	{
		public function DailyDoView()
		{
			super();
		}

		override protected function init() : void
		{
			enableTween = true;
			_closeButton = btn_close;
			const listLayout : TiledRowsLayout = new TiledRowsLayout();
			listLayout.gap = 8;
			listLayout.useSquareTiles = false;
			listLayout.useVirtualLayout = true;
			listLayout.tileVerticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_TOP;
			listLayout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
			list_task.layout = listLayout;
			list_task.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			list_task.verticalScrollPolicy = Scroller.SCROLL_POLICY_ON;
			list_task.itemRendererFactory = itemRendererFactory;

			function itemRendererFactory() : IListItemRenderer
			{
				const renderer : DailyDoRender = new DailyDoRender();
				renderer.setSize(672, 100);
				return renderer;
			}

			setToCenter();
			clickBackroundClose();
		}

		override protected function openTweenComplete() : void
		{
			AchievementData.instance.attainInfo && onUpdateList(null, AchievementData.instance.attainInfo);
		}

		override protected function addListenerHandler() : void
		{
			super.addListenerHandler();
			addContextListener(EventType.UPDATE_ACHIEVEMENT, onUpdateList);
			addContextListener(SAttain_send.CMD + "", onUpdateRender);
			addContextListener(SAttain_get.CMD + "", onUpdateRender);
			addContextListener(SAttaintoday_send.CMD + "", onUpdateRender);
		}

		private function onUpdateRender(evt : Event, info : *) : void
		{
			var attainData : Attain;
			var data : AttainInfo;

			if (info is SAttain_send)
			{
				data = AchievementData.instance.getAttainInfoById(info.id);
				attainData = Attain.hash.getValue(info.id);
				data.num = attainData.finish_num = attainData.condition;
			}
			else if (info is SAttaintoday_send)
			{
				data = AchievementData.instance.getAttainInfoById(info.id);
				attainData = Attain.hash.getValue(info.id);
				data.num = attainData.finish_num = info.num;
			}
			else if (SAttain_get(info).code == 0)
			{
				data = AchievementData.instance.getAttainInfoById(DailyDoRender.get_id);
				attainData = Attain.hash.getValue(DailyDoRender.get_id);
				data.num = attainData.finish_num = -1;
				ShowLoader.remove();
				AchievementData.instance.attainInfo && onUpdateList(null, AchievementData.instance.attainInfo);
				return;
			}
			attainData && list_task.dataProvider.updateItem(attainData);
		}

		private function onUpdateList(evt : Event, list : *) : void
		{
			var len : int = list.length;
			var attainInfo : AttainInfo;
			var attainData : Attain;

			for (var i : int = 0; i < len; i++)
			{
				attainInfo = list[i];
				attainData = Attain.hash.getValue(attainInfo.id);

				if (attainData)
				{
					if (attainData.type == 9)
						attainData.finish_num = attainInfo.num;
				}
				else
				{
					warn("客户端缺少成就表:" + attainInfo.id);
				}
			}
			var tmp_list : Array = Attain.getListByType(9, GameMgr.instance.tollgateID);
			tmp_list.sortOn(["isFinish", "finish_num"], [Array.DESCENDING, Array.DESCENDING]);
			list_task.dataProvider = new ListCollection(tmp_list);
		}

	}
}