package game.view.tavern.data
{
    import com.singleton.Singleton;

    import game.net.data.IData;
    import game.net.data.vo.GateHero;
    import game.net.data.vo.TavernHeroVo;
    import game.net.data.vo.heroSoulList;
    import game.view.data.Data;

    public class TavernData
    {
        public static function get instance():TavernData
        {
            return Singleton.getInstance(TavernData) as TavernData;
        }
        /**酒馆*/
        public var heroList:Vector.<IData>;
        public var fushData1:Data=new Data();

        /**佣兵数据列表[GateHero{id:佣兵id,state:佣兵状态}]*/
        public var MercenaryList:Vector.<IData>=null;

        /**命运之论*/
        public var heroSoulVector:Vector.<IData>;
        public var fushData2:Data=new Data();
        public var fushData3:Data=new Data();
        public var leftTimes:uint=0;


        /**获取雇佣兵*/
        public function GetMercenarDataById(id:uint):GateHero
        {
            var i:int=0, len:int=MercenaryList.length;
            for (i; i < len; i++)
            {
                if ((MercenaryList[i] as GateHero).id == id)
                    return MercenaryList[i] as GateHero;
            }
            return null;
        }

        /**获取可以抽取的魂*/
        public function get hasSoul():int
        {
            var num:int=0;
            for each (var hs:heroSoulList in TavernData.instance.heroSoulVector)
            {
                if (hs.type == 0)
                {
                    num++;
                }
            }
            return num;
        }

        /**是否有英雄被锁上*/
        public function get isLock():Boolean
        {
            var i:int=0, length:int=heroList.length;
            for (i; i < length; i++)
            {
                if ((heroList[i] as TavernHeroVo).lock == 1)
                    return true;
            }
            return false;
        }
    }
}
