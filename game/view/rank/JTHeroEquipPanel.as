package game.view.rank {
    import game.common.JTGlobalDef;
    import game.common.JTLogger;
    import game.data.ExpData;
    import game.data.Goods;
    import game.data.HeroData;
    import game.data.Val;
    import game.manager.AssetMgr;
    import game.managers.JTFunctionManager;
    import game.view.rank.ui.JTUIHeroEquipment;

    import starling.display.Image;
    import starling.display.Sprite;

    /**
     *
     * @author CabbageWrom
     *
     */
    public class JTHeroEquipPanel extends JTUIHeroEquipment {
        private static var _instance:JTHeroEquipPanel = null;

        public function JTHeroEquipPanel(heroInfo:HeroData = null) {
            super();

            if (heroInfo) {
                refreshUI(heroInfo);
            }
            JTFunctionManager.registerFunction(JTGlobalDef.REFRESH_HERO_PROPERTY, refreshUI);
        }

        public function refreshUI(heroInfo:HeroData):void {
            refreshHero(heroInfo);
            refreshHeroUI(heroInfo);
            refreshEquipments(heroInfo);
        }

        public function refreshHero(heroInfo:HeroData):void {
            pinzhi.texture = AssetMgr.instance.getTexture("ui_hero_yingxiongpinzhi_0" + heroInfo.getQualityImageId());
            heroType.texture = AssetMgr.instance.getTexture("ui_gongyong_zheyetubiao" + heroInfo.job);
            level_text.text = heroInfo.level + "";
            var exp:Number = (heroInfo.exp / ExpData.hash.getValue(heroInfo.level).exp * 100 >> 0);

            if (exp < 0)
                exp = 0;

            if (exp > 100)
                exp = 100;
            par.width = exp / 100 * 152;
            rate.text = exp > 100 ? "N/A" : exp + "%";

            if (heroInfo.level >= ExpData.hash.keys().length) {

            }
            hero_name.text = heroInfo.name;

            var color:Array = Val.HERO_COLOR;
            var index:int = heroInfo.quality - 1;
            index < 0 ? index = 0 : null;
            hero_name.color = color[index];
        }

        public function refreshEquipments(heroInfo:HeroData):void {
            for (var i:int = 0; i < 4; i++) {
                //大于0，data.widget[i],保存的装备Id
                var equipID:int = heroInfo["seat" + (i + 1)];
                if (equipID > 0) {
                    var goods:Goods = Goods.goods.getValue(equipID);
                    if (!goods) {
                        continue;
                    }

                    (this["Equip" + (i + 1)] as Image).texture = AssetMgr.instance.getTexture(goods.picture);
                    (this["box" + (i + 1)] as Image).texture = AssetMgr.instance.getTexture("ui_gongyong_90wupingkuang" + (goods.quality - 1));
                    if (goods.limitLevel >= 1) {
                        this["level" + (i + 1)].visible = true;
                        this["level" + (i + 1)].text = "";
                    } else {
                        this["level" + (i + 1)].visible = false;
                    }
                    this["sum" + (i + 1)].visible = false;
                } else {
                    (this["box" + (i + 1)] as Image).texture = AssetMgr.instance.getTexture("ui_gongyong_90wupingkuang0");
                    var txtTure:String = "";
                    switch (i) {
                        case 0:
                            txtTure = "ui_yingxiongshengdian_wuqikuangbiaozhi1";
                            break;
                        case 1:
                            txtTure = "ui_yingxiongshengdian_wuqikuangbiaozhi13";
                            break;
                        case 2:
                            txtTure = "ui_yingxiongshengdian_wuqikuangbiaozhi14";
                            break;
                        case 3:
                            txtTure = "ui_yingxiongshengdian_wuqikuangbiaozhi15";
                            break;
                    }
                    (this["Equip" + (i + 1)] as Image).texture = AssetMgr.instance.getTexture(txtTure);
                    this["level" + (i + 1)].visible = false;
                    this["sum" + (i + 1)].visible = true;
                }
                (this["Equip" + (i + 1)] as Image).x = (this["box" + (i + 1)] as Image).x;
                (this["Equip" + (i + 1)] as Image).y = (this["box" + (i + 1)] as Image).y;
            }
        }

        public function refreshHeroUI(heroInfo:HeroData):void {
            JTHeroUI.show(this, heroInfo, this.bg.x, this.bg.y);
            var heroUI:JTHeroUI = JTHeroUI.getInstance();
            var index:int = this.getChildIndex(heroUI);

            if (index == -1) {
                this.addChild(heroUI);
            }
            this.setChildIndex(heroUI, this.numChildren - 1);
        }

        override public function dispose():void {
            super.dispose();
            JTFunctionManager.removeFunction(JTGlobalDef.REFRESH_HERO_PROPERTY, refreshUI);
        }

        /**
         * 单方法为伪单例
         * @param parent 父容器
         * @param heroInfo 英难数据
         *
         */
        public static function show(parent:Sprite, heroInfo:HeroData):void {
            if (!_instance) {
                _instance = new JTHeroEquipPanel();
                _instance.x = -70;
                _instance.y = -24;
                parent.addChild(_instance);
            }

            if (_instance.parent != parent) {
                JTLogger.error();
            }
            _instance.refreshUI(heroInfo);
        }

        public static function hide():void {
            if (_instance) {
                _instance.removeFromParent();
                _instance.dispose();
                _instance = null;
            }
        }

        public static function instance(heroInfo:HeroData = null):JTHeroEquipPanel {
            return new JTHeroEquipPanel(heroInfo);
        }
    }
}


