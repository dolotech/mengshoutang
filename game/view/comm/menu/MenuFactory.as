package game.view.comm.menu
{

    import org.osflash.signals.ISignal;

    import starling.display.Sprite;
    import starling.events.Event;
    import starling.textures.Texture;

    public class MenuFactory extends Sprite
    {

        private var _objects:Array=[];
        private var _focus:ISignal;

        public function set onFocus(focus:ISignal):void
        {
            this._focus=focus;
        }

        override public function dispose():void
        {
            _focus && _focus.removeAll();
            _objects=null;
            super.dispose();
        }

        public function factory(objects:Array):void
        {
            var i:int=0;
            _objects.length=0;
            var length:int=objects.length;
            for (i; i < length; i++)
            {
                addButtons(objects[i]);
            }
        }

        private function addButtons(obj:Object):void
        {
            var downSkin:Texture=obj.downSkin;
            var defaultSkin:Texture=obj.defaultSkin;
            var menu:MenuButton=new MenuButton(defaultSkin, _focus, "", downSkin);
            _objects.push(menu);
            menu.x=obj.x;
            menu.y=obj.y;

            if (obj.width)
                menu.width=obj.width;
            if (obj.height)
                menu.height=obj.height;

            if (obj.text)
            {
                menu.text=obj.text;
                menu.fontSize=obj.size;
                menu.fontColor=obj.color;
            }
            menu.onTouchClick=obj.onClick;
            if (obj.name)
            {
                menu.name=obj.name;
            }
            addChild(menu);
            if (obj.isSelect)
            {
                menu.select();
            }
            if (obj.scale)
            {
                menu.scaleX=menu.scaleY=obj.scale;
            }
        }

        public function set selectedIndex(value:int):void
        {
            _objects[value].dispatchEventWith(Event.TRIGGERED);
        }

        public function get tableButtons():Array
        {
            return _objects;
        }
    }
}
