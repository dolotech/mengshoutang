package game.view.city
{
import org.osflash.signals.ISignal;
import org.osflash.signals.Signal;

import starling.animation.IAnimatable;
import starling.core.Starling;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import com.utils.Constants;

public class DragScrollManager  implements IAnimatable
    {
        private var tween:Number = 0.2;
        public var limitOffset:Number = 0;
        private var saveX:Number;
        public var isDraging:Boolean = false;
        private var acceleration:Number = 8;
        private var repositionSpeed:Number = 20;
        private var speedX:Number = 0;
        private var isGoing:Boolean = false;
        private var lastX:Number = 0;
        private var dragStartMouseX:Number = 0;
        private var goingX:Number = 0;
        public var rollContainer:ScrollDisplayObjectContainer;
        public var npcPositionList:Array;
		public var onComplete:ISignal;

        public function createSroll(target:ScrollDisplayObjectContainer) : void
        {
			var stageWidth:int = Constants.FullScreenWidth/Constants.scale;
            this.rollContainer = target;
			onComplete = new Signal();
            this.rollContainer.dragNumber = this.rollContainer.width -stageWidth;
            this.rollContainer.scale = 1;
           
            this.initListener();
            this.rollContainer.limitLeft = 0;
            this.rollContainer.limitRight = stageWidth - this.rollContainer.width;  
          
			
        }

        public function initListener() : void
        {
            this.rollContainer.parent.addEventListener(TouchEvent.TOUCH, this.onTouch);
        }
		
		public var isScroll:Boolean;

        private  function onTouch(e:TouchEvent):void
        {
			if(isScroll)return;
            var touch:Touch = e.getTouch(this.rollContainer.parent);
           if(touch)
           {
               if(touch.phase == TouchPhase.BEGAN)
               {
                   onStartDrag(touch);
               }
               else if(touch.phase == TouchPhase.MOVED)
               {
                   this.addEnterframeHandler();
                   _oldPos =   touch.globalX;
               }
               else if(touch.phase == TouchPhase.ENDED)
               {
                   onStopDrag(touch);
               }

           }
        }
        public function advanceTime(time:Number):void
        {
			if(!rollContainer)
			{
				Starling.juggler.remove(this);
				onComplete.dispatch();
				return;
			}
            var _loc_2:* = NaN;
            var _loc_3:* = NaN;
            var _loc_6:* = NaN;
            if (this.isDraging)
            {
                _loc_2 =  _oldPos - this.dragStartMouseX;
                _loc_3 = _loc_2 / this.rollContainer.dragNumber;
                this.rollContainer.moveX(_loc_3);
                this.speedX = this.rollContainer.x - this.lastX;
                this.lastX = this.rollContainer.x;
            }
            else if (this.isGoing)
            {
				var differ:Number = this.goingX - this.rollContainer.x;
				var abs:Number = (differ + (differ >> 31)) ^ (differ >> 31);
				var gx:Number = Math.ceil(abs * this.tween);
                if (abs > gx && abs > 1)
                {
                    var dis:Number = gx / this.rollContainer.dragNumber;
                    if (this.goingX > this.rollContainer.x)
                    {
                        this.rollContainer.moveX(dis, false);
                    }
                    else
                    {
                        this.rollContainer.moveX(-dis, false);
                    }
                }
                else
                {
                    this.rollContainer.x = this.goingX;
                    this.removeEnterframeHandler();
                }
            }
            else
            {
                _loc_6 = this.speedX / this.rollContainer.dragNumber;
                this.rollContainer.moveX(_loc_6, false);
                if (this.speedX > 0)
                {
                    this.speedX = this.speedX - this.acceleration;
                    this.speedX = this.speedX < 0 ? (0) : (this.speedX);
                }
                else if (this.speedX < 0)
                {
                    this.speedX = this.speedX + this.acceleration;
                    this.speedX = this.speedX > 0 ? (0) : (this.speedX);
                }
                if (this.speedX == 0)
                {
                    this.removeEnterframeHandler();
                }
                if (this.rollContainer.x > this.rollContainer.limitLeft - this.limitOffset)
                {
                    this.goPosition(this.rollContainer.limitLeft - this.limitOffset);
                }
                else if (this.rollContainer.x < this.rollContainer.limitRight + this.limitOffset)
                {
                    this.goPosition(this.rollContainer.limitRight + this.limitOffset);
                }
            }
        }
        private var _oldPos:int;
        public function onStartDrag(touch:Touch) : void
        {
            //-----------------------------------------------
            this.setDataStaying();
            //this.dragStartMouseX = this.rollContainer.parent.mouseX;
            //-----------------------------------------------
            this.dragStartMouseX = touch.globalX;
            //-----------------------------------------------
            this.rollContainer.dragstartX = this.rollContainer.x;
//            this.addEnterframeHandler();
            this.isDraging = true;
        }

        public function onStopDrag(touch:Touch) : void
        {
            this.isDraging = false;
            if (this.rollContainer.x > this.rollContainer.limitLeft - this.limitOffset)
            {
                this.goPosition(this.rollContainer.limitLeft - this.limitOffset);
            }
            else if (this.rollContainer.x < this.rollContainer.limitRight + this.limitOffset)
            {
                this.goPosition(this.rollContainer.limitRight + this.limitOffset);
            }
        }

        public function goPosition(goingX:Number) : void
        {
            this.isGoing = true;
            this.goingX = goingX;
            this.speedX = this.repositionSpeed;
            this.addEnterframeHandler();
        }

        public function setPosition(param1:Number) : void
        {
            this.rollContainer.x = param1;
        }

       /* public function goNPCCenter(param1:int) : void
        {
            var _loc_2:* = this.npcPositionList[param1];
            var _loc_3:* = FullScreenWidth.standardWidth / 2 - _loc_2;
            if (_loc_3 > this.rollContainer.limitLeft - this.limitOffset)
            {
                _loc_3 = -this.limitOffset;
            }
            else if (_loc_3 < this.rollContainer.limitRight + this.limitOffset)
            {
                _loc_3 = this.rollContainer.limitRight + this.limitOffset;
            }
            getInstance().goPosition(_loc_3);
        }*/

        public function setDataStaying() : void
        {
            this.isDraging = false;
            this.speedX = 0;
            this.isGoing = false;
            this.lastX = this.rollContainer.x;
            this.dragStartMouseX = 0;
            this.rollContainer.dragstartX = 0;
            this.goingX = 0;
        }

        public function addEnterframeHandler() : void
        {
           Starling.juggler.add(this);
        }
	
        public function removeEnterframeHandler() : void
        {
            this.setDataStaying();
            Starling.juggler.remove(this);
			onComplete.dispatch();
        }

    public function dispose():void
    {
		removeEnterframeHandler();
        this.rollContainer.parent.removeEventListeners(TouchEvent.TOUCH);
        rollContainer = null;


    }
    }
}
