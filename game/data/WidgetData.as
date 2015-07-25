package game.data
{
	import com.data.Data;
	import com.data.HashMap;
	import com.utils.ArrayUtil;
	
	import game.manager.HeroDataMgr;
	import game.net.data.IData;
	import game.net.data.vo.MagicBallVO;
	import game.view.uitils.FunManager;

/**
	 * 物品数据
	 * @author Administrator
	 */
	public class WidgetData extends Goods
	{
		/**
		 * 是否还有可以穿戴的最好装备 
		 */
		public var hasBestEquip:Boolean;
		/**
		 * 
		 * @default 
		 */
		public var position:int;
		public var  socketsNum:int;    //装备插槽数量
		
		/**
		 *  装备的英雄ID
		 */		
		public var equip:int;
		
		public var sockets:Vector.<MagicBallVO>;
		
		public var gem_value:int;
		public var gem_type:String;
		
		override public function clone():Data
		{
			var newObj:WidgetData = super.clone() as WidgetData;
			newObj.sockets = this.sockets.concat();
			return newObj;
		}
		
		override public function copy(value:Object):void
		{
			super.copy(value);
			
			if(value.hasOwnProperty("sockets") && value.sockets)
			{
				var s:Vector.<IData> = value.sockets;
				this.sockets = new Vector.<MagicBallVO>;
				for each(var ball:MagicBallVO in s)
				{
					var newBall:MagicBallVO = new MagicBallVO();
					newBall.id = ball.id;
					newBall.value = ball.value;
					this.sockets.push(newBall);
				}	
			}
		}
		//属性
		public function get getAttribute():Array
		{
			return [defend,puncture,hit,dodge,crit,critPercentage,anitCrit,toughness];
		}


        public function get getAllAttribute():Array
        {
            return [attack,hp,defend,puncture,hit,dodge,crit,critPercentage,anitCrit,toughness];
        }
		
		/**
		 * 玩家所有物品  
		 */		
		public static var hash:HashMap = new HashMap();
		
		/**
		 * 
		 * @param goods
		 */
		public function WidgetData(goods:Goods=null)
		{
			sockets = new Vector.<MagicBallVO>;
			// 对象复制
			if(goods)
			{
				copy(goods);
			}
		}
		
		public static function countByType(type:int):int
		{
			var count:int = 0;
			var props:Vector.<*> = hash.values();
			var len:int = props.length;
			for (var i:int = 0; i < len; i++)
			{
				var widget:WidgetData = props[i] as WidgetData;
				if(widget.type == type)
				{
					count ++;
				}
			}
			return count;
		}
		
		public static function getWidgetByType(type:int):WidgetData
		{
			var props:Vector.<*> = hash.values();
			var len:int = props.length;
			for (var i:int = 0; i < len; i++)
			{
				var widget:WidgetData = props[i] as WidgetData;
				if(widget.type == type)
				{
					return widget;
				}
			}
			return null;
		}
		
		public static function getWidgetNoEquipByType(type:int,equip:int):WidgetData
		{
			var props:Vector.<*> = hash.values();
			var len:int = props.length;
			for (var i:int = 0; i < len; i++)
			{
				var widget:WidgetData = props[i] as WidgetData;
				if(widget.type == type && (widget.equip==0 || widget.equip==equip))
				{
					return widget;
				}
			}
			return null;
		}
		
		public static function pileByType(type:int):int
		{
			var count:int = 0;
			var props:Vector.<*> = hash.values();
			var len:int = props.length;
			for (var i:int = 0; i < len; i++)
			{
				var widget:WidgetData = props[i] as WidgetData;
				if(widget.type == type)
				{
					count += widget.pile;
				}
			}
			return count;
		}
		
		public static function pileByTypeNoEquip(type:int):int
		{
			var count:int = 0;
			var props:Vector.<*> = hash.values();
			var len:int = props.length;
			for (var i:int = 0; i < len; i++)
			{
				var widget:WidgetData = props[i] as WidgetData;
				if(widget.type == type && widget.equip==0)
				{
					count += widget.pile;
				}
			}
			return count;
		}
		
		public static function getCanEquipWidgetByType(type:int):WidgetData
		{
			var count:int = 0;
			var props:Vector.<*> = hash.values();
			var len:int = props.length;
			for (var i:int = 0; i < len; i++)
			{
				var widget:WidgetData = props[i] as WidgetData;
				if(widget.type == type && widget.equip==0)
				{
					return widget
				}
			}
			return null;
		}
		
		//分别装备，道具，材料的总数
		public static function goods(tab:int):int
		{
			var count:int = 0;
			hash.eachValue(function (value:WidgetData):void
			{
				if(value.tab == tab && value.equip == 0)
					count++;
			});
			return count;
		}
		/*
		*
		* 根据装备类型（
		* 1;武器
		2：项链
		3：戒指
		4：手镯）
		获取装备列表
		* */
		public static function getBySeat(seat:int):Vector.<Goods>
		{
			var widgetDatas:Vector.<*> = hash.values();
			var vector:Vector.<Goods> = new <Goods>[];
			var k:int = 0;
			for each(var widgetData:WidgetData in widgetDatas)
			{
				if(seat == widgetData.seat)
				{
					vector[k++] = widgetData;
				}
			}
			return vector;
		}
		
		/**
		 * 
		 * @param sort
		 * @return 
		 */
//		public static function getBySort(sort:int):Vector.<WidgetData>
//		{
//			var vector:Vector.<WidgetData> = new Vector.<WidgetData>;
//			
//			hash.eachValue(eachValue);
//			var i:int = 0 ;
//			function eachValue(widget:WidgetData):void
//			{
//				if(sort == widget.sort)
//				{
//					vector[i++] = widget;
//				}
//			}
//			return vector;
//		}
		
		/**
		 * 
		 * @param sort
		 * @param tab
		 * @return 
		 * =====宝珠商店获取的(同步背包)堆叠的排序
		 */		
		public static function getMagicBalls(sort:int, tab:int) : Vector.<Goods>
		{
			var list:Vector.<Goods> = new Vector.<Goods>;
			var vector:Vector.<*> = hash.values();
			var len:int = vector.length;
			var k:int = 0;
			for(var i:int = 0; i < len; i++)
			{
				var goods:Goods = vector[i] as Goods;
				if(sort == goods.sort && tab == goods.tab)
				{
					list[k++] = goods;
				}
			}
			return list;
		}
		
		/**
		 * 
		 * @param sort
		 * @param tab
		 * @return 
		 * 背包的道具栏的堆叠数排序
		 */		
		public static function getBySort(sort:int, tab:int):Array
		{
//			var dic:Dictionary=new Dictionary();
//			var tmp_list:Array=[];
//			hash.eachValue(eachValue);
//			function eachValue(widget:WidgetData):void
//			{
//				if(sort == widget.sort && tab==widget.tab)
//				{
//					if(dic[widget.type]==null)
//						dic[widget.type] = widget.clone();
//					else
//						dic[widget.type].pile += widget.pile;
//				}
//			}
//			for each(var widget:WidgetData in dic)
//			{
//				tmp_list.push(widget);	
//			}
//			return tmp_list;
			
			var tmp_list:Array = [];
			var vector:Vector.<*> = hash.values();
			var len:int = vector.length;
			var k:int = 0;
			for(var i:int = 0; i < len; i++)
			{
				var goods:Goods = vector[i] as Goods;
				if(sort == goods.sort && tab == goods.tab)
				{
					tmp_list[k++] = goods;
				}
			}
			return tmp_list;
		}
		/**
		 * 创建玩家所有道具 
		 * @param props
		 * 
		 */		
		public static function  createProps(props:Vector.<IData>):void
		{
			var len:int = props.length;
			for (var i:int = 0; i < len; i++)
			{
				var obj:GameGoodsVo = new GameGoodsVo();
				readObject(obj,props[i]);
				var goods:Goods = Goods.goods.getValue(obj.type) as Goods;
				var data:WidgetData;

//                if(goods.tab == 2 && goods.sort == 4)
//                {
//                    data = new MagicData(goods);
//                }
//                else
                {
                    data = new WidgetData(goods);
                }

				data.copy(obj);
				hash.put(data.id, data);
			}
		}
		
		
		public var values:Vector.<Object>
		/**
		 * 创建玩家所有装备 
		 * @param props
		 * 
		 */		
		public static function  createEquip(equip:Vector.<IData>):void
		{
			var len:int = equip.length;
			for (var i:int = 0; i < len; i++)
			{
				var obj:GameEquipVo = new GameEquipVo();
				readObject(obj,equip[i]);
				var data:WidgetData = WidgetData.hash.getValue(obj.id);
				
				if(!data)
				{
					var goods:Goods = Goods.goods.getValue(obj.type) as Goods;
					data = new WidgetData(goods);
				}
				var heroData:HeroData
				if(data.equip > 0)
				{
					heroData = HeroDataMgr.instance.hash.getValue(data.equip);
					if(heroData)
					{
						heroData.subEquipProperty(data.id);
					}
				}
				data.pile=1;
				data.copy(obj);
				hash.put(data.id, data);
				if(data.sockets.length > 0)
				{
					var j:int = 0;
					var length:int = data.sockets.length;
					var magic:MagicBallVO;
					var ball:Goods ;
					var key:String;
					for ( j ; j < length ; j ++)
					{
						magic = data.sockets[j];
						ball = Goods.goods.getValue(magic.id);
						key = Val.MAGICBALL[ball.magicIndex - 1];
						data[key] += magic.value;
					}
				}
				if(data.equip > 0)
				{
					heroData = HeroDataMgr.instance.hash.getValue(data.equip);
					if(heroData)
					{
						heroData.updataEquipProperty(data.id);
					}
				}
				data.mathValues();
			}
		}
		
		public function addStrengthen(rise:Number):void
		{
			var i:int;
			var len:int = Val.PROPERTY_LIST.length;
			for ( i ; i < 2 ; i ++)
			{
				var key:String = Val.PROPERTY_LIST[i];
				if(key != "attack" && key != "hp")continue;
				var value:int;
				var j:int = 0;
				var length:int = sockets.length;
				var magic:MagicBallVO;
				var ball:Goods ;
				if(sockets.length >0)
				{
					
					for ( j ; j < length ; j ++)
					{
						magic = sockets[j];
						ball = Goods.goods.getValue(magic.id);
						//						key = ;
						if(key == Val.MAGICBALL[ball.magicIndex - 1])
						{
							this[key] -= magic.value;
							value = magic.value;
							break;
						}
					}
				}
				
				this[key] += Math.ceil(Number(this[key] * rise - this[key]));
				
				if(sockets.length > 0)
				{
					j = 0;
					length = sockets.length;
					
					for ( j ; j < length ; j ++)
					{
						magic = sockets[j];
						ball = Goods.goods.getValue(magic.id);
						//						key = ;
						if(key == Val.MAGICBALL[ball.magicIndex - 1])
						{
							this[key] += magic.value;
							value = magic.value;
							break;
						}
					}
				}
			}
			mathValues();
		}
		
		
		public function removeStrengthen(rise:Number):void
		{
			var i:int;
			var len:int = Val.PROPERTY_LIST.length;
			for ( i ; i < 2 ; i ++)
			{
				var key:String = Val.PROPERTY_LIST[i];
				if(key != "attack" && key != "hp")continue;
				var value:int;
				var j:int = 0;
				var length:int = sockets.length;
				var magic:MagicBallVO;
				var ball:Goods 	;
				if(sockets.length >0)
				{
					
					for ( j ; j < length ; j ++)
					{
						magic = sockets[j];
						ball = Goods.goods.getValue(magic.id);
						//						key = ;
						if(key == Val.MAGICBALL[ball.magicIndex - 1])
						{
							this[key] -= magic.value;
							value = magic.value;
							break;
						}
					}
				}
				this[key] -= Math.ceil(Number(this[key] - (this[key] / rise)));
				if(sockets.length > 0)
				{
					j = 0;
					length = sockets.length;
					
					for ( j ; j < length ; j ++)
					{
						magic = sockets[j];
						ball = Goods.goods.getValue(magic.id);
						//						key = ;
						if(key == Val.MAGICBALL[ball.magicIndex - 1])
						{
							this[key] += magic.value;
							value = magic.value;
							break;
						}
					}
				}
			}
			
			mathValues();
		}
		
		public function mathValues():void
		{
			values  = new Vector.<Object>(5);
			var k:int = 0 ; 
			var l:int = Val.PROPERTY_LIST.length;
			var index:int;
			var obj:Object;
			for ( k  ; k < l ; k ++)
			{
				var key:String = Val.PROPERTY_LIST[k];
				if(this[key]  > 0 && key != "hp" && key != "attack")
				{
					
					obj = {key:k,value:this[key]};
					values[index] = obj;
					
					if(sockets.length >0)
					{
						var j:int = 0;
						var length:int = sockets.length;
						var magic:MagicBallVO;
						var ball:Goods;
						for ( j ; j < length ; j ++)
						{
							magic = sockets[j];
							ball = Goods.goods.getValue(magic.id);
							//						key = ;
							if(key == Val.MAGICBALL[ball.magicIndex - 1])
							{
								obj.value -= magic.value;
								if(obj.value > 0)
								{
									values[index] = obj;
								}
								break;
							}
						}
					}
					if(values[index].value == 0)
					{
						values.splice(index,1);
					}
					else 	index++;
					
					if(index > 4)break;
				}
			}
		}
		
		public function getStrengthenValue(key:String, rise:Number):int
		{
			var value:int = this[key];
			
			if(sockets.length >0)
			{
				var j:int = 0;
				var length:int = sockets.length;
				var magic:MagicBallVO;
				var ball:Goods ;
				for ( j ; j < length ; j ++)
				{
					magic = sockets[j];
					ball = Goods.goods.getValue(magic.id);
					//						key = ;
					if(key == Val.MAGICBALL[ball.magicIndex - 1])
					{
						value -= magic.value;
						break;
					}
				}
			}
			
			return Math.ceil(value *rise - value); // this[key] += Math.ceil(Number(this[key] * rise - this[key]));;
		}
		
		public function get Combat():uint
		{
			return Math.ceil((crit + dodge + critPercentage + hit + anitCrit + defend + puncture + toughness * 2 + 10000) / 10000 * (hp / 7 + attack));
		}
		
		/**
		 * 获得该类型,英雄可以穿戴的最好装备 
		 * @param heroData
		 * @return 
		 * 
		 */
		public function getBestEquipByHero(heroData:HeroData):WidgetData
		{
			var tmpEquipList:Array = ArrayUtil.change2Array(WidgetData.hash.values());
			var len:int=tmpEquipList.length;
			var widgetData:WidgetData;
			var bestEquip:WidgetData;
			for(var i:int=0;i<len;i++)
			{
				widgetData=tmpEquipList[i];
				
				if(widgetData.limitLevel > heroData.level || widgetData.type < 100000 ||  widgetData.seat!=seat ||( seat == 1 &&widgetData.sort != heroData.weapon))
					continue;
				if(widgetData.seat==5 && widgetData.type==type)
					continue;
				if (widgetData.equip == 0 || widgetData.equip == heroData.id) 
				{
					if(bestEquip == null && widgetData.Combat>Combat)
						bestEquip=widgetData;
					else if(bestEquip && widgetData.Combat > bestEquip.Combat)
						bestEquip=widgetData;
				}
			}
			return bestEquip;
		}

        public function get propertyValue() : int
        {
            return FunManager.jewelry_upgrade(control2, level);
        }
	}
}