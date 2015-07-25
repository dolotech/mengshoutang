package feathers.controls.tree
{

    /**
     * 树组件的数据VO
     * 这个类定义为动态类，可以根据需要添加属性
     * 目前可以在对应的XML中写入相应 节点属性，会自动添加进这个类中
     * 这里的树结构使用的是递归存放形式
     * @author Samuel
     *
     */
    public dynamic class TreeCellRendererVO extends Object
    {
        private var _id:int=0;
        /**
         *父节点的数据
         */
        private var _parentNode:TreeCellRendererVO;
        /**
         *子节点的数据 Array<TreeCellRendererVO>
         */
        private var _childNodes:Array;
        /**
         *是否有父节点
         * [read-only]
         */
        private var _hasParentNode:Boolean;
        /**
         *是否有子节点
         * [read-only]
         */
        private var _hasChildNodes:Boolean;
        /**
         *节点文字
         */
        private var _label:String;

        public function TreeCellRendererVO()
        {
        }

        public function get id():int
        {
            return _id;
        }

        public function set id(value:int):void
        {
            _id=value;
        }

        public function get label():String
        {
            return _label;
        }

        public function set label(value:String):void
        {
            _label=value;
        }

        public function get hasChildNodes():Boolean
        {
            return _hasChildNodes;
        }


        public function get hasParentNodes():Boolean
        {
            return _hasParentNode;
        }


        public function get childNodes():Array
        {
            return _childNodes;
        }

        public function set childNodes(value:Array):void
        {
            _childNodes=value;

            this._hasChildNodes=true;
        }

        public function get parentNode():TreeCellRendererVO
        {
            return _parentNode;
        }

        public function set parentNode(value:TreeCellRendererVO):void
        {
            _parentNode=value;

            if (_parentNode != null)
            {
                this._hasParentNode=true;
            }
        }

    }
}
