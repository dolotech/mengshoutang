package game.view.tavern.view {
    import com.components.RollTips;
    import com.dialog.DialogMgr;
    import com.langue.Langue;
    import com.sound.SoundManager;
    import com.view.base.event.EventType;

    import flash.geom.Point;

    import game.data.HeroData;
    import game.data.MercenaryData;
    import game.data.SkillData;
    import game.dialog.ShowLoader;
    import game.manager.AssetMgr;
    import game.manager.GameMgr;
    import game.net.data.c.CHeroBuy;
    import game.net.data.c.CIsHeroBuy;
    import game.net.data.s.SHeroBuy;
    import game.net.data.s.SIsHeroBuy;
    import game.net.data.vo.GateHero;
    import game.net.message.base.Message;
    import game.view.hero.HeroShow;
    import game.view.heroHall.SkillDesDialog;
    import game.view.heroHall.render.StarBarRender;
    import game.view.tavern.TavernDialog;
    import game.view.tavern.data.TavernData;
    import game.view.tavern.render.MercenaryIconRender;
    import game.view.tavern.render.MercenaryListRender;
    import game.view.uitils.Res;
    import game.view.viewBase.EngageViewBase;

    import starling.core.Starling;
    import starling.display.Button;
    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.display.MovieClip;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.text.TextField;
    import starling.textures.Texture;

    /**
     *雇佣兵界面
     * @author lfr
     *
     */
    public class EngageView extends EngageViewBase {
        /**父类引用*/
        private var _selfParent:TavernDialog = null;
        /**佣兵列表*/
        private var _mercenaryList:MercenaryListRender = null;
        /**声音*/
        private var _sound:String;
        /**当前佣兵数据*/
        private var _mercenaryData:MercenaryData = null;
        /**英雄模型显示*/
        private var _heroAvatar:HeroShow = null;
        /**星星*/
        private var _starBar:StarBarRender = null;
        /**动画图标*/
        private var _mcImage:MovieClip = null;
        /**当前操作服务端数据*/
        private var _gateHero:GateHero = null;
        /**是否已经初始化数据*/
        private var isInitData:Boolean;

        public function EngageView(parent:TavernDialog) {
            _selfParent = parent;
            super();
        }

        /**初始化*/
        override protected function init():void {
            //英雄模型
            _heroAvatar = new HeroShow();
            _heroAvatar.x = 150;
            _heroAvatar.y = 270;
            heroPanel.addQuiackChild(_heroAvatar);

            var kuang:Image = heroPanel.getChildByName("kuang") as Image;

            _starBar = new StarBarRender();
            _starBar.x = kuang.x;
            _starBar.y = kuang.y;
            heroPanel.addQuiackChild(_starBar);

            _mercenaryList = new MercenaryListRender();
            _mercenaryList.x = 371;
            _mercenaryList.y = 505;
            _mercenaryList.setSize(520, 100);
            addQuiackChild(_mercenaryList);

            text_num.text = "";
            btn_diamond.touchable = false;
        }

        /**初始化监听*/
        override protected function addListenerHandler():void {
            super.addListenerHandler();
            //收到服务端数据列表
            this.addContextListener(SIsHeroBuy.CMD.toString(), onHeroBuyList);
            //购买成功
            this.addContextListener(SHeroBuy.CMD.toString(), onHeroBuyHandler);
            //佣兵选择
            this.addContextListener(EventType.NOTIFY_MERCENARY_SELECT, onMercenarySelected);
            //购买    s
            this.btn_diamond.addEventListener(Event.TRIGGERED, buyMercenaryHandler);
        }

        public function initData():void {
            if (!isInitData) {
                Message.sendMessage(new CIsHeroBuy()); //关卡会变化所以大开都要刷新
                isInitData = true;
            }
        }

        /**接收到服务端购状态列表*/
        private function onHeroBuyList(event:Event, info:SIsHeroBuy):void {
            ShowLoader.remove();
            //服务端数据
            TavernData.instance.MercenaryList = info.heroes;
            _mercenaryList.updateMercenaryList(TavernData.instance.MercenaryList);
            _mercenaryList.selectedIndex = _mercenaryList._selectedIndex;
        }

        /**接收到服务端购买数据*/
        private function onHeroBuyHandler(event:Event, info:SHeroBuy):void {
            var sheroBuy:SHeroBuy = info;
            switch (info.state) {
                case 0: //购买成功 
                    var merIconItem:MercenaryIconRender = _mercenaryList.getChildItem(_mercenaryList.selectedIndex) as MercenaryIconRender;
                    _gateHero.state = 2;
                    merIconItem.data = _gateHero;
                    TavernData.instance.GetMercenarDataById(_gateHero.id).state = 2;
                    this.btn_diamond.touchable = false;
                    icon.visible = false;
                    text_num.text = "";
                    tipsText.text = Langue.getLangue("Already_Buy"); //英雄购买
                    addTips("buySuccess");
                    break;
                case 1: //金币不足
                    addTips("notEnoughCoin");
                    break;
                case 2: //未达到关卡数
                    RollTips.add(Langue.getLangue("Not_Reached_Points"));
                    break;
                case 3: //已经购买
                    RollTips.add(Langue.getLangue("Already_Buy"));
                    break;
                case 4: //配置表错误
                    RollTips.add(Langue.getLangue("Configuration_ERR"));
                    break;
                case 5: //背包格子不足
                    RollTips.add(Langue.getLangue("MaxHero"));
                    break;
                case 6: //钻石不足
                    RollTips.add(Langue.getLangue("diamendNotEnough"));
                    break;
                default: //程序异常
                    RollTips.add(Langue.getLangue(getLangue("codeError") + ",code:" + info.state));
                    break;
            }
            ShowLoader.remove();
        }

        /**选中佣兵 mercenary {id:佣兵id,state:状态}*/
        private function onMercenarySelected(e:Event, mercenary:GateHero):void {
            if (mercenary == null)
                return;
            _gateHero = mercenary;
            _mercenaryData = MercenaryData.hash.getValue(_gateHero.id);
            updata();
        }

        /**根据选中的佣兵英雄数据更新UI*/
        public function updata():void {
            if (visible && _gateHero != null && _mercenaryData != null) {
                var arr:Array = Langue.getLans("Mercenary_Icon_Value");
                switch (_gateHero.state) {
                    case 0: //可以购买 
                        this.btn_diamond.touchable = true;
                        icon.visible = true;
                        icon.texture = Res.instance.getGoldPhoto(_mercenaryData.payType);
                        text_num.text = _mercenaryData.sellPrice.toString();
                        tipsText.text = "";
                        break;
                    case 1: //未解锁
                        this.btn_diamond.touchable = false;
                        icon.visible = false;
                        text_num.text = "";
                        tipsText.text = Langue.getLangue("Not_Unlock");
                        break;
                    case 2: //已经购买
                        this.btn_diamond.touchable = false;
                        icon.visible = false;
                        text_num.text = "";
                        tipsText.text = Langue.getLangue("Already_Buy");
                        break;
                    default:
                        this.btn_diamond.touchable = false;
                        icon.visible = false;
                        text_num.text = "";
                        tipsText.text = "";
                        break;
                }
                if (_gateHero.state != 2) {
                    text_Competence.text = Langue.getLangue("Hero_IN_Unlock").replace("*", _mercenaryData.pointID);
                } else {
                    text_Competence.text = arr[3];
                }

                /**-----------------------------------------------------------------------------*/
                var heroData:HeroData = HeroData.hero.getValue(_mercenaryData.heroID);
                _mercenaryList.stopAllSound();
                if (_sound != heroData.sound) {
                    _sound = heroData.sound;
                    SoundManager.instance.playSound(heroData.sound, true, 1, 1);
                }
                text_heroName.text = heroData.name;
                (heroPanel.getChildByName("heroName") as TextField).text = heroData.name;
                _heroAvatar.updateHero(heroData, true);

                /**--------------------------------------------------------------------------*/
                var kuang:Image = heroPanel.getChildByName("kuang") as Image;
                _starBar.updataStar(_mercenaryData.star, 0.8);
                _starBar.offsetXY(kuang.x + (kuang.width - _starBar.width) * 0.5, kuang.y + 73);
                var qualtyid:uint = _mercenaryData.quality > 0 ? _mercenaryData.quality - 1 : 0;
                (heroPanel.getChildByName("effectbg_1") as Image).texture = AssetMgr.instance.getTexture("ui_yingxiongkapaiguang_" + qualtyid + "_1");
                (heroPanel.getChildByName("effectbg_2") as Image).texture = AssetMgr.instance.getTexture("ui_yingxiongkapaiguang_" + qualtyid + "_2");
                (heroPanel.getChildByName("effectbg_3") as Image).texture = AssetMgr.instance.getTexture("ui_yingxiongkapaiguang_" + qualtyid + "_1");


                if (_mercenaryData.level > 0) {
                    (heroPanel.getChildByName("textLv") as TextField).text = _mercenaryData.level + "";
                }

                var textureVec:Vector.<Texture> = new Vector.<Texture>;
                textureVec.push(AssetMgr.instance.getTexture("ui_gongyong_zheyetubiao" + heroData.job));
                textureVec.push(AssetMgr.instance.getTexture("ui_hero_yingxiongpinzhi_0" + ((7 - qualtyid))));
                if (_mcImage == null) {
                    _mcImage = new MovieClip(textureVec, 0.5);
                    _mcImage.x = 225;
                    _mcImage.y = 310;
                    heroPanel.addChild(_mcImage);
                    Starling.juggler.add(_mcImage);
                } else {
                    _mcImage.setFrameTexture(0, AssetMgr.instance.getTexture("ui_gongyong_zheyetubiao" + heroData.job));
                    _mcImage.setFrameTexture(1, AssetMgr.instance.getTexture("ui_hero_yingxiongpinzhi_0" + ((7 - _mercenaryData.quality) + 1)));
                    _mcImage.currentFrame = 0;
                }

                /**--------------------------------------------------------------------------*/
                heroIcon.texture = Res.instance.getHeroIcoPhoto(heroData.show);
                text_heroInfo.text = heroData.des;
                text_expertValue.text = Langue.getLans("hero_job")[heroData.job - 1];
                text_HabitWeaponValue.text = Langue.getLans("Equip_type")[heroData.weapon - 1];
                showHeroSkill(heroData);
            }
        }

        private function buyMercenaryHandler(e:Event):void {
            if (_mercenaryData) {
                //金币不足
                if (_mercenaryData.payType == 1 && GameMgr.instance.coin < _mercenaryData.sellPrice) {
                    addTips("notEnoughCoin");
                    return;
                }
                //钻石不足
                if (_mercenaryData.payType == 2 && GameMgr.instance.diamond < _mercenaryData.sellPrice) {
                    addTips("diamendNotEnough");
                    return;
                }
                var cmd:CHeroBuy = new CHeroBuy();
                cmd.id = _mercenaryData.id
                Message.sendMessage(cmd);
            } else {

            }
        }

        /**
         * 英雄技能
         * @param heroData
         */
        private function showHeroSkill(heroData:HeroData):void {
            var skillData:SkillData;
            var image:Button = null;
            var arr:Array = [];
            for (var i:int = 0; i < 3; i++) {
                skillData = SkillData.getSkill(heroData["skill" + (i + 1)]);
                image = this["heroSkill_" + i] as Button;
                image.touchable = true;
                if (skillData) {
                    image.visible = true;
                    image.upState = AssetMgr.instance.getTexture(skillData.skillIcon);
                    image.addEventListener(TouchEvent.TOUCH, thochHandler);
                    arr.push(image);
                } else {
                    image.visible = false;
                }
            }

            if (arr.length == 1) {
                image = arr[0] as Button;
                image.x = 710;
            } else if (arr.length == 2) {
                image = arr[0] as Button;
                image.x = 656;
                image = arr[1] as Button;
                image.x = 758;
            } else if (arr.length == 3) {
                image = arr[0] as Button;
                image.x = 612;
                image = arr[1] as Button;
                image.x = 710;
                image = arr[2] as Button;
                image.x = 807;
            }
        }

        private function thochHandler(e:TouchEvent):void {
            if (_mercenaryData == null)
                return;
            var index:uint = uint((e.currentTarget as DisplayObject).name.split("_")[1]) + 1;
            var heroData:HeroData = HeroData.hero.getValue(_mercenaryData.heroID);
            var touch:Touch = e.getTouch(stage);
            if (touch == null)
                return;
            var skillData:SkillData = SkillData.getSkill(heroData["skill" + index]);
            var p:Point = touch.getLocation(stage);
            p = new Point(p.x - 450, p.y);
            switch (touch && touch.phase) {
                case TouchPhase.BEGAN:
                    _selfParent.isVisible = true;
                    DialogMgr.instance.open(SkillDesDialog, {data: skillData, point: p});
                    break;
                case TouchPhase.ENDED:
                    DialogMgr.instance.closeDialog(SkillDesDialog);
                    break;
            }
        }

        /**销毁*/
        override public function dispose():void {

            while (this.numChildren > 0) {
                this.getChildAt(0).removeFromParent(true);
            }

            super.dispose();
            _mercenaryList = null;
            _sound = null;
            _heroAvatar = null;
            _starBar = null;
            _mcImage = null;
        }
    }
}
