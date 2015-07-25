package com.net
{
	import com.mvc.core.Facade;
	import com.mvc.interfaces.INotification;
	import com.view.base.event.ViewDispatcher;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.ObjectEncoding;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	import game.net.data.AddCmd;
	import game.net.data.IData;

	import starling.animation.DelayedCall;
	import starling.core.Starling;

	/**
	 *
	 *
	 * 只负责传输二进制数据和解决半包粘包问题
	 *
	 * 不负责包结构解析
	 *
	 * 上行包结构：两个字节的包长+一个字节的包序+两个字节命令号(模块路由+方法路由)+具体的数据
	 *
	 * 下行包结构：两个字节的包长+两个字节命令号(模块路由+方法路由)+具体的数据
	 *
	 * @author Michael
	 *
	 */
	public class TcpSocket extends Facade
	{
		private const HEADLENGTH : uint = 2;
		protected var order : int = 0; // 自增包序
		protected var _ip : String; // 包头长度
		protected var _port : int;
		protected var _socket : Socket;
		protected var isSelf : Boolean;
		private var _recvBuffer : ByteArray;
		private var _tempBuffer : ByteArray;
		private var dispatcher : ViewDispatcher;
		private var delayCall : DelayedCall;

		public function get connected() : Boolean
		{
			return _socket && _socket.connected;
		}

		public function connect(ip : String, port : int) : void
		{
			this._ip = ip;
			this._port = port;
			order = 0;
			_recvBuffer = new ByteArray();
			_tempBuffer = new ByteArray();

			_socket && close(true) && removeListener();

			try
			{
				_socket = new Socket();
			}
			catch (e : Error)
			{
				_socket = new Socket();
			}
			addListener();
			_socket.timeout = 5000;
			_socket.objectEncoding = ObjectEncoding.AMF3;
			_socket.endian = Endian.BIG_ENDIAN;
			_socket.connect(_ip, _port);
			dispatcher = ViewDispatcher.instance;

			if (delayCall)
				Starling.juggler.remove(delayCall);
			delayCall = Starling.juggler.delayCall(function() : void
				{
					delayCall = null;

					if (!_socket.connected)
					{
						trace("重新连接");
						closeHandler(null);
					}
					else
					{
						trace("已经连接");
					}
				}, 5);
		}

		public function close(isSelf : Boolean = false) : void
		{
			this.isSelf = isSelf;
			order = 0;

			try
			{
				if (isSelf && delayCall)
					Starling.juggler.remove(delayCall);
				_socket.close();
			}
			catch (e : Error)
			{

			}

		}

		public function sendData(dataBase : IData) : void
		{
			send(dataBase.getCmd(), dataBase.serialize());
		}

		protected function addListener() : void
		{
			_socket.addEventListener(Event.CONNECT, connectHandler);
			_socket.addEventListener(Event.CLOSE, closeHandler);
			_socket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			_socket.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
		}

		protected function removeListener() : void
		{
			_socket.removeEventListener(Event.CLOSE, closeHandler);
			_socket.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			_socket.removeEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
			_socket.removeEventListener(Event.CONNECT, connectHandler);
		}

		/**
		 *    发送网络数据
		 * @param module    - 模块路由
		 * @param data        - 具体数据
		 *
		 */
		protected function send(module : uint, dataBytes : ByteArray) : void
		{
			if (!_socket.connected)
			{
				return;
			}
			//取对象
			var sendBytes : ByteArray = new ByteArray();
			sendBytes.writeShort(dataBytes.length); // 写入包长(不包括包头长度)
			sendBytes.writeByte(order);
			sendBytes.writeShort(module);
			sendBytes.writeBytes(dataBytes, 0, dataBytes.bytesAvailable);
			_socket.writeBytes(sendBytes);
			_socket.flush();

			if (order >= 255)
			{

				order = 0;
			}
			else
			{
				order++;
			}
		}

		protected function dispatchData(dataBase : INotification) : void
		{
			notifyObserver(dataBase);
		}

		/**
		 *身份验证
		 * @param data
		 *
		 */
		private function identity() : void
		{
			if (!_socket.connected)
			{
				return;
			}
			_socket.writeUTFBytes("ABCDEFGHIJKLMN876543210");
			_socket.flush();
		}

		protected function closeHandler(event : Event) : void
		{
			removeListener()
		}

		protected function connectHandler(event : Event) : void
		{
			identity();
		}

		protected function ioErrorHandler(event : IOErrorEvent) : void
		{
			removeListener()

			try
			{
				close();
			}
			catch (e : Error)
			{
				trace(e);
			}
		}

		protected function securityErrorHandler(event : SecurityErrorEvent) : void
		{
			removeListener()

			try
			{
				close();
			}
			catch (e : Error)
			{
				trace(e);
			}
		}

		/**
		 * 解包过程
		 * 处理半包和粘包
		 */
		private function socketDataHandler(event : ProgressEvent) : void
		{
			_tempBuffer.clear();

			if (_recvBuffer.length > 0)
			{
				_tempBuffer.writeBytes(_recvBuffer);
				_tempBuffer.position = 0
				_recvBuffer.clear();
			}
			_socket.readBytes(_tempBuffer, _tempBuffer.length, _socket.bytesAvailable);

			while (_tempBuffer.bytesAvailable > 0)
			{
				var packlen : int = _tempBuffer.readUnsignedShort(); // 读取包内容长度

				if (_tempBuffer.bytesAvailable >= (packlen + HEADLENGTH)) // 判断是否接收完整包，否则把半包放回缓冲等待下次一起数据到来一起读取
				{
					var module : int = _tempBuffer.readUnsignedShort(); // 读取模块号
					//取对象
					var pack : ByteArray = new ByteArray();

					if (packlen > 0)
					{
						_tempBuffer.readBytes(pack, 0, packlen);
						pack.position = 0;
					}
					//取对象
					
					var className : Class = AddCmd.getClassByModule(module);
					var dataBase : IData = new className();
					dataBase.deSerialize(pack);
                    pack.clear();
					
					(dataBase as INotification).setName(module + "");
					if (!dispatchData(dataBase as INotification))
					{
						dispatcher.dispatch(dataBase.getCmd() + "", dataBase);
					}
				}
				else
				{
					_tempBuffer.position -= HEADLENGTH; // 恢复已读的包头指针
					_recvBuffer.writeBytes(_tempBuffer, _tempBuffer.position, _tempBuffer.bytesAvailable);
					_recvBuffer.position = 0;
					break;
				}
			}
		}
	}
}
