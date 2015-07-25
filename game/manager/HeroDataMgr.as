package game.manager
{
    import com.data.HashMap;
    import com.singleton.Singleton;
    import com.utils.ArrayUtil;

    import flash.utils.ByteArray;
    import flash.utils.Dictionary;

    import game.common.JTGlobalDef;
    import game.common.JTLogger;
    import game.data.Goods;
    import game.data.HeroData;
    import game.data.HeroTotalData;
    import game.data.MainLineData;
    import game.data.MonsterData;
    import game.data.SkillData;
    import game.data.TollgateData;
    import game.data.Val;
    import game.data.WidgetData;
    import game.managers.JTFunctionManager;
    import game.net.data.IData;
    import game.net.data.s.SNewhero;
    import game.net.data.vo.HeroVO;

    /**
     * 玩家收集的所有英雄
     * @author Michael
     *
     */
    public class HeroDataMgr
    {
        public static var list_heroGrid:Dictionary;

        public static function initGridCostList(data:ByteArray):void
        {
            list_heroGrid=new Dictionary();
            data.position=0;
            var vector:Array=data.readObject() as Array;
            var len:int=vector.length;

            for (var i:int=0; i < len; i++)
            {
                var obj:Object=vector[i];
                list_heroGrid[int(obj.id)]=obj.money;
            }
        }
        /**
         *  玩家收集的所有英雄
         */
        public var hash:HashMap;
        /**
         * 本场战斗内的英雄包括对手
         */
        public var battleHeros:HashMap;



        /**
         *
         */
        public function HeroDataMgr()
        {
            hash=new HashMap();
            battleHeros=new HashMap();

        }

        public function getBySeat(seat:int):HeroData
        {
            var hero:HeroData;
            var arr:Vector.<*>=hash.values();
            for each (var heroData:HeroData in arr)
            {
                if (heroData.seat == Val.posC2S(seat))
                {
                    hero=heroData;
                    break;
                }
            }
            return hero;
        }

        /**
         * 怪物的战斗力
         * @return
         *
         */
        public function get monsterPower():int
        {
            var power:int=0;
            var hero_list:Vector.<*>=battleHeros.values();
            var len:int=hero_list.length;
            var hero:HeroData;
            for (var i:int=0; i < len; i++)
            {
                hero=hero_list[i];
                if (hero.team != HeroData.BLUE)
                {
                    power+=hero.getPower;
                }
            }
            return power;
        }

        /**
         *
         * @return
         */
        public static function get instance():HeroDataMgr
        {
            return Singleton.getInstance(HeroDataMgr) as HeroDataMgr;
        }

        /**
         * 创建一个玩家的英雄，已经存在该英雄则更新该英雄属性
         * @param vo
         * @return
         */
        public function create(data:SNewhero):void
        {
            var hero:HeroData=hash.getValue(data.id);
            // 已经存在该英雄则更新该英雄属性
            if (!hero)
            {
                hero=HeroData.hero.getValue(data.type) as HeroData;
                hero=hero.clone() as HeroData;
            }
            var heroBase:HeroData=new HeroData();
            heroBase.copy(data);
            heroBase.id=data.id;
            hero.id=data.id;
            hero.copy(data);
            hero.heroPrototype=new HeroData();
            hero.heroPrototype.copy(data);
            hash.put(hero.id, hero);
            map[data.id]=heroBase;
            hero.updataPropertys(heroBase);
        }

        /**
         *用户登陆或做任务的获得的勇士的（基础属性）
         */
        public var map:Dictionary=new Dictionary(false);

        public function init(heroes:Vector.<IData>):void
        {
            var len:int=heroes.length;
            for (var i:int=0; i < len; i++)
            {
                var hero:HeroVO=heroes[i] as HeroVO;
                var heroData:HeroData=HeroData.hero.getValue(hero.type) as HeroData;
                var baseHero:HeroData=new HeroData();
                heroData=heroData.clone() as HeroData;
                baseHero.copy(hero);
                heroData.copy(hero);
                heroData.id=hero.id;
                baseHero.id=hero.id;
                heroData.team=HeroData.BLUE;
                heroData.heroPrototype=new HeroData();
                heroData.heroPrototype.copy(hero);
                heroData.heroPrototype.level=heroData.level;
                map[hero.id]=baseHero;
                hash.put(heroData.id, heroData);
                heroData.updataPropertys(baseHero);
            }
            JTFunctionManager.registerFunction(JTGlobalDef.UPDATA_LEVEL_HEROS, onUpdataLevelHeros);
            JTFunctionManager.registerFunction(JTGlobalDef.UPDATA_QUALITY_HERO, onUpdataQualityHero);
            JTFunctionManager.registerFunction(JTGlobalDef.UPDATA_STAR_HERO, onUpdataStarHero);

        }


        /**获取所有英雄的最大等级的等级*/
        public function getHerosMaxLv():int
        {
            var lv:int=0;
            for each (var heroData:HeroData in HeroDataMgr.instance.hash.values())
            {
                if (heroData.level > lv)
                {
                    lv=heroData.level;
                }
            }
            return lv;
        }


        /**
         * 根据类型获得英雄
         * @param type
         * @return
         *
         */
        public function getHeroDataByType(type:int):HeroData
        {
            return ArrayUtil.getIndexByField(hash.values(), type, "type") as HeroData;
        }

        /**
         * 获得已经上阵的英雄
         * @return
         *
         */
        public function getOnBattleHero():Array
        {
            var tmpArr:Array=ArrayUtil.change2Array(hash.values());
            var tmpReturn:Array=[];
            var len:int=tmpArr.length;
            for (var i:int=0; i < len; i++)
            {
                var hero:HeroData=tmpArr[i] as HeroData;

                if (hero && hero.seat > 0)
                {
                    tmpReturn.push(hero);
                }
            }
            return tmpReturn;
        }

        /**
         * 是否达到4个或者没有可用上阵英雄
         * @return
         *
         */
        public function get isMaxBattle():Boolean
        {
            var count:int=getOnBattleHero().length;
            var freeCount:int=getFreeBattleHero().length;
            return count == HeroDataMgr.instance.seatMax || (count < HeroDataMgr.instance.seatMax && freeCount == 0);
        }

        /**获取最大的上阵英雄个数*/
        public function get seatMax():int
        {
            if (GameMgr.instance.tollgateID < 6)
            {
                return 1;
            }
            else if (GameMgr.instance.tollgateID < 11)
            {
                return 2;
            }
            else if (GameMgr.instance.tollgateID < 21)
            {
                return 3;
            }
            else if (GameMgr.instance.tollgateID < 41)
            {
                return 4;
            }
            return Val.SEAT_MAX; //5个英雄
        }


        /**获取当前开启英雄可上阵格子数*/
        public function get seatTollgeteId():int
        {
            var tollgate:uint=0;
            if (GameMgr.instance.sBattle)
            {
                tollgate=GameMgr.instance.sBattle.success == 1 ? GameMgr.instance.tollgateID - 1 : GameMgr.instance.tollgateID;
            }
            else //录像情况
            {
                tollgate=GameMgr.instance.isPass ? GameMgr.instance.tollgateID - 1 : GameMgr.instance.tollgateID;
            }

            if (tollgate < 6)
            {
                return 1;
            }
            else if (tollgate < 11)
            {
                return 2;
            }
            else if (tollgate < 21)
            {
                return 3;
            }
            else if (tollgate < 41)
            {
                return 4;
            }
            return Val.SEAT_MAX; //5个英雄
        }

        /**
         *
         * @param heroNum 上阵英雄人数1-5
         * @return 开启的最低关卡上阵英雄人数
         *
         */
        public function getOpenTollgateId(heroNum:uint):int
        {
            heroNum=heroNum > Val.SEAT_MAX ? Val.SEAT_MAX : heroNum;
            for each (var data:HeroTotalData in HeroTotalData.hash.values())
            {
                if (data.maxcount == heroNum)
                {
                    return data.id;
                }
            }
            return 5;
        }

        /**
         * 获得已经上阵英雄的数量
         * @return
         *
         */
        public function getOnBattleHeroCount():int
        {
            return getOnBattleHero().length;
        }

        /**
         * 获得没有上阵英雄的
         * @return
         *
         */
        public function getFreeBattleHero():Array
        {
            var tmpArr:Array=ArrayUtil.change2Array(hash.values());
            var tmpReturn:Array=[];
            var len:int=tmpArr.length;
            for (var i:int=0; i < len; i++)
            {
                var hero:HeroData=tmpArr[i] as HeroData;

                if (hero && hero.seat == 0)
                {
                    tmpReturn.push(hero);
                }
            }
            return tmpReturn;
        }

        public function getHeroBattleHeroByType(type:int):HeroData
        {
            var tmpArr:Array=ArrayUtil.change2Array(hash.values());
            var len:int=tmpArr.length;
            for (var i:int=0; i < len; i++)
            {
                var hero:HeroData=tmpArr[i] as HeroData;

                if (hero && hero.type == type)
                    return hero;
            }
            return null;
        }

        private function onUpdataQualityHero(result:Object):void
        {
            var heroInfo:HeroData=result as HeroData;
            var baseHero:HeroData=this.getHeroInfo(heroInfo.id) as HeroData;
            var quality:int=heroInfo.getUpQuality();
            heroInfo.updateQualityPropertys(quality);
            heroInfo.quality=quality;
        }

        private function onUpdataStarHero(result:Object):void
        {
            var heroInfo:HeroData=result as HeroData;
            var baseHero:HeroData=this.getHeroInfo(heroInfo.id) as HeroData;
            var star:int=heroInfo.getUpStar();
            heroInfo.updateStarPropertys(star);
            heroInfo.foster=star;

        }

        private function onUpdataLevelHeros(result:Object):void
        {
            var hero_id:int=result.id;
            var hero_level:int=result.level;
            var heroInfo:HeroData=hash.getValue(hero_id) as HeroData;
            var baseHero:HeroData=getHeroInfo(heroInfo.id) as HeroData;
            var copyHero:HeroData=baseHero.clone() as HeroData;
            copyHero.level=hero_level;
            heroInfo.updataPropertys(copyHero);
        }

        /**
         * 获取基础勇士数据
         * @param id
         * @return
         *
         */
        public function getHeroInfo(id:int):HeroData
        {
            if (map[id])
            {
                return map[id] as HeroData;
            }
            JTLogger.error("[HeroDataManager.getHeroInfo] Can't Find The Hero ID:" + id);
            return null;
        }

        /**
         * 创建一个战斗内怪物
         * @return
         */
        public function createMonsters(tollgate:TollgateData):void
        {
            var monsters:Array=tollgate.monsters;
            var len:int=monsters.length;
            for (var i:int=0; i < len; i++)
            {
                var type:int=monsters[i][0];
                var monster:MonsterData=MonsterData.monster.getValue(type);

                monster=monster.clone() as MonsterData;
                monster.copy(monster);

                monster.currenthp=createHP(monster);
                monster.hp=monster.currenthp;
                monster.id=monster.seat=int(monsters[i][1]) + 20;
                monster.team=HeroData.RED;
                battleHeros.put(monster.id, monster);
            }
        }


        /**
         *创建对手英雄
         *
         */
        public function createRival(heros:Vector.<IData>, type:int=0):void
        {
            var len:int=heros.length;
            if (len == 0)
            {
                JTLogger.error("[Error!]");
            }
            for (var i:int=0; i < len; i++)
            {
                var hero:Object=heros[i] as Object;
                if (type == 0)
                {
                    var monster:MonsterData=MonsterData.monster.getValue(hero.type) as MonsterData;
                    if (monster)
                    {
                        monster=monster.clone() as MonsterData;
                        monster.level=hero.level;
                        monster.hp=hero.hp;
                        monster.seat1=hero.weapon;
                        monster.currenthp=createHP(monster);
                        monster.id=hero.seat;
                        monster.seat=hero.seat;
                        monster.team=HeroData.RED;
                        battleHeros.put(monster.id, monster);
                    }
                    else
                    {
                        createBattleHeros(hero);
                    }
                }
                else
                {
                    createBattleHeros(hero);
                }
            }
        }

        public function createBattleHeros(hero:Object):void
        {
            var heroData:HeroData=HeroData.hero.getValue(hero.type) as HeroData;
            heroData=heroData.clone() as HeroData;
            heroData.level=hero.level;
            heroData.hp=hero.hp;
            heroData.seat1=hero.weapon;
            heroData.id=hero.seat;
            heroData.seat=hero.seat;
            heroData.team=HeroData.RED;
            heroData.currenthp=createHP(heroData);
            battleHeros.put(heroData.id, heroData);
        }

        public function getMaxLevelHero():HeroData
        {
            var returnHero:HeroData;
            var list:Vector.<*>=hash.values();
            var len:int=list.length;
            var heroData:HeroData;
            for (var i:int=0; i < len; i++)
            {
                heroData=list[i] as HeroData;
                if (returnHero == null || heroData.level > returnHero.level)
                    returnHero=heroData;
            }
            return returnHero;
        }

        public function getPower():uint
        {
            var power:uint=0;
            var list:Vector.<*>=hash.values();
            var len:int=list.length;
            var heroData:HeroData;
            for (var i:int=0; i < len; i++)
            {
                heroData=list[i] as HeroData;
                if (heroData && heroData.seat > 0)
                {
                    power+=heroData.getPower;
                }
            }
            return power;
        }

        public function getEnemyPower():uint
        {
            var power:uint=0;
            var list:Vector.<*>=battleHeros.values();
            var len:int=list.length;
            var heroData:HeroData;
            for (var i:int=0; i < len; i++)
            {
                heroData=list[i] as HeroData;
                if (heroData && heroData.seat > 0)
                {
                    power+=heroData.getPower;
                }
            }
            return power;
        }

        /**
         * 创建一个战斗内英雄
         * @return
         */
        public function createHero(hero:HeroData):void
        {
            var sourceHero:HeroData=hero;
            hero=hero.clone() as HeroData;
            hero.id=hero.seat; // 战斗内，以位置作为唯一标识
            hero.currenthp=createHP(hero); // 战斗内英雄的血量要计算该英雄的光环
            hero.hp=hero.currenthp;
            hero.sourceHero=sourceHero;
            hero.team=int(hero.seat / 10) == 1 ? HeroData.BLUE : HeroData.RED;
            battleHeros.put(hero.id, hero);
        }

        // 计算战斗内英雄光环的血量。
        private function createHP(heroData:HeroData):int
        {
            var hp:int=heroData.hp;
            var v:Number=1.0;
            for (var i:int=0; i < 3; i++)
            {
                var skill:int=heroData["skill" + (i + 1)];
                if (skill > 0)
                {
                    var skillData:SkillData=SkillData.getSkill(skill);
                    var cmd:String=skillData.cmd;
                    var trigger:String=skillData.trigger;
                    if (cmd.indexOf("add_hp") != -1 && trigger.indexOf("init") != -1)
                    {
                        var reg:RegExp=/[(\d+)](\.\d+)?/g
                        var arr:Array=cmd.match(reg);
                        v+=Number(arr[0]);
                    }
                }
            }
            return hp * v;
        }


        /**获取SP百分比*/
        public function heroSpPercent(heroData:HeroData):int
        {
            var percent:Number=0;
            var par:Number=heroData.addSp / 100;
            var hp:int=0;
            if (heroData.oldHp <= 0)
            {
                heroData.oldHp=heroData.hp;
            }
            hp=heroData.oldHp;
            var fz:Number=heroData.currenthp - hp * par;
            var fm:Number=hp - hp * par;
            if (fz <= 0)
            {
                percent=1;
            }
            else
            {
                percent=1 - (fz / fm);
                if ((fz / fm) <= 0)
                {
                    percent=1;
                }
            }
            return int(percent * 100);
        }



        public function getAllHeroFieldByType(type:String):int
        {
            var i:int;
            var return_value:int=0;
            hash.eachValue(fun);

            function fun(data:HeroData):void
            {
                if (data.seat == 0)
                    return;
                return_value+=data[type];
            }
            return return_value;
        }


        public function getAllHeroEquipFieldByType(type:String):int
        {
            var i:int;
            var widget:WidgetData;
            var return_value:int=0;
            hash.eachValue(fun);

            function fun(data:HeroData):void
            {
                if (data.seat == 0)
                    return;
                for (i=1; i <= 5; i++)
                {
                    if (data["seat" + i] == 0)
                        continue;
                    widget=WidgetData.hash.getValue(data["seat" + i]);
                    return_value+=widget[type];
                }
            }
            return return_value;
        }

        public function getAllHeroEquipGemFieldByType(type:String):int
        {
            var i:int;
            var j:int;
            var len:int;
            var gemData:Goods;
            var widget:WidgetData;
            var return_value:int=0;
            hash.eachValue(fun);

            function fun(data:HeroData):void
            {
                if (data.seat == 0)
                    return;
                for (i=1; i <= 5; i++)
                {
                    if (data["seat" + i] == 0)
                        continue;
                    widget=WidgetData.hash.getValue(data["seat" + i]);
                    len=widget.sockets.length;

                    for (j=0; j < len; j++)
                    {
                        gemData=Goods.goods.getValue(widget.sockets[j].id);
                        return_value+=gemData[type];
                    }
                }
            }
            return return_value;
        }
    }
}

