package game.net.message
{
    import com.dialog.Dialog;
    import com.dialog.DialogMgr;
    import com.langue.Langue;
    import com.scene.SceneMgr;
    import com.view.base.event.EventType;

    import flash.utils.getDefinitionByName;

    import avmplus.getQualifiedClassName;

    import game.common.JTLogger;
    import game.data.Goods;
    import game.data.HeroData;
    import game.data.TollgateData;
    import game.data.WidgetData;
    import game.manager.GameMgr;
    import game.manager.HeroDataMgr;
    import game.net.data.IData;
    import game.net.data.c.CEmbattle;
    import game.net.data.c.CFbNightmare;
    import game.net.data.c.CFbNightmareInfo;
    import game.net.data.c.CVideoInfo;
    import game.net.data.c.CVideoRank;
    import game.net.data.s.SEmbattle;
    import game.net.data.s.SFbNightmare;
    import game.net.data.s.SFbNightmareInfo;
    import game.net.data.s.SVideoInfo;
    import game.net.data.s.SVideoRank;
    import game.net.data.vo.HeroPosition;
    import game.net.data.vo.NightmareInfo;
    import game.net.data.vo.videoRankList;
    import game.net.message.base.Message;
    import game.scene.BattleLoader;
    import game.scene.world.NewFbScene;
    import game.scene.world.NewMainWorld;
    import game.scene.world.NighteMareView;
    import game.view.city.CityFace;
    import game.view.loginReward.ResignDlg;

    /**
     * 游戏通信
     * @author hyy
     *
     */
    public class GameMessage extends Message
    {
        private static var nightMare_id:int;
        private static var cur_sceneClass:Class;
        private static var cur_dialogClass:Array;
        private static var cur_param:Array;

        public function GameMessage()
        {
            super();
        }

        override protected function addListenerHandler():void
        {
            this.addHandler(SEmbattle.CMD, emBattleNotification);
            this.addHandler(SVideoRank.CMD, battleRankNotify);
            this.addHandler(SVideoInfo.CMD, battleRankVideoInfoNotify);
            this.addHandler(SFbNightmareInfo.CMD, fbNightmareInfoNotify);
            this.addHandler(SFbNightmare.CMD, checkFbNightmareStatusNotify);
        }

        public static function removeBackDialog(dialogClass:Class):void
        {
            var obj:*=getQualifiedClassName(dialogClass);

            if (cur_dialogClass)
            {
                var len:int=cur_dialogClass.length;

                for (var i:int=0; i < len; i++)
                {
                    if (obj == cur_dialogClass[i])
                    {
                        cur_dialogClass.splice(i, 1);
                        break;
                    }
                }
            }
        }

        /**
         * 战斗返回
         * @return
         *
         */
        public static function gotoTollgateBack():Boolean
        {
            if (cur_sceneClass == null && cur_dialogClass == null)
                return false;
            DialogMgr.instance.closeAllDialog();
            cur_sceneClass && SceneMgr.instance.changeScene(cur_sceneClass);
            var len:int=cur_dialogClass.length;

            for (var i:int=0; i < len; i++)
            {
                DialogMgr.instance.open(cur_dialogClass[i], cur_param[i]);
            }
            return true;
        }

        /**
         * 用上次记录的数据进入关卡/副本
         * @param id
         *
         */
        public static function gotoOldTollgateData(id:int):void
        {
            gotoTollgateData(id, cur_sceneClass, cur_dialogClass, cur_param)
        }

        /**
         * 检测是否可以进入关卡/副本
         * @param id
         *
         */
        public static function gotoTollgateData(id:int, sceneClass:Class=null, dialogClass:Array=null, param:Array=null):void
        {
            cur_sceneClass=sceneClass;
            cur_dialogClass=dialogClass;
            cur_param=param;

            var tollgateData:TollgateData=TollgateData.hash.getValue(id);

            if (tollgateData == null)
            {
                JTLogger.warn("找不到关卡：" + id);
                return;
            }

            if (GameMgr.instance.tired < tollgateData.tired)
            {
                GoodsMessage.onBuyTiredClick();
                return;
            }

            checkGoods();

            function checkGoods():void
            {
                var goods:Goods=tollgateData.castNightmareGoods;

                //需要物品，并且玩家有需要的物品
                if (goods && WidgetData.pileByType(goods.type) >= goods.pile)
                {
                    var tip:ResignDlg=DialogMgr.instance.open(ResignDlg) as ResignDlg;
                    tip.text=Langue.getLangue("cast_nightmare_goods").replace("*", goods.pile + "x" + goods.name);
                    tip.onResign.addOnce(onBuyReturn);
                    tip.onClose.addOnce(onCloseReturn);

                    function onBuyReturn():void
                    {
                        loaderGame(id, tollgateData.isFb ? 2 : 0);
                    }

                    function onCloseReturn():void
                    {
                        if (SceneMgr.instance.getCurScene() is CityFace)
                            return;

                        if (GameMgr.instance.tired < tollgateData.tired)
                        {
                            NewMainWorld.buy_tired=true;
                        }

                        if (GameMgr.instance.game_type == GameMgr.MAIN_LINE)
                        {
                            SceneMgr.instance.changeScene(NewMainWorld);
                        }
                        else if (GameMgr.instance.game_type == GameMgr.FB)
                        {
                            SceneMgr.instance.changeScene(NewFbScene);
                        }
                    }
                }
                //需要物品，但是玩家没有该道具
                else if (goods)
                {
                    DialogMgr.instance.open(NighteMareView, goods);
                }
                else
                {
                    if (tollgateData.isNightMare)
                    {
                        nightMare_id=id;
                        GameMessage.getCheckFbNightmareStatus(id);
                    }
                    else
                    {
                        loaderGame(id, tollgateData.isFb ? 2 : 0);
                    }
                }
            }
        }


        public static function loaderGame(id:int, pos:int=0):void
        {
            (new BattleLoader).load(id, pos);
        }

        /**
         * 空的不能删除,自动移除loader
         * @param info
         *
         */
        private function emBattleNotification(info:SEmbattle):void
        {

        }

        /**
         * 发送布阵信息
         *
         */
        public static function sendEmBattle():void
        {
            var send_list:Vector.<IData>=new Vector.<IData>;
            // 关闭英雄对话框保存布阵
            var tmp_list:Array=HeroDataMgr.instance.getOnBattleHero();
            var len:int=tmp_list.length;
            var heroData:HeroData;

            for (var i:int=0; i < HeroDataMgr.instance.seatMax; i++)
            {
                heroData=tmp_list[i];

                if (heroData == null)
                    continue;
                var data:HeroPosition=new HeroPosition();
                data.id=heroData.id;
                data.position=heroData.seat;
                send_list.push(data);
            }

            var cmd:CEmbattle=new CEmbattle();
            cmd.heroes=send_list;
            sendMessage(cmd);
        }

        /**
         * 获得关卡最佳战斗列表
         *
         */
        public static function sendBattleRank(id:int):void
        {
            var cmd:CVideoRank=new CVideoRank();
            cmd.tollgateid=id;
            sendMessage(cmd);
        }

        private function battleRankNotify(info:SVideoRank):void
        {
            var len:int=info.videoRankInfo.length;
            var tmp_list:Array=[];
            var data:videoRankList;

            for (var i:int=0; i < 3; i++)
            {
                data=i >= len ? null : info.videoRankInfo[i] as videoRankList;
                tmp_list.push(data ? {name: data.name, power: data.power, picture: data.picture, index: i} : null);
            }
            tmp_list.sortOn("power", Array.NUMERIC);
            this.dispatch(EventType.UPDATE_BATTLE_VIDEO_RANK, tmp_list);
        }

        /**
         * 查看录像
         * @param id
         * @param tollgateid
         *
         */
        public static function sendBattleRankVideoInfo(id:int, tollgateid:int):void
        {
            var cmd:CVideoInfo=new CVideoInfo();
            cmd.tollgateid=tollgateid;
            cmd.id=id;
            sendMessage(cmd);
        }

        private function battleRankVideoInfoNotify(info:SVideoInfo):void
        {

        }

        /**
         * 请求噩梦评星
         *
         */
        public static function getFbNightmareInfo():void
        {
            var cmd:CFbNightmareInfo=new CFbNightmareInfo();
            sendMessage(cmd);
        }

        private function fbNightmareInfoNotify(info:SFbNightmareInfo):void
        {
            var len:int=info.nightmareInfo.length;
            var render:NightmareInfo;
            var tollgateData:TollgateData;

            for (var i:int=0; i < len; i++)
            {
                render=info.nightmareInfo[i] as NightmareInfo;
                tollgateData=TollgateData.hash.getValue(render.id);
                tollgateData.nightmare_star=render.star;

                if (tollgateData.nightmareData)
                    tollgateData.nightmareData.nightmare_star=render.star;
            }
            dispatch(EventType.UPDATE_MAINLINE_STAR);
        }

        /**
         * 检测噩梦是否可以进入
         *
         */
        public static function getCheckFbNightmareStatus(id:int):void
        {
            var cmd:CFbNightmare=new CFbNightmare();
            cmd.id=id;
            sendMessage(cmd);
        }

        private function checkFbNightmareStatusNotify(info:SFbNightmare):void
        {
            switch (info.code)
            {
                case 0:
                    if (nightMare_id > 0)
                        loaderGame(nightMare_id);
                    break;
                case 1:
                    addTips("nightmare1");
                    break;
                case 2:
                    addTips("nightmare2");
                    break;
                case 3:
                    addTips("nightmare3");
                    break;
                default:
                    addTips(getLangue("codeError") + info.code);
                    break;
            }
        }
    }
}

