package game.view.replacePhotoList {
    import com.components.RollTips;
    import com.langue.Langue;
    import com.utils.ArrayUtil;
    import com.view.base.event.EventType;
    import feathers.controls.Scroller;
    import feathers.data.ListCollection;
    import feathers.layout.TiledColumnsLayout;
    import game.data.ConfigData;
    import game.data.GamePhotoData;
    import game.manager.GameMgr;
    import game.net.message.RoleInfomationMessage;
    import starling.events.Event;

    /**
     * 更换头像
     * @author liufurong
     */
    public class GamePhotoDlg extends GamePhotoDlgBase {
        public function GamePhotoDlg() {
            super();
            txt_name.text = Langue.getLangue("SelectAvatar");
        }

        override protected function init():void {
            const listLayout:TiledColumnsLayout = new TiledColumnsLayout();
            listLayout.gap = 20;
            listLayout.useSquareTiles = false;
            listLayout.useVirtualLayout = true;
            listLayout.horizontalAlign = TiledColumnsLayout.HORIZONTAL_ALIGN_CENTER;
            listLayout.verticalAlign = TiledColumnsLayout.TILE_VERTICAL_ALIGN_TOP;
            listLayout.paging = TiledColumnsLayout.PAGING_HORIZONTAL; //自动排列			
            list_bag.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF; //横向滚动 
            list_bag.verticalScrollPolicy = Scroller.SCROLL_POLICY_ON; //垂直 滚动 			
            list_bag.layout = listLayout;
            list_bag.itemRendererFactory = itemRendererFactory;
            function itemRendererFactory():NewGamePhotoRender {
                const renderer:NewGamePhotoRender = new NewGamePhotoRender();
                return renderer;
            }
            clickBackroundClose();
        }

        override protected function show():void {
            setToCenter();
            upHeroPhotolist();
        }

        /**
         * 点击打开更换头像按钮，更新头像列表
         */
        private function upHeroPhotolist():void {
            var heroPhotoArray:Array = ArrayUtil.change2Array(GamePhotoData.hashMapPhoto.values());
            list_bag.dataProvider = new ListCollection(heroPhotoArray);
        }

        override protected function addListenerHandler():void {
            super.addListenerHandler();
            this.addViewListener(list_bag, Event.CHANGE, onListHeroPhoto);
            this.addContextListener(EventType.UP_HEROPHOTO, updateHeroPhotoList);
        }

        /**
         * 点击头像的操作，更换头像是否成功
         */
        private function onListHeroPhoto(event:Event):void {
            var heroPhotoData:GamePhotoData = list_bag.selectedItem as GamePhotoData;
            // 角斗场关卡小于限制等级不可以更换头像
            if (GameMgr.instance.tollgateID <= ConfigData.instance.arenaGuide) {
                RollTips.add(Langue.getLangue("didNotReach"));
                return;
            }
            // 现在使用的头像已经使用了 不可以更换
            if (GameMgr.instance.picture == heroPhotoData.id) {
                RollTips.add(Langue.getLangue("useTheirOwnAvatar"));
                return;
            } else {
                // 请求更新头像
                RoleInfomationMessage.sendeHeroPhoto(heroPhotoData.id);
            }
        }

        /**
         * 成功更换头像,关闭窗口
         */
        private function updateHeroPhotoList():void {
            close();
        }

    }
}
