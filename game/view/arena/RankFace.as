package game.view.arena
{
    import com.components.RollTips;
    import com.langue.Langue;
    import com.mvc.interfaces.INotification;

    import feathers.controls.List;
    import feathers.controls.renderers.IListItemRenderer;
    import feathers.data.ListCollection;
    import feathers.layout.TiledRowsLayout;

    import game.dialog.ShowLoader;
    import game.net.GameSocket;
    import game.net.data.IData;
    import game.net.data.c.CArena_rank;
    import game.net.data.c.CRank_box;
    import game.net.data.s.SArena_rank;
    import game.net.data.s.SRank_box;
    import game.view.arena.base.RankBoxBase;

    import starling.events.Event;

    /**
     * 竞技场,排行
     * @author litao
     *
     */
    public class RankFace extends RankBoxBase
    {
        private static var isOpen:Boolean;

        public function RankFace()
        {
            super();
            creatList();
            awardImage.touchable=false;
            boxButton.addEventListener(Event.TRIGGERED, onBox);
            awardImage.visible=false;
        }


        private function onBox(e:Event):void
        {
            var data:ArenaDareData=ArenaDareData.instance.getData("dare") as ArenaDareData;
            if (data.rank <= 100)
            {
                if (!isOpen)
                {
                    var cmd:CRank_box=new CRank_box;
                    GameSocket.instance.sendData(cmd);
                    ShowLoader.add();
                }
                else
                {
                    RollTips.add(Langue.getLangue("todayYouUse"));
                }
            }
            else
            {
                RollTips.add(Langue.getLangue("notInran"));
            }

        }

        private var _list:List;


        private function creatList():void
        {
            const listLayout:TiledRowsLayout=new TiledRowsLayout();
            listLayout.gap=12;
            listLayout.useSquareTiles=false;
            listLayout.useVirtualLayout=true;
            listLayout.paddingTop=12;
            listLayout.tileVerticalAlign=TiledRowsLayout.TILE_VERTICAL_ALIGN_TOP;
            listLayout.tileHorizontalAlign=TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
            _list=new List;
            _list.x=243;
            _list.y=175;
            _list.width=668;
            _list.height=388;
            _list.layout=listLayout;


            _list.itemRendererFactory=tileListItemRendererFactory;
            addChild(_list);
        }

        private function refreshHeroList(dataList:Vector.<IData>):void
        {
            const collection:ListCollection=new ListCollection(dataList);
            _list.dataProvider=collection;
        }

        private function tileListItemRendererFactory():IListItemRenderer
        {
            const renderer:RankItemRender=new RankItemRender();

            return renderer;
        }

        override public function handleNotification(_arg1:INotification):void
        {
            if (_arg1.getName() == String(SArena_rank.CMD))
            {
                var report:SArena_rank=_arg1 as SArena_rank;
                report.lists.unshift(null);
                refreshHeroList(report.lists);
            }
            else if (_arg1.getName() == String(SRank_box.CMD))
            {
                var box:SRank_box=_arg1 as SRank_box;
                if (box.code == 0)
                {
                    isOpen=true;
                    var arr:Array=Langue.getLans("arenaValue");
                    var coin:String=arr[0] + box.gold + ",";
                    var hon:String=arr[2] + box.honor + "";
                    RollTips.add(Langue.getLangue("obtain") + ":" + coin + hon);
                }
                else if (box.code == 1)
                {
                    RollTips.add(Langue.getLangue("todayYouUse"));
                }
                else if (box.code == 2)
                {
                    RollTips.add(Langue.getLangue("notInran"));
                }
                else if (box.code >= 127)
                {
                    RollTips.add(Langue.getLangue("codeError") + box.code);
                }
            }
            ShowLoader.remove();
        }

        override public function listNotificationName():Vector.<String>
        {
            var vect:Vector.<String>=new Vector.<String>;
            vect.push(SArena_rank.CMD);
            vect.push(CRank_box.CMD);
            return vect;
        }


        public function send():void
        {
            var cmd:CArena_rank=new CArena_rank;
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
import game.net.data.vo.RankList;
import game.view.arena.base.RankItemBase;

class RankItemRender extends DefaultListItemRenderer
{
    private var skin:RankItemBase

    public function RankItemRender()
    {
        setSize(657, 66);
        skin=new RankItemBase;
        defaultSkin=skin;
        skin.touchable=false;
        with (skin)
        {
            FightingTxt.fontName=expTxt.fontName=nameTxt.fontName=noTxt.fontName="方正综艺简体"

        }
    }

    override public function set data(value:Object):void
    {
        super.data=value;
        if (value == null)
        {
            var arr:Array=Langue.getLans("rankTitles");
            skin.noTxt.text=arr[0]
            skin.nameTxt.text=arr[1];
            skin.expTxt.text=arr[2];
            skin.FightingTxt.text=arr[3];

            return;
        }

//		var arr:Array = Langue.getLans("rankTitles");
//		var name:String = (value as RankList).name.charAt(0) == "^" ? (Robot.hash.getValue(info.name.charAt(2)) as Robot).name:info.name ;

        skin.noTxt.text=(value as RankList).index + "";
        var arr1:Array=((value as RankList).name as String).split(".");
        skin.nameTxt.text=arr1[0] == "^" ? (Robot.hash.getValue(int(arr1[1])) as Robot).name : (value as RankList).name;
        ;
        skin.expTxt.text=(value as RankList).exp + "";
        skin.FightingTxt.text=(value as RankList).fighting + "";
    }

    override public function dispose():void
    {
        skin && skin.dispose();
        super.dispose();
    }
}
