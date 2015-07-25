package game.data
{
	import com.data.Data;

	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	import game.manager.HeroDataMgr;
	import game.manager.TaskDataMgr;

	public class StoryConfigData extends Data
	{
		public var tollgateId : int;
		public var pos : int;
		public var taskId : int;

		public static var dic : Dictionary;
		public static var taskDic : Dictionary;

		public function StoryConfigData()
		{
			super();
		}

		public static function init(data : ByteArray) : void
		{
			dic = new Dictionary();
			taskDic = new Dictionary();
			data.position = 0;
			var vector : Array = data.readObject() as Array;
			var len : int = vector.length;

			for (var i : int = 0; i < len; i++)
			{
				var obj : Object = vector[i];
				var instance : StoryConfigData = new StoryConfigData();

				for (var key : String in obj)
				{
					instance[key] = obj[key];
				}

				if (instance.tollgateId > 0)
				{
					if (dic[instance.tollgateId] == null)
						dic[instance.tollgateId] = [];
					dic[instance.tollgateId].push(instance);
				}

				if (instance.taskId > 0)
				{
					if (taskDic[instance.taskId] == null)
						taskDic[instance.taskId] = [];
					taskDic[instance.taskId].push(instance);
				}
			}
		}

		public static function getStory(id : int, pos : int) : StoryConfigData
		{
			var taskData : TaskData = TaskDataMgr.instance.taskDataByTollgateId(id);
			var data : StoryConfigData;

			if (taskData != null)
				data = getStoryByTaskId(taskData.TaskId, pos);

			if (data == null)
				data = getStoryById(id, pos);
			return data;
		}

		public static function getStoryById(id : int, pos : int) : StoryConfigData
		{
			var tmp_list : Array = dic[id];

			if (tmp_list == null)
				return null;
			var len : int = tmp_list.length;
			var data : StoryConfigData;

			for (var i : int = 0; i < len; i++)
			{
				data = tmp_list[i]

				if (data.pos == pos)
					return data;
			}
			return null;
		}

		public static function getStoryByTaskId(id : int, pos : int) : StoryConfigData
		{
			var tmp_list : Array = taskDic[id];

			if (tmp_list == null)
				return null;
			var len : int = tmp_list.length;
			var data : StoryConfigData;

			for (var i : int = 0; i < len; i++)
			{
				data = tmp_list[i]

				if (data.pos == pos)
					return data;
			}
			return null;
		}

		public static function getAllHalfPhoto(id : int) : Array
		{
			var tmp_arr : Array = [];
			var data : StoryConfigData;

			for (var i : int = 1; i <= 3; i++)
			{
				data = getStory(id, i);

				if (data)
					tmp_arr = tmp_arr.concat(data.getHalfPhoto());
			}
			return tmp_arr;
		}

		public function getHalfPhoto() : Array
		{
			var tmp_arr : Array = [];
			var list : Array = StoryData.dic[id];

			if (list == null)
				return tmp_arr;
			var len : int = list.length;
			var storyData : StoryData;
			var target : HeroData;
			var roleShow : RoleShow;

			for (var i : int = 0; i < len; i++)
			{
				storyData = list[i];

				if (storyData.target == -1)
					continue;

				if (storyData.target == 0)
					target = HeroDataMgr.instance.getMaxLevelHero();
				else
					target = MonsterData.monster.getValue(storyData.target);
				roleShow = RoleShow.hash.getValue(target.show) as RoleShow;
				tmp_arr.push(roleShow.half_photo);
			}
			return tmp_arr;
		}
	}
}