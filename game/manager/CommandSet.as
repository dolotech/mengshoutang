package game.manager
{
	import com.singleton.Singleton;

	import game.net.data.IData;
	import game.net.data.vo.BattleVo;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	public class CommandSet
	{
		private var _set : Vector.<IData>;
		private var _currentIndex : int;
		private var _lenght : int;
		private var _copySet : Vector.<IData>;
		public var onSkip : ISignal = new Signal();

		public function init(battleCommands : Vector.<IData>) : void
		{
			_set = battleCommands;
			_copySet = _set.concat();
			_currentIndex = 0;
			_lenght = _set.length;
		}

		public function replay() : void
		{
			_set = _copySet.concat();
			_currentIndex = 0;
			_lenght = _set.length;
		}

		public function pop() : BattleVo
		{
			if (_currentIndex >= _lenght)
				return null;

			var command : BattleVo = _set[_currentIndex++] as BattleVo;

			if (_currentIndex >= 5)
			{
				onSkip.dispatch();
			}
			return command;
		}

		public function getCommand() : BattleVo
		{
			if (_currentIndex >= _lenght)
				return null;

			var command : BattleVo = _set[_currentIndex] as BattleVo;
			return command;
		}

		private var end_count : int = -1;

		public function getEndCount() : int
		{
			return 30;
			if (end_count == -1)
				return BattleVo(_set[_set.length - 2]).bout;
			else
				return end_count;
		}

		public function getIndexCount() : int
		{
			var command : BattleVo = getCommand();
			return command ? command.bout : -1;
		}

		public function get originalLen() : int
		{
			return _lenght;
		}

		public function get lenght() : int
		{
			return _lenght - 1 - _currentIndex;
		}

		public function get currentIndex() : int
		{
			return _currentIndex;
		}

		public static function get instance() : CommandSet
		{
			return Singleton.getInstance(CommandSet) as CommandSet;
		}
	}
}