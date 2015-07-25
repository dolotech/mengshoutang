package game.uils
{

	import com.utils.ArrayUtil;
	import com.utils.Constants;
	
	import flash.data.EncryptedLocalStore;
	import flash.utils.ByteArray;
	
	import game.common.JTLogger;
	import game.net.message.MailMessage;

	/**
	 * 本地缓存管理
	 * @author yangyang
	 *
	 */
	public class LocalShareManager
	{
		public static const UPDATE : String = "update_data";
		public static const GM_USER_PWD : String = "gamecenter1_data";
		public static const USER_PWD : String = "user_data";
		public static const SOUND : String = "sound_data";
		public static const CHARGE : String = "charge_data";
		public static const SERVER : String = "server_list_data";
		public static const BEAST_BATTLE : String = "beast_battle";
		protected var local_data : Object;
		protected var PATH : String = "ccyxlm_data";
		private static var instance : LocalShareManager;

		public static function getInstance() : LocalShareManager
		{
			if (instance == null)
			{
				instance = new LocalShareManager();
				instance.init();
			}
			return instance;
		}

		public function LocalShareManager(path : String = "ccyxlm_data")
		{
			PATH = path;
		}

		/**
		 * 需要初始化两次，一次请求账号ID
		 * 第二次初始化账号信息
		 *
		 */
		public function init() : void
		{
			var bytes : ByteArray

			try
			{
				bytes = EncryptedLocalStore.getItem(PATH);
			}
			catch (errObject : Error)
			{
				JTLogger.warn(errObject);
			}

			if (bytes == null)
				local_data = {};
			else
				local_data = bytes.readObject();

		}

		public function get(property : String, isAddMd5 : Boolean = true) : *
		{
			return local_data[property + (isAddMd5 ? Constants.userPwdMd5 : "")];
		}

		public function save(property : String, data : *, isAddMd5 : Boolean = true) : Boolean
		{
			local_data[property + (isAddMd5 ? Constants.userPwdMd5 : "")] = data;

			//一些重要数据立马刷新
//			if (property == CHARGE || property == UPDATE)
				flush();
			return true;
		}

		public function clear(property : String, isAddMd5 : Boolean = true) : Boolean
		{
			delete local_data[property + (isAddMd5 ? Constants.userPwdMd5 : "")];
			flush();
			return true;
		}

		public function clearAll() : void
		{
			instance = null;
			local_data = {};
		}

		public function flush() : void
		{
			try
			{
				var bytes : ByteArray = new ByteArray();
				bytes.writeObject(local_data);
				EncryptedLocalStore.setItem(PATH, bytes);
			}
			catch (e : Error)
			{
				JTLogger.warn(e);
			}
		}

		/**
		 * 存储信息
		 *
		 */
		public function cacheSaveData() : void
		{
			MailMessage.savetReceiveList();
		}

	}
}