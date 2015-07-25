/**
 * Created with IntelliJ IDEA.
 * User: turbine
 * Date: 13-9-30
 * Time: 下午4:21
 * To change this template use File | Settings | File Templates.
 *
 *
 *
 * 角色移动
 */
package game.hero.command {
import game.hero.Hero;
import game.hero.MoveableEntity;

import starling.display.DisplayObject;

import treefortress.spriter.SpriterClip;

public class MoveCommand  extends Command{
    public function MoveCommand(executor:Hero) {

        super(executor);
    }

    public var target:DisplayObject;
    public var gapx:int = 0;
    public var gapy:int = 3;

    override public function execute():void
    {
        _hero.moveto(target,gapx,gapy);

        _hero.playMoveAnimation();
        _hero.onAnimationComplete(animationComplete);
        _hero.moveComplete.addOnce(moveComplete)
    }

    private  function moveComplete(entity:MoveableEntity):void
    {
        onComplete.dispatch(this);
    }

    private function animationComplete(sp:SpriterClip):void
    {

    }
}
}
