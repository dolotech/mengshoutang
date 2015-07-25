package feathers.controls
{
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;

    import feathers.controls.tree.TreeCellRenderer;
    import feathers.controls.tree.TreeCellRendererVO;
    import feathers.controls.tree.TreeEvent;

    import starling.display.Sprite;
    import starling.events.Event;

    /**
     *树组件
     * 支持无限级别的深度
     * 只需要给出一个xml格式即可
     * 该XML的格式如下
     *<node>
     *	<node label="BranchNode0">
     *	<node label="LeafNode0"/>
     *	<node label="LeafNode1"/>
     * </node>
     *  <node label="BranchNode1">
     *  <node label="LeafNode0"/>
     *  <node label="LeafNode1"/>
     * </node>
     *</node>;
     *
     * 注意节点的名字 node可以为任意名字。这里参考yahoo 的 astra-flash中的树组建的XML格式
     * 但每个节点内必须要有label属性，可以给“”值，但不能没有。因为他是节点的显示文字
     * 还可以自己加入其他任意属性。随后在组建中可以取出  比如<node label="test" id="1" data="id为1的data"/>
     * 这样的话 id和data都是属于自定义的属性。
     * 理论上可以支持N深度的XML列表
     * 但实际没有测试过。但百层以内的还是没问题的
     *
     *
     *
     * 简单的使用方法是这样
     var tree:Tree = new Tree();
     tree.x = 100;
     tree.dataProvider = myxml;
     tree.addEventListener(TreeEvent.CLICK_NODE, onClickTreeNode);
     this.addChild(tree);

     * 注意：请设置下treeWidth属性。用来设置树的宽度。这影响到鼠标经过的检测区域问题
     * 还可以设置itemRenderer属性来进行自定义渲染。请继承TreeCellRenderer来实现
     * 如果不设置 itemRenderer 默认使用TreeCellRenderer来渲染
     * 当其他属性都设置完毕后 最后请设置 dataProvider属性。给出一个XML  与上述所讲格式的XML即可。程序就自动根据XML进行绘制了
     * 主要算法 是 递归解析。 递归一遍XML 生成数据的VO(TreeCellRendererVO)放入数组（层叠递归存放的数组）
     * 随后在递归一边数组 生成渲染格子(TreeCellRenderer)放入一个层叠数组，和一个无深度的数组。
     *
     * @author Samuel
     *
     *
     */
    public class Tree extends ScrollContainer
    {
        public static const NODE_OPEN:String="nodeOpen";
        public static const NODE_CLOSE:String="nodeClose";

        private var _dataProvider:*;
        protected var xmlProvider:XML;
        private var _itemRenderer:*;
        public var maxLevel:int;
        /**
         *Array<TreeCellRendererVO>
         */
        protected var treeCellRendererVOArrayProvider:Array;
        /**
         *Array<TreeCellRenderer> 递归存放
         */
        protected var treeCellRendererArray:Array;
        /**
         *顺序存放的所有 TreeCellRenderer
         */
        protected var treeCellRendererList:Array;
        /**滚动容器*/
        protected var treeContainer:Sprite;
        /**当前选中对象*/
        protected var currentRenderer:TreeCellRenderer=null;

        public function Tree()
        {
            super();
            this.init();
        }

        /**初始化*/
        protected function init():void
        {

            horizontalScrollPolicy=Scroller.SCROLL_POLICY_OFF;
            verticalScrollPolicy=Scroller.SCROLL_POLICY_ON;
            this.initListener();
        }

        /**开始监听*/
        protected function initListener():void
        {
            this.addEventListener(TreeEvent.CLICK_NODE, onClickNode);
        }


        /**移除监听*/
        protected function removeListener():void
        {
            this.removeEventListener(TreeEvent.CLICK_NODE, onClickNode);
        }

        /**
         *点击了某一个节点的处理
         * @param e
         *
         */
        protected function onClickNode(e:TreeEvent):void
        {
            this.drawLayout();
            this.resetSelected(e);
        }

        /**
         *重新设置下选中哪个
         *
         */
        protected function resetSelected(e:TreeEvent):void
        {
            currentRenderer=e.target as TreeCellRenderer;
            for each (var treecell:TreeCellRenderer in this.treeCellRendererList)
            {
                if (currentRenderer != treecell)
                {
                    if (!currentRenderer.hasChildNodes)
                    {
                        treecell.unSelected();
                        this.readjustLayout();
                    }
                }
            }
        }

        /**
         *绘制布局
         * 这里设置下最根节点的布局
         * 但实际上在TreeCellRenderer中还要设置下各个项的子项位置,同样的方法
         * 如果在这里写一个递归统一设置下布局也可以。但就不用了。因为递归调用消耗还是比较大的
         * 就犯个小懒了 哈哈
         *
         */
        protected function drawLayout():void
        {
            if (this.treeCellRendererArray == null)
                return;
            var len:uint=this.treeCellRendererArray.length;
            for (var i:int=0; i < len; i++)
            {
                var childDis:TreeCellRenderer=this.treeCellRendererArray[i];

                if (i == 0)
                {
                    childDis.y=0;
                }
                else
                {
                    childDis.y=this.treeCellRendererArray[i - 1].y + this.treeCellRendererArray[i - 1].height;
                }
            }
            this.explicitHeight=this.treeContainer.height;

        }


        /**
         *这里绘制 UI
         * 但这里不设置位置
         * 位置统一在drawLayout中处理
         *
         */
        protected function drawUI():void
        {
            this.treeContainer=new Sprite();
            this.addChild(this.treeContainer);
            var len:uint=this.treeCellRendererArray.length;
            for (var i:int=0; i < len; i++)
            {
                var childDis:TreeCellRenderer=this.treeCellRendererArray[i];
                this.treeContainer.addChild(childDis);
            }
            this.drawLayout();
        }

        /**
         *这里进行XMl转换为TreeCellRendererVO数组的操作
         * @param dataXML
         *
         */
        protected function resolveXMLData(dataXML:XML):void
        {
            this.treeCellRendererVOArrayProvider=[];

            for each (var node:XML in dataXML.elements())
            {
                this.treeCellRendererVOArrayProvider.push(this.splitXMLDataToVO(null, node));
            }
            this.resolveArrayData(this.treeCellRendererVOArrayProvider);
        }

        /**
         *递归解析
         * 将XML解析为Array数组
         * @param parentVo
         * @param data
         * @return
         *
         */
        protected function splitXMLDataToVO(parentVo:TreeCellRendererVO, data:XML):TreeCellRendererVO
        {
            var treeCellRendererVO:TreeCellRendererVO=new TreeCellRendererVO();

            treeCellRendererVO.label=data.@label;

            //解析属性
            for each (var attribute:XML in data.attributes())
            {
                var attriName:String=String(attribute.name());
                var attriValue:String=String(attribute.toString());

                if (attriName != "label")
                {
                    treeCellRendererVO[attriName]=attriValue;
                }
            }

            if (parentVo != null)
            {
                treeCellRendererVO.parentNode=parentVo;
            }

            //判断是否有子节点
            if (data.elements().length() > 0)
            {
                //还有子节点
                treeCellRendererVO.childNodes=[];

                for each (var node:XML in data.elements())
                {
                    treeCellRendererVO.childNodes.push(this.splitXMLDataToVO(treeCellRendererVO, node));
                }
            }
            return treeCellRendererVO;
        }

        /**
         *这里进行 TreeCellRendererVO数组转换为TreeCellRenderer的操作
         * @param arrayTreeCellRendererVO Array<TreeCellRendererVO>
         *
         */
        protected function resolveArrayData(arrayTreeCellRendererVO:Array):void
        {
            this.treeCellRendererArray=[];
            this.treeCellRendererList=[];

            for each (var nodeVO:TreeCellRendererVO in arrayTreeCellRendererVO)
            {
                this.treeCellRendererArray.push(this.splitVOToRenderer(0, null, nodeVO));
            }

            this.drawUI();
        }

        /**
         * 递归解析
         * 将TreeCellRendererVo解析为TreeCellRenderer渲染项
         * @param parentRenderer
         * @param data
         * @return
         *
         */
        protected function splitVOToRenderer(level:int, parentRenderer:TreeCellRenderer, data:TreeCellRendererVO):TreeCellRenderer
        {
            var treeCellRenderer:TreeCellRenderer;
            if (this._itemRenderer == null)
            {
                treeCellRenderer=new TreeCellRenderer();
            }
            else
            {
                var renderer:Class=getDefinitionByName(getQualifiedClassName(this._itemRenderer)) as Class;
                treeCellRenderer=new renderer() as TreeCellRenderer;
            }

            treeCellRenderer.onwer=this;
            if (parentRenderer != null)
            {
                treeCellRenderer.parentNode=parentRenderer;
            }
            treeCellRenderer.level=level;

            if (data.hasChildNodes)
            {
                treeCellRenderer.childNodes=[];
                ++level;
                this.maxLevel=level;

                for each (var nodeVO:TreeCellRendererVO in data.childNodes)
                {
                    treeCellRenderer.childNodes.push(this.splitVOToRenderer(level, treeCellRenderer, nodeVO));
                }
                treeCellRenderer.drawChildrenDisplay();
            }
            treeCellRenderer.data=data;
            //放入一个集合中以便以后统一管理
            this.treeCellRendererList.push(treeCellRenderer);
            return treeCellRenderer;

        }


        /**获取自定义渲染器*/
        public function get itemRenderer():*
        {
            return _itemRenderer;
        }

        /**
         *定制一个自定义的渲染器
         * @param value
         *
         */
        public function set itemRenderer(value:*):void
        {
            _itemRenderer=value;
        }


        /**获取数据源*/
        public function get dataProvider():*
        {
            return _dataProvider;
        }

        /**
         *注入dataProvider后 进行类型判断分别处理
         * @param value 数据源目前支持xml 和Array的TreeCellRendererVO数据模型
         *
         */
        public function set dataProvider(value:*):void
        {
            while (this.treeContainer && this.treeContainer.numChildren > 0)
            {
                this.treeContainer.getChildAt(0).removeFromParent(true);
            }
            _dataProvider=value;

            if (value is XML)
            {
                this.xmlProvider=value;
                this.resolveXMLData(value);
                return;
            }

            if (value is Array)
            {
                this.treeCellRendererVOArrayProvider=value;
                this.resolveArrayData(value);
                return;
            }

        }

        public function get contentWidth():Number
        {
            return this.treeContainer ? this.treeContainer.width : 0;
        }

        public function get contentHeigth():Number
        {
            return this.treeContainer ? this.treeContainer.height : 0;
        }

        override public function dispose():void
        {
            while (this.treeContainer && this.treeContainer.numChildren > 0)
            {
                this.treeContainer.getChildAt(0).removeFromParent(true);
            }
            _dataProvider=null;
            xmlProvider=null;
            _itemRenderer=null;
            maxLevel=0;
            treeCellRendererVOArrayProvider=null;
            treeCellRendererArray=null;
            treeCellRendererList=null;
            treeContainer=null;
        }

    }
}
