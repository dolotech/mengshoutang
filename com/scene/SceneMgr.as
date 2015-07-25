package com.scene
{
    import com.singleton.Singleton;
    import com.utils.Constants;

    import flash.geom.Rectangle;

    import avmplus.getQualifiedClassName;

    import game.hero.AnimationCreator;
    import game.manager.AssetMgr;
    import game.view.city.CityFace;
    import game.view.dispark.DisparkControl;

    import starling.core.Starling;
    import starling.display.DisplayObjectContainer;

    import treefortress.spriter.SpriterClip;

    /**
     * 场景管理
     * @author Michael
     *
     */
    public class SceneMgr
    {
        private var container:DisplayObjectContainer; //场景容器
        /**
         * 当前场景数据
         */
        public var sceneClass:Class;
        private var currScene:BaseScene;

        public function SceneMgr()
        {

        }

        public static function get instance():SceneMgr
        {
            return Singleton.getInstance(SceneMgr) as SceneMgr;
        }


        /**
         * 必须初始化
         * @param stage
         *
         */
        public function init(stage:DisplayObjectContainer):void
        {
            this.container=stage;
        }

        public function getCurScene():IScene
        {
            return currScene;
        }

        public function isScene(stateClass:Class):Boolean
        {
            return currScene is stateClass;
        }
//		private const HASH : Array = ["game.view.city::CityFace", "game.scene.world::NewMainWorld", "game.scene.world::NewFbScene", "game.scene::BattleScene"];
        private const HASH:Array=[];

        /**
         * 转换场景
         * @param stateName
         *
         */
        public function changeScene(stateClass:Class, param:Object=null, showAnmation:Boolean=true):BaseScene
        {
            if (stateClass == null)
            {
                return currScene;
            }

            if (sceneClass == stateClass)
            {
                return currScene;
            }
            sceneClass=stateClass;


            var oldScene:BaseScene;

            if (currScene)
            {
                if (HASH.indexOf(getQualifiedClassName(stateClass)) != -1)
                {
                    if (showAnmation)
                    {
                        var swapAnimation:SpriterClip=AnimationCreator.instance.create("loadingzhouyou", AssetMgr.instance, true);
                        swapAnimation.play("loadingzhouyou");

                        if (getQualifiedClassName(stateClass) == "game.view.city::CityFace")
                        {
                            swapAnimation.scaleX=-1;
                            swapAnimation.x=Constants.FullScreenWidth;
                        }
                        else
                        {
                            swapAnimation.scaleX=1;
                        }

                        swapAnimation.y=Constants.FullScreenHeight;
                        Starling.current.stage.addChild(swapAnimation);
                    }
                }

                if (HASH.indexOf(getQualifiedClassName(stateClass)) == -1)
                {
                    currScene.dispose();
                }
            }
            oldScene=currScene;
            currScene=new stateClass() as BaseScene;
            currScene.data=param;
            container.addChild(currScene);

            if (HASH.indexOf(getQualifiedClassName(stateClass)) != -1)
            {
                if (getQualifiedClassName(stateClass) == "game.view.city::CityFace")
                    currScene.x=Constants.FullScreenWidth;
                else
                    currScene.x=-currScene.width;

                Starling.current.juggler.tween(currScene, 1, {x: 0, onComplete: onComplete});
            }
            function callback():void
            {
                Starling.current.juggler.tween(currScene, 1, {x: 0, onComplete: onComplete});
            }

            function onComplete(obj:Object=null):void
            {
                oldScene.dispose();
            }
            currScene.clipRect=new Rectangle(0, 0, Constants.virtualWidth, Constants.virtualHeight);
            currScene.scaleX=currScene.scaleY=Constants.scale;

            return currScene;
        }
    }
}
