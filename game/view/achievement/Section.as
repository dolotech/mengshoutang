package game.view.achievement {

    import com.sound.SoundManager;

    import game.view.achievement.data.AchievementData;
    import game.view.uitils.DisplayMemoryMrg;

    import starling.display.DisplayObject;
    import starling.display.Sprite;

    /**
     * 创建 不同的成就显示
     * @author litao
     *
     */
    public class Section extends Sprite {
        public var face:DisplayObject;

        public function Section() {
            AchievementData.instance.onUpate.add(onUpdate);
        }

        /**
         * @param type 1 = 总览, 2=日常,3=战斗,4=英雄,5=功能,6=技能
         */
        public function createSection(type:int):void {
            if (numChildren > 0)
                face = getChildAt(0);
            face && face.removeFromParent();
            face = null;

            switch (type) {
                case 1:
                    face = DisplayMemoryMrg.instance.getMemory("overall", Overall);
                    AchievementData.instance.currentSection = 6;
                    (face as Overall).Rest();
                    break;
                case 3:
                    face = DisplayMemoryMrg.instance.getMemory("daily", TaskList);
                    (face as TaskList).inits();
                    (face as TaskList).restItemRender(AchievementData.instance.SectionList(1));
                    AchievementData.instance.currentSection = 1;
                    break;
                case 4:
                    face = DisplayMemoryMrg.instance.getMemory("daily", TaskList);
                    (face as TaskList).inits();
                    (face as TaskList).restItemRender(AchievementData.instance.SectionList(2));
                    AchievementData.instance.currentSection = 2;
                    break;
                case 5:
                    face = DisplayMemoryMrg.instance.getMemory("daily", TaskList);
                    (face as TaskList).inits();
                    (face as TaskList).restItemRender(AchievementData.instance.SectionList(3));
                    AchievementData.instance.currentSection = 3;
                    break;
                case 6:
                    face = DisplayMemoryMrg.instance.getMemory("daily", TaskList);
                    (face as TaskList).inits();
                    (face as TaskList).restItemRender(AchievementData.instance.SectionList(4));
                    AchievementData.instance.currentSection = 4;
                    break;
                default :
                    break;
            }
            face && addChild(face);
        }

        private function onUpdate():void {
            if (this.numChildren == 0)
                return;
            var face:Object = getChildAt(0);
            SoundManager.instance.playSound("chengjiulingqu");

            if (AchievementData.instance.currentSection == 5) {
                face.restItemRender(AchievementData.instance.SectionList(6).concat(AchievementData.instance.SectionList(7).concat(AchievementData.instance.SectionList(8))));
            } else if (AchievementData.instance.currentSection == 6) {
                (face as Overall).Rest();
            } else if (AchievementData.instance.currentSection < 5) {
                face.restItemRender(AchievementData.instance.SectionList(AchievementData.instance.currentSection));
            }
        }

        override public function dispose():void {
            AchievementData.instance.onUpate.removeAll();
            DisplayMemoryMrg.instance.removeToMemory("overall");
            DisplayMemoryMrg.instance.removeToMemory("daily");
            DisplayMemoryMrg.instance.removeToMemory("fight");
            DisplayMemoryMrg.instance.removeToMemory("hero");
            DisplayMemoryMrg.instance.removeToMemory("function");
            DisplayMemoryMrg.instance.removeToMemory("arena");
            super.dispose();
        }

    }
}
