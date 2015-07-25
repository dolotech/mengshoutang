package game.view.comm
{
    import com.dialog.Dialog;
    import com.sound.SoundManager;
    import com.utils.Constants;
    import com.view.View;

    import flash.geom.Point;
    import flash.utils.getTimer;

    import game.base.BaseIcon;
    import game.common.JTGlobalDef;
    import game.data.IconData;
    import game.hero.AnimationCreator;
    import game.manager.AssetMgr;
    import game.managers.JTFunctionManager;

    import starling.animation.Transitions;
    import starling.core.Starling;
    import starling.display.DisplayObjectContainer;
    import starling.display.Quad;

    import treefortress.spriter.SpriterClip;

    public class GetGoodsAwardEffectDia extends Dialog
    {

        private var getEffectSp:SpriterClip;
        private var listGoods:Vector.<IconData>=null;
        private var mask:Quad=null;
        private var effectPoint:Point=null;
        private var effectName:String="";
        private var effectSound:String="";
        private var effectFrame:int=0;

        public function GetGoodsAwardEffectDia()
        {
            super();
            mask=new Quad(Constants.FullScreenWidth, Constants.FullScreenHeight);
            mask.touchable=true;
            mask.alpha=0;
            addChild(mask);
            addClickFun(closeDialog, true);
        }

        private function closeDialog(view:View):void
        {
            SoundManager.instance.stopSound(effectSound);
            mask && mask.removeFromParent(true);
            close();
        }

        /**
         *
         * @param container
         * @param parameter 数据Vector.<IconData>或者｛vector：Vector.<IconData>，effectPoint：effectPoint，effectName：effectName，effectSound：effectSound｝
         * @param okFun
         * @param cancelFun
         *
         */
        override public function open(container:DisplayObjectContainer, parameter:Object=null, okFun:Function=null, cancelFun:Function=null):void
        {
            super.open(container, parameter, okFun, cancelFun);
            if (parameter is Vector.<IconData>)
            {
                listGoods=parameter as Vector.<IconData>;
            }
            else
            {
                listGoods=parameter.hasOwnProperty("vector") ? parameter.vector as Vector.<IconData> : new Vector.<IconData>;
                effectPoint=parameter.hasOwnProperty("effectPoint") ? parameter.effectPoint : null;
                effectName=parameter.hasOwnProperty("effectName") ? parameter.effectName : "";
                effectSound=parameter.hasOwnProperty("effectSound") ? parameter.effectSound : "";
                effectFrame=parameter.hasOwnProperty("effectFrame") ? parameter.effectFrame : 0;
            }
            initEffect();
            JTFunctionManager.executeFunction(JTGlobalDef.STOP_CITY_ANIMATABLE);
        }

        override public function close():void
        {
            JTFunctionManager.executeFunction(JTGlobalDef.PLAY_CITY_ANIMATABLE);
            super.close();
        }

        private function initEffect():void
        {
//            var len:int = listGoods.length;
//            var i:int = 0;
//            var frame:int = 0;
//            for (i; i < len; i++) {
//                effectName = listGoods[i].effect as String;
//                effectSound = listGoods[i].playSound as String;
//                frame = listGoods[i].frame as int;
//            }
            if (!getEffectSp)
            {
                getEffectSp=AnimationCreator.instance.create(effectName, AssetMgr.instance);
            }

            if (!getEffectSp.parent)
            {
                getEffectSp.play(effectName);
                SoundManager.instance.playSound(effectSound);
                getEffectSp.animation.id=getTimer();
                getEffectSp.animation.looping=true;
                Starling.juggler.add(getEffectSp);
                getEffectSp.x=effectPoint ? effectPoint.x : (Constants.virtualWidth) >> 1;
                getEffectSp.y=effectPoint ? effectPoint.y : (Constants.virtualHeight) >> 1;
                addQuiackChild(getEffectSp);
                getEffectSp.touchable=false;
            }
            getEffectSp.addCallback(function():void
            {
                showGoods();
            }, effectFrame, true);

            getEffectSp.animationComplete.add(onComplete);
            function onComplete():void
            {
                getEffectSp.stop();
                getEffectSp && getEffectSp.removeFromParent();
                close();
            }
        }

        private function showGoods():void
        {
            if (listGoods && listGoods.length > 0)
            {
                var i:int=0;
                var goods:IconData=null;
                var gridGoods:BaseIcon=null;
                var len:int=listGoods.length;

                var vec1:Vector.<IconData>=new Vector.<IconData>;
                var vec2:Vector.<IconData>=new Vector.<IconData>;
                for (i=0; i < len; i++)
                {
                    goods=listGoods[i] as IconData;
                    if (i % 2 == 0)
                    {
                        vec1.push(goods);
                    }
                    else
                    {
                        vec2.push(goods);
                    }
                }
                var cw:int=(len % 2 == 0) ? (Constants.virtualWidth + 50) : (Constants.virtualWidth - 50);
                var isSigle:Boolean=(len % 2 == 0) ? false : true;
                var cx:int=0;
                len=vec1.length;
                for (i=0; i < len; i++)
                { //向右
                    goods=vec1[i] as IconData;
                    gridGoods=new BaseIcon(goods);
                    gridGoods.x=(cw - gridGoods.width) >> 1;
                    gridGoods.y=(Constants.virtualHeight - 100) >> 1;
                    addQuiackChild(gridGoods);
                    if (!isSigle)
                    {
                        //双数个物品的时候
                        Starling.juggler.tween(gridGoods, 1, {x: gridGoods.x + (i + 1) * 100 - 50, transition: Transitions.EASE_OUT_ELASTIC});
                    }
                    else
                    {
                        //单个物品的时候
                        Starling.juggler.tween(gridGoods, 1, {x: gridGoods.x + (i + 1) * 100 - 50, transition: Transitions.EASE_OUT_ELASTIC});
                    }
                }

                len=vec2.length;
                for (i=0; i < len; i++)
                { //向左
                    goods=vec2[i] as IconData;
                    gridGoods=new BaseIcon(goods);
                    gridGoods.x=(cw - gridGoods.width) >> 1;
                    gridGoods.y=(Constants.virtualHeight - 100) >> 1;
                    addQuiackChild(gridGoods);
                    Starling.juggler.tween(gridGoods, 1, {x: gridGoods.x - (i + 1) * 100 + 50, transition: Transitions.EASE_OUT_ELASTIC});
                }
            }
        }

        override public function dispose():void
        {
            getEffectSp && getEffectSp.dispose();
            mask && mask.removeFromParent(true);
            super.dispose();
            getEffectSp=null;
            listGoods=null;
            mask=null;
        }

    }
}
