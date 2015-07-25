package com.components
{
	import com.sound.SoundManager;
	
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public class TabButton extends Sprite
	{
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
    
        private var mUseHandCursor:Boolean;
		private var _selected:Boolean;
		public var selected_click:Boolean;
		
		public function TabButton(upState:Texture, downState:Texture,text:String="")
		{
			mUpState = upState;
            mDownState = downState;
            mBackground = new Image(upState);
			addChild(mBackground);
			mEnabled = true;
            mUseHandCursor = true;
            mTextBounds = new Rectangle(0, 0, upState.width, upState.height);      
			if (text.length != 0) this.text = text;
			  
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function createTextField():void
        {
            if (mTextField == null)
            {
                mTextField = new TextField(mTextBounds.width, mTextBounds.height, "");
                mTextField.vAlign = VAlign.CENTER;
                mTextField.hAlign = HAlign.CENTER;
                mTextField.touchable = false;
                mTextField.autoScale = true;
                addChild(mTextField);
            }
            
            mTextField.width  = mTextBounds.width;
            mTextField.height = mTextBounds.height;
            mTextField.x = mTextBounds.x;
            mTextField.y = mTextBounds.y;
        }
		
		 /** The name of the font displayed on the button. May be a system font or a registered 
          * bitmap font. */
        public function get fontName():String { return mTextField ? mTextField.fontName : "Verdana"; }
        public function set fontName(value:String):void
        {
            createTextField();
            mTextField.fontName = value;
        }
        
        /** The size of the font. */
        public function get fontSize():Number { return mTextField ? mTextField.fontSize : 12; }
        public function set fontSize(value:Number):void
        {
            createTextField();
            mTextField.fontSize = value;
        }
        
        /** The color of the font. */
        public function get fontColor():uint { return mTextField ? mTextField.color : 0x0; }
        public function set fontColor(value:uint):void
        {
            createTextField();
            mTextField.color = value;
        }
		
        /** Indicates if the font should be bold. */
        public function get fontBold():Boolean { return mTextField ? mTextField.bold : false; }
        public function set fontBold(value:Boolean):void
        {
            createTextField();
            mTextField.bold = value;
        }
		
		 /** The text that is displayed on the button. */
        public function get text():String { return mTextField ? mTextField.text : ""; }
        public function set text(value:String):void
        {
            createTextField();
            mTextField.text = value;
        }

		private function onTouch(event:TouchEvent):void
        {
            Mouse.cursor = (mUseHandCursor && mEnabled && event.interactsWith(this)) ? 
                MouseCursor.BUTTON : MouseCursor.AUTO;
            
            var touch:Touch = event.getTouch(this);
            if ((!selected_click && _selected) || !mEnabled || touch == null)
			{
				return;
			}
            
            if (touch.phase == TouchPhase.BEGAN && (selected_click || !_selected) )
            {
                mBackground.texture = mDownState;
                _selected = true;
				SoundManager.instance.playSound("UI_click");
				dispatchEventWith(Event.TRIGGERED, true);
            }
            
			event.stopPropagation();
        }

		public function set selected(value : Boolean) : void
		{
			this._selected = value;

			if(this._selected == true)
			{
				mBackground.texture = mDownState;
			}
			else
			{
				mBackground.texture = mUpState;
			}
		}

		public function get selected() : Boolean
		{
			return (this._selected);
		}
		
		/** The bounds of the textfield on the button. Allows moving the text to a custom position. */
		public function get textBounds():Rectangle { return mTextBounds.clone(); }
		public function set textBounds(value:Rectangle):void
		{
			mTextBounds = value.clone();
			createTextField();
		}

	}
}
