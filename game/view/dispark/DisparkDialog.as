package game.view.dispark
{
    import com.dialog.Dialog;

    import game.common.JTGlobalDef;
    import game.data.DisparkData;
    import game.dialog.ShowLoader;
    import game.managers.JTFunctionManager;
    import game.net.data.c.CSetfunData;
    import game.net.message.base.Message;
    import game.view.dispark.render.DisparkRender;

    import starling.core.Starling;

    public class DisparkDialog extends Dialog
    {

        public function DisparkDialog(isAutoInit:Boolean=false)
        {
            super(isAutoInit);
        }


        override protected function show():void
        {
            if (DisparkControl.instance.disparkList.length > 0)
            {
                JTFunctionManager.executeFunction(JTGlobalDef.STOP_CITY_ANIMATABLE);
                starTween();
                setToCenter();
            }
            else
            {
                this.close();
            }
        }

        override public function close():void
        {
            JTFunctionManager.executeFunction(JTGlobalDef.PLAY_CITY_ANIMATABLE);
            super.close();
        }


        /**启动缓动*/
        protected function starTween():void
        {
            if (DisparkControl.instance.disparkList.length > 0)
            {
                var disparkRender:DisparkRender=DisparkControl.instance.disparkList[0] as DisparkRender;
                disparkRender.alpha=0;
                disparkRender.y=30;
                this.addQuiackChild(disparkRender);
                sendDispark(disparkRender.disparkData.id);
                Starling.juggler.tween(disparkRender, 1.5, {y: 0, alpha: 1, onComplete: onTweenComplete});
            }
            else
            {
                close();
            }
        }

        private function sendDispark(id:uint):void
        {
            var dispark:DisparkData=DisparkData.hash.getValue(id);
            if (dispark.statue == 0)
            {
                if (dispark.type == 0)
                {
                    dispark.statue=1;
                }
                else if (dispark.type == 1)
                {
                    dispark.statue=2;
                }
                var cmd:CSetfunData=new CSetfunData();
                cmd.id=id;
                cmd.value=dispark.statue;
                Message.sendMessage(cmd);
                ShowLoader.remove();

            }
        }


        /**缓动结束一个*/
        private function onTweenComplete():void
        {
            if (DisparkControl.instance.disparkList[0])
            {
                var disparkRender:DisparkRender=DisparkControl.instance.disparkList[0] as DisparkRender;
                if (disparkRender.disparkData.callBack != null)
                {
                    disparkRender.disparkData.callBack(disparkRender.disparkData);
                }
                disparkRender.removeFromParent(true);
                DisparkControl.instance.disparkList.shift();
                starTween();
            }
        }

        /**销毁*/
        override public function dispose():void
        {
            while (this.numChildren > 0)
            {
                this.removeChildAt(0).removeFromParent(true);
            }
            super.dispose();
        }

    }
}
