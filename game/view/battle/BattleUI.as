package game.view.battle {
    import com.langue.Langue;
    import com.utils.Constants;
    import com.view.View;
    import com.view.base.event.EventType;
    import com.view.base.event.ViewDispatcher;

    import flash.geom.Rectangle;

    import game.data.HeroData;
    import game.data.MainLineData;
    import game.data.MonsterData;
    import game.data.RoleShow;
    import game.data.TollgateData;
    import game.data.Val;
    import game.data.VipData;
    import game.hero.AnimationCreator;
    import game.hero.Hero;
    import game.manager.AssetMgr;
    import game.manager.BattleAssets;
    import game.manager.BattleHeroMgr;
    import game.manager.CommandSet;
    import game.manager.GameMgr;
    import game.manager.HeroDataMgr;
    import game.managers.JTSingleManager;
    import game.uils.LocalShareManager;
    import game.view.heroHall.render.StarBarRender;
    import game.view.uitils.Res;
    import game.view.viewBase.BattleViewBases;

    import starling.core.Starling;
    import starling.display.Button;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.filters.ColorMatrixFilter;
    import starling.text.TextField;
    import starling.textures.Texture;

    import treefortress.spriter.SpriterClip;

    /*
     * 游戏战斗内，屏幕顶部血量和回合数的显示
     *
     * */
    public class BattleUI extends View {
        public static const SPEED:String = "speed";
        public static const PASS:String = "pass";

        private var battleView:BattleViewBases = null;
//        private var bossView:BoosViewBase=null;
        private var video_animation:SpriterClip = null;

        private var bossSeat:uint = 0;
        private var bossHPValue:Number = 1;
        public var skip:Boolean = false;

        public var bossHpBar:Image;
        public var dropHpBar:Image;
        public var addHpBar:Image;

        private var maskBar:Sprite = null;
        private var maskVar:Sprite = null;
        private var maskRect:Rectangle = null;

        public var tag_speed1:Button;
        public var tag_pass:Button;
        public var tag_speed2:Button;
        public var bossPercent:TextField;

        public function BattleUI() {
            super();
        }

        /**
         *初始化
         *
         */
        override protected function init():void {
            createBattleView();
            var tollgateData:TollgateData = GameMgr.instance.tollgateData;
            if (tollgateData != null) {
                var mainLineData:MainLineData = (MainLineData.getPoint(tollgateData.id) as MainLineData);
                if (mainLineData.boss_level > 0) { //创建boss视图界面
//                    bossView=new BoosViewBase();
//                    bossView.touchable=false;
//                    addChild(bossView);
//                    addMaskSprite();
//                    bossView.x=Constants.virtualWidth - bossView.width;

                    var arr:Array = GameMgr.instance.tollgateData.monsters;
                    var seat:uint = 0;
                    var len:uint = arr.length;
                    var i:uint = 0;
                    var boss:MonsterData = null;
                    for (i = 0; i < arr.length; i++) {
                        seat = uint(arr[i][1]);
                        if (mainLineData.boss_seat == seat) {
                            bossSeat = mainLineData.boss_seat;
                            boss = MonsterData.monster.getValue(uint(arr[i][0]));
                            if (boss != null) {
//                                bossView.bossName.text=boss.name;
//                                boss.useIcon=(RoleShow.hash.getValue(boss.show) as RoleShow).photo;
//                                (bossView.bossHead.getChildByName("bossIcon") as Image).texture=AssetMgr.instance.getTexture(boss.useIcon);
                            }
                            break;
                        }
                    }
                }
            }
            BattleHeroMgr.instance.hash.eachValue(eachHero);
            var enemyPower:int = 0;
            BattleHeroMgr.instance.hash.eachValue(updateHP);
            function updateHP(hero:Hero):void {
                if (hero.data.team == HeroData.BLUE) {
                    hero.data.power = 0;
                } else {
                    enemyPower += hero.data.getPower;
                    hero.data.power = 0;
                }
            }

            if (GameMgr.instance.tollgateData)
                enemyPower = GameMgr.instance.tollgateData.power;
            else if (JTSingleManager.instance.pvpInfoManager && JTSingleManager.instance.pvpInfoManager.enemy_info)
                enemyPower = JTSingleManager.instance.pvpInfoManager.enemy_info.power;


            if (GameMgr.instance.sBattle == null) {
                video_animation = AnimationCreator.instance.create("effect_video", BattleAssets.instance);
                video_animation.play("effect_video");
                video_animation.animation.looping = true;
                video_animation.x = 730;
                video_animation.y = 50;
                addChild(video_animation);
                Starling.juggler.add(video_animation);
                tag_pass.visible = true;
            }
        }

        /**初始化监听*/
        override protected function addListenerHandler():void {
            tag_pass.addEventListener(Event.TRIGGERED, onSkip);
            tag_speed1.addEventListener(Event.TRIGGERED, onChangeSpeed);
            tag_speed2.addEventListener(Event.TRIGGERED, onChangeSpeed);
            ViewDispatcher.instance.addEventListener(EventType.BATTLE_GAME_OVER, removeBattlePanel);
        }

        /**显示*/
        override protected function show():void {
            var speed:Number = LocalShareManager.getInstance().get(SPEED);
            if (speed == 0.0 || isNaN(speed))
                speed = 1.0;
            showSpeedType(speed);
        }

        private function addMaskSprite():void {
            var assetMgr:AssetMgr = AssetMgr.instance;
            var texture:Texture;
//           var texture:Texture = assetMgr.getTexture('ui_zhandou_xuetiao_di')
//            bossHpBar = new Image(texture);
//            bossHpBar.x = 10;
//            bossHpBar.y = 44;
//            bossHpBar.width = 614;
//            bossHpBar.height = 24;
//            bossView.addQuiackChild(bossHpBar);
//            bossHpBar.touchable = false;
//            bossHpBar.smoothing = Constants.smoothing;
            texture = assetMgr.getTexture('ui_zhandou_xuetiao_huang')
            dropHpBar = new Image(texture);
            dropHpBar.x = 10;
            dropHpBar.y = 44;
            dropHpBar.width = 614;
            dropHpBar.height = 24;
            dropHpBar.touchable = false;
            dropHpBar.visible = false;
            dropHpBar.smoothing = Constants.smoothing;
            texture = assetMgr.getTexture('ui_zhandou_xuetiao_lv')
            addHpBar = new Image(texture);
            addHpBar.x = 10;
            addHpBar.y = 44;
            addHpBar.width = 614;
            addHpBar.height = 24;
            addHpBar.touchable = false;
            addHpBar.visible = false;
            addHpBar.smoothing = Constants.smoothing;

            maskBar = new Sprite();
            maskBar.touchable = false;
//            bossView.addChild(maskBar);
            //maskBar.addQuiackChild(bossHpBar);

            maskVar = new Sprite();
            maskVar.touchable = false;
//            bossView.addChild(maskVar);
            maskVar.addChild(addHpBar);
            maskVar.addChild(dropHpBar);

            texture = assetMgr.getTexture('ui_zhandou_xuetiao_zhao');
            var image:Image = new Image(texture);
            image.x = 4;
            image.y = 43;
            image.width = 625;
            image.height = 28;
            image.touchable = false;
            image.smoothing = Constants.smoothing;
//            bossView.addQuiackChild(image);
            //maskRect=new Rectangle(bossHpBar.x, bossHpBar.y, bossHpBar.width, bossHpBar.height);
        }

        /**boss加血*/
        private function addBossHp(value:Number):void {
//            if (bossView != null)
//            {
//                addHpBar.visible=true;
//                var aw:Number=maskRect.width * (1 - value);
//                var w:Number=maskRect.width - (maskBar.clipRect == null ? 0 : maskBar.clipRect.width) - aw;
//                maskVar.clipRect=new Rectangle(maskRect.x + aw, maskRect.y, w, maskRect.height);
//                maskBar.clipRect=new Rectangle(maskRect.x + aw, maskRect.y, maskRect.width - aw, maskRect.height);
//                Starling.juggler.removeTweens(maskVar.clipRect);
//                Starling.juggler.tween(maskVar.clipRect, 1, {width: 0, x: maskRect.x + aw, onComplete: onComplete});
//                function onComplete():void
//                {
//                    Starling.juggler.removeTweens(maskVar.clipRect);
//                    addHpBar.visible=false;
//                }
//            }
        }

        /**boss掉血*/
        private function dropBossHp(value:Number):void {
//            if (bossView != null)
//            {
//                dropHpBar.visible=true;
//                var aw:Number=maskRect.width * (1 - value);
//                var w:Number=aw - (maskBar.clipRect == null ? 0 : (maskRect.width - maskBar.clipRect.width));
//                var cx:Number=maskRect.x + (aw - w);
//                maskVar.clipRect=new Rectangle(cx, maskRect.y, w, maskRect.height);
//                maskBar.clipRect=new Rectangle(maskRect.x + aw, maskRect.y, maskRect.width - aw, maskRect.height);
//                Starling.juggler.removeTweens(maskVar.clipRect);
//                Starling.juggler.tween(maskVar.clipRect, 1, {width: 0, x: cx + w, onComplete: onComplete});
//                function onComplete():void
//                {
//                    Starling.juggler.removeTweens(maskVar.clipRect);
//                    dropHpBar.visible=false;
//                }
//            }
        }

        /**创建上阵英雄*/
        private function createBattleView():void {
            battleView = new BattleViewBases();
            battleView.x = (Constants.virtualWidth - battleView.width) >> 1;
            battleView.y = (Constants.virtualHeight - battleView.height) + 10;
            battleView.visible = false;
            addQuiackChild(battleView);

            bossPercent = new TextField(136, 36, '', '', 18, 0xFFFFCC, false);
            bossPercent.touchable = false;
            bossPercent.hAlign = 'right';
            bossPercent.text = '';
            bossPercent.x = 15;
            bossPercent.y = 15;
            this.addQuiackChild(bossPercent);
            bossPercent.text = Langue.getLangue("fight_num") + ":" + "1/" + CommandSet.instance.getEndCount();

            var texture:Texture = AssetMgr.instance.getTexture('ui_icon_acceleration1');
            tag_speed1 = new Button(texture);
            tag_speed1.name = 'tag_speed1';
            tag_speed1.x = 15;
            tag_speed1.width = 52;
            tag_speed1.height = 29;
            tag_speed1.y = Constants.virtualHeight - tag_speed1.height - 10;
            this.addQuiackChild(tag_speed1);

            texture = AssetMgr.instance.getTexture('ui_icon_acceleration1_5');
            tag_speed2 = new Button(texture);
            tag_speed2.name = 'tag_speed2';
            tag_speed2.x = 15;
            tag_speed2.width = 100;
            tag_speed2.height = 29;
            tag_speed2.y = Constants.virtualHeight - tag_speed2.height - 10;
            this.addQuiackChild(tag_speed2);

            texture = AssetMgr.instance.getTexture('ui_icon_newkip');
            tag_pass = new Button(texture);
            tag_pass.name = 'tag_pass';
            tag_pass.width = 69;
            tag_pass.height = 35;
            tag_pass.x = Constants.virtualWidth - tag_pass.width - 15;
            tag_pass.y = Constants.virtualHeight - tag_pass.height - 10;
            tag_pass.visible = false;
            this.addQuiackChild(tag_pass);

            var getEffectSp:SpriterClip = null;
            var spBar:Sprite = null;
            var star:StarBarRender = null;
            var photo:String = "";
            var i:int = 0;
            var img:Image = null;
            var heroQuality:Image = null;

            for (i = 0; i < 5; i++) {
                spBar = battleView["angerBar_" + i] as Sprite;
                maskBarRect(spBar, 95, 20, 0);
                img = battleView["heroIcon_" + i] as Image;
                getEffectSp = AnimationCreator.instance.create("effect_yingxiongdazhao", AssetMgr.instance);
                getEffectSp.play("NewAnimation");
                getEffectSp.animation.looping = true;
                getEffectSp.animation.id = i;
                getEffectSp.name = "NewAnimation_" + i;
                getEffectSp.touchable = false;
                getEffectSp.visible = false;
                getEffectSp.stop();
                battleView.addQuiackChildAt(getEffectSp, battleView.getChildIndex(battleView.Bg) + 1);
                getEffectSp.x = img.x - 6;
                getEffectSp.y = img.y - 4;

                star = new StarBarRender();
                star.touchable = false;
                star.name = "star_" + i;
                battleView.addQuiackChild(star);
                star.x = img.x + (img.width - star.width) * 0.5;
                star.y = img.height - star.height - 8;
            }

            i = 0;
            for each (var hero:Hero in BattleHeroMgr.instance.hash.values()) {
                if (hero.id != 0 && hero.data.team == HeroData.BLUE) {
                    photo = (RoleShow.hash.getValue(hero.data.show) as RoleShow).photo;
                    img = battleView["heroIcon_" + i] as Image;
                    img.texture = AssetMgr.instance.getTexture(photo);
                    heroQuality = battleView["heroQuality_" + i] as Image;
                    heroQuality.texture = Res.instance.getWinHeroQualityPhoto(hero.data.quality);
                    star = battleView.getChildByName("star_" + i) as StarBarRender;
                    star.updataStar(hero.data.foster, 0.35);
                    star.x = img.x + (img.width - star.width) * 0.5;
                    star.y = img.height - star.height - 8;
                    i++;
                }
            }

            for (i = 0; i < 5; i++) //头像下标0-4
            {
                if (HeroDataMgr.instance.seatTollgeteId < i + 1) //可以上阵人数<=头像下标
                {
                    (battleView["textPoints_" + i] as TextField).text = Langue.getLangue("past_first_Open").replace("*",
                                                                                                                    HeroDataMgr.instance.getOpenTollgateId(i + 1));
                } else {
                    (battleView["textPoints_" + i] as TextField).text = "";
                }

                img = battleView["heroIcon_" + i] as Image;
                heroQuality = battleView["heroQuality_" + i] as Image;
                img.filter = heroQuality.filter = null;
            }
        }

        public function showBattleView():void {
            if (battleView) {
                battleView.visible = true;
            }
        }

        /**修改提示类型*/
        private function onSkip(evt:Event):void {
            var gameMgr:GameMgr = GameMgr.instance;
            if (gameMgr.isGameover)
                return;

            if (gameMgr.battle_type == 3 || gameMgr.battle_type == 2) {
                addTips("no_pass_1");
                return;
            } else if (!gameMgr.isPass && gameMgr.battle_type == 0) {
                addTips("no_pass_2");
                return;
            } else if (!skip && gameMgr.battle_type == 0) {
                addTips("no_pass_3");
                return;
            }
            this.dispatchEventWith(PASS);
        }

        /**修改播放速度*/
        private function onChangeSpeed(evt:Event):void {
            var speed:Number;
            switch (evt.currentTarget) {
                case tag_speed1:
                    speed = GameMgr.instance.vipData.baseVip.fast / 10;
                    break;
                case tag_speed2:
                    speed = 1.0;
                    break;
                default:
                    break;
            }
            var vipData:VipData = GameMgr.instance.vipData.baseVip.getNextVipBySpeed();

            if (speed == 1.0 && vipData)
                addTips(getLangue("vip_speed").replace("*", vipData.fast / 10).replace("*", vipData.id));
            LocalShareManager.getInstance().save(SPEED, speed);
            showSpeedType(speed);
        }

        /**修改播放速度*/
        private function showSpeedType(speed:Number):void {
            Constants.speed = speed;
            tag_speed1.visible = speed == 1.0;
            tag_speed2.visible = speed != 1.0;
            if (tag_speed2.visible)
                tag_speed2.upState = Res.instance.getVipSpeedPhoto(speed);
        }

        /**遍历每一个*/
        private function eachHero(hero:Hero):void {
            hero.onHPChange.add(updateAll);
        }

        /**更新血*/
        private function updateAll(hero:Hero):void {
            if (bossPercent != null && CommandSet.instance.getIndexCount() != -1) {
                bossPercent.text = Langue.getLangue("fight_num") + ":" + (CommandSet.instance.getIndexCount()) + "/" + CommandSet.instance.getEndCount();
            }

            var index:int = getPhotoIndex(hero.data);
            if (index >= 0 && hero.data.currenthp <= 0) //已经死亡
            {
                var sp:Sprite = battleView["angerBar_" + index] as Sprite;
                maskBarRect(sp, 95, 20, 0);
                Starling.juggler.removeTweens(sp.getChildByName("angerBar"));
                var eff:SpriterClip = battleView.getChildByName("NewAnimation_" + index) as SpriterClip;
                eff.visible = false; //隐藏效果
                eff.stop();
                Starling.juggler.remove(eff);
                (battleView["heroIcon_" + index] as Image).filter = new ColorMatrixFilter(Val.filter);
                (battleView["heroQuality_" + index] as Image).filter = new ColorMatrixFilter(Val.filter);
                (battleView.getChildByName("star_" + index) as StarBarRender).filter = new ColorMatrixFilter(Val.filter);
                return;
            }
            updataSp(hero.data);
//            if (bossView != null)
//            {
//                BattleHeroMgr.instance.hash.eachValue(updateHP);
//                function updateHP(hero:Hero):void
//                {
//                    if (hero.data.seat == (bossSeat + 20))
//                    {
//                        updateBossHP(hero.data.currenthp / hero.data.hp);
//                    }
//                }
//            }
        }

        /**更新怒气*/
        private function updataSp(heroData:HeroData):void {
            if (!heroData.isCanSkill)
                return;
            var index:int = getPhotoIndex(heroData);
            if (index >= 0) {
                (battleView["heroIcon_" + index] as Image).filter = null;
                (battleView["heroQuality_" + index] as Image).filter = null;
                var sp:Sprite = battleView["angerBar_" + index] as Sprite;
                var eff:SpriterClip = battleView.getChildByName("NewAnimation_" + index) as SpriterClip;
                var angerBar:Image = sp.getChildByName("angerBar") as Image;
                //更新怒气条
                var scale:Number = HeroDataMgr.instance.heroSpPercent(heroData) / 100;
                if (scale >= 1) {
                    heroData.isCanSkill = false; //修改缓存
                    eff.visible = true;
                    eff.play("NewAnimation");
                    Starling.juggler.add(eff);
                }
                maskBarRect(sp, 95, 20, scale);
            }
        }

        private function maskBarRect(mask:Sprite, w:Number, h:Number, parcent:Number, time:Number = 0.1, callBack:Function = null):void {
            var maskRect:Rectangle = mask.clipRect;
            mask.clipRect = new Rectangle(0, 0, maskRect ? maskRect.width : 0, h);
            Starling.juggler.removeTweens(mask.clipRect);
            Starling.juggler.tween(mask.clipRect, time, {width: w * parcent, onComplete: function():void {
                if (callBack != null) {
                    callBack();
                }
            }});
        }


        /**释放技能*/
        public function freeSkill(heroData:HeroData):void {
            var index:int = getPhotoIndex(heroData);
            if (index >= 0) {
                (battleView["heroIcon_" + index] as Image).filter = null;
                (battleView["heroQuality_" + index] as Image).filter = null;
                (battleView.getChildByName("star_" + index) as StarBarRender).filter = null;
                var sp:Sprite = battleView["angerBar_" + index] as Sprite;
                var eff:SpriterClip = battleView.getChildByName("NewAnimation_" + index) as SpriterClip;
                maskBarRect(sp, 95, 20, 1, 0.1, function():void {
                    Starling.juggler.delayCall(function():void {
                        maskBarRect(sp, 95, 20, 0, 2, function():void {
                            eff.visible = false; //隐藏效果
                            eff.stop();
                            Starling.juggler.remove(eff);
                        });
                    }, heroData.callbackFrame / 1000 - 0.1);
                });
            }
        }

        private function getPhotoIndex(heroData:HeroData):int {
            var index:int = -1;
            if (heroData.team == HeroData.BLUE) {
                //找出对应英雄index
                for each (var chero:Hero in BattleHeroMgr.instance.hash.values()) {
                    if (chero.id != 0) { //不是固有英雄
                        if (chero.data.team == HeroData.BLUE) { //如果是自己的英雄
                            index++;
                            if (heroData.id == chero.id) { //如果自己英雄==当前英雄下标找到
                                break;
                            }
                        }
                    }
                }
            }
            return index;
        }

        /**
         * 更新敌方血量
         *
         */
        public function updateBossHP(value:Number):void {
            value = (value * 100 >> 0) / 100;
            if (value > 1)
                value = 1;
            if (value < 0)
                value = 0;
            if (bossHPValue == value)
                return;
            if (bossHPValue < value) { // 增
                addBossHp(value);
            } else if (bossHPValue > value) { // 减
                dropBossHp(value);
            }
            bossHPValue = value;
        }

        /**移除英雄版面*/
        public function removeBattlePanel():void {
            while (battleView && battleView.numChildren) {
                battleView.getChildAt(0).removeFromParent(true);
            }
            tag_speed2 && tag_speed1.removeFromParent(true);
            tag_speed2 && tag_speed2.removeFromParent(true);
            tag_pass && tag_pass.removeFromParent(true);
        }

        /**销毁*/
        override public function dispose():void {
            ViewDispatcher.instance.removeEventListener(EventType.BATTLE_GAME_OVER, removeBattlePanel);
            super.dispose();
            removeBattlePanel();
//            if (bossView)
//                bossView.dispose();
//            if (battleView)
//                battleView.dispose();

            while (this.numChildren > 0) {
                this.getChildAt(0).removeFromParent(true);
            }

//            bossHpBar=null;
            dropHpBar = null;
            addHpBar = null;

            maskBar = null;
            maskVar = null;
            maskRect = null;

            tag_speed1 = null;
            tag_pass = null;
            tag_speed2 = null;
            bossPercent = null;

//            bossView=null;
            battleView = null;
            video_animation = null;
            bossSeat = 0;
            bossHPValue = 0;
            skip = false;
        }

    }
}


