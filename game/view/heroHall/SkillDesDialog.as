package game.view.heroHall {
    import com.utils.Constants;

    import game.data.SkillData;
    import game.manager.AssetMgr;
    import game.view.viewBase.SkillDesDialogBase;

    import starling.display.DisplayObjectContainer;

    public class SkillDesDialog extends SkillDesDialogBase {

        public function SkillDesDialog() {
            super();
        }

        override protected function init():void {
            enableTween = false;
            clickBackroundClose();
        }

        override public function open(container:DisplayObjectContainer, parameter:Object = null, okFun:Function = null, cancelFun:Function = null):void {
            creatUI(parameter.data as SkillData);
            super.open(container, parameter, okFun, cancelFun);
            this.x = parameter.point.x;
            this.y = parameter.point.y - this.height + 100 * Constants.scale;
        }

        protected function creatUI(skill:SkillData):void {
            skilName.text = skill.name;
            skillType.text = skill.skillTypeName;
            icon.texture = AssetMgr.instance.getTexture(skill.skillIcon);
            skillDes.text = skill.desc;
        }

        override public function dispose():void {
            super.dispose();
            while (this.numChildren > 0) {
                this.getChildAt(0).removeFromParent(true);
            }

        }
    }
}
