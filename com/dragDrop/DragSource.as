package com.dragDrop {
    import com.view.Clickable;

    import org.osflash.signals.ISignal;
    import org.osflash.signals.Signal;

    import starling.display.Image;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.textures.Texture;

    /**
     * 拖动对象
     * @author Michael
     *
     */
    public class DragSource extends Clickable implements IDragSource {
        private var touchPointID:int = -1;
        private var image:starling.display.Image;
        private var _data:DragData;
        protected var texture:Texture;

        protected var _onDragStart:Signal;
        protected var _onDragComplete:Signal;
        protected var _onChange:Signal;

        public function DragSource(texture:Texture = null, dragable:Boolean = true) {
            this._onDragStart = new Signal(DragSource);
            this._onDragComplete = new Signal(DragSource);
            this._onChange = new Signal(DragSource);

            _data = new DragData();

            if (texture) {
                inits(texture, dragable);
            }
        }

        public function remove():void {
            _onChange.removeAll();
            _onDragComplete.removeAll();
            _onDragStart.removeAll();
            _data = new DragData();
            this.removeEventListeners();
            this.removeFromParent();
        }

        public function inits(texture:Texture, dragable:Boolean = true):void {
            this.texture = texture;
            if (image)
                image.removeFromParent();
            image = new starling.display.Image(this.texture)
            this.addChild(image);
            if (dragable) {
                this.addEventListener(TouchEvent.TOUCH, onRenderTouchedHandler);
            }
        }


        public function get data():DragData {
            return _data;
        }

        protected function onRenderTouchedHandler(event:TouchEvent):void {
            var touch:Touch;
            touch = event.getTouch(this, TouchPhase.BEGAN);
            if (touch) {

            }

            touch = event.getTouch(this, TouchPhase.ENDED);
            if (touch) {

                if (touch.tapCount == 2) {
//					trace("double clicked!");
                } else {

                }

                this.touchPointID = -1;
            }

            touch = event.getTouch(this, TouchPhase.MOVED);
            if (touch) {
                if (this.touchPointID == touch.id)
                    return;
                this.touchPointID = touch.id;

                var avatar:Image = new starling.display.Image(this.texture)
                DragDropManager.startDrag(this, touch.clone(), _data, avatar, -avatar.width / 2, -avatar.height / 2);
            }

            touch = event.getTouch(this, TouchPhase.HOVER);
            if (touch) {

            }

            touch = event.getTouch(this);
            if (touch == null) {

            }
        }

        public function onDragStartHandler(value:Function):void {
            _onDragStart.add(value);
        }

        public function onDragCompletedHandler(value:Function):void {
            _onDragComplete.add(value);
        }

        public function get onDragStart():ISignal {
            return _onDragStart;
        }

        public function get onDragComplete():ISignal {
            return _onDragComplete;
        }

        public function get onChange():ISignal {
            return this._onChange;
        }

        override public function dispose():void {
            _onChange.removeAll();
            _onDragComplete.removeAll();
            _onDragStart.removeAll();
            _data.destroy();
            this.removeEventListeners();
            super.dispose();
        }
    }
}
