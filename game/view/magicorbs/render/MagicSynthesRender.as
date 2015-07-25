package game.view.magicorbs.render {
    import feathers.controls.renderers.DefaultListItemRenderer;

    import game.data.ForgeData;
    import game.data.Goods;
    import game.data.WidgetData;
    import game.hero.AnimationCreator;
    import game.manager.AssetMgr;

    import starling.core.Starling;
    import starling.display.Image;
    import starling.events.Event;
    import starling.text.TextField;
    import starling.textures.Texture;

    import treefortress.spriter.SpriterClip;

    public class MagicSynthesRender extends DefaultListItemRenderer {
        private var selectIco:SpriterClip;
        private var bg:Image;
        private var quaBg:Image;
        private var fusion:Image;
        private var image:Image;
        private var goods:Goods;
        private var txt_name:TextField;

        public function MagicSynthesRender() {
            super();
            setSize(93.25, 91.15);
        }

        override public function set data(value:Object):void {
            super.data = value;
            if (value == null)
                return;

            var data:Goods = value as Goods;
            goods = Goods.goods.getValue(data.type);
            var texture:Texture = AssetMgr.instance.getTexture("ui_gongyong_90wupingkuang" + (goods.quality - 1));
            bg = updateImage(bg, texture, 0);
            image = updateImage(image, value == null ? null : AssetMgr.instance.getTexture(goods.picture));

            updataText();
            createFusion(goods);
        }

        private function updataText():void {
            if (txt_name == null) {
                txt_name = new TextField(93.25, 30, '', '', 20, 0xF0952C, false);
                txt_name.name = "txt_name";
                this.addChild(txt_name);
                txt_name.text = goods.name;
                txt_name.touchable = false;
                txt_name.y = image.y + image.height;
            }

            if (goods.name) {
                txt_name.text = goods.name;
            } else {
                txt_name.text = "";
            }
        }

        override public function set isSelected(value:Boolean):void {
            super.isSelected = value;

            if (value) {
                if (!selectIco) {
                    selectIco = AnimationCreator.instance.create("effect_012", AssetMgr.instance);
                }

                if (!selectIco.parent) {
                    selectIco.play("effect_012");
                    selectIco.animation.looping = true;
                    Starling.juggler.add(selectIco);
                    selectIco.x = bg.width >> 1;
                    selectIco.y = bg.height >> 1;
                    addChild(selectIco);
                    selectIco.touchable = false;
                }
                owner.dispatchEventWith(Event.SELECT, false, data);
            } else {
                if (selectIco) {
                    selectIco.stop();
                    Starling.juggler.remove(selectIco);
                    selectIco.removeFromParent();
                }
            }
        }

        private function createFusion(value:Boolean = false):void {
            var textureQua:Texture = AssetMgr.instance.getTexture("ui_gongyong_90wupingkuang");
            quaBg = updateImage(quaBg, textureQua, 0);

            var forgrArr:Vector.<*> = ForgeData.hash.values();
            var len:int = forgrArr.length;
            var tmpForge:ForgeData;
            var forge:ForgeData
            for (var i:int = 0; i < len; i++) {
                tmpForge = forgrArr[i] as ForgeData;
                // 过滤宝珠
                if (tmpForge.maxSort == 3 && tmpForge.miniSort == data.quality - 1) {
                    forge = tmpForge;
                    break;
                }
            }

            var num:int = WidgetData.pileByType(goods.type - 1);
            if (num >= forge.magicNumber) {
                var texture:Texture = value ? AssetMgr.instance.getTexture("ui_strengthen_jianglilingqu") : null;
                fusion = updateImage(fusion, texture);
                fusion.x = 20;
            } else {
                fusion && fusion.removeFromParent();
            }
        }

        private function updateImage(image:Image, texture:Texture, index:int = -1):Image {
            if (image) {
                image.removeFromParent();
            }

            if (image == null && texture) {
                image = new Image(texture);
            } else if (texture) {
                image.texture = texture;
            }

            if (image) {
                image.visible = texture != null;
                index == -1 ? addChild(image) : addChildAt(image, index);
            }
            return image;
        }
    }
}
