package game.net.message.base
{
	import game.net.GameSocket;
	import game.net.data.IData;

	public class Notify
	{
		public function Notify()
		{
		}

		public function sendMessage(data : IData) : void
		{
			GameSocket.instance.sendData(data);
		}
	}
}