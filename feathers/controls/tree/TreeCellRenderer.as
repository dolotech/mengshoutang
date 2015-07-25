package feathers.controls.tree
{
    import feathers.controls.Tree;

    import game.manager.AssetMgr;

    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.text.TextField;
    import starling.text.TextFieldAutoSize;

    /**
     *树组件的渲染项
     * 注意，这个类作为基类使用。可以根据自定义样式进行继承重写
     * openIcon和closeIcon两个属性这里没有写 可以作为打开和关闭时候的图标显示 icon作为普通的图标显示
     * 如果使用openIcon和CloseIcon的话，需要重写initUI,drawData,setOpenIcon,setCloseIcon 这几个方法，
     * 顺序是 在initUI中进行初始化 new一下就可以
     * 在drawData中进行具体的设置，图片位置等 最后addQuiackChild
     * 在 setOpenIcon和setCloseIcon设置出现不出现 这两个方法会在该节点打开或者关闭的时候自动调用。只需要重写就可以了
     * openIcon和CloseIcon的资源根据项目需要自己设置。可以使用位图或者嵌入资源等。这里不做约束。类型给出的是*类型
     *
     * @author Samuel
     *
     */
    public class TreeCellRenderer extends Sprite
    {

        public var onwer:Tree;
        //鼠标作用的区域
        private var _data:TreeCellRendererVO;
        private var _parentNode:TreeCellRenderer;
        private var _childNodes:Array;
        private var _hasParentNode:Boolean;
        private var _hasChildNodes:Boolean;
        protected var icon:*;
        protected var labelTextField:TextField;
        private var _level:int;
        private var paddingX:int=30;
        protected var childrenContainer:Sprite;
        public var nodeStatus:String=Tree.NODE_CLOSE;
        private var _isSelected:Boolean;

        public function TreeCellRenderer()
        {
            super();
            this.initUI();
            this.initListener();
        }

        /**
         *是否选中
         * @return Boolean
         *
         */
        protected function get isSelected():Boolean
        {
            return _isSelected;
        }

        /**
         *初始化UI
         * 可以根据需要继承此类重写此方法，添加自己需要的UI组建
         * 此方法只是进行初始化UI ，不会将UI放置到显示列表中，也不会设置位置 宽度等。
         * 位置宽度 在drawData()中进行。如果需要自定义定位请重写drawData()方法
         *
         */
        protected function initUI():void
        {
            this.labelTextField=new TextField(100, 24, "lable", "myFont", 20, 0xffffff);
        }

        protected function initListener():void
        {
            this.addEventListener(TreeEvent.CLICK_NODE, otherClickNode);
            this.addEventListener(TouchEvent.TOUCH, onClick);
        }

        protected function removeListener():void
        {
            this.removeEventListener(TreeEvent.CLICK_NODE, otherClickNode);
            this.removeEventListener(TouchEvent.TOUCH, onClick);
        }

        /**
         *点击事件
         * @param e
         *
         */

        protected function onClick(e:TouchEvent):void
        {
            if (onwer.isScrolling)
                return;
            var touch:Touch=e.getTouch(e.currentTarget as Sprite);
            if (touch && touch.phase == TouchPhase.ENDED)
            {
                //终止事件的冒泡，因为MouseEvent事件在FP底层是默认冒泡派发的
                e.stopPropagation();
                this.clickNode();
                this.dispatchEvent(new TreeEvent(TreeEvent.CLICK_NODE, this, true));
            }

        }

        protected function clickNode():void
        {

            this.selected();

            if (!this.isOpen())
            {
                this.open();
            }
            else
            {
                this.close();
            }
        }

        /**
         *选中
         *
         */
        public function selected():void
        {

            this._isSelected=true;
            this.setSelectedBg();

        }

        /**
         *没选中
         *
         */
        public function unSelected():void
        {
            this._isSelected=false;
            this.unSelectedBg();
        }

        /**取消选中状态*/
        protected function unSelectedBg():void
        {
            if (!_isSelected && this.icon && !hasChildNodes)
            {
                (this.icon as Image).texture=AssetMgr.instance.getTexture("ui_butten_rongyufenleianniu1");
            }
        }

        /**选中状态*/
        protected function setSelectedBg():void
        {
            if (_isSelected && this.icon && !hasChildNodes)
            {
                (this.icon as Image).texture=AssetMgr.instance.getTexture("ui_butten_rongyufenleianniu2");
            }
        }

        /**
         *打开节点操作
         *
         */
        protected function open():void
        {
            if (this.hasChildNodes)
            {
                if (this.isOpen() == false)
                {
                    this.nodeStatus=Tree.NODE_OPEN;
                    this.childrenContainer.y=this.height;
                    this.addQuiackChild(this.childrenContainer);
                }
            }
        }


        /**
         *关闭节点操作
         *
         */
        protected function close():void
        {
            if (this.hasChildNodes)
            {
                if (this.isOpen() == true)
                {
                    this.nodeStatus=Tree.NODE_CLOSE;
                    this.childrenContainer.y=this.height;
                    this.childrenContainer.removeFromParent();
                }
            }
        }

        public function isOpen():Boolean
        {
            if (!this._hasChildNodes)
            {
                return false;
            }

            if (this.nodeStatus == Tree.NODE_OPEN)
            {
                return true;
            }

            if (this.nodeStatus == Tree.NODE_CLOSE)
            {
                return false;
            }
            return false;
        }

        protected function otherClickNode(e:TreeEvent):void
        {
            this.drawLayout();

        }

        /**
         *开始解析数据
         *
         */
        protected function resloveData():void
        {
            this.icon=(hasChildNodes) ? new Image(AssetMgr.instance.getTexture("ui_Buyingdiamond_title")) : new Image(AssetMgr.instance.getTexture("ui_butten_rongyufenleianniu1"));
            //没办法给的图大只能缩放一下
            this.icon.scaleX=0.9;
            this.icon.scaleY=0.9;
            this.drawData();
        }
        protected var ocReference:Image;

        /**
         *根据数据 构建UI
         * 所有UI已经在initUI中初始化过
         * 这里进行UI的位置和宽度的设置
         * 最后添加到显示列表中
         */
        protected function drawData():void
        {
            var iconReference:Image=this.icon as Image;
            iconReference.x=12;
            iconReference.y=2;
            this.addQuiackChild(iconReference);
            this.labelTextField.touchable=false;
            this.labelTextField.autoSize=TextFieldAutoSize.HORIZONTAL;
            this.labelTextField.fontSize=hasChildNodes ? 24 : 20;
            this.labelTextField.text=this.data.label;
            this.labelTextField.x=((iconReference.width - this.labelTextField.width) >> 1) + iconReference.x;
            this.labelTextField.y=((iconReference.height - this.labelTextField.height) >> 1) + iconReference.y;
            this.addQuiackChild(this.labelTextField);
        }

        /**
         *绘制子节点显示对象
         * 放入容器中childrenContainer
         * 这个容器暂时不显示
         *
         */
        public function drawChildrenDisplay():void
        {
            this.childrenContainer=new Sprite();
            var len:int=this._childNodes.length;
            for (var i:int=0; i < len; i++)
            {
                var childDis:TreeCellRenderer=this._childNodes[i];
                this.childrenContainer.addQuiackChild(childDis);
            }
            this.drawLayout();
        }

        /**
         *设置位置
         *
         */
        protected function drawLayout():void
        {
            if (!this._hasChildNodes)
            {
                return;
            }
            var len:int=this._childNodes.length;
            for (var i:int=0; i < len; i++)
            {
                var childDis:TreeCellRenderer=this._childNodes[i];

                if (i == 0)
                {
                    childDis.y=0;
                }
                else
                {
                    childDis.y=this._childNodes[i - 1].y + this._childNodes[i - 1].height;
                }
            }
        }

        public function get level():int
        {
            return _level;
        }

        public function set level(value:int):void
        {
            _level=value;

            if (value != 0)
            {
                this.x=paddingX;
            }
        }

        /**
         *是否有子节点
         * [read-only]
         */
        public function get hasChildNodes():Boolean
        {
            return _hasChildNodes;
        }

        /**
         *是否有父节点
         * [read-only]
         */
        public function get hasParentNode():Boolean
        {
            return _hasParentNode;
        }

        /**
         *子节点的数据 Array<TreeCellRenderer>
         */
        public function get childNodes():Array
        {
            return _childNodes;
        }

        /**
         * @private
         */
        public function set childNodes(value:Array):void
        {
            _childNodes=value;
            this._hasChildNodes=true;
        }

        /**
         *父节点的数据
         */
        public function get parentNode():TreeCellRenderer
        {
            return _parentNode;
        }

        /**
         * @private
         */
        public function set parentNode(value:TreeCellRenderer):void
        {
            _parentNode=value;

            if (_parentNode != null)
            {
                this._hasParentNode=true;
            }
        }

        public function get data():TreeCellRendererVO
        {
            return _data;
        }

        public function set data(value:TreeCellRendererVO):void
        {
            _data=value;

            if (_data != null)
            {
                this.resloveData();
            }
        }

        override public function dispose():void
        {
            super.dispose();
        }

    }
}
