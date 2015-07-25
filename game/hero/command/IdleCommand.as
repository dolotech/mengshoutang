package game.hero.command
{
	import game.hero.Hero;

/**
	 * 待机循环检测行动命令
	 * @author Michael
	 *
	 */
	public class IdleCommand  extends Command
	{
		public function IdleCommand(executor:Hero)
		{
			super(executor);
		}
		override public function execute():void
		{
            _hero.playIdleAnimation();
		}
	}
}