package com.mvc.core
{
	import com.mvc.interfaces.IFacade;
	import com.mvc.interfaces.INotification;
	import com.mvc.interfaces.IObserver;

	import flash.utils.Dictionary;

	/**
	 *
	 * @author Michael
	 *
	 */
	public class Facade implements IFacade
	{


		private static var _observerMap : Dictionary = new Dictionary();
		private static var _instance : Facade;

		public function Facade()
		{
		}

		public static function get instance() : Facade
		{
			if (!_instance)
			{
				_instance = new Facade();
			}
			return _instance;
		}

		public static function addObserver(arg1 : String, _arg2 : IObserver) : void
		{
			var vector : Vector.<IObserver> = _observerMap[arg1];

			if (vector)
			{
				var len : int = vector.length;

				for (var i : int = 0; i < len; i++)
				{
					var observer : IObserver = vector[i] as IObserver;

					if (observer == _arg2)
					{
						break;
					}
				}
				vector.push(_arg2);

			}
			else
			{
				if (_observerMap[arg1] == null)
					_observerMap[arg1] = new Vector.<IObserver>();
				_observerMap[arg1].push(_arg2);
			}
		}

		public static function removeObserver(arg1 : String, _arg2 : IObserver) : void
		{
			var vector : Vector.<IObserver> = (_observerMap[arg1] as Vector.<IObserver>);

			if (vector == null)
				return;
			var len : int = vector.length;

			for (var i : int = len - 1; i >= 0; i--)
			{
				var observer : IObserver = vector[i] as IObserver;

				if (observer == _arg2)
				{
					vector.splice(i, 1);
					break;
				}
			}

			if (vector.length == 0)
			{
				delete _observerMap[arg1];
			}
		}

		public function notifyObserver(arg1 : INotification) : Boolean
		{
			var vector : Vector.<IObserver> = (_observerMap[arg1.getName()] as Vector.<IObserver>);

			if (vector == null)
				return false;
			var len : int = vector.length;
			var observer : IObserver;

			for (var i : int = len - 1; i >= 0; i--)
			{
				observer = vector[i] as IObserver;
				observer.handleNotification(arg1)
			}
			return len > 0;
		}
	}
}
