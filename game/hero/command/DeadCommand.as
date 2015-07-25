package game.hero.command
{
	import game.hero.Hero;

import starling.core.Starling;

/**
	 * 死亡
	 * @author Michael
	 *
	 */
	public class DeadCommand extends Command
	{
		public function DeadCommand(executor:Hero)
		{
			super(executor);
		}

		override public function execute():void
		{
            Starling.juggler.tween(_hero, 0.3, {alpha: 0, onComplete: onCompleteHer});
//            _hero.command.removeAllCommand();
		}

		private function onCompleteHer():void
		{
            Starling.juggler.removeTweens(_hero);
            _hero.visible = false;
            _hero.stopAnimation();
            onComplete.dispatch(this);
		}
	}
}


//6222 9800 6063 7529