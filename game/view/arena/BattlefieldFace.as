package game.view.arena
{
    import com.mvc.interfaces.INotification;
    import com.utils.ObjectUtil;
    import com.view.View;

    import feathers.controls.List;
    import feathers.controls.renderers.IListItemRenderer;
    import feathers.data.ListCollection;
    import feathers.layout.TiledRowsLayout;

    import game.dialog.ShowLoader;
    import game.net.GameSocket;
    import game.net.data.IData;
    import game.net.data.c.CArena_report;
    import game.net.data.s.SArena_report;
    import game.net.data.vo.ReportList;
    import game.scene.arenaWorld.ArenaBattleLoader;

    import starling.events.Event;
    import starling.text.TextField;

    /**
     * 竞技场，战报
     * @author litao
     *
     */
    public class BattlefieldFace extends View
    {
        public function BattlefieldFace()
        {
            super();
            createList();
//			send();
        }
        private var _list:List;

        private function createList():void
        {

            const listLayout:TiledRowsLayout=new TiledRowsLayout();
            listLayout.gap=16;
            listLayout.useSquareTiles=false;
            listLayout.useVirtualLayout=true;

            listLayout.tileVerticalAlign=TiledRowsLayout.TILE_VERTICAL_ALIGN_TOP;
            listLayout.tileHorizontalAlign=TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
            _list=new List;
            _list.x=65;
            _list.y=165;
            _list.width=856;
            _list.height=354;
            _list.layout=listLayout;
            _list.paddingTop=15;

            _list.addEventListener(Event.CHANGE, onSelect);
            _list.itemRendererFactory=tileListItemRendererFactory;
            addChild(_list);
        }

        private function onSelect(e:Event):void
        {
            if (_list.selectedIndex == -1)
                return;
            var name:int=(_list.selectedItem as ReportList).name.charAt(0) == "^" ? 0 : 1;

            (new ArenaBattleLoader).load(_list.selectedItem.id, 2, name);

            _list.selectedIndex=-1;

        }

        private function refreshHeroList(dataList:Vector.<IData>):void
        {
            const collection:ListCollection=new ListCollection(dataList);
            _list.dataProvider=collection;
        }

        private function tileListItemRendererFactory():IListItemRenderer
        {
            const renderer:BattlefieldItemRender=new BattlefieldItemRender();

            return renderer;
        }


        private var tex:TextField;

        override public function handleNotification(_arg1:INotification):void
        {
            var report:SArena_report=_arg1 as SArena_report;
            if (tex && tex.parent)
                tex.removeFromParent(true);
            if (report.lists.length > 0)
                refreshHeroList(report.lists);
            else
            {
                tex=new TextField(200, 50, "暂无战报", "myFont", 32);
                addChild(tex);
                ObjectUtil.setToCenter(stage, tex);
            }
            ShowLoader.remove();
        }

        override public function listNotificationName():Vector.<String>
        {
            var vect:Vector.<String>=new Vector.<String>;
            vect.push(SArena_report.CMD);
            return vect;
        }


        public function send():void
        {
            var cmd:CArena_report=new CArena_report;
            GameSocket.instance.sendData(cmd);
            ShowLoader.add();
        }

        override public function dispose():void
        {
            _list.dispose();
            super.dispose();
        }

    }
}
import com.langue.Langue;

import feathers.controls.renderers.DefaultListItemRenderer;

import game.manager.AssetMgr;
import game.net.data.vo.ReportList;
import game.view.arena.base.BattlefieldBase;

import starling.display.Button;

class BattlefieldItemRender extends DefaultListItemRenderer
{
    private var skin:BattlefieldBase
    private var btn:Button;

    public function BattlefieldItemRender()
    {
        super();
        setSize(841, 63);
        skin=new BattlefieldBase;
        defaultSkin=skin;
        skin.touchable=false;
        btn=new Button(AssetMgr.instance.getTexture("ui_button_kapai_goumai"));
        btn.x=712;
        btn.width=132;
        btn.height=73;
        addChild(btn);
        btn.text=Langue.getLangue("Counter");
        btn.fontColor=0x0;
        btn.fontSize=30;
    }

    override public function set data(value:Object):void
    {
        if (!value)
            return;
        skin.youTxt.text=Langue.getLans("youBe")[0];
        skin.otherTxt.text=(value as ReportList).name;
        skin.otherTxt.fontName="方正综艺简体";
        skin.loseTxt.text=Langue.getLans("youBe")[1];
        skin.captionTxt.text=Langue.getLans("youBe")[2];
        super.data=value;
    }

    override public function dispose():void
    {
        skin.dispose();
        super.dispose();
    }
}