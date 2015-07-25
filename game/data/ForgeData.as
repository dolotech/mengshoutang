package game.data
{
	import com.data.HashMap;
	
	import flash.utils.ByteArray;
	
	import game.manager.HeroDataMgr;
	import game.net.message.EquipMessage;


	/**
	 * 唯一key - 合成装备id
	 * @author Administrator
	 */
	public class ForgeData extends Goods
	{
		/**
		 * 成功率
		 * @default
		 */
		public var successRate : int;
		/**
		 * 材料1
		 * @default
		 */
		public var material1 : int;

		/**
		 *宝珠数量
		 */
		public var magicNumber : int;
		/**
		 *
		 * @default
		 */
		public var material2 : int;
		/**
		 *
		 * @default
		 */
		public var material3 : int;
		/**
		 *
		 * @default
		 */
		public var material4 : int;
		/**
		 *
		 * @default
		 */
		public var material5 : int;
		/**
		 *
		 * @default
		 */
		public var material6 : int;

		/**
		 *大类
		 */
		public var maxSort : int;
		/**
		 *小类
		 */
		public var miniSort : int;

		/**
		 *材料
		 */
		public var materials : String;

		/**
		 * 价格
		 */
		public var price : int;
		/**
		 *价格类型
		 */
		public var moneyTyep : int;

		private var forge_list : Array;

		public function ForgeData()
		{
			super();
		}


		/**
		 *
		 * @default
		 */
		public static var hash : HashMap;

		public static function getGoodsListBySort(sort : int) : Array
		{
			var tmp_arr : Array = [];
			hash.eachValue(fun);
			function fun(data : ForgeData) : void
			{
				if (data.maxSort == sort)
					tmp_arr.push(data);
			}
			return tmp_arr;
		}

		/**
		 *
		 * @param data
		 */
		public static function init(data : ByteArray) : void
		{
			hash = new HashMap();
			foreVect = new Vector.<ForgeData>;
			data.position = 0;

			var vector : Array = data.readObject() as Array;
			var len : int = vector.length;

			for (var i : int = 0; i < len; i++)
			{
				var obj : Object = vector[i];
				var instance : ForgeData = new ForgeData();

				for (var key : String in obj)
				{
					instance[key] = obj[key];
				}

				var goods : Goods = Goods.goods.getValue(instance.id);
				instance.copy(goods);
				instance.id = obj.id;
				hash.put(instance.id, instance);
			}
			setSort();
		}

		public static var foreVect : Vector.<ForgeData>;

		private static function setSort() : void
		{
			var k : int = 0;
			hash.eachValue(function(value : ForgeData) : void
				{
					foreVect[k++] = value;
				});
			foreVect.sort(function(a : ForgeData, b : ForgeData) : Number
				{
					return a.type > b.type ? 1 : -1;
				});
		}

		public function getForgeList() : Array
		{
			if (forge_list)
				return forge_list;
			forge_list = [];
			var exp : RegExp = /\{[\d,\,]*\}/gs;
			var ex : RegExp = /\d+/gs;
			var tmp_materials : Array = materials.match(exp);
			var tmp_goodsArray : Array;
			var tmp_goods : Goods

			for (var i : int = 0, len : int = tmp_materials.length; i < 4; i++)
			{
				if (i >= len)
					continue;

				tmp_goodsArray = tmp_materials[i].match(ex);
				tmp_goods = Goods.goods.getValue(tmp_goodsArray[0]);
				tmp_goods = tmp_goods.clone() as Goods;

				if (tmp_goods == null)
				{
					trace("找不到合成物品", tmp_goodsArray[0]);
					continue;
				}
				tmp_goods.need_FusionCount = tmp_goodsArray[1];
				tmp_goods.isLookInfo = true;
				forge_list[i] = tmp_goods;
			}
			return forge_list;
		}

		public function unEquip() : void
		{
//			var exp : RegExp = /\{[\d,\,]*\}/gs;
//			var ex : RegExp = /\d+/gs;
//			var tmp_materials : Array = materials.match(exp);
//			var tmp_goodsArray : Array;
//			var tmp_goods : WidgetData;
//
//			for (var i : int = 0, len : int = tmp_materials.length; i < 4; i++)
//			{
//				if (i >= len)
//					continue;
//				tmp_goodsArray = tmp_materials[i].match(ex);
//				tmp_goods = WidgetData.getWidgetByType(tmp_goodsArray[0]);
//
//				if (tmp_goods && tmp_goods.equip > 0)
//					EquipMessage.sendReplaceEquip(tmp_goods.seat, HeroDataMgr.instance.hash.getValue(tmp_goods.equip), 0);
//			}
		}

		/**
		 * 是否可以合成
		 *
		 */
		public function get isCanForge() : Boolean
		{
			if (forge_list == null)
				return false;
			var can : Boolean = true;
			var tmp_goods : Goods

			for (var i : int = 0, len : int = forge_list.length; i < 4; i++)
			{
				tmp_goods = forge_list[i];

				if (i >= len || tmp_goods.type == 0)
					continue;
				tmp_goods.pile = WidgetData.pileByType(tmp_goods.type);

				if (tmp_goods.pile < tmp_goods.need_FusionCount)
					can = false;
			}
			return can;
		}

		public function get isGet() : int
		{
			return WidgetData.getWidgetByType(id) ? 1 : 0;
		}
	}
}
