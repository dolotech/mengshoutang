package game.view.arena
{
    import com.components.RollTips;
    import com.mvc.interfaces.INotification;
    import com.utils.ObjectUtil;
    import com.view.View;

    import feathers.controls.List;
    import feathers.controls.renderers.IListItemRenderer;
    import feathers.data.ListCollection;
    import feathers.layout.TiledRowsLayout;

    import game.dialog.ShowLoader;
    import game.manager.GameMgr;
    import game.net.GameSocket;
    import game.net.data.IData;
    import game.net.data.c.CArena_bonus;
    import game.net.data.s.SArena_bonus;
    import game.net.data.vo.ActiveTarget;
    import game.scene.arenaWorld.ArenaBattleLoader;

    import starling.events.Event;
    import starling.text.TextField;

    /**
     * 竞技场，悬赏
     * @author litao
     *
     */
    public class RewardFace extends View
    {
        public function RewardFace()
        {
            super();
            createList();
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
            if (GameMgr.instance.arenaname == (_list.selectedItem as ActiveTarget).name1 || GameMgr.instance.arenaname == (_list.selectedItem as ActiveTarget).name2)
            {
                RollTips.add("您在该榜中，不能接关于自己的榜");
                return;
            }
            var name:int=(_list.selectedItem as ActiveTarget).name2.charAt(0) == "^" ? 0 : 1;
            (new ArenaBattleLoader).load(_list.selectedItem.id, 3, name);

            _list.selectedIndex=-1;

        }

        private function refreshHeroList(dataList:Vector.<IData>):void
        {
            const collection:ListCollection=new ListCollection(dataList);
            _list.dataProvider=collection;
        }

        private function tileListItemRendererFactory():IListItemRenderer
        {
            const renderer:rewardItmeRender=new rewardItmeRender();

            return renderer;
        }

        private var text:TextField;

        override public function handleNotification(_arg1:INotification):void
        {
            if (text && text.parent)
                text.removeFromParent(true)


            var report:SArena_bonus=_arg1 as SArena_bonus;


            if (report.active.length > 0)
            {
                refreshHeroList(report.active);

            }
            else
            {
                text=new TextField(200, 50, "暂无悬赏", "myFont", 32);
                addChild(text);
                ObjectUtil.setToCenter(stage, text);
            }

            ShowLoader.remove();
        }

        override public function listNotificationName():Vector.<String>
        {
            var vect:Vector.<String>=new Vector.<String>;
            vect.push(SArena_bonus.CMD);
            return vect;
        }


        public function send():void
        {
            var cmd:CArena_bonus=new CArena_bonus;
            GameSocket.instance.sendData(cmd);
            ShowLoader.add();
        }

        override public function dispose():void
        {
            _list && _list.dispose();
            super.dispose();
        }
    }
}


import com.langue.Langue;

import feathers.controls.renderers.DefaultListItemRenderer;

import game.data.Robot;
import game.manager.AssetMgr;
import game.net.data.vo.ActiveTarget;
import game.view.arena.base.RewardItemBase;

import starling.display.Button;

class rewardItmeRender extends DefaultListItemRenderer
{
    private var skin:RewardItemBase
    private var btn:Button;

    public function rewardItmeRender()
    {
        setSize(841, 63);
        skin=new RewardItemBase;
        defaultSkin=skin;
        skin.touchable=false;
        btn=new Button(AssetMgr.instance.getTexture("ui_button_kapai_goumai"));
        btn.x=712;
        btn.width=132;
        btn.height=73;
        addChild(btn);
        btn.text=Langue.getLangue("Bounty");
        btn.fontColor=0x0;
        btn.fontSize=30;
        skin.beTxt.fontName=skin.captionTxt.fontName=skin.otherNameTxt.fontName=skin.myNameTxt.fontName="方正综艺简体";
    }

    override public function set data(value:Object):void
    {
        if (!value)
            return;
        skin.beTxt.text=Langue.getLangue("be");
        skin.myNameTxt.text=(value as ActiveTarget).name1;
        var arr1:Array=((value as ActiveTarget).name2 as String).split(".");
        skin.otherNameTxt.text=arr1[0] == "^" ? (Robot.hash.getValue(arr1[1]) as Robot).name : (value as ActiveTarget).name2;
        skin.captionTxt.text="打败了，正在悬赏1000w讨伐他";
        super.data=value;
    }
}
