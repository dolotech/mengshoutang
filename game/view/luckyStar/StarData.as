package game.view.luckyStar
{
	import com.singleton.Singleton;
	
	import game.data.LuckyStarData;

	public class StarData
	{
		/**
		 *是否请求过幸运星初始信息 
		 */		
		public var isSend:Boolean = false;
		/**
		 *期号 ,用来索引本期抽奖物品
		 */		
		public var id:int = 1;
		/**
		 *累积消费总价值  
		 */		
		public var values:int;


		/**
		 * 
		 * 幸运星
		 * 
		 */		
		
		public var star:int;
		
		
		public static function get instance():StarData
		{
			return Singleton.getInstance(StarData) as StarData;
		}
		
		public function get goodsList():Vector.<LuckyStarData>
		{
			return LuckyStarData.LuckGoods(id);
		}
		
	}
}