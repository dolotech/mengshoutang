/**
 * Created with IntelliJ IDEA.
 * User: Administrator
 * Date: 13-9-17
 * Time: 上午9:55
 * To change this template use File | Settings | File Templates.
 */
package com.utils {
import flash.geom.Rectangle;

import org.osflash.signals.ISignal;
import org.osflash.signals.Signal;

import starling.display.DisplayObject;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

/*
 *
 *   显示对象点击代理
 * */
public class TouchProxy {

    private static const MAX_DRAG_DIST:Number = 50;


//    private var mTextBounds:Rectangle;

//    private var mScaleWhenDown:Number;
//    private var mAlphaWhenDisabled:Number;
//    private var mEnabled:Boolean;

    public function TouchProxy(target:DisplayObject) {
        _target = target;
        _target.addEventListener(TouchEvent.TOUCH, onTouch);
        onClick = new Signal(Touch);
		onBack = new Signal();
		onMove = new Signal(Touch);
		onDown = new Signal(Touch);
		onUp = new Signal(Touch);
    }

//    private var mUseHandCursor:Boolean;
    public var onClick:ISignal;
    private var mIsDown:Boolean;
    private var _target:DisplayObject;
	public var onBack:ISignal;
	public var onMove:ISignal;
	public var onDown:ISignal;
	public var onUp:ISignal;

    private function onTouch(event:TouchEvent):void {
//        Mouse.cursor = (mUseHandCursor && mEnabled && event.interactsWith(_target)) ?
//                MouseCursor.BUTTON : MouseCursor.AUTO;

        var touch:Touch = event.getTouch(_target);
        if (touch == null) return;
//		trace(this,mIsDown);
        if (touch.phase == TouchPhase.BEGAN && !mIsDown) {
			onDown.dispatch(touch);
            mIsDown = true;
		
            //       SoundManager.instance.playSound("UI_click");
        }
        else if (touch.phase == TouchPhase.MOVED && mIsDown) {
            // reset button when user dragged too far away after pushing
            var buttonRect:Rectangle = _target.getBounds(_target.stage);
			onMove.dispatch(touch);
            if (touch.globalX < buttonRect.x - MAX_DRAG_DIST ||
                    touch.globalY < buttonRect.y - MAX_DRAG_DIST ||
                    touch.globalX > buttonRect.x + buttonRect.width + MAX_DRAG_DIST ||
                    touch.globalY > buttonRect.y + buttonRect.height + MAX_DRAG_DIST) {
                mIsDown = false;

            }
        }
        else if (touch.phase == TouchPhase.ENDED && mIsDown) {
            mIsDown = false;
//            dispatchEventWith(Event.TRIGGERED, true);
            onClick.dispatch(touch);
			onBack.dispatch(_target);
        }
		else if (touch.phase == TouchPhase.ENDED)
		{
			onUp.dispatch(touch);
		}
    }
}
}
