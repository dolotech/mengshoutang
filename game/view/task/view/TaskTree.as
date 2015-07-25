package game.view.task.view
{
    import feathers.controls.Tree;

    import game.view.task.render.TaskCellRender;

    /**
     * 任务列表
     * @author Samuel
     *
     */
    public class TaskTree extends Tree
    {
        public function TaskTree()
        {
            super();
        }


        /**大开所有父节点*/
        public function openAllNodes():void
        {
            for each (var treecell:TaskCellRender in this.treeCellRendererList)
            {
                if (treecell.hasChildNodes)
                {
                    treecell.selectItem();
                    this.readjustLayout();
                }
            }
            this.drawLayout();
        }


        /**大开开单个父节点*/
        public function openNodes(type:uint):void
        {
            for each (var treecell:TaskCellRender in this.treeCellRendererList)
            {
                if (treecell.hasChildNodes)
                {
                    if (uint(treecell.data.id) == type)
                    {
                        treecell.selectItem();
                        this.readjustLayout();
                        break;
                    }
                }
            }
            this.drawLayout();
        }


        /**大开第一个父节点*/
        public function openOneNode():void
        {
            for each (var treecell:TaskCellRender in this.treeCellRendererList)
            {
                if (treecell.hasChildNodes)
                {
                    treecell.selectItem();
                    this.readjustLayout();
                    break;
                }
            }
            this.drawLayout();
        }


        /**选中第一个子节点*/
        public function selectOneNode():void
        {
            for each (var treecell:TaskCellRender in this.treeCellRendererList)
            {
                if (treecell.hasParentNode)
                {
                    treecell.selectItem();
                    this.readjustLayout();
                    break;
                }
            }
            this.drawLayout();
        }

        /**选中某个子节点*/
        public function selectChildNode(id:uint):void
        {
            for each (var treecell:TaskCellRender in this.treeCellRendererList)
            {
                if (treecell.hasParentNode)
                {
                    if (uint(treecell.data.id) == id)
                    {
                        treecell.selectItem();
                        this.readjustLayout();
                        break;
                    }
                }
            }
            this.drawLayout();
        }


        /**
         * 获取节点渲染器选项
         * @param id 节点id
         * @param type 节点类型 0子节点类型 1父节点类型
         * @return TaskCellRender
         * */

        public function getCellRenderById(id:uint, type:uint=0):TaskCellRender
        {
            for each (var treecell:TaskCellRender in this.treeCellRendererList)
            {
                if (type == 0 && treecell.hasParentNode)
                {
                    if (uint(treecell.data.id) == id)
                    {
                        return treecell;
                    }
                }
                else if (type == 1 && treecell.hasChildNodes)
                {
                    if (uint(treecell.data.id) == id)
                    {
                        return treecell;
                    }

                }
            }
            return null;
        }



    }
}
