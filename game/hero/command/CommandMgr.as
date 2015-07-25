/**
 * Created with IntelliJ IDEA.
 * User: turbine
 * Date: 13-10-7
 * Time: 上午9:39
 * To change this template use File | Settings | File Templates.
 */
package game.hero.command {
import starling.animation.IAnimatable;
import starling.core.Starling;

/*
*
* 角色行为命令处理
* */
public class CommandMgr implements IAnimatable {
    public var _todoList:Vector.<Command>;
    public var _lastCommand:Command;
    private var _idle:IdleCommand;

    public function CommandMgr(idle:IdleCommand) {
        _todoList = new <Command>[];
        _idle = idle;
//        Starling.juggler.add(this);
        execute();
    }

    public function hasCommand():Boolean
    {
        return Boolean(_todoList.length);
    }

    public function removeAllCommand():void
    {
        _todoList.length = 0;
    }
    public function addCommand(command:Command):void
    {
        _todoList.push(command);
    }

    private function  execute():void
    {
         var command:Command = popCommand();
        if(command)
        {
            Starling.juggler.remove(this);
            command.onComplete.addOnce(executeComplete);
            command.execute();
        }
        else
        {
            Starling.juggler.add(this);
            _idle.execute();
        }
    }

    private  function executeComplete(cmd:Command):void
    {
        execute();
    }

    private function popCommand():Command
    {
        if(_todoList.length > 0)
        {
            _lastCommand = _todoList.shift();
            return _lastCommand;
        }
        else
        {
            return null;
        }
    }

    public function advanceTime(time:Number):void
    {
        if(_todoList.length > 0)
        {
            execute();
        }
    }

    public function dispose():void {
        Starling.juggler.remove(this);
        _todoList.length = 0;
    }
}
}
