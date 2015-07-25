package game.data
{
	import com.data.HashMap;
	
	import flash.utils.ByteArray;
	
	import starling.textures.Texture;

	/**
	 * 商城数据
	 * @author Administrator
	 */
	public class ShopData extends Goods
	{
		public var texture:Texture;
        public var shopType:int;
		/**
		 * 价格
		 * @default 
		 */
		public var cost:Number;
		/**
		 * 购买数量
		 * @default 
		 */
		public var count:int;

		/**
		 *  购买数量2
		 * @default 
		 */		
		public var count1:int;
		/**
		 * 价格2
		 * @default 
		 */
		public var price2:int;
		
		
		public function ShopData()
		{
			super();
		}


		/**
		 *
		 * @default
		 */
		public static var hash:HashMap;

		/**
		 *
		 * @param data
		 */
		public static function init(data:ByteArray):void
		{
			hash=new HashMap();
			data.position=0;

			var vector:Array=data.readObject() as Array;
			var len:int=vector.length;
			for (var i:int=0; i < len; i++)
			{
				var obj:Object=vector[i];
				var instance:ShopData=new ShopData();

				var goods:Goods = Goods.goods.getValue(obj.type);
				instance.copy(goods);
				
				for (var key:String in obj)
				{
					instance[key]=obj[key];
				}
				
				hash.put(instance.id, instance);
			}
		}
	}
}
