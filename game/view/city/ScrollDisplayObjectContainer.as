package game.view.city
{
import starling.display.Sprite;

public class ScrollDisplayObjectContainer extends Sprite
    {
        public var scale:Number = 1;
        public var dragstartX:Number = 0;
        public var lastX:Number = 0;
        public var dragNumber:Number = 0;
        public var limitLeft:Number;
        public var limitRight:Number;

        public function moveX(param1:Number, param2:Boolean = true) : void
        {
            if (param2)
            {
                this.x = this.dragstartX + param1 * this.dragNumber;
            }
            else
            {
                this.x = this.x + param1 * this.dragNumber;
            }
            if (x > this.limitLeft)
            {
                this.x = this.limitLeft;
            }
            else if (x < this.limitRight)
            {
                this.x = this.limitRight;
            }
        }
    }
}
