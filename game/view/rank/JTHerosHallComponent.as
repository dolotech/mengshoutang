package game.view.rank {
    import feathers.core.PopUpManager;

    import game.common.JTGlobalDef;
    import game.common.JTLogger;
    import game.data.HeroData;
    import game.managers.JTFunctionManager;
    import game.view.rank.ui.JTUIHeroBackground;

    import starling.display.Sprite;
    import starling.events.Event;

    /**
     * 英雄之家面板
     * @author CabbageWrom
     *
     */
    public class JTHerosHallComponent extends JTUIHeroBackground {
        private const MAX_HERO_NUM:int = 9;
        private static var instance:JTHerosHallComponent = null;

        public function JTHerosHallComponent(dataList:Object) {
            super();
            if (!dataList) {
                JTLogger.error("[JTHeroListComponent.JTHeroListComponent]dataList is empty!");
            }
            JTFunctionManager.registerFunction(JTGlobalDef.REFRESH_HERO_EQUIPMENT, onRefreshHeroEquip);
            initiliaze(dataList);
        }

        private function initiliaze(dataList:Object):void {
            JTScrollHerosPanel.show(this, dataList);
            this.btn_close.addEventListener(Event.TRIGGERED, onCloseHandler);
        }

        private function onCloseHandler(e:Event):void {
            hide();
        }

        private function onRefreshHeroEquip(itemInfo:Object):void {
            JTHeroEquipPanel.show(this, itemInfo as HeroData);
            JTHeroPropertys.show(this, itemInfo as HeroData);
        }

        override public function dispose():void {
            super.dispose();
            JTHeroUI.hide();
            JTHeroEquipPanel.hide();
            JTHeroPropertys.hide();
            JTScrollHerosPanel.hide();
            JTFunctionManager.removeFunction(JTGlobalDef.REFRESH_HERO_EQUIPMENT, onRefreshHeroEquip);
        }

        public static function show(parent:Sprite, dataList:Object):void {
            if (!instance) {
                instance = new JTHerosHallComponent(dataList);
                PopUpManager.addPopUp(instance, false);
            }
        }

        public static function getInstance():JTHerosHallComponent {
            return instance;
        }

        public static function showTitle(title:String):void {
            if (instance) {
                instance.txt_title.text = title;
            }
        }

        public static function hide():void {
            if (instance) {
                PopUpManager.removePopUp(instance, true);
                instance = null;
            }
        }
    }
}

