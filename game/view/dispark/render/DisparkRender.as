package game.view.dispark.render
{
    import com.view.View;

    import game.data.DisparkData;
    import game.view.viewBase.DisparkRenderBase;

    import starling.text.TextField;

    public class DisparkRender extends DisparkRenderBase
    {

        private var _disparkData:DisparkData=null;

        public function DisparkRender(disparkData:DisparkData, isAutoInit:Boolean=true)
        {
            _disparkData=disparkData;
            super();
        }

        public function get disparkData():DisparkData
        {
            return _disparkData;
        }

        public function set disparkData(value:DisparkData):void
        {
            _disparkData=value;
        }

        /**初始化*/
        override protected function init():void
        {
            txtContent.text=_disparkData.tips;
        }

        /**监听*/
        override protected function addListenerHandler():void
        {

        }

        /**销毁*/
        override public function dispose():void
        {
            while (this.numChildren > 0)
            {
                this.removeChildAt(0).removeFromParent(true);
            }
        }


    }
}
