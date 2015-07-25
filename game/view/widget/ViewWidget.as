/**
 * Created with IntelliJ IDEA.
 * User: Administrator
 * Date: 13-12-16
 * Time: 下午7:40
 * To change this template use File | Settings | File Templates.
 */
package game.view.widget {
import com.sound.SoundManager;

import flash.geom.Rectangle;
import flash.text.TextField;

import game.data.Goods;
import game.manager.AssetMgr;

import org.osflash.signals.ISignal;
import org.osflash.signals.Signal;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.textures.Texture;

public class ViewWidget extends Sprite {
    private var _widgetData:Goods;
    private var _picture:Image;
    private var _quality:Boolean;
    public var onClick:ISignal;

    public function ViewWidget(widgetData:Goods,quality:Boolean = true) {
        _quality = quality;
        data   = widgetData;
        onClick = new Signal(Goods);
        addEventListener(TouchEvent.TOUCH, onTouch);
    }

    public function  set data(widgetData:Goods):void
    {
           if(widgetData)
           {
               _widgetData = widgetData;
               if (_widgetData) {
                   init(_widgetData);
               }
           }
    }

    private function init(widgetData:Goods, dragable:Boolean = true):void {

        if(_quality)
        {
            showQuality();
        }

       var texture:Texture =  AssetMgr.instance.getTexture(widgetData.picture);
//        if(_picture) _picture.removeFromParent();
        if(!_picture)
        {
            _picture=new starling.display.Image(texture)
            this.addChild(_picture);
        }
        else
        {
            _picture.texture = texture;
        }


    }

    private  var _qualityImage:Image;
    private function showQuality():void
    {
        var texture:Texture = AssetMgr.instance.getTexture("ui_gongyong_90wupingkuang"+ (_widgetData.quality - 1)) ;
        if(_qualityImage)
        {
            _qualityImage.texture = texture;
        }
        else
        {
            _qualityImage = new Image(texture) ;
            addChild(_qualityImage);
        }
    }

    private static const MAX_DRAG_DIST:Number = 50;

    private var mUpState:Texture;
    private var mDownState:Texture;

    private var mContents:Sprite;
    private var mBackground:Image;
    private var mTextField:TextField;
    private var mTextBounds:Rectangle;

    private var mScaleWhenDown:Number;
    private var mAlphaWhenDisabled:Number;
    private var mEnabled:Boolean;
    private var mIsDown:Boolean;
    private var mUseHandCursor:Boolean;
    private function onTouch(event:TouchEvent):void
    {

        var touch:Touch = event.getTouch(this);
        if (!mEnabled || touch == null) return;

        if (touch.phase == TouchPhase.BEGAN && !mIsDown)
        {
            if(mDownState)
            {
                mBackground.texture = mDownState;
                mContents.scaleX = mContents.scaleY = mScaleWhenDown;
                mContents.x = (1.0 - mScaleWhenDown) / 2.0 * mBackground.width;
                mContents.y = (1.0 - mScaleWhenDown) / 2.0 * mBackground.height;
            }
            mIsDown = true;
            SoundManager.instance.playSound("UI_click");
        }
        else if (touch.phase == TouchPhase.MOVED && mIsDown)
        {
            // reset button when user dragged too far away after pushing
            var buttonRect:Rectangle = getBounds(stage);
            if (touch.globalX < buttonRect.x - MAX_DRAG_DIST ||
                    touch.globalY < buttonRect.y - MAX_DRAG_DIST ||
                    touch.globalX > buttonRect.x + buttonRect.width + MAX_DRAG_DIST ||
                    touch.globalY > buttonRect.y + buttonRect.height + MAX_DRAG_DIST)
            {
                resetContents();
            }
        }
        else if (touch.phase == TouchPhase.ENDED && mIsDown)
        {
            resetContents();
            onClick.dispatch(_widgetData) ;
        }
    }

    private function resetContents():void
    {
        mIsDown = false;
        mBackground.texture = mUpState;
        mContents.x = mContents.y = 0;
        mContents.scaleX = mContents.scaleY = 1.0;
    }

}
}
