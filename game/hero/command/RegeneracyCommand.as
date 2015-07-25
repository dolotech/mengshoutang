/**
 * Created with IntelliJ IDEA.
 * User: turbine
 * Date: 13-10-8
 * Time: 上午10:48
 * To change this template use File | Settings | File Templates.
 */
package game.hero.command {
import com.dialog.DialogMgr;
import com.scene.SceneMgr;
import com.sound.SoundManager;

import game.data.EffectSoundData;
import game.hero.AnimationCreator;
import game.hero.Hero;
import game.manager.BattleAssets;
import game.net.data.vo.BattleTarget;
import game.scene.BattleScene;

import treefortress.spriter.SpriterClip;

/*
      *
      * 复活
      *
      * */
public class RegeneracyCommand extends Command {

    public function RegeneracyCommand(executor:Hero) {
        super(executor);
    }

    public var battleTarget:BattleTarget;
    override public function execute():void
    {
        var skillName:String = "skill_103";
        var skillEffect:SpriterClip =AnimationCreator.instance.create(skillName,BattleAssets.instance,true);

        skillEffect.play(skillName);
        skillEffect.addCallback(skillcb,1087);
        playSound(skillName);
		DialogMgr.instance.closeAllDialog();
        var scene:BattleScene = SceneMgr.instance.getCurScene() as BattleScene;
        scene.addEffect(skillEffect,_hero.x,_hero.y-_hero.hitHeight/2);
    }

    private  function  skillcb():void
    {
        _hero.visible = true;
        _hero.alpha = 1;
        _hero.startAnimation();

        if(battleTarget)
        {
            _hero.data.currenthp = battleTarget.hp;
            _hero.onHPChange.dispatch(_hero);
        }

//        var idle:IdleCommand = new IdleCommand(_hero);
//        _hero.command.addCommand(idle);
//        _hero.command.execute();
        onComplete.dispatch(this);
    }

    private function playSound(skillName:String):void {
        var sound:EffectSoundData = EffectSoundData.hash.getValue(skillName);
        if(sound && sound.name)
        {
            SoundManager.instance.playSound(sound.sound);
        }
    }
}
}
