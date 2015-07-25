package game.view.achievement {
    import com.sound.SoundManager;
    import com.utils.Constants;
    import com.view.Clickable;
    
    import game.data.Attain;
    import game.data.Goods;
    import game.data.HeroData;
    import game.data.RoleShow;
    import game.data.WidgetData;
    import game.hero.AnimationCreator;
    import game.manager.AssetMgr;
    import game.net.data.vo.AttainInfo;
    import game.view.gameover.WinView;
    import game.view.viewBase.ListItemRenderBase;
    
    import starling.core.Starling;
    import starling.display.Stage;
    import starling.events.TouchEvent;
    
    import treefortress.spriter.SpriterClip;

    /**
     * 成就完成提示
     * @author litao
     *
     */
    public class TipAchievement extends Clickable {
        private var goodsList:ListItemRenderBase;
        private var action:SpriterClip;
        private var data:AttainInfo;

        public function TipAchievement() {
            super();
            SoundManager.instance.playSound("chengjiu");
        }

        public function open(container:Stage, parameter:Object = null, okFun:Function = null, cancelFun:Function = null):void {
            data = parameter as AttainInfo;
            container.addChild(this);

            scaleX = scaleY = Constants.scale;
            addChildTip();
            showPros();
            this.addEventListener(TouchEvent.TOUCH, onClose);
        }

        private function onClose(evt:TouchEvent):void {
            this.removeFromParent(true);
        }

        private function showPros():void {
            var attainData:Attain = Attain.hash.getValue(data.id);
            goodsList.caption.text = attainData.caption;
            goodsList.title.text = attainData.name;

            if (attainData.goodsType != 5)
                goodsList.values.text = " x " + attainData.values;

            if (attainData.goodsType == 2) {
                goodsList.goodsIcon.texture = AssetMgr.instance.getTexture("ui_tubiao_zuanshi_da");
            } else if (attainData.goodsType == 1) {
                goodsList.goodsIcon.texture = AssetMgr.instance.getTexture("ui_tubiao_jinbi_da");
            } else if (attainData.goodsType == 3) {
                goodsList.goodsIcon.texture = AssetMgr.instance.getTexture("ui_wudixingyunxing_xingxing");
            } else if (attainData.goodsType == 5) {
                var type:int = attainData.values;
                var heroData:HeroData = (HeroData.hero.getValue(type) as HeroData);
                var photo:String = (RoleShow.hash.getValue(heroData.show) as RoleShow).photo;
                goodsList.goodsIcon.texture = AssetMgr.instance.getTexture(photo);
                goodsList.quality.texture = AssetMgr.instance.getTexture("ui_gongyong_100yingxiongkuang_" + heroData.quality);
            } else {
                var d:WidgetData = new WidgetData(Goods.goods.getValue(attainData.goodsType));
				goodsList.goodsIcon.texture = AssetMgr.instance.getTexture(d.picture);
                goodsList.quality.texture = AssetMgr.instance.getTexture("ui_gongyong_90wupingkuang" + (d.quality - 1));
            }
        }

        private function addChildTip():void {
            goodsList = new ListItemRenderBase();
            addQuiackChild(goodsList);
            goodsList.x = (Constants.virtualWidth >> 1) - (goodsList.width >> 1);
            goodsList.y = Constants.virtualHeight - goodsList.height - 30;
			goodsList.okReceive.visible = false;

            var action:SpriterClip = AnimationCreator.instance.create("effect_018", AssetMgr.instance);
            action.play("effect_018");
            action.animation.looping = true;
            action.touchable = false;
            Starling.juggler.add(action);
            action.x = goodsList.x + (goodsList.width >> 1);
            action.y = goodsList.y +　(goodsList.height >> 1);
            addQuiackChild(action);

            Starling.juggler.delayCall(function():void {
                removeFromParent(true);
            }, 3);
        }

        override public function dispose():void {
            this.removeEventListener(TouchEvent.TOUCH, onClose);
            WinView.achievementData = null;
            goodsList && goodsList.dispose();
            action && action.dispose();
            super.dispose();
        }
    }
}
