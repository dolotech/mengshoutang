package game.data
{
	import com.data.Data;
	import com.data.HashMap;

	import flash.utils.ByteArray;

	/**
	 * 关卡
	 * @author Administrator
	 */
	public class TollgateData extends Data
	{
		public static var tollgateCount : int;
		public var tired : int;
		/**
		 *
		 * @default
		 */
		public var type : int;
		/**
		 *
		 * @default
		 */
		public var monsters : Array;

		public var gold : int;
		public var produce : String;
		public var power : int;
		public var nightmare : int;
		public var exp : int;
		public var consume : Array = [];
		public var help_hero : Array = [];
		private var _helpHeroList : Array;
		public var nightmare_star : int;


		public function get helpHeroList() : Array
		{
			if (_helpHeroList)
				return _helpHeroList;
			var len : int = help_hero.length;
			var heroData : HeroData;
			_helpHeroList = [];

			for (var i : int = 0; i < len; i++)
			{
				heroData = MonsterData.monster.getValue(help_hero[i][0]).clone();
				heroData.currenthp = heroData.hp;
				heroData.team = HeroData.BLUE;
				heroData.seat = Val.posC2S(help_hero[i][1] - 1);
				_helpHeroList.push(heroData);
			}
			return _helpHeroList;
		}

		/**
		 * 噩梦消耗物品
		 * @return
		 *
		 */
		public function get castNightmareGoods() : Goods
		{
			if (consume.length == 0)
				return null;
			var goods : Goods = Goods.goods.getValue(consume[0][0]);

			if (goods == null)
				return null;
			goods = goods.clone() as Goods;
			goods.pile = consume[0][1];
			return goods;
		}

		public function get nightmareData() : TollgateData
		{
			return TollgateData.hash.getValue(nightmare);
		}

		public function get tollgateName() : String
		{
			return MainLineData.getPoint(id).pointName;
		}

		/**
		 * 获得关卡掉落
		 * @return
		 *
		 */
		public function get rewardList() : Array
		{
			var id : int = produce.split(",").pop().split("}").shift();
			return MainLineData.list_reward[id];
		}

		/**
		 *
		 */
		public function TollgateData()
		{
			super();
			monsters = [];
		}
		/**
		 *
		 * @default
		 */
		public static var hash : HashMap;

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
			return id >= 20000 && id < 3000;
		}

		/**
		 *
		 * @param data
		 */
		public static function init(data : ByteArray) : void
		{
			hash = new HashMap();
			data.position = 0;
			var exp : RegExp = /\{[\d,\,]*\}/gs;
			var ex : RegExp = /\d+/gs;

			var vector : Array = data.readObject() as Array;
			var len : int = vector.length;
			var count : int = 0;

			for (var i : int = 0; i < len; i++)
			{
				var obj : Object = vector[i];
				var instance : TollgateData = new TollgateData();

				for (var key : String in obj)
				{
					if (key == "monsters" || key == "consume" || key == "help_hero")
					{
						var str : String = obj[key];

						if (str == null)
							continue;
						var arr : Array = str.match(exp);
						var le : int = arr.length;

						for (var k : int = 0; k < le; k++)
						{
							var sub : String = arr[k];
							var subArr : Array = sub.match(ex);
							instance[key][k] = subArr;
						}
					}
					else
					{
						instance[key] = obj[key];
					}
				}

				if (instance.id < 1000)
					count++;
				hash.put(instance.id, instance);
			}
			tollgateCount = count;
		}

		public static function reset() : void
		{
			hash.eachValue(fun);
			function fun(data : TollgateData) : void
			{
				data.nightmare_star = 0;
			}
		}
	}
}