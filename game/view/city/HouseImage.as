package game.view.city
{
	import flash.geom.Rectangle;
	import game.manager.AssetMgr;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * ...
	 * @author ...
	 */
	public class HouseImage extends Sprite
	{
		private static const MAX_DRAG_DIST:Number=0;
		public var onClick:ISignal;

		public var isScale:Boolean=true;

		private var mIsDown:Boolean;
		private var mbounds:Rectangle;

		public function HouseImage(name:String)
		{
			super();

			var image:Image=new Image(AssetMgr.instance.getTexture(name));
			addChild(image);

			onClick=new Signal(HouseImage);

			addEventListener(TouchEvent.TOUCH, onTouch);
		}

		private function resetContents():void
		{
			mIsDown=false;
			this.x=this.y=0;
			this.x=mbounds.x;
			this.y=mbounds.y;
			this.scaleX=this.scaleY=1.0;

		}


		private var _oldPos:int;

		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch=event.getTouch(this);
			if (touch == null)
				return;

			if (touch.phase == TouchPhase.BEGAN && !mIsDown)
			{
//            if(mDownState)
				if (isScale)
				{
////                mBackground.texture = mDownState;
					this.scaleX=this.scaleY=0.95;
					mbounds=new Rectangle(this.x, this.y, this.width, this.height);
					this.x+=0.025 * mbounds.width;
					this.y+=0.05 * mbounds.height;
//                _oldPos =      touch.globalX;
				}
				_oldPos=touch.globalX;
				//_clip.play(_animationName + "_action");
				//_clip.animation.looping = true;
				mIsDown=true;
					//SoundManager.instance.playSound("UI_click");
			}
			else if (touch.phase == TouchPhase.MOVED && mIsDown)
			{
				// reset button when user dragged too far away after pushing
				var buttonRect:Rectangle=getBounds(stage);
//            if (touch.globalX < buttonRect.x - MAX_DRAG_DIST ||
//                    touch.globalY < buttonRect.y - MAX_DRAG_DIST ||
//                    touch.globalX > buttonRect.x + buttonRect.width + MAX_DRAG_DIST ||
//                    touch.globalY > buttonRect.y + buttonRect.height + MAX_DRAG_DIST)
//			{
//				resetContents();
//			}

				if (Math.abs(touch.globalX - _oldPos) > 20)
				{
					resetContents();
				}
			}
			else if (touch.phase == TouchPhase.ENDED && mIsDown)
			{
				resetContents();


				onClick.dispatch(this);
			}
		}

		override public function dispose():void
		{
			super.dispose();
			while (this.numChildren > 0)
			{
				this.getChildAt(0).removeFromParent(true);
			}
			onClick=null;
			isScale=false;
			mIsDown=false;
			mbounds=null;
		}

	}

}
