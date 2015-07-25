package game.hero
{
    import com.dialog.Dialog;
    import com.dialog.DialogMgr;
    import com.langue.Langue;
    import com.scene.SceneMgr;
    import com.sound.SoundManager;
    import com.utils.Constants;
    import com.view.base.event.EventType;
    import com.view.base.event.ViewDispatcher;

    import flash.geom.Point;

    import game.data.Goods;
    import game.data.HeroData;
    import game.data.RoleShow;
    import game.data.SkillData;
    import game.data.StoryConfigData;
    import game.data.TollgateData;
    import game.data.WidgetData;
    import game.dialog.MsgDialog;
    import game.dialog.ShowLoader;
    import game.fight.Position;
    import game.fight.PowerSkill;
    import game.hero.command.AttackCommand;
    import game.hero.command.Command;
    import game.hero.command.GameoverCommand;
    import game.hero.command.MageBallCommand;
    import game.hero.command.MoveCommand;
    import game.hero.command.SkillCommand;
    import game.hero.command.TreatCommand;
    import game.manager.AssetMgr;
    import game.manager.BattleHeroMgr;
    import game.manager.CommandSet;
    import game.manager.GameMgr;
    import game.net.GameSocket;
    import game.net.data.vo.BattleTarget;
    import game.net.data.vo.BattleVo;
    import game.net.message.GameMessage;
    import game.scene.BattleScene;
    import game.scene.NewBattleWords;
    import game.scene.world.NewFbScene;
    import game.scene.world.NewMainWorld;
    import game.uils.Config;
    import game.view.closeDlgBackroud.CloseDlgBackground;
    import game.view.dispark.DisparkControl;
    import game.view.gameover.LostView;
    import game.view.gameover.WinView;
    import game.view.new2Guide.NewGuide2Manager;
    import game.view.viewGuide.ViewGuideManager;

    import starling.core.Starling;
    import starling.display.DisplayObject;

    import treefortress.spriter.SpriterClip;

    /**
     * 战斗命令驱动
     * @author Michael
     *
     */
    public class BattleDriver
    {
        private var container:BattleScene;
        public static var point:int;
        public var skip:Boolean=false;

        public function BattleDriver(container:BattleScene)
        {
            this.container=container;
        }

        /**
         * 技能
         *
         */
        public function skillDeal(sponsor:Hero, target:Hero, command:BattleVo):void
        {
            /*1：移动攻击
             2：远程施法*/
            var skillID:int=command.skill;
            var skillData:SkillData=SkillData.getSkill(skillID);
            var attackType:int=skillData.attackType;

            if (attackType == 1)
            {
                var moveCMD:MoveCommand=new MoveCommand(sponsor);
                moveCMD.gapx=sponsor.getDis(target);
                moveCMD.target=target;
                sponsor.command.addCommand(moveCMD);

                var skillCMD:Command;
                skillCMD=new SkillCommand(sponsor);
                skillCMD.command=command;
                sponsor.command.addCommand(skillCMD);


                moveCMD=new MoveCommand(sponsor);
                var sp:DisplayObject=Position.instance.getPos(sponsor.data.seat);
                moveCMD.gapx=0;
                moveCMD.gapy=0;
                moveCMD.target=sp;
                sponsor.command.addCommand(moveCMD);
            }
            else
            {
                var mage:MageBallCommand=new MageBallCommand(sponsor);
                mage.command=command;
                sponsor.command.addCommand(mage);

                skillCMD=new SkillCommand(sponsor);
                skillCMD.command=command;
                sponsor.command.addCommand(skillCMD);
            }
        }

        /**
         * 远程攻击
         *
         */
        public function remoteAttackDeal(sponsor:Hero, target:Hero, command:BattleVo):void
        {
            var attackCMD:AttackCommand=new AttackCommand(sponsor);
            attackCMD.command=command;
            sponsor.command.addCommand(attackCMD);
        }

        /**
         * 近程攻击
         *
         */
        public function attackDeal(sponsor:Hero, target:Hero, command:BattleVo):void
        {
            var moveCMD:MoveCommand=new MoveCommand(sponsor);
            moveCMD.gapx=sponsor.getDis(target);
            moveCMD.target=target;
            sponsor.command.addCommand(moveCMD);

            var attackCMD:AttackCommand=new AttackCommand(sponsor);
            attackCMD.command=command;
            sponsor.command.addCommand(attackCMD);

            moveCMD=new MoveCommand(sponsor);

            var sp:DisplayObject=Position.instance.getPos(sponsor.data.seat);
            moveCMD.gapx=0;
            moveCMD.gapy=0;
            moveCMD.target=sp;
            sponsor.command.addCommand(moveCMD);
        }

        /**
         * 治疗
         *
         */
        public function treatDeal(sponsor:Hero, target:Hero, command:BattleVo):void
        {
            var treatCommand:TreatCommand=new TreatCommand(sponsor);
            treatCommand.command=command;
            sponsor.command.addCommand(treatCommand);
        }

        public function starup(tollgateID:int=0):void
        {
            point=tollgateID;
            execute();
        }

        private function execute(hero:Hero=null):void
        {
            if (Config.isWarPass)
                skip=true;

            if (skip)
            {
                gameOver();
                return;
            }

            var command:BattleVo=CommandSet.instance.getCommand();
            var skillData:SkillData=null;
            if (command)
            {
                var sponsor:Hero=BattleHeroMgr.instance.hash.getValue(command.sponsor) as Hero;
                command=CommandSet.instance.pop();
                var target:Hero=BattleHeroMgr.instance.hash.getValue((command.targets[0] as BattleTarget).id) as Hero;
                sponsor.onNextOne.addOnce(execute);
                var roleShow:RoleShow=RoleShow.hash.getValue(sponsor.data.show);

                if (command.skill > 0)
                {
                    skillData=SkillData.getSkill(command.skill);
                    if (skillData.type == 3 || skillData.type == 6)
                    {
                        var powerSkill:PowerSkill=new PowerSkill(skillData, command.targets, command);
                        powerSkill.onComplete.addOnce(function(powerSkill:PowerSkill):void
                        {
                            skillDeal(sponsor, target, command);
                        });
                        this.container.battleUI.freeSkill(sponsor.data);
                    }
                    else
                    {
                        skillDeal(sponsor, target, command);
                    }

                }
                else
                {
                    if (sponsor.data.team == target.data.team) // 职业治疗目标仅且只有一个，目标为队友
                    {
                        treatDeal(sponsor, target, command);
                    }
                    else
                    {
                        if (roleShow.attackType == 3) // 近程攻击
                        {
                            attackDeal(sponsor, target, command);
                        }
                        else
                        {
                            remoteAttackDeal(sponsor, target, command);
                        }

                    }

                }

            }
            else
            {
                Starling.juggler.delayCall(gameOver, 1);
            }

        }

        private function showUpgrade():void
        {
            var storyData:StoryConfigData;
            var animation:SpriterClip;
            var mask:CloseDlgBackground;

            if (GameMgr.instance.sBattle)
            {
                if (GameMgr.instance.sBattle.success == 1)
                {
                    storyData=StoryConfigData.getStory(point, 2);
                }
                else
                {
                    storyData=StoryConfigData.getStory(point, 3);
                }

                if (storyData)
                    container.addChild(new NewBattleWords(storyData, startBoxAnimation));
                else
                    startBoxAnimation();
            }
            else
                callback();

            function startBoxAnimation():void
            {

                if (GameMgr.instance.sBattle && GameMgr.instance.sBattle.success == 1 && GameMgr.instance.game_type == 0)
                {
                    playHeroWinAnimation();
                    Starling.juggler.delayCall(showBoxAnimation, 0.8);
                }
                else
                {
                    callback();
                }
            }


            function showBoxAnimation():void
            {
                SoundManager.instance.stopAllSounds();
                SoundManager.instance.playSound("diaoluo");
                animation=AnimationCreator.instance.create("effect_036", AssetMgr.instance);
                animation.play("out");
                animation.animation.looping=false;
                var point:Point=Position.instance.getPoint(24)
                animation.x=point.x;
                animation.y=point.y;
                animation.animationComplete.addOnce(onPlayComplete);
                animation.touchable=false;
                mask=new CloseDlgBackground(0.2);
                container.addChild(mask);
                container.addChild(animation);
                DisparkControl.instance.checkBattleOpen();


                function onPlayComplete():void
                {
                    animation.play("round");
                    animation.animation.looping=true;
                    SoundManager.instance.stopAllSounds();
//					SoundManager.instance.playSound("piaofu", true, 0, 9999);
                    SoundManager.instance.playSound("piaofu", true, 0, 99999);
                    SoundManager.instance.tweenVolume("piaofu", 1.0, 2);
                    mask.addClickFun(onOpenComplete);
                }


                function onOpenComplete():void
                {
                    mask.touchable=false;
                    animation.play("open");
                    animation.animation.looping=false;
                    animation.animationComplete.addOnce(callback);
                    SoundManager.instance.stopAllSounds();
                    SoundManager.instance.playSound("kaixiang");
                }
            }


            function callback():void
            {
                animation && animation.removeFromParent(true);
                mask && mask.removeFromParent(true);

                //录像
                if (GameMgr.instance.sBattle == null)
                {
                    GameMessage.gotoTollgateData(point);
                }
                else if (GameMgr.instance.sBattle.success == 1)
                {
                    saidComplete();
                    function saidComplete():void
                    {
                        ViewDispatcher.dispatch(EventType.BATTLE_GAME_OVER);
                        DialogMgr.instance.open(WinView, point, ck, null, Dialog.OPEN_MODE_TRANSLUCENCE, 0x000, 0.5);
                    }
                    NewGuide2Manager.isLoading=false;
                    NewGuide2Manager.gotoNext();
                }
                else
                {
                    saidComplete1();
                    function saidComplete1():void
                    {
                        ViewDispatcher.dispatch(EventType.BATTLE_GAME_OVER);
                        DialogMgr.instance.open(LostView, point, ck, null, Dialog.OPEN_MODE_TRANSLUCENCE, 0x000, 0.5);
                    }
                }

                if (!GameSocket.instance.connected)
                {
                    DialogMgr.instance.open(MsgDialog, Langue.getLangue("connect_again"));
                    ShowLoader.remove();
                }
                ViewGuideManager.checkViewGuide();
            }
            // 结算对话框返回
            function ck(type:int, win:String="win", agin:String=""):void
            {
                var tollgateData:TollgateData;
                var goods:Goods;
                if (win == "win") // 赢了
                {
                    if (GameMgr.instance.game_type == GameMgr.MAIN_LINE)
                    {
                        if (agin != "agin")
                        {
                            if (TollgateData.hash.getValue(point + 1) == null)
                                point-=1;

                            if (GameMgr.instance.tired < (TollgateData.hash.getValue(point + 1) as TollgateData).tired)
                            {
                                NewMainWorld.buy_tired=true;
                                SceneMgr.instance.changeScene(NewMainWorld);
                                return;
                            }
                            GameMessage.gotoOldTollgateData(point + 1);
                        }
                        else
                        {
                            tollgateData=TollgateData.hash.getValue(point);
                            goods=tollgateData.castNightmareGoods;

                            if (GameMgr.instance.tired < tollgateData.tired)
                            {
                                NewMainWorld.buy_tired=true;
                                SceneMgr.instance.changeScene(NewMainWorld);
                            }
                            else if (goods != null && WidgetData.pileByType(goods.type) < goods.pile)
                            {
                                NewMainWorld.buy_goods=point;
                                SceneMgr.instance.changeScene(NewMainWorld);
                            }
                            else
                            {
                                GameMessage.gotoOldTollgateData(point);
                            }
                        }
                    }
                    else if (GameMgr.instance.game_type == GameMgr.FB)
                    {
                        SceneMgr.instance.changeScene(NewFbScene);
                    }
                }
                else //输了
                {
                    tollgateData=TollgateData.hash.getValue(point);

                    if (GameMgr.instance.game_type == GameMgr.MAIN_LINE)
                    {
                        goods=tollgateData.castNightmareGoods;

                        if (GameMgr.instance.tired < tollgateData.tired)
                        {
                            NewMainWorld.buy_tired=true;
                            SceneMgr.instance.changeScene(NewMainWorld);
                            return;
                        }
                        else if (goods != null && WidgetData.pileByType(goods.type) < goods.pile)
                        {
                            NewMainWorld.buy_goods=point;
                            SceneMgr.instance.changeScene(NewMainWorld);
                            return;
                        }
                        GameMessage.gotoOldTollgateData(point);
                    }

                    else if (GameMgr.instance.game_type == GameMgr.FB) //  副本
                    {
                        if (GameMgr.instance.tired < tollgateData.tired)
                        {
                            NewMainWorld.buy_tired=true;
                            SceneMgr.instance.changeScene(NewFbScene);
                        }
                        else
                        {
                            GameMessage.gotoOldTollgateData(point);
                        }
                    }
                }
            }

        }

        /*
         * 游戏结束，复活所有所有死去的战友
         *
         * */
        private function regeneracyAllHero():void
        {

            BattleHeroMgr.instance.hash.eachValue(forEachHero);
            function forEachHero(hero:Hero):void
            {
                if (hero.data.team == HeroData.BLUE)
                {
                    if (!hero.visible)
                    {
                        var gameoverCommand:GameoverCommand=new GameoverCommand(hero);
                        hero.command.addCommand(gameoverCommand);
                    }
                }
            }
        }

        private function playHeroWinAnimation():void
        {
            BattleHeroMgr.instance.hash.eachValue(forEachHero);
            function forEachHero(hero:Hero):void
            {
                if (hero.data.team == HeroData.BLUE)
                {
                    if (hero.visible)
                        hero.playWinAnimation()
                }
            }
        }

        private function gameOver():void
        {
            if (GameMgr.instance.isGameover)
            {
                return;
            }
            GameMgr.instance.isGameover=true;
            Constants.speed=1;
            showUpgrade();
        }
    }
}


