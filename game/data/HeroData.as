package game.data
{
	import com.data.Data;
	import com.data.HashMap;
	import com.utils.ArrayUtil;

	import flash.utils.ByteArray;

	import game.common.JTFormulaUtil;
	import game.common.JTGlobalDef;
	import game.common.JTLogger;
	import game.manager.GameMgr;
	import game.manager.HeroDataMgr;

	/**
	 *英雄表和英雄数据
	 * @author Administrator
	 *
	 */
	public class HeroData extends Data
	{
		/**
		 * 已经获得的英雄列表
		 */
		public static var getHeroList : Array = [];
		/**
		 * 队伍
		 */
		public static const BLUE : int = 1;
		public static const RED : int = 2;
		public static const DRAW : int = 3;
		public static var hero : HashMap;

		public var useIcon : String;
		public var items : String;
		public var foster : int;
		public var sound : String;
		public var heroPrototype : HeroData;
		public var skillword : String;
		public var sourceHero : HeroData; //创建战斗英雄时，复制原型英雄数据

		/**
		 * 等级
		 */

		/**
		 *
		 * @default
		 */

		public static function init(data : ByteArray) : void
		{
			hero = new HashMap();
			data.position = 0;
			var vector : Array = data.readObject() as Array;
			var len : int = vector.length;

			for (var i : int = 0; i < len; i++)
			{
				var obj : Object = vector[i];
				var instance : HeroData = new HeroData();

				for (var key : String in obj)
				{
					instance[key] = obj[key];
				}
				instance.useIcon = "ui_yingxiongshengdian_wuqikuangbiaozhi" + instance.weapon;
				hero.put(instance.type, instance);
			}
		}

		public var get_hard : int;
		public var get_type : String;
		public var des : String;

		public var size : int;
		/**
		 * 英雄表现数据
		 */
		public var show : int;
		/**
		 * 命中
		 * @default
		 */
		public var hit : int;
		/**
		 * 防御
		 * @default
		 */
		public var defend : int;
		/**
		 *  1：DPS
		 *    2：T
		 *    3：辅助
		 *    4：治疗
		 *
		 * @default
		 */
		public var job : int;
		/**
		 * 布阵位置
		 * @default
		 */
		public var seat : int;
		public var oldseat : int = 0;
		public var lock_seat : Boolean = false;
		public var seat1 : int; // 英雄身上的武器
		public var seat2 : int; // 英雄身上的项链
		public var seat3 : int; // 英雄身上的戒指
		public var seat4 : int; // 英雄身上的手镯
		public var seat5 : int; // 英雄身上的称号

		/**总血量*/
		public var hp : int;
		/**计算sp临时缓存*/
		public var oldHp : int;
		/**攻击*/
		public var attack : int;
		/**类型*/
		public var type : int;
		/**品质*/
		public var quality : int;
		/**
		 * 稀有度
		 */
		public var rarity : int;
		/**
		 *武器类型,比如(剑，刀,法杖)
		 */
		public var weapon : int;
		/**状态*/
		public var state : int;
		/**
		 * 抗韧性 (怪物才有这属性)
		 */
		public var anitToughness : int;
		/**
		 * 韧性
		 */
		public var toughness : int;
		/**
		 * 抗暴
		 */
		public var anitCrit : int;
		/**
		 * 暴击提成
		 */
		public var critPercentage : int;
		/**
		 *暴击率
		 */
		public var crit : int;
		/**
		 * 闪避
		 */
		public var dodge : int;
		/**
		 * 穿刺
		 * @default
		 */
		public var puncture : int;
		/**
		 * 当前血量 (战斗内用于表现扣血)
		 */
		public var currenthp : int;
		/**
		 *敌人还是自己人人
		 */
		public var team : int;
		public var level : int;

		/**
		 * 经验
		 */
		public var exp : int;
		public var selectStaut : int = 3;
		/**
		 * 技能列表
		 */
		public var skill1 : int;
		public var skill2 : int;
		public var skill3 : int;

		/**是否已经放大招*/
		public var isCanSkill : Boolean = true;

		/**
		 * 是否获得
		 */
		public function get isGet() : Boolean
		{
			return getHeroList.indexOf(type) >= 0;
		}

		/**
		 * 是否新品种
		 */
		public var isNew : int;

		public function get getPropertys() : Array
		{
			return [attack, hp, defend, puncture, hit, dodge, crit, critPercentage, anitCrit, toughness];
		}

		public function getAttributes() : Array
		{
			return ["attack", "hp", "defend", "puncture", "hit", "dodge", "crit", "critPercentage", "anitCrit", "toughness"];
		}


		/**
		 * 获取当前英难下一品质的属性列表
		 * @param nextQualityId 下一级的品质
		 * @return
		 *
		 */
		public function getNextPurgePropertys(nextQuality : int) : Array
		{
			var nextHeroData : HeroQualityData = HeroQualityData.hash.getValue(nextQuality);
			var baseHeroInfo : Object = HeroDataMgr.instance.getHeroInfo(this.id);

			if (!baseHeroInfo)
			{
				JTLogger.error("[HeroData.getNextUpgradePropertys] Cant Find ID Hero:" + this.id);
			}
			var cHeroInfo : HeroQualityData = HeroQualityData.hash.getValue(this.quality);
			var propertys : Array = getAttributes();
			var i : int = 0;
			var l : int = propertys.length;
			var list : Array = [];

			for (i = 0; i < l; i++)
			{
				var property : String = propertys[i] as String;

				if (!baseHeroInfo.hasOwnProperty(property))
				{
					JTLogger.error("");
				}
				var bvaseValue : Number = baseHeroInfo[property];
				var nextValue : int = JTFormulaUtil.getUpProperty(JTFormulaUtil.getNextPurgeDeff(bvaseValue, cHeroInfo.arg, nextHeroData.arg), level);
				list[i] = nextValue - JTFormulaUtil.getUpProperty(bvaseValue, level);
			}
			return list;
		}


		/**
		 * 净化成功 当前英雄属性
		 * @param qualityID
		 *
		 */
		public function updateQualityPropertys(qualityID : int) : void
		{
			var nextHeroData : HeroQualityData = HeroQualityData.hash.getValue(qualityID);
			var currentHeroData : HeroQualityData = HeroQualityData.hash.getValue(quality);
			var baseHeroInfo : Object = HeroDataMgr.instance.getHeroInfo(this.id);

			if (!baseHeroInfo)
			{
				JTLogger.error("[HeroData.getNextUpgradePropertys] Cant Find ID Hero:" + this.id);
			}
			var propertys : Array = getPropertys;
			var i : int = 0;
			var length : int = propertys.length;
			var key : Array = Val.PROPERTY_LIST;

			for (i; i < length; i++)
			{
				var property : String = key[i];

				if (!baseHeroInfo.hasOwnProperty(property))
				{
					JTLogger.error("");
				}
				var bvaseValue : int = baseHeroInfo[property];
				var currValue : int = JTFormulaUtil.getNextPurgeDeff(bvaseValue, currentHeroData.arg, nextHeroData.arg);
				baseHeroInfo[property] = currValue;
				var nextValue : int = JTFormulaUtil.getUpProperty(currValue, level);
				this[property] = nextValue;
			}
			this.updataEquipPropertys(this);
		}

		/**
		 * 获取当前英难下一星级的增加属性列表
		 * @param nextQualityId 下一级的品质
		 * @return
		 *
		 */
		public function getNextStarPropertys(nextStar : int) : Array
		{
			var heroStar : HeroStarData = HeroStarData.hash.getValue(this.type);
			var baseHeroInfo : HeroData = HeroDataMgr.instance.getHeroInfo(this.id);

			if (!baseHeroInfo)
			{
				JTLogger.error("[HeroData.getNextStarPropertys] Cant Find ID Hero:" + this.id);
			}
			var propertys : Array = getAttributes();
			var i : int = 0;
			var l : int = propertys.length;
			var list : Array = [];

			for (i = 0; i < l; i++)
			{
				var property : String = propertys[i] as String;

				if (!baseHeroInfo.hasOwnProperty(property))
				{
					JTLogger.error("");
				}
				var bvaseValue : int = baseHeroInfo[property];
				var nextValue : int = JTFormulaUtil.getNextStarDeff(bvaseValue, heroStar.stars[nextStar]);
				list[i] = nextValue - bvaseValue;
			}
			return list;
		}


		/**
		 * 升星成功  增加当前英雄的 属性
		 * @param star
		 *
		 */
		public function updateStarPropertys(star : int) : void
		{
			var heroStar : HeroStarData = HeroStarData.hash.getValue(this.type);
			var baseHeroInfo : Object = HeroDataMgr.instance.getHeroInfo(this.id);

			if (!baseHeroInfo)
			{
				JTLogger.error("[HeroData.updateStarPropertys] Cant Find ID Hero:" + this.id);
			}
			var propertys : Array = getPropertys;
			var i : int = 0;
			var length : int = propertys.length;
			var key : Array = Val.PROPERTY_LIST;

			for (i; i < length; i++)
			{
				var property : String = key[i];

				if (!baseHeroInfo.hasOwnProperty(property))
				{
					JTLogger.error("");
				}
				var baseValue : Number = baseHeroInfo[property];
				var nextValue : int = JTFormulaUtil.getUpProperty(baseValue, level);
				this[property] = nextValue;
			}

			this.updataEquipPropertys(this);
		}


		/**是否是boss*/
		public function get isBoss() : Boolean
		{
			if (this.team != BLUE)
			{
				if (GameMgr.instance.tollgateData)
				{
					var mainLineData : MainLineData = (MainLineData.getPoint(GameMgr.instance.tollgateData.id) as MainLineData);

					if (mainLineData != null)
					{
						if ((mainLineData.boss_seat + 20) == this.seat)
						{
							return true;
						}
					}
				}
			}
			return false;
		}


		public function getQualityImageId() : int
		{
			if (this.quality == 0)
			{
				this.quality = 1;
			}
			return JTGlobalDef.QUALITY_SEVEN - this.quality + 1;
		}

		public function getNextQualityImageID() : int
		{
			var qualit : int = getQualityImageId();

			if (qualit >= 2)
			{
				qualit -= 1;
			}
			return qualit;
		}

		/**
		 *是否可升级品质
		 * @return 可以返回，则返回true,否则返回false
		 *
		 */
		public function isUpQuality() : Boolean
		{
			if (this.quality + 1 > JTGlobalDef.QUALITY_SEVEN)
			{
				return false;
			}
			return true;
		}

		/**
		 *是否可升级星级
		 * @return 可以返回，则返回true,否则返回false
		 *
		 */
		public function isUpStar() : Boolean
		{
			if (this.foster + 1 > JTGlobalDef.STAR_SEVEN)
			{
				return false;
			}
			return true;
		}

		/**
		 * 获取升级品质
		 * @return 如果大于最大品质则返回最大品质（7），否则返回下一级品质
		 *
		 */
		public function getUpQuality() : int
		{
			if (this.quality + 1 > JTGlobalDef.QUALITY_SEVEN)
			{
				return this.quality;
			}
			return this.quality + 1;
		}

		/**
		 * 获取升级星级
		 * @return 如果大于星级质则返回最大星级（5），否则返回下一级星级
		 *
		 */
		public function getUpStar() : int
		{
			if (this.foster + 1 > JTGlobalDef.STAR_SEVEN)
			{
				return this.foster;
			}
			return this.foster + 1;
		}


		/**
		 *增加装备属性
		 * @param widgetid
		 *
		 */
		public function updataEquipProperty(widgetid : int) : void
		{
			if (widgetid > 0)
			{
				var le : int = Val.PROPERTY_LIST.length;
				var widgetData : WidgetData = WidgetData.hash.getValue(widgetid);

				if (widgetData == null)
				{
					trace("装备添加属性错误");
					return;
				}

				for (var k : int = 0; k < le; k++)
				{
					var equipProperty : String = Val.PROPERTY_LIST[k];
					var value : int = widgetData[equipProperty];

					if (value > 0)
					{
						this[equipProperty] += value;
					}
				}
			}
		}

		public function subEquipProperty(widgetid : int) : void
		{
			if (widgetid > 0)
			{
				var widgetData : WidgetData = WidgetData.hash.getValue(widgetid);
				var le : int = Val.PROPERTY_LIST.length;

				for (var k : int = 0; k < le; k++)
				{
					var key : String = Val.PROPERTY_LIST[k];
					var value : int = widgetData[key];

					if (value > 0)
					{
						this[key] -= value;
					}
				}
			}
		}

		/**
		 *更新升级过后的属性值
		 * @param heroInfo
		 *
		 */
		public function updataLvPropertys(heroInfo : HeroData) : void
		{
			var i : int = 0;
			var len : int = Val.PROPERTY_LIST.length;
			var key : String;

			for (i; i < len; i++)
			{
				key = Val.PROPERTY_LIST[i];
				var value : int = heroInfo[key];
				this[key] = JTFormulaUtil.getUpProperty(value, heroInfo.level);
			}
		}


		/**
		 * 更新所有属性（品质加成，升星加成，等级加成，装备加成）
		 */
		public function updataPropertys(heroInfo : HeroData) : void
		{
			updataLvPropertys(heroInfo);
			updataEquipPropertys(heroInfo);
		}

		public function updataEquipPropertys(heroInfo : HeroData) : void
		{
			updataEquipProperty(heroInfo.seat1); // 叠加装备的属性
			updataEquipProperty(heroInfo.seat2);
			updataEquipProperty(heroInfo.seat3);
			updataEquipProperty(heroInfo.seat4);
			updataEquipProperty(heroInfo.seat5);
		}


		//属性
		public var power : int;

		/**
		 * 战斗力
		 * @return
		 *
		 */
		public function get getPower() : uint
		{
			if (power > 0)
			{
				return power;
			}
			return Math.ceil((crit + dodge + critPercentage + hit + anitCrit + defend + puncture + toughness * 2 + 10000) / 10000 * (hp / 7 + attack));
		}

		/**
		 * 我的英雄的最高品质
		 * @return
		 *
		 */
		public function get myHeroQuality() : int
		{
			var hasHeroArr : Array = ArrayUtil.change2Array(HeroDataMgr.instance.hash.values());
			hasHeroArr.sortOn("quality");
			var data : HeroData = ArrayUtil.deleteArrayByField(hasHeroArr, name, "name") as HeroData;

			if (data)
				return data.quality;
			return 0;
		}

		/**
		 * 获得当前穿戴的装备列表
		 * @return
		 *
		 */
		public function getHeroCurrEquipList() : Array
		{
			var weapon_id : int;
			var widget : WidgetData;
			var bestWidget : WidgetData;
			var tmp_list : Array = [];

			for (var i : int = 1; i <= 5; i++)
			{
				weapon_id = this["seat" + i];
				widget = WidgetData.hash.getValue(weapon_id);

				if (widget == null)
					widget = new WidgetData();
				widget.seat = i;

				//武器强制设置类型
				if (i == 1)
					widget.sort = weapon;
				else if (i == 5)
					widget.sort = 21;
				else
					widget.sort = 11 + i;
				bestWidget = widget.getBestEquipByHero(this);
				widget.hasBestEquip = bestWidget && bestWidget.id != widget.id;
				tmp_list.push(widget);
			}
			return tmp_list;
		}

		/**
		 * 卸载英雄所有装备
		 *
		 */
		public function unAllEquip() : void
		{
			var weapon_id : int;
			var widget : WidgetData;

			for (var i : int = 1; i <= 5; i++)
			{
				weapon_id = this["seat" + i];

				if (weapon_id == 0)
					continue;
				widget = WidgetData.hash.getValue(weapon_id);
				widget.equip = 0;
			}
		}

		/**怒气加成方法*/
		public function get addSp() : int
		{
			var sp : int = 0;

			for (var i : int = 0; i < 3; i++)
			{
				var skill : int = this["skill" + (i + 1)];

				if (skill > 0)
				{
					var skillData : SkillData = SkillData.getSkill(skill);
					var trigger : String = skillData.trigger;

					if (trigger.indexOf("die") != -1) //死亡怒气满
					{
						sp = 100;
						break;
					}

					if (trigger.indexOf("wake") != -1)
					{
						var reg : RegExp = /\d+/gs;
						var arr : Array = trigger.match(reg);
						sp = int(arr[0]);
						break;
					}
				}
			}
			return sp;
		}

		/**获取等待播放技能时间*/
		public function get callbackFrame() : int
		{
			var frame : int = 0;

			for (var i : int = 0; i < 3; i++)
			{
				var skill : int = this["skill" + (i + 1)];

				if (skill > 0)
				{
					var skillData : SkillData = SkillData.getSkill(skill);
					skillData.callbackFrame
					var trigger : String = skillData.trigger;

					if (trigger.indexOf("die") != -1) //死亡怒气满
					{
						frame = skillData.callbackFrame;
						break;
					}

					if (trigger.indexOf("wake") != -1)
					{
						frame = skillData.callbackFrame;
						break;
					}
				}
			}
			return frame;
		}
	}
}
