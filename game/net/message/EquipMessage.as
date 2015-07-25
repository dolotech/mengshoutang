package game.net.message
{
    import com.components.RollTips;
    import com.dialog.DialogMgr;
    import com.sound.SoundManager;
    import com.view.base.event.EventType;

    import flash.utils.Dictionary;
    import flash.utils.getTimer;

    import game.data.Goods;
    import game.data.HeroData;
    import game.data.StrengthenData;
    import game.data.WidgetData;
    import game.manager.GameMgr;
    import game.manager.HeroDataMgr;
    import game.net.data.IData;
    import game.net.data.c.CEmbed;
    import game.net.data.c.CForge;
    import game.net.data.c.CHeroDismissal;
    import game.net.data.c.CHeroStar;
    import game.net.data.c.CHeroTab;
    import game.net.data.c.COversellItem;
    import game.net.data.c.CPurge;
    import game.net.data.c.CSetEquip;
    import game.net.data.c.CStrengthen;
    import game.net.data.c.CStrengthenCD;
    import game.net.data.c.CUnembed;
    import game.net.data.s.SEmbed;
    import game.net.data.s.SForge;
    import game.net.data.s.SHeroDismissal;
    import game.net.data.s.SHeroStar;
    import game.net.data.s.SHeroTab;
    import game.net.data.s.SOversellItem;
    import game.net.data.s.SPurge;
    import game.net.data.s.SSetEquip;
    import game.net.data.s.SStrengthen;
    import game.net.data.s.SStrengthenCD;
    import game.net.data.s.SUnembed;
    import game.net.data.vo.AotoEquipVO;
    import game.net.data.vo.forgeDoneIds;
    import game.net.data.vo.forgeIds;
    import game.net.message.base.Message;
    import game.view.goodsGuide.EquipInfoDlg;

    /**
     * 装备处理
     * @author hyy
     *
     */
    public class EquipMessage extends Message
    {
        private static var autoEquipList:Array=[];
        private static var curr_hero:HeroData;
        private static var curr_forgeId:int;
        private static var sell_widget:Goods;

        public function EquipMessage()
        {
            super();
        }

        override protected function addListenerHandler():void
        {
            this.addHandler(SSetEquip.CMD, updateAutoEquipNotify);
            this.addHandler(SForge.CMD, updateForgeEquipNotify);
            this.addHandler(SStrengthenCD.CMD, updateStrengthenEquipCDNotify);
            this.addHandler(SStrengthen.CMD, strengthenNotify);
            this.addHandler(SPurge.CMD, onPurgeNotify);
            this.addHandler(SHeroStar.CMD, onHeroStar);
            this.addHandler(SEmbed.CMD, onGemNotify);
            this.addHandler(SUnembed.CMD, onUnGemNotify);
            this.addHandler(SHeroTab.CMD, onBuyHeroGridNotify);
            this.addHandler(SHeroDismissal.CMD, onHeroDismissalNotify);
            this.addHandler(SOversellItem.CMD, onSellGoodsNotify);
            this.addHandler(EventType.CONNNECT, onConnected);
        }

        private function onConnected():void
        {
            curr_hero=null;
            sell_widget=null;
            curr_forgeId=0;
            autoEquipList.length=0;
            list_strengthenCD.length=0;
        }

        /**
         * 合成装备
         * @param forgeId
         *
         */
        public static function sendForgeGoods(forgeId:int):void
        {
            if (curr_forgeId != 0)
            {
                trace("正在合成装备", forgeId)
                return;
            }
            var cmd:CForge=new CForge();
            var ids:Vector.<IData>=new Vector.<IData>();
            var data:forgeIds=new forgeIds();
            data.id=curr_forgeId=forgeId;
            ids.push(data);
            cmd.ids=ids;
            sendMessage(cmd);
        }

        /**
         * 合成装备
         * @param view
         * @param info
         *
         */
        private function updateForgeEquipNotify(info:SForge):void
        {
            var props:Vector.<IData>=info.ids;
            var len:int=props.length;
            curr_forgeId=0;

            for (var i:int=0; i < len; ++i)
            {
                var forgeDoneData:forgeDoneIds=props[i] as forgeDoneIds;

                if (0 == forgeDoneData.type)
                {
                    SoundManager.instance.playSound("hechengchenggong");
                }
                else if (1 == forgeDoneData.type)
                {
                    addTips("FORGE_FAIL");
                }
                dispatch(EventType.NOTIFY_FORGE_EQUIP, info.code == 0 || info.code == 3);
            }

            if (2 == info.code)
            {
                addTips(("NOT_ENOUGH"));
            }
            else if (3 == info.code)
            {
                addTips("packFulls");
            }
            else if (4 == info.code)
            {
                addTips("notEnoughCoin");
            }
            else if (5 == info.code)
            {
                addTips("diamendNotEnough");
            }
            else if (6 == info.code)
            {
                addTips("EQUIP_FORGE");
            }
        }

        /**
         * 替换装备
         * @param seat
         * @param hero_id
         * @param replce_id 替换ID。0为卸下装备
         *
         */
        public static function sendReplaceEquip(seat:int, heroData:HeroData, replce_id:int):void
        {
            if (curr_hero)
                return;
            var vo:AotoEquipVO=new AotoEquipVO();
            vo.equipID=replce_id;
            vo.seat=seat;
            vo.heroID=heroData.id;
            var cmd:CSetEquip=new CSetEquip();
            cmd.aotoEquipVO=new Vector.<IData>();
            cmd.aotoEquipVO.push(vo);
            //必须记录，否则返回无法操作
            autoEquipList[seat]=vo;
            //必须记录，否则返回无法操作
            curr_hero=heroData;
            sendMessage(cmd);
        }

        /**
         * 装备替换
         * @param view
         * @param info
         *
         */
        private function updateAutoEquipNotify(info:SSetEquip):void
        {
            if (curr_hero == null)
                return;

            switch (info.code)
            {
                case 0:
                    var base_hero:HeroData=HeroDataMgr.instance.map[curr_hero.id];
                    var widgetData:WidgetData;
                    var tips:String="";
                    var index:int=0;
                    for (var i:int=1; i <= 5; i++)
                    {
                        if (autoEquipList[i])
                        {
                            index++;
                            //英雄穿戴了装备了,就卸掉
                            var oldID:int=curr_hero["seat" + i];

                            if (oldID > 0)
                            {
                                widgetData=WidgetData.hash.getValue(oldID);
                                widgetData.equip=0;
                                curr_hero.subEquipProperty(oldID); // 移除该装备属性
                                tips=getLangue("EQUIp_down_success");
                            }
                            else
                            {
                                tips=getLangue("EQUIP_SUCCESS");
                            }

                            var newId:int=autoEquipList[i].equipID;
                            widgetData=WidgetData.hash.getValue(newId);

                            if (widgetData)
                                widgetData.equip=curr_hero.id;
                            base_hero["seat" + i]=newId;
                            curr_hero["seat" + i]=newId;
                            curr_hero.updataEquipProperty(newId); // 添加新装备属性
                        }
                    }
                    if (index > 1)
                        tips=getLangue("EQUIP_SUCCESS");
                    if (tips != "")
                        addTips(tips);
                    this.dispatch(EventType.NOTIFY_HERO_EQUIP, curr_hero);
                    break;
                case 1:
                    RollTips.addLangue("equipPackFull");
                    break;
                case 2:
                    RollTips.addLangue("equipNotLevel");
                    break;
                case 127:
                    RollTips.addLangue("notHero");
                    break;
                case 128:
                    RollTips.addLangue("equipNotEquip");
                    break;
                case 130:
                    RollTips.addLangue("notEquip");
                    break;
                case 131:
                    RollTips.addLangue("equipOathHero");
                    break;
                default:
                    break;
            }
            curr_hero=null;
            autoEquipList.length=0;
            dispatch(EventType.UPDATE_POWER);
        }

        /**
         * 发送自动换装消息
         * @param curr_hero
         * @param tmp_list
         *
         */
        public static function sendAutoEquip(heroData:HeroData, tmp_list:Array):void
        {
            if (curr_hero)
                return;
            var weapon_id:int;
            var widget:WidgetData;
            var beat_widget:WidgetData;
            var aotoEquipVO:AotoEquipVO;
            var tmp_autoEquip:Vector.<IData>=new Vector.<IData>();

            for (var i:int=1; i <= 5; i++)
            {
                widget=tmp_list[i - 1];

                beat_widget=widget.getBestEquipByHero(heroData);

                if (beat_widget && beat_widget.id != widget.id)
                {
                    aotoEquipVO=new AotoEquipVO();
                    aotoEquipVO.equipID=beat_widget.id;
                    aotoEquipVO.heroID=heroData.id;
                    aotoEquipVO.seat=i;
                    //必须记录，否则返回无法操作
                    tmp_autoEquip.push(aotoEquipVO);
                }
                autoEquipList[i]=aotoEquipVO;
                aotoEquipVO=null;
            }

            if (tmp_autoEquip.length == 0)
            {
                RollTips.addLangue("noreplceEquip");
                autoEquipList.length=0;
                return;
            }
            //必须记录，否则返回无法操作
            curr_hero=heroData;
            var cmd:CSetEquip=new CSetEquip();
            cmd.aotoEquipVO=tmp_autoEquip;
            sendMessage(cmd);
        }

        /**
         * 获取强化装备的CD
         * @param equip_id
         *
         */
        private static var list_strengthenCD:Array=[];
        private static var dic_strengthen:Dictionary=new Dictionary();

        public static function sendStrengthenCD(equip_id:int):void
        {
            if (equip_id == 0)
                return;
            list_strengthenCD.push(equip_id);
            var cmd:CStrengthenCD=new CStrengthenCD();
            cmd.equid=equip_id;
            sendMessage(cmd, false);
        }

        private function updateStrengthenEquipCDNotify(info:SStrengthenCD):void
        {
            if (info.code == 0)
            {
                var equip_id:int=list_strengthenCD.shift();
                dic_strengthen[equip_id]=info.time;
                dic_strengthen[equip_id + "time"]=getTimer();
                this.dispatch(EventType.NOTIFY_STRENGTHEN_CD, info.time);
            }
            else
            {
                addTips("程序异常:" + info.code);
            }
        }

        /**
         * 强化装备
         * @param equip_id
         * @param list_stone
         *
         */
        public static function sendStrengthenEquip(equip_id:int, list_stone:Array):void
        {
            var lastTime:int=dic_strengthen[equip_id];
            var currTime:int=dic_strengthen[equip_id + "time"];
            lastTime=lastTime - (getTimer() - currTime) / 1000;

            var cmd:CStrengthen=new CStrengthen();
            cmd.pay=lastTime > 0 ? 1 : 0;

            for (var i:int=0; i < 3; i++)
            {
                cmd["enId" + (i + 1)]=list_stone[i] ? list_stone[i].type : 0;
            }
            cmd.equid=equip_id;
            sendMessage(cmd);
        }

        private function strengthenNotify(info:SStrengthen):void
        {
            var tip_msg:String="";
            var isDemotion:Boolean;

            switch (info.code)
            {
                //强化成功
                case 0:
                    updateStrengthenWidget();
                    tip_msg="strengthenOk";
                    //最高等级
                    if (info.level == 15)
                        tip_msg="strengthenMax";

                    SoundManager.instance.playSound("qianghuachenggong");
                    break;
                //强化失败
                case 1:
                    updateStrengthenWidget();
                    tip_msg=isDemotion ? "strengthenFail1" : "strengthenFail";
                    SoundManager.instance.playSound("qianghuashibai");
                    break;
                case 2:
                    tip_msg="notEnoughCoin";
                    break;
                case 3:
                    tip_msg="strengthenTired";
                    break;
                case 4:
                    tip_msg="materialNotEnough";
                    break;
                case 5:
                    tip_msg="strengthenTop";
                    break;
                case 6:
                    tip_msg="diamendNotEnough";
                    break;
                case 7:
                    tip_msg="NON_STRENGTHEN";
                    break;
                default:
                    tip_msg="strengthenProgramFail";
                    break;
            }

            function updateStrengthenWidget():void
            {
                var widget:WidgetData=WidgetData.hash.getValue(info.equid);

                //更新装备属性
                var strengthenData:StrengthenData=StrengthenData.hash.getValue(widget.sort + "" + info.level);
                var heroData:HeroData=widget.equip > 0 ? HeroDataMgr.instance.hash.getValue(widget.equip) : null;

                //升级
                if (info.level > widget.level)
                {
                    heroData && heroData.subEquipProperty(widget.id);
                    widget.addStrengthen(strengthenData.rise);
                    heroData && heroData.updataEquipProperty(widget.id);
                }

                //降级
                if (info.level < widget.level)
                {
                    isDemotion=true;
                    heroData && heroData.subEquipProperty(widget.id);
                    widget.removeStrengthen(strengthenData.rise);
                    heroData && heroData.updataEquipProperty(widget.id);
                }
                widget.level=info.level;
                dispatch(EventType.UPDATE_HERO_EQUIP, widget);
            }

            if (tip_msg != "")
                addTips(tip_msg);
            dispatch(EventType.NOTIFY_STRENGTHEN, {"isSuccess": info.code == 0 || info.code == 3, id: info.equid});
            dispatch(EventType.UPDATE_POWER);
        }

        /**
         * 镶嵌宝石
         * @param equip_id
         * @param list_gem
         *
         */
        public static function sendInputGem(equip_id:int, gem_id:int):void
        {
            var cmd:CEmbed=new CEmbed();
            cmd.equid=equip_id
            cmd.gemid=gem_id;
            sendMessage(cmd);
        }

        private function onGemNotify(info:SEmbed):void
        {
            switch (info.code)
            {
                case 0:
                    //附魔成功
                    addTips("ENCHANTING_SUCCESS");
                    this.dispatch(EventType.UPDATE_EQUIP_GEM);
                    break;
                case 1:
                    addTips("ENCHANTING_LOSE");
                    break;
                case 2:
                    addTips("NOTMONEY_UP");
                    break;
                case 3:
                    break;
                case 127:
                    addTips(getLangue("ENCHANTING_LOSE_ERROR") + ",code:" + info.code);
                    break;
                default:
                    break;
            }
            dispatch(EventType.UPDATE_POWER);
        }

        /**
         * 卸载宝石
         * @param equip_id
         * @param list_gem
         *
         */
        public static function sendUnGem(equip_id:int, gem_id:int):void
        {
            var cmd:CUnembed=new CUnembed();
            cmd.equid=equip_id
            cmd.gemid=gem_id;
            sendMessage(cmd);
        }

        private function onUnGemNotify(info:SUnembed):void
        {
            switch (info.code)
            {
                case 0:
                    addTips("UNENCHANTING_SUCCESS");
                    this.dispatch(EventType.UPDATE_EQUIP_GEM);
                    break;
                case 1:
                    addTips("NOTMONEY_UP");
                    break;
                case 2:
                    addTips("diamendNotEnough");
                    break;
                case 3:
                    addTips("packFulls");
                    break;
                case 127:
                    addTips(getLangue("ENCHANTING_LOSE_ERROR") + ",code:" + info.code);
                    break;
                default:
                    break;
            }
            dispatch(EventType.UPDATE_POWER);
        }

        /**
         * 英雄进阶
         * @param curr_hero
         *
         */
        public static function sendJinjieMessage(tmp_hero:HeroData):void
        {
            curr_hero=tmp_hero;
            var cmd:CPurge=new CPurge();
            cmd.heroid=curr_hero.id; //.id;
            sendMessage(cmd);
        }


        private function onPurgeNotify(info:SPurge):void
        {
            if (curr_hero == null)
                return;

            switch (info.code)
            {
                case 0:
                    var quality:int=curr_hero.getUpQuality();
                    curr_hero.updateQualityPropertys(quality);
                    curr_hero.quality=quality;
                    this.dispatch(EventType.NOTIFY_HERO_PURGE, curr_hero);
                    addTips("purgeSuccess"); //净化成功
                    break;
                case 1:
                    addTips("notEnoughCoin"); //金币不足
                    break;
                case 2:
                    addTips("diamendNotEnough"); //钻石不足
                    break;
                case 3:
                    addTips("materialNotEnough"); //材料不足
                    break;
                case 4:
                    addTips("MAXQUALITY"); //英雄已经是最高品质
                    break;
                default:
                    addTips(getLangue("codeError") + ",code:" + info.code);
                    break;
            }
            dispatch(EventType.UPDATE_POWER);
            curr_hero=null;
        }


        /**
         * 英雄升星
         * @param curr_hero
         *
         */
        public static function sendStarMessage(tmp_hero:HeroData):void
        {
            curr_hero=tmp_hero;
            var cmd:CHeroStar=new CHeroStar();
            cmd.heroid=curr_hero.id;
            sendMessage(cmd);
        }

        private function onHeroStar(info:SHeroStar):void
        {
            if (curr_hero == null)
                return;

            switch (info.code)
            {
                case 0:
                    curr_hero.updateStarPropertys(curr_hero.foster);
                    this.dispatch(EventType.NOTIFY_HERO_STAR, curr_hero);
                    addTips("starSuccess"); //升星成功
                    break;
                case 1:
                    addTips("starFail"); //升星失败
                    break;
                case 2:
                    addTips("starMax"); //升星达到上限
                    break;
                case 3:
                    addTips("notEnoughCoin"); //金币不足
                    break;
                case 4:
                    addTips("diamendNotEnough"); //钻石不足
                    break;
                case 5:
                    addTips("materialNotEnough"); //材料不足
                    break;
                default:
                    addTips(getLangue("codeError") + ",code:" + info.code);
                    break;
            }
            curr_hero=null;

        }


        /**
         * 解散英雄
         * @param tmp_hero
         *
         */
        public static function sendDissolutionMessage(tmp_hero:HeroData):void
        {
            var cmd:CHeroDismissal=new CHeroDismissal();
            curr_hero=tmp_hero;
            cmd.id=tmp_hero.id;
            sendMessage(cmd);
        }

        private function onHeroDismissalNotify(info:SHeroDismissal):void
        {
            switch (info.code)
            {
                case 0:
                    this.dispatch(EventType.REMOVE_HERO);
                    curr_hero.unAllEquip();
                    HeroDataMgr.instance.hash.remove(curr_hero.id);
                    this.dispatch(EventType.REMOVE_HERO, curr_hero);
                    break;
                case 3:
                    addTips("heroDismissalBagFull");
                    break;
                case 127:
                    addTips(getLangue("codeError") + ",code:" + info.code);
                    break;
                default:
                    break;
            }
            curr_hero=null;
        }

        /**
         * 购买英雄格子数量
         * @param tmp_hero
         *
         */
        public static function sendDBuyHeroGridMessage():void
        {
            var cmd:CHeroTab=new CHeroTab();
            sendMessage(cmd);
        }

        private function onBuyHeroGridNotify(info:SHeroTab):void
        {
            switch (info.code)
            {
                case 0:
                    GameMgr.instance.hero_gridCount=info.num;
                    addTips("buySuccess");
                    this.dispatch(EventType.BUY_HERO_GRID);
                    break;
                case 1:
                    addTips("diamendNotEnough"); //钻石不足
                    break;
                case 3:
                    addTips("heroGridFull");
                    break;
                case 127:
                    addTips(getLangue("ENCHANTING_LOSE_ERROR") + ",code:" + info.code);
                    break;
                default:
                    break;
            }
        }

        /**
         * 出售物品
         * @param id
         * @param tab
         *
         */
        public static function sendSellGoods(widget:Goods):void
        {
            if (sell_widget)
                return;
            var cmd:COversellItem=new COversellItem;
            cmd.tab=widget.tab;
            var vect:Vector.<int>=new Vector.<int>;
            vect.push(widget.id);
            sell_widget=widget;
            cmd.ids=vect;
            sendMessage(cmd);
        }

        private function onSellGoodsNotify(info:SOversellItem):void
        {
            switch (info.code)
            {
                case 0:
                    addTips("sellOk");
                    SoundManager.instance.playSound("deal");
                    DialogMgr.instance.deleteDlg(EquipInfoDlg);
                    dispatch(EventType.SELL_GOODS, sell_widget);
                    break;
                default:
                    addTips(getLangue("codeError") + info.code);
                    break;
            }
            sell_widget=null;
        }
    }
}
