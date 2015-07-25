/**
 * Created with IntelliJ IDEA.
 * User: Administrator
 * Date: 13-11-19
 * Time: 下午7:55
 * To change this template use File | Settings | File Templates.
 */
package game.view.city
{
	import com.sound.SoundManager;
	import flash.geom.Rectangle;
	import starling.core.Starling;
	import starling.display.Sprite;
	import treefortress.spriter.core.Animation;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.TextureAtlas;

	import treefortress.spriter.SpriterClip;

	public class House extends Sprite
	{
		private static const MAX_DRAG_DIST:Number=0;
		public var onClick:ISignal;

		public var isScale:Boolean=true;

		private var mIsDown:Boolean;
		private var mbounds:Rectangle;
		private var _animationName:String;
		private var _clip:SpriterClip;

		public function House(animations:Object, textureAtlas:TextureAtlas, animationName:String)
		{
			super();
			_clip=new SpriterClip(animations, textureAtlas);
			_clip.play(animationName);
			_clip.animation.looping=true;
			addChild(_clip);
			_animationName=animationName;
			_clip.touchable=true;
			onClick=new Signal(House);
			addEventListener(TouchEvent.TOUCH, onTouch);
		}

		private function resetContents():void
		{
			mIsDown=false;
//        mBackground.texture = mUpState;
			this.x=this.y=0;
			this.x=mbounds.x;
			this.y=mbounds.y;
			_clip.play(_animationName);
			_clip.animation.looping=true;
			this.scaleX=this.scaleY=1.0;
		}

		public function play():void
		{
			Starling.juggler.add(_clip);
		}

		public function stop():void
		{
			Starling.juggler.remove(_clip);
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




				function complate(sp:SpriterClip):void
				{
					_clip.play(_animationName);
					_clip.animation.looping=true;
				}

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
			mIsDown=false;
			mbounds=null;
			_animationName="";
			_clip=null;
		}

	}
}
