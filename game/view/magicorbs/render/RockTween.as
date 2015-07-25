/**
 * Created with IntelliJ IDEA.
 * User: Administrator
 * Date: 14-5-12
 * Time: 下午10:35
 * To change this template use File | Settings | File Templates.
 */
package game.view.magicorbs.render
{
    import starling.core.Starling;
    import starling.display.DisplayObject;

    public class RockTween
    {
        private var target:DisplayObject;
        private var x:int;
        private var y:int;

        public function RockTween(target:DisplayObject, start:Boolean=true)
        {
            this.target=target;
            x=target.x;
            y=target.y;

            if (start)
            {
                rightRotation();
            }
        }

        private function leftRotation():void
        {
            target.x-=1;
            target.y-=1;
            Starling.juggler.tween(target, 0.08, {rotation: 0.03, onComplete: rotationZeroLeft});
        }

        private function rotationZeroLeft():void
        {
            target.x+=1;
            target.y+=1;
            Starling.juggler.tween(target, 0.08, {rotation: 0, onComplete: rightRotation});
        }

        private function rotationZeroRight():void
        {
            target.x+=1;
            target.y+=1;
            Starling.juggler.tween(target, 0.08, {rotation: 0, onComplete: leftRotation});
        }

        public function rightRotation():void
        {
            target.x-=1;
            target.y-=1;
            Starling.juggler.tween(target, 0.08, {rotation: -0.03, onComplete: rotationZeroRight});
        }

        public function stop():void
        {
            Starling.juggler.removeTweens(target);
            target.rotation=0;
            target.x=x;
            target.y=y;
        }


    }
}
