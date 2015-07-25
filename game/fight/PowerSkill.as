/**
 * Created with IntelliJ IDEA.
 * User: Administrator
 * Date: 13-11-8
 * Time: 上午11:57
 * To change this template use File | Settings | File Templates.
 */
package game.fight {
    import com.dialog.DialogMgr;
    import com.scene.SceneMgr;
    import com.sound.SoundManager;
    import com.utils.Constants;

    import game.data.EffectSoundData;
    import game.data.SkillData;
    import game.hero.AnimationCreator;
    import game.hero.Hero;
    import game.manager.BattleAssets;
    import game.manager.BattleHeroMgr;
    import game.net.data.IData;
    import game.net.data.vo.BattleTarget;
    import game.net.data.vo.BattleVo;
    import game.scene.BattleScene;

    import org.osflash.signals.ISignal;
    import org.osflash.signals.Signal;

    import treefortress.spriter.SpriterClip;

    /*
    *
    * 觉醒技能
    * */
    public class PowerSkill {
        private  var scene:BattleScene;
        private var    battleTarget:Vector.<IData>;
        private var command:BattleVo;
        public var onComplete:ISignal;
        private var effect_040:SpriterClip;
        private var effect_041:SpriterClip;
        private var skillWord:SpriterClip
        /*
        * 觉醒技能
        *
        * */
        public function PowerSkill(skillData : SkillData,battleTarget:Vector.<IData>,command:BattleVo) {
            this.battleTarget = battleTarget;
            this.command = command;
            //effect_104  觉醒特效
            // effect_105 觉醒文字特效
            DialogMgr.instance.closeAllDialog();
            scene = SceneMgr.instance.getCurScene() as BattleScene;
            onComplete = new Signal(PowerSkill)   ;
            effect_040 =  AnimationCreator.instance.create("effect_040",BattleAssets.instance);
            effect_040.play("effect_040");
            effect_040.animation.looping = true;
            scene.addToPowerSkillLayer(effect_040,0,0);
            var sponsor:Hero = BattleHeroMgr.instance.hash.getValue(command.sponsor) as Hero;
            effect_041 = AnimationCreator.instance.create("effect_041",BattleAssets.instance);
            effect_041.play("effect_041");
            scene.addEffect(effect_041,0,0);
            effect_041.x = (Constants.virtualWidth) * .5 ;
            effect_041.y = (Constants.virtualHeight) * .5 - 150;
            var skillWordName:String;
            if(!sponsor.data.skillword)
            {
                skillWordName = "word_50004";         // 怪物统一觉醒技能名字
            }
            else
            {
                skillWordName = sponsor.data.skillword;
            }
            skillWord =  AnimationCreator.instance.create(skillWordName,BattleAssets.instance);
            skillWord.animationComplete.addOnce(skillWordComplate);
            skillWord.play(skillWordName);
            scene.addEffect(skillWord,0,0);

            skillWord.x = (Constants.virtualWidth ) * .5;
            skillWord.y = (Constants.virtualHeight ) * .5 - 150;

//        SoundManager.instance.playSound("juexingtexiao");

            battleTarget = command.targets as Vector.<IData>;
            var len : int = battleTarget.length;

            for (var i : int = 0; i < len; i++)
            {
                var battleT : BattleTarget = battleTarget[i] as BattleTarget;
                var target : Hero = BattleHeroMgr.instance.hash.getValue(battleT.id) as Hero;
                scene.addToPowerSkillLayer(target,target.x,target.y);

            }


            var sound:EffectSoundData = EffectSoundData.hash.getValue(skillWordName);
            if(sound && sound.name)
            {
                SoundManager.instance.playSound(sound.sound);
            }

//        sponsor.onNextOne.addOnce(unPowerSkill);

            scene.addToPowerSkillLayer(sponsor,sponsor.x,sponsor.y);
        }

        private function unPowerSkill() : void
        {
            if (this.command)
            {
                var battleTarget : Vector.<IData> = this.command.targets as Vector.<IData>;
                var len : int = battleTarget.length;

                for (var i : int = 0; i < len; i++)
                {
                    var battleT : BattleTarget = battleTarget[i] as BattleTarget;
                    var target : Hero = BattleHeroMgr.instance.hash.getValue(battleT.id) as Hero;
                    scene.addToRoleLayer(target,target.x,target.y);
                }
                target = BattleHeroMgr.instance.hash.getValue(this.command.sponsor) as Hero;
                scene.addToRoleLayer(target,target.x,target.y);
                this.command = null;
            }

            effect_040.dispose();
            effect_041.dispose();
            skillWord.dispose();
        }

        private function skillWordComplate(sp:SpriterClip):void
        {
            unPowerSkill();
            onComplete.dispatch(this);
        }
    }
}


