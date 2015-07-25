package game.data
{
	import com.data.Data;

	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**
	 * 主线章节数据(用于前端界面显示)
	 * @author Administrator
	 *
	 */
	public class MainLineData extends Data
	{
		public var chapterID : int
		public var chapterName : String;
		public var chapterScope : Array;
		public var chapterScopeId : Array;
		public var chapterIcon : String;
		public var pointID : int
		public var pointName : String;
		public var scene : String;
		public var points_ico : String;
		public var points_point : Point;
		public var pco_effect : String;
		public var bgm : String;
		public var boss_level : int;
		public var boss_seat : int;
		public var boss_type : int;
		public var startIndex : int;

		public var guide_level : int;
		public var guide_equip : int;
		public var guide_strengthen : int;
		public var guide_quality : int;
		public var guide_gem : int;
		public var guide_gem_level : int;

		public function get tollgateData() : TollgateData
		{
			return TollgateData.hash.getValue(id);
		}


		/**
		 * 是否副本
		 * @return
		 *
		 */
		public function get isFb() : Boolean
		{
			return id >= 1000 && id <= 2000;
		}

		/**
		 * 是否噩梦副本
		 * @return
		 *
		 */
		public function get isNightMare() : Boolean
		{
			return id >= 20000 && id <= 30000;
		}

		/**
		 * 是否剧情
		 * @return
		 *
		 */
		public function get isStory() : Boolean
		{
			return id > 30000;
		}

		public static var list : Array = [];
		private static var dic_mainline : Dictionary;
		public static var list_reward : Dictionary;

		public static function getPoint(id : int) : MainLineData
		{
			return dic_mainline[id];
		}

		/**
		 * 根据打到的关卡数获得关卡页数
		 * @param id
		 * @return
		 *
		 */
		public static function getPageById(id : int) : int
		{
			var len : int = list.length;
			var data : MainLineData;

			for (var i : int = 0; i < len; i++)
			{
				data = list[i];

				if (id <= data.chapterScopeId[1])
					return i + 1;
			}
			return 0;
		}

		public static function initReward(data : ByteArray) : void
		{
			list_reward = new Dictionary();
			data.position = 0;
			var vector : Array = data.readObject() as Array;
			var len : int = vector.length;
			var goods : Goods;

			for (var i : int = 0; i < len; i++)
			{
				var obj : Object = vector[i];
				goods = Goods.goods.getValue(obj.tid);

				if (goods == null || int(obj.tid) == 0)
					continue;

				if (list_reward[obj.id] == null)
					list_reward[obj.id] = [goods];
				else if(list_reward[obj.id].indexOf(goods) == -1)
					list_reward[obj.id].push(goods);
			}
		}

		public static function init(data : ByteArray) : void
		{
			dic_mainline = new Dictionary();
			data.position = 0;
			var vector : Array = data.readObject() as Array;
			var len : int = vector.length;
			var mainData : MainLineData;

			for (var i : int = 0; i < len; i++)
			{
				var obj : Object = vector[i];
				mainData = new MainLineData();

				for (var key : String in obj)
				{
					var value : String = obj[key];

					if ("chapterScope" == key)
						mainData.chapterScopeId = mainData[key] = value.split(",");
					else if ("points_point" == key && value)
						mainData[key] = new Point(value.split(",")[0], value.split(",")[1]);
					else
						mainData[key] = value;
				}

				dic_mainline[mainData.id] = mainData;
			}

			var startIndex : int;
			var endIndex : int;
			var tmp_list : Array;

			//解析出大章节关卡
			for each (mainData in dic_mainline)
			{
				if (mainData.chapterScope.length > 1)
				{
					tmp_list = [];
					startIndex = mainData.chapterScope[0];
					endIndex = mainData.chapterScope[1];
					mainData.startIndex = startIndex;

					for (i = startIndex; i <= endIndex; i++)
					{
						tmp_list.push(dic_mainline[i]);
					}
					mainData.chapterScope = tmp_list;
					list.push(mainData);
				}
			}
		}
	}
}