/**
 * Created with IntelliJ IDEA.
 * User: Administrator
 * Date: 13-9-16
 * Time: 下午4:28
 * To change this template use File | Settings | File Templates.
 */
package game.data
{
	import com.data.Data;
	import com.data.HashMap;
	
	import flash.utils.ByteArray;
	
	import game.manager.GameMgr;
	import game.net.message.RoleInfomationMessage;
	import game.uils.LocalShareManager;


	public class FBCDData extends Data
	{
		public var desc : String;
		public var eliteTime : int;
		public var liteBossTime : int;
		public var bossTime : int;
		public var fbTime : int;
		public var drop : Array;
		public var openLevel : int;
		public var openlevel3 : int;
		public var openlevel2 : int;

		public function FBCDData()
		{
			super();
			drop = [];
		}
		public static var hash : HashMap;

		public static function init(data : ByteArray) : void
		{
			hash = new HashMap();
			data.position = 0;
			var ex : RegExp = /\d+/gs;
			var vector : Array = data.readObject() as Array;
			var len : int = vector.length;

			for (var i : int = 0; i < len; i++)
			{
				var obj : Object = vector[i];
				var instance : FBCDData = new FBCDData();

				for (var key : String in obj)
				{
					var value : String = obj[key];

					if (key == "drop")
					{
						var subArr : Array = value.match(ex);
						instance[key] = subArr;
					}
					else
					{
						instance[key] = value;
					}
				}
				hash.put(instance.id, instance);
			}
		}

		/**
		 * 检测该副本是否打过
		 * @return
		 *
		 */
		public function checkPass(tollgateID : int = -1) : Boolean
		{
			for (var j : int = 0; j < 3; j++)
			{
				if (checkPassByIndex(j, tollgateID))
				{
					return true;
				}
			}
			return false;
		}

		public function checkPassByIndex(index : int, tollgateID : int = -1) : Boolean
		{
			if (tollgateID == -1)
				tollgateID = GameMgr.instance.tollgateID-1;
			var levels : Array = ["openLevel", "openlevel2", "openlevel3"];

			if (tollgateID >= this[levels[index]] && !checkFbAttack(id, index))
			{
				return true;
			}
			return false;
		}

		/**
		 * 检测是否有副本没有打过
		 * @param id
		 * @return false全部打过 true 有没有打过的
		 *
		 */
		public static function checkFbStatus(id : int) : Boolean
		{
			var list : Vector.<*> = hash.values();
			var data : FBCDData;
			var levels : Array = ["openLevel", "openlevel2", "openlevel3"];

			for (var i : int = 0, len : int = list.length; i < len; i++)
			{
				data = list[i];

				if (data.checkPass(id))
				{
					return true;
				}
			}
			return false;
		}

		private static function checkFbAttack(fbId : int, index : int) : Boolean
		{
			return getPassFbList().indexOf(fbId + "|" + index) >= 0;
		}
		
		public static function saveFbAttack(fbId : int, index : int) : void
		{
			if(!checkFbAttack(fbId,index))
			{
				getPassFbList().push(fbId + "|" + index);
				RoleInfomationMessage.sendeSaveRoleInfo(Val.PASS_FB,getPassFbList().join(","));
			}
		}

		/**
		 * 保存已经打过的副本
		 */
		private static var savePassFb : Array;

		public static function getPassFbList() : Array
		{
			if (savePassFb == null)
			{
				var abc : String = LocalShareManager.getInstance().get(Val.PASS_FB+"");

				if (abc)
					savePassFb = String(abc).split(",");
			}

			if (savePassFb == null)
			{
				RoleInfomationMessage.sendeGetSaveRoleInfo(Val.PASS_FB);
				savePassFb=[];
			}
			return savePassFb;
		}
		
		/**
		 * 更新通过的关卡列表 
		 * @param list
		 * 
		 */
		public static function updatePassFbList(list:Array):void
		{
			savePassFb=list;
			savePassFbList();
		}

		public static function savePassFbList() : void
		{
			if(savePassFb!=null)
			{
				LocalShareManager.getInstance().save(Val.PASS_FB+"",getPassFbList());
			}
		}
		
		public static function clear():void
		{
			savePassFb=null;
		}
	}
}
