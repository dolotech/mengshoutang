/**
 * Created with IntelliJ IDEA.
 * User: turbine
 * Date: 13-9-30
 * Time: 下午4:29
 * To change this template use File | Settings | File Templates.
 */
package game.hero.command {
import game.hero.Hero;
import game.net.data.vo.BattleVo;

import org.osflash.signals.ISignal;
import org.osflash.signals.Signal;

public class Command {

    protected  var _hero:Hero
	public var  command:BattleVo;
    public var onComplete:ISignal;
    public function Command(executor:Hero) {
        _hero = executor;
        onComplete = new Signal(Command);
    }

    public function set executor(executor:Hero):void
    {
        _hero = executor;
    }

    public function execute():void
    {

    }
}
}
