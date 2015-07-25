package game.view.comm {
    import com.dialog.DialogMgr;
    import com.langue.Langue;

    import flash.geom.Point;

    import game.common.JTGlobalDef;
    import game.data.HeroData;
    import game.data.SkillData;
    import game.manager.AssetMgr;
    import game.managers.JTFunctionManager;
    import game.view.heroHall.SkillDesDialog;
    import game.view.uitils.Res;
    import game.view.viewBase.heroSkillBase;

    import starling.display.Button;
    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;

    public class HeroSkillDialog extends heroSkillBase {
        private var heroData:HeroData = null;

        public function HeroSkillDialog() {
            super();
        }

        override protected function init():void {
            enableTween = false;
            clickBackroundClose();
        }

        /**打开*/
        override public function open(container:DisplayObjectContainer, parameter:Object = null, okFun:Function = null, cancelFun:Function = null):void {
            super.open(container, parameter, okFun, cancelFun);
            JTFunctionManager.executeFunction(JTGlobalDef.STOP_CITY_ANIMATABLE);
            heroData = parameter as HeroData;
            creatUI(heroData);
            setToCenter();
        }

        override public function close():void {
            super.close();
            JTFunctionManager.executeFunction(JTGlobalDef.PLAY_CITY_ANIMATABLE);
        }

        private function creatUI(heroData:HeroData):void {
            heroIcon.texture = Res.instance.getHeroIcoPhoto(heroData.show);
            text_heroName.text = heroData.name;
            text_expert.text = Langue.getLangue("Expert_Location") + ":"; //擅长位置
            text_expertValue.text = Langue.getLans("hero_job")[heroData.job - 1];
            text_HabitWeapon.text = Langue.getLangue("Usual_Weapons") + ":"; //惯用武器
            text_HabitWeaponValue.text = Langue.getLans("Equip_type")[heroData.weapon - 1];
            text_heroPresent.text = Langue.getLangue("Hero_Introduction"); //英雄介绍信
            text_heroInfo.text = heroData.des;

            var skillData:SkillData;
            var image:Button = null;
            var arr:Array = [];
            for (var i:int = 0; i < 3; i++) {
                skillData = SkillData.getSkill(heroData["skill" + (i + 1)]);
                image = this["heroSkill_" + i] as Button;
                image.touchable = true;
                if (skillData) {
                    image.visible = true;
                    image.upState = AssetMgr.instance.getTexture(skillData.skillIcon);
                    image.addEventListener(TouchEvent.TOUCH, touchHandler);
                    arr.push(image);
                } else {
                    image.visible = false;
                }
            }

            if (arr.length == 1) {
                image = arr[0] as Button;
                image.x = 365;
            } else if (arr.length == 2) {
                image = arr[0] as Button;
                image.x = 310;
                image = arr[1] as Button;
                image.x = 410;
            } else if (arr.length == 3) {
                image = arr[0] as Button;
                image.x = 270;
                image = arr[1] as Button;
                image.x = 365;
                image = arr[2] as Button;
                image.x = 465;
            }
        }

        /**
         *点击英雄的技能 查看信息
         * @param e TouchEvent
         */
        private function touchHandler(e:TouchEvent):void {
            var index:uint = uint((e.currentTarget as DisplayObject).name.split("_")[1]) + 1;
            var touch:Touch = e.getTouch(stage);
            if (touch == null)
                return;
            var skillData:SkillData = SkillData.getSkill(heroData["skill" + index]);
            var p:Point = touch.getLocation(stage);
            p = new Point(p.x - 450, p.y);
            switch (touch && touch.phase) {
                case TouchPhase.BEGAN:
                    isVisible = true;
                    DialogMgr.instance.open(SkillDesDialog, {data: skillData, point: p});
                    break;
                case TouchPhase.ENDED:
                    DialogMgr.instance.closeDialog(SkillDesDialog);
                    break;
                default:
                    break;
            }
        }

        /**销毁*/
        override public function dispose():void {
            for (var i:int = 0; i < 3; ++i) {
                this["heroSkill_" + i].removeEventListener(TouchEvent.TOUCH, touchHandler);
            }

            while (this.numChildren > 0) {
                this.getChildAt(0).removeFromParent(true);
            }

            heroData = null;
        }
    }
}
