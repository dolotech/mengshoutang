package game.scene.arenaWorld {
    import com.components.RollTips;
    import com.dialog.DialogMgr;
    import com.langue.Langue;
    import com.mobileLib.utils.ConverURL;
    import com.mvc.core.Facade;
    import com.mvc.interfaces.INotification;
    import com.mvc.interfaces.IObserver;
    import com.scene.SceneMgr;
    import com.singleton.Singleton;
    
    import flash.utils.getQualifiedClassName;
    
    import feathers.core.PopUpManager;
    
    import game.common.JTSession;
    import game.dialog.ShowLoader;
    import game.hero.AnimationCreator;
    import game.manager.BattleAssets;
    import game.manager.GameMgr;
    import game.manager.HeroDataMgr;
    import game.net.GameSocket;
    import game.net.data.IData;
    import game.net.data.c.CArena_RivalFightInfo;
    import game.net.data.s.SArena_RivalFightInfo;
    import game.scene.BattleScene;
    import game.scene.LoadingScene;
    import game.view.arena.ArenaDareData;
    import game.view.data.Data;

    public class ArenaBattleLoader implements IObserver {
        public function ArenaBattleLoader() {

        }

        private var _id:int; //对手ID
        private var _name:int;

        /**
         *
         * @return
         */
        public function getName():String {
            return (getQualifiedClassName(this));
        }

        /**
         *
         */
        public function removeObserver():void {
            var vector:Vector.<String> = listNotificationName();
            var len:int = vector.length;

            for (var i:int = 0; i < len; i++) {
                var name:String = vector[i];
                Facade.removeObserver(name, this);
            }
        }

        public function listNotificationName():Vector.<String> {
            var vect:Vector.<String> = new Vector.<String>;
            vect.push(SArena_RivalFightInfo.CMD);
            return vect;
        }

        public function handleNotification(_arg1:INotification):void {
            if (_arg1.getName() == String(SArena_RivalFightInfo.CMD)) {
                var fightInfo:SArena_RivalFightInfo = _arg1 as SArena_RivalFightInfo;

                if (fightInfo.code == 0) {
                    DialogMgr.instance.closeAllDialog();
                    SceneMgr.instance.changeScene(LoadingScene);
                    HeroDataMgr.instance.createRival((_arg1 as SArena_RivalFightInfo).messege, _name);
                    loadMap("map_013", onComplete);
                    function onComplete():void {
                        AnimationCreator.instance.loadRiv(onLoaded, BattleAssets.instance);
                    }

                    function onLoaded():void {
                        dispose();
                        DialogMgr.instance.closeAllDialog();

                        SceneMgr.instance.changeScene(BattleScene, {"tollgate": 0, "pos": 3, "id": _id});
                    }
                } else if (fightInfo.code == 1) {
                    RollTips.add(Langue.getLangue("arenaNumBuy"));
                } else if (fightInfo.code == 2) {
                    RollTips.add(Langue.getLangue("JieBangNoenough"));
                } else if (fightInfo.code == 3) {
                    RollTips.add(Langue.getLangue("No_Challenge_yourself"));
                } else if (fightInfo.code >= 127) {
                    RollTips.add(Langue.getLangue("codeError") + fightInfo.code);
                }
            }
            ShowLoader.remove();
        }

        /**
         * 战斗 此接口为PVP中使用，有
         * @param name
         * @param id
         * @param messages
         *
         */
        public static function showBattle(name:int, id:int, messages:Vector.<IData>):void {
			GameMgr.instance.game_type=GameMgr.PVP;
            var battleLoading:ArenaBattleLoader = new ArenaBattleLoader();
            DialogMgr.instance.closeAllDialog();
            PopUpManager.removePopUps();
            SceneMgr.instance.changeScene(LoadingScene);
            HeroDataMgr.instance.createRival(messages, name);
            battleLoading.loadMap("map_013", onComplete);
            function onComplete():void {
                AnimationCreator.instance.loadRiv(onLoaded, BattleAssets.instance);
            }

            function onLoaded():void {
                battleLoading.dispose();
                DialogMgr.instance.closeAllDialog();
                JTSession.isPvp = true;
                PopUpManager.removePopUps();
                SceneMgr.instance.changeScene(BattleScene, {"tollgate": 0, "pos": 3, "id": id});
            }
        }

        /**
         *
         * @param id 对手ID。
         * @param type 1正常挑战，2反击，3揭榜
         * @param name 0，是怪物，1是英雄
         *
         */
        public function load(id:int, type:int, name:int = 0):void {
			GameMgr.instance.game_type=GameMgr.PVP;
            initObserver();
            var cmd:CArena_RivalFightInfo = new CArena_RivalFightInfo;
            cmd.id = id;
            cmd.type = type;
            _id = id;
            _name = name;
            (Data.instance.getData("dare") as ArenaDareData).type = type;
            GameSocket.instance.sendData(cmd);
            ShowLoader.add();
        }

        public function dispose():void {
            removeObserver();
            Singleton.remove(this);
        }

        /**
         *
         */
        protected function initObserver():void {
            var vector:Vector.<String> = listNotificationName();
            var len:int = vector.length;

            for (var i:int = 0; i < len; i++) {
                var name:String = vector[i];
                Facade.addObserver(name, this);
            }
        }

        private function loadMap(mapName:String, callback:Function):void {
            BattleAssets.instance.enqueue(ConverURL.conver("scene/" + mapName));
            BattleAssets.instance.enqueue(ConverURL.conver("fightaudio/"));
            BattleAssets.instance.enqueue(ConverURL.conver("battleBgm/" + "battle_bgm.mp3"));
            BattleAssets.instance.enqueue(ConverURL.conver("fight/"));

            BattleAssets.instance.loadQueue(onComplete);
            function onComplete(ratio:Number):void {
                if (ratio == 1.0) {
                    callback != null && callback();
                }
            }
        }
    }
}
