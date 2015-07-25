package game.net.message
{
    import com.dialog.DialogMgr;
    import com.langue.Langue;
    import com.sound.SoundManager;
    import com.view.base.event.EventType;
    
    import game.data.ConfigData;
    import game.data.Goods;
    import game.data.HeroData;
    import game.data.ShopData;
    import game.data.VipData;
    import game.data.WidgetData;
    import game.manager.GameMgr;
    import game.manager.HeroDataMgr;
    import game.net.GameSocket;
    import game.net.data.c.CBuy_tired;
    import game.net.data.c.CColiseumBuy;
    import game.net.data.c.CGetMagicOrbs;
    import game.net.data.c.CHeroPotion;
    import game.net.data.c.CJewelry;
    import game.net.data.c.CShop;
    import game.net.data.s.SBuy_tired;
    import game.net.data.s.SColiseumBuy;
    import game.net.data.s.SGetMagicOrbs;
    import game.net.data.s.SHeroPotion;
    import game.net.data.s.SJewelry;
    import game.net.data.s.SShop;
    import game.net.message.base.Message;
    import game.view.arena.ConvertPropsDlg;
    import game.view.loginReward.ResignDlg;
    import game.view.uitils.FunManager;
    
    import sdk.DataEyeManger;

    public class GoodsMessage extends Message
    {
        private static var buy_id:int;
        private static var hero_id:int;
        private static var hero_level:int;
        public static var buy_tired_count:int;

        public function GoodsMessage()
        {
            super();
        }

        override protected function addListenerHandler():void
        {
            this.addHandler(EventType.CONNNECT, onConnected);
            this.addHandler(SShop.CMD, onShopNoitfy);
            this.addHandler(SBuy_tired.CMD, onBuyTiredNoitfy);
            this.addHandler(SHeroPotion.CMD, onUseExpNotify);
            this.addHandler(SColiseumBuy.CMD, buyPvpEquipNotify);
			this.addHandler(SJewelry.CMD, autoTest111);
			this.addHandler(SGetMagicOrbs.CMD, autoTest);
        }
public static var isOpen:Boolean=false;
        private function onConnected():void
        {
            buy_tired_count=0;
            buy_id=0;
        }

        /**
         * 发送购买物品
         * @param id
         *
         */
        public static function onSendBuyItem(id:int):void
        {
            if (buy_id != 0)
                return;
            var sendBuyShop:CShop=new CShop();
            buy_id=sendBuyShop.id=id;
            sendMessage(sendBuyShop);
        }

        private function onShopNoitfy(info:SShop):void
        {
            switch (info.code)
            {
                case 0:
                    var goods:ShopData=ShopData.hash.getValue(buy_id);
                    DataEyeManger.instance.buyItem(goods.name, goods.cost, goods.count);
                    addTips("buySuccess");
                    SoundManager.instance.playSound("deal");
                    break;
                case 1:
                    addTips("notEnoughCoin");
                    break;
                case 2:
                    addTips("diamendNotEnough");
                    break;
                case 3:
                    addTips("packFulls");
                    break;
                default:
                    addTips("codeError");
                    break;
            }
            buy_id=0;
        }

        /**
         * 购买疲劳
         *
         */
        public static function onBuyTiredClick():void
        {
            var money:int=FunManager.power_buy(GoodsMessage.buy_tired_count);
            var tip:ResignDlg=DialogMgr.instance.open(ResignDlg) as ResignDlg;
            tip.text=Langue.getLangue("buyTired").replace("*", money);
            tip.onResign.addOnce(onBuyReturn);

            function onBuyReturn():void
            {
                if (money > GameMgr.instance.diamond)
                {
                    addTips("diamendNotEnough");
                    return;
                }

                else if (GameMgr.instance.tired >= ConfigData.instance.tired_max)
                {
                    addTips("TiredFull");
                    return;
                }

                var vipData:VipData=GameMgr.instance.vipData.baseVip;
                var needVip:int=vipData.getVipByTiredCount(GoodsMessage.buy_tired_count + 1);

                if ((GoodsMessage.buy_tired_count + 1) >= vipData.tired_buy && vipData.id < needVip)
                {
                    addTips(Langue.getLangue("vip_tried_buy").replace("*", needVip).replace("*", GoodsMessage.buy_tired_count + 1));
                    return;
                }

                GoodsMessage.onSendBuyTired();
            }
        }

        /**
         * 购买PVP装备
         * @param type
         *
         */
        public static function onSendBuyPvpEquip(type:int):void
        {
            var cmd:CColiseumBuy=new CColiseumBuy;
            cmd.id=type;
            sendMessage(cmd);
        }

        private function buyPvpEquipNotify(info:SColiseumBuy):void
        {
            switch (info.code)
            {
                case 0:
                    SoundManager.instance.playSound("deal");
                    DialogMgr.instance.deleteDlg(ConvertPropsDlg);
                    addTips("convertSuccess");
                    break;
                case 1:
                    addTips("honorError");
                    break;
                case 3:
                    addTips("packFulls");
                    break;
            }
        }

        /**
         * 购买疲劳
         *
         */
        public static function onSendBuyTired():void
        {
            var cmd:CBuy_tired=new CBuy_tired();
            sendMessage(cmd);
        }

        private function onBuyTiredNoitfy(info:SBuy_tired):void
        {
            switch (info.code)
            {
                case 0:
                    var money:int=FunManager.power_buy(buy_tired_count);
                    GameMgr.instance.tired=info.tired;
                    buy_tired_count=info.num;
                    DataEyeManger.instance.buyItem(DataEyeManger.BUY_TIRED, money, 100, DataEyeManger.BUY_TIRED);
                    this.dispatch(EventType.UPDATE_TIRED);
                    addTips("buySuccess");
                    break;
                case 1:
                    addTips("diamendNotEnough");
                    break;
                case 2:
                    addTips("TiredFull");
                    break;
                case 4:
                    addTips("vip_max");
                    break;
                case 127:
                    addTips("codeError");
                    break;
            }
        }

        /**
         * 请求使用经验药水
         *
         */
        public static function onSendUseExp(heroId:int, goodsid:int):void
        {
            var hero:HeroData=HeroDataMgr.instance.getHeroInfo(heroId);
            hero_level=hero.level;
            var cmd:CHeroPotion=new CHeroPotion();
            hero_id=cmd.id=heroId;
            cmd.mats=goodsid;
            sendMessage(cmd);
        }

        private function onUseExpNotify(info:SHeroPotion):void
        {
            switch (info.code)
            {
                case 0:
                    addTips("USE_SUCCESS");
                    if (hero_level < info.level)
                    {
                        dispatch(EventType.PLAY_HERO_ANIMATION, info.level); //升级
                    }
                    dispatch(EventType.UPDATE_HERO_INFO); //没升级加经验
                    break;
                case 1:
                    addTips("materialNotEnough"); //材料不足
                    break;
                case 2:
                    addTips("maxLevel");
                    break;
                default:
                    addTips("codeError");
                    break;
            }
        }

        private static var curr_Goods:Goods;

        public static function autoTest111(info:SJewelry):void
        {
			if(!isOpen)
				return;
            if (curr_Goods)
            {
                curr_Goods.exp=info.exp;
                curr_Goods.level=info.level;
            }
            autoTest();
        }

        public static function autoTest():void
        {
			if(!isOpen)
				return;
            var arr:Array=WidgetData.getBySort(4, 2);
            var len1:int=arr.length;
            var goods:WidgetData;
            var eat_goods:WidgetData;
            var max_level:int=5;

            if (curr_Goods == null || curr_Goods.level == max_level)
            {
                for (var i:int=0; i < len1; i++)
                {
                    goods=arr[i] as WidgetData;

                    if (goods.quality > 3 && goods.level < max_level)
                    {
                        curr_Goods=goods;
                    }
                }
            }

            if (curr_Goods == null || curr_Goods.level >= max_level)
            {
                trace("没有3级宝珠");
                return;
            }

            for (var j:int=0; j < len1; j++)
            {
                if (arr[j].quality <= 4 && arr[j].level == 1)
                    eat_goods=arr[j] as WidgetData;
            }

            if (eat_goods == null)
            {
                var cmd:CGetMagicOrbs=new CGetMagicOrbs();
                cmd.level=1;
                GameSocket.instance.sendData(cmd);
                trace("购买宝珠");
                return;
            }
            var tmps:Vector.<int>=new Vector.<int>();
            tmps.push(eat_goods.id);
            var cmd1:CJewelry=new CJewelry();
            var ids:Vector.<int>=new Vector.<int>();
            cmd1.id=curr_Goods.id;
            cmd1.ids=tmps;
            GameSocket.instance.sendData(cmd1);
            trace("吞噬:", curr_Goods.id, curr_Goods.name, curr_Goods.level, curr_Goods.exp)
        }
    }
}
