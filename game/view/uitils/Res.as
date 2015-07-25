package game.view.uitils {
    import game.data.Goods;
    import game.data.RoleShow;
    import game.manager.AssetMgr;

    import starling.textures.Texture;

    public class Res {
        private var assetMgr:AssetMgr;

        public function Res() {
            assetMgr = AssetMgr.instance;
        }

        private static var _instance:Res;

        public static function get instance():Res {
            if (_instance == null)
                _instance = new Res();
            return _instance;
        }

        /**
         * 人物头像
         * @param picture
         * @return
         *
         */
        public function getRolePhoto(picture:int):Texture {
            return assetMgr.getTexture("ui_pvp_renwutouxiang" + picture);
        }

        /**
         * 竞技图标
         * @param rankLevel
         * @return
         *
         */
        public function getRankPhoto(rankLevel:int):Texture {
            if (rankLevel == 0)
                rankLevel = 6;
            return assetMgr.getTexture("ui_iocn_qualifying" + rankLevel);
        }

        /**
         * 品质
         * @param quality
         * @return
         *
         */
        public function getQualityPhoto(quality:int):Texture {
            return assetMgr.getTexture(getQualityPhotoStr(quality));
        }

        /**
         * 品质
         * @param quality
         * @return str
         *
         */
        public function getQualityPhotoStr(quality:int):String {
            return "ui_gongyong_90wupingkuang" + (quality - 1);
        }

        /**
         * 胜利界面的品质图标
         * @param quality
         * @return
         *
         */
        public function getWinQualityPhoto(quality:int):Texture {
            return assetMgr.getTexture("ui_gongyong_90wupingkuang" + (quality - 1));
        }

        public function getWinHeroQualityPhoto(quality:int):Texture {
            return assetMgr.getTexture("ui_gongyong_100yingxiongkuang_" + (quality - 1));
        }

        /**
         * 英雄图标
         * @param show
         * @return
         *
         */
        public function getHeroIcoPhoto(show:int):Texture {
            return assetMgr.getTexture((RoleShow.hash.getValue(show) as RoleShow).photo);
        }

        /**
         * 英雄图标
         * @param show
         * @return
         *
         */
        public function getVipSpeedPhoto(speed:Number):Texture {
            return assetMgr.getTexture("ui_icon_acceleration" + Math.floor(speed) + "_" + (speed % 1.0) * 10);
        }

        /**
         * 获得物品的图标
         * @param id
         * @return
         *
         */
        public function getGoodsPhoto(id:int):Texture {
            var goods:Goods = Goods.goods.getValue(id);
            return assetMgr.getTexture(goods.picture);
        }

        /**
         * 获得货币图标
         * @param type 1金币，2钻石
         * @return
         *
         */
        public function getGoldPhoto(type:int):Texture {
            return assetMgr.getTexture(type == 1 ? "ui_gongyong_money" : "ui_gongyong_zuanshi");
        }
    }
}
