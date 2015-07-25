package game.data
{
	import com.data.Data;
	import com.langue.Langue;

	import flash.utils.ByteArray;

	public class VipData extends Data
	{
		public static var list : Array = [];
		/**
		 * vip每日礼包
		 */
		public static var list_dayReward : Array = [];
		/**
		 * VIP升级礼包
		 */
		public static var list_reward : Array = [];
		public static var month_card : Object = {};
		public var diamond : int;
		public var chat : int;
		public var fast : int;
		public var tired_buy : int;
		public var jingji_buy : int;
		public var fb_buy : int;
		public var free : int;
		public var reward : int;
		public var dayPrize : int;
		public var baseVip : VipData;

		public function VipData()
		{
			super();
		}

		public static function init(data : ByteArray) : void
		{
			list.length = 0;
			data.position = 0;
			var vector : Array = data.readObject() as Array;
			var len : int = vector.length;

			for (var i : int = 0; i < len; i++)
			{
				var obj : Object = vector[i];
				var instance : VipData = new VipData();

				for (var key : String in obj)
				{
					instance[key] = obj[key];
				}
				instance.id -= 1;
				list.push(instance);
			}
		}

		public static function initDayReward(data : ByteArray) : void
		{
			list_dayReward.length = 0;
			data.position = 0;
			var vector : Array = data.readObject() as Array;
			var len : int = vector.length;

			for (var i : int = 0; i < len; i++)
			{
				var obj : Object = vector[i];
				list_dayReward[obj.id] = getReward(obj.prize);
			}
		}

		public static function initMonthCard(data : ByteArray) : void
		{
			data.position = 0;
			var vector : Array = data.readObject() as Array;
			var len : int = vector.length;
			var obj : Object = vector[0];
			month_card.first = obj.first;
			month_card.today = obj.today;
		}

		public static function initReward(data : ByteArray) : void
		{
			list_reward.length = 0;
			data.position = 0;
			var vector : Array = data.readObject() as Array;
			var len : int = vector.length;

			for (var i : int = 0; i < len; i++)
			{
				var obj : Object = vector[i];
				list_reward[obj.id] = getReward(obj.prize);
			}
		}

		public static function getRewardName(list : Array) : String
		{
			if (list == null)
				return Langue.getLangue("NOTENCHANTING");
			var str : String = "";
			var len : int = list.length;
			var data : Data;

			for (var i : int = 0; i < len; i++)
			{
				data = list[i];

				if (str != "")
					str += ",";

				if (data is Goods)
				{
					str += data.name + "x" + Goods(data).pile;
				}
				else
				{
					str += data.name + "x1";
				}

			}
			return str;
		}

		private static function getReward(prize : String) : Array
		{
			if (prize == "" || prize == null)
				return null;
			var tmpArr : Array = prize.split("&");
			var saveArr : Array = [];
			var goods : Data;

			for (var j : int = 0; j < tmpArr.length; j++)
			{
				var goodsArr : Array = tmpArr[j].split(",");

				if (goodsArr[0] == 5)
				{
					goods = HeroData.hero.getValue(goodsArr[1].split("|")[0]);
					goods = goods.clone();
					HeroData(goods).quality = goodsArr[1].split("|")[1];
				}
				else
				{
					goods = Goods.goods.getValue(goodsArr[0]);
					goods = goods.clone();
					Goods(goods).pile = goodsArr[1];
				}
				saveArr.push(goods);
			}
			return saveArr;
		}

		/**
		 * 获取购买疲劳需要vip等级
		 * @param count
		 * @return
		 *
		 */
		public function getVipByTiredCount(count : int) : int
		{
			return getVipByField(count, "tired_buy");
		}

		/**
		 * 获取副本次数需要vip等级
		 * @param count
		 * @return
		 *
		 */
		public function getVipByFbCount(count : int) : int
		{
			return getVipByField(count, "fb_buy");
		}

		/**
		 * 获取副本次数需要vip等级
		 * @param count
		 * @return
		 *
		 */
		public function getVipByJingjiCount(count : int) : int
		{
			return getVipByField(count, "jingji_buy");
		}

		private function getVipByField(count : int, filed : String) : int
		{
			var len : int = list.length;
			var data : VipData;

			for (var i : int = 0; i < len; i++)
			{
				data = list[i];

				if (data[filed] >= count)
					return data.id;
			}
			return 0;
		}

		public function getNextVipBySpeed() : VipData
		{
			var len : int = list.length;
			var data : VipData;

			for (var i : int = 0; i < len; i++)
			{
				data = list[i];

				if (data.fast > fast)
					return data;
			}
			return null;
		}

		/**
		 * 当前vip级别以前所需要的值
		 * @return
		 *
		 */
		public function get totaleFree() : int
		{
			var data : VipData;
			var value : int = 0;

			for (var i : int = 0; i < id; i++)
			{
				data = list[i];
				value += data.free;
			}
			return value;
		}
	}
}