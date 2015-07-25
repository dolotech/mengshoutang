/**
 * Created with IntelliJ IDEA.
 * User: Administrator
 * Date: 13-11-13
 * Time: 下午4:17
 * To change this template use File | Settings | File Templates.
 */
package game.hero.command {
import game.hero.Hero;

public class GameoverCommand extends Command{
    public function GameoverCommand(executor:Hero) {
        super(executor);
    }

    override public function execute():void
    {
            _hero.visible = true;
            _hero.alpha = 1;
            _hero.startAnimation();

            _hero.playIdleAnimation();
//            var idle:IdleCommand = new IdleCommand(_hero);
//            _hero.command.addCommand(idle);
//            _hero.command.execute();

    }
}
}
