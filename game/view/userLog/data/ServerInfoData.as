package game.view.userLog.data
{
	import com.data.Data;

	public class ServerInfoData extends Data
	{
		/**
		 * 服务器ID 
		 */
		public var sid : int;
		public var port : int;
		public var ip : String;
		/**
		 * 1正常2爆满3维护中 4新区5即将开放
		 */
		public var status : int;
		/**
		 * 版本号 
		 */
		public var version : String;
		/**
		 * 说明 
		 */
		public var des : String;

		public function ServerInfoData()
		{
			super();
		}
	}
}