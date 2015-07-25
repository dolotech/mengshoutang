package game.view.achievement {
    import com.cache.Pool;

    import feathers.controls.List;
    import feathers.controls.renderers.IListItemRenderer;
    import feathers.data.ListCollection;
    import feathers.layout.TiledRowsLayout;

    import game.dialog.ShowLoader;
    import game.net.GameSocket;
    import game.net.data.IData;
    import game.net.data.c.CAttain_get;
    import game.net.data.vo.AttainInfo;
    import game.view.achievement.data.AchievementData;

    import starling.core.Starling;
    import starling.events.Event;

    public class TaskList extends List {
        public function inits(w:int = 0, h:int = 0):void {
            const listLayout:TiledRowsLayout = new TiledRowsLayout();
            listLayout.gap = 1;
            listLayout.useSquareTiles = false;
            listLayout.useVirtualLayout = true;
            listLayout.tileVerticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_TOP;
            listLayout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;

            this.x = 244;
            this.y = 142;

            if (w == 0 && h == 0) {
                this.width = 670;
                this.height = 465;
            } else {
                this.width = w;
                this.height = h;
            }
            this
            layout = listLayout;
            paddingTop = 5;
            itemRendererFactory = tileListItemRendererFactory;
            super.addEventListener(Event.SELECT, onSelect);
        }

        public function restItemRender(dataList:Vector.<IData>):void {
            var i:int = 0;
            var length:int = dataList.length;
            var obj:AttainInfo;
            var data:Vector.<IData> = new Vector.<IData>;
            var k:int;

            for (i; i < length; i++) {
                obj = dataList[i] as AttainInfo;

                if (obj.type == 2)
                    continue;
                if (obj.id != 0) {
                    data[k++] = obj;
                }
            }

            data.sort(sortFun);
            function sortFun(a:AttainInfo, b:AttainInfo):Number {
                var result:int = 0;

                if (a.type > b.type) {
                    result = -1;
                } else if (a.type < b.type) {
                    result = 1;
                } else {
                    if (a.id < b.id) {
                        result = -1;
                    } else if (a.id > b.id) {
                        result = 1;
                    }
                }
                return result;
            }

            const collection:ListCollection = new ListCollection(data);

            dataProvider = collection;
            verticalScrollPosition = 800;
            Starling.juggler.delayCall(function():void {
                verticalScrollPosition = 0;
                var i:int = 0;
                var len:int = dataViewPort.numChildren;
                var item:Object;

                for (i; i < len; i++) {
                    item = dataViewPort.getChildAt(i);

                    if (item.data == currentData) {
                        item.data = item.data;
                        break;
                    }
                }
            }, 0.01);
            refreshBackgroundSkin()
        }

        private function tileListItemRendererFactory():IListItemRenderer {
            var renderer:taskItemRender = Pool.getObj(taskItemRender);

            if (!renderer) {
                renderer = new taskItemRender();
            }
            return renderer;
        }
        private var currentData:Object;

        private function onSelect(e:Event):void {
            if (selectedIndex == -1)
                return;
            var info:AttainInfo = selectedItem as AttainInfo;
            currentData = selectedItem;
            selectedIndex = -1;

            if (info.type == 1) {
                var cmd:CAttain_get = new CAttain_get();
                cmd.id = info.id;
                AchievementData.instance.getId = info.id;
                GameSocket.instance.sendData(cmd);
                ShowLoader.add();
            }
        }

        override public function dispose():void {
            super.dispose();
            currentData = null;
        }
    }
}

import com.cache.Pool;

import feathers.controls.renderers.DefaultListItemRenderer;

import game.common.JTLogger;
import game.data.Attain;
import game.data.Goods;
import game.data.HeroData;
import game.data.RoleShow;
import game.data.WidgetData;
import game.hero.AnimationCreator;
import game.manager.AssetMgr;
import game.net.data.vo.AttainInfo;
import game.view.achievement.data.AchievementData;
import game.view.viewBase.ListItemRenderBase;

import starling.core.Starling;
import starling.events.Event;

import treefortress.spriter.SpriterClip;

class taskItemRender extends DefaultListItemRenderer {
    public var skin:ListItemRenderBase = new ListItemRenderBase;
    private var maxPar:int;
    private var action:SpriterClip;

    public function taskItemRender() {
        defaultSkin = skin;
        for (var i:int = 0; i < skin.numChildren; i++) {
            skin.getChildAt(0).touchable = true;
        }
        setSize(641, 103);
    }

    override public function set data(value:Object):void {
        if (!value)
            return;
        var info:AttainInfo = value as AttainInfo;
        var attainData:Attain = Attain.hash.getValue(info.id);

        if (attainData == null) {
            JTLogger.warn("找不到成就：" + info.id);
            return;
        }
        skin.caption.text = attainData.caption;
        skin.title.text = attainData.name;
        skin.caption.touchable = true;
        skin.title.touchable = true;
        skin.okReceive.visible = true;
        skin.okReceive.touchable = true;

        if (attainData.goodsType != 5)
            skin.values.text = " x " + attainData.values;
        else
            skin.values.text = " x " + 1;
        action && action.removeFromParent();

        if (info.type != 0) {
            action = AnimationCreator.instance.create("effect_012", AssetMgr.instance);
            action.play("effect_012");
            action.animation.looping = true;
            Starling.juggler.add(action);
            action.x = skin.quality.x + (skin.quality.width >> 1);
            action.y = skin.quality.y + (skin.quality.height >> 1);
            addQuiackChild(action);
            action.touchable = true;
        } else {
            skin.okReceive.visible = false;
        }

        if (attainData.goodsType == 2) {
            skin.goodsIcon.texture = AssetMgr.instance.getTexture("ui_tubiao_zuanshi_da");
        } else if (attainData.goodsType == 1) {
            skin.goodsIcon.texture = AssetMgr.instance.getTexture("ui_tubiao_jinbi_da");
        } else if (attainData.goodsType == 3) {
            skin.goodsIcon.texture = AssetMgr.instance.getTexture("ui_wudixingyunxing_xingxing");
        } else if (attainData.goodsType == 5) {
            var type:int = attainData.values;
            var heroData:HeroData = (HeroData.hero.getValue(type) as HeroData);
            var photo:String = (RoleShow.hash.getValue(heroData.show) as RoleShow).photo;
            skin.goodsIcon.texture = AssetMgr.instance.getTexture(photo);
            skin.quality.texture = AssetMgr.instance.getTexture("ui_gongyong_100yingxiongkuang_" + (heroData.quality));
        } else {
            var d:WidgetData = new WidgetData(Goods.goods.getValue(attainData.goodsType));
            skin.goodsIcon.texture = AssetMgr.instance.getTexture(d.picture);
            skin.quality.texture = AssetMgr.instance.getTexture("ui_gongyong_90wupingkuang" + (d.quality - 1));
        }
        var total:int = AchievementData.instance.total(attainData.conditionType);
        var currentIndex:int = AchievementData.instance.currentIndex(info.id);
        super.data = value;
    }

    override public function set isSelected(value:Boolean):void {
        super.isSelected = value;
        owner.dispatchEventWith(Event.SELECT);
    }

    public function customDispose():void {
        //_isDispose = true;
    }

    private var _isDispose:Boolean;

    override public function dispose():void {
//        if (_isDispose) {
//            skin && skin.dispose();
//        } else {
//            Pool.setObj(this)
//        }
        super.dispose();
        skin && skin.removeFromParent(true);
    }
}
