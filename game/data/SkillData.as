package game.data
{
	import com.data.Data;
	import com.data.HashMap;

	import flash.utils.ByteArray;

	/**
	 * 技能
	 * @author Michael
	 *
	 */
	public class SkillData extends Data
	{
		/**
		 *
		 * 1、主动技能
		   2、主动锁定技能
		   3、主动觉醒技能
		   4、光环始终触发
		   5、光环被动触发
		   （光环触发不占回合）
		   （123，类型，按照优先级，3为最高，1为最低）
		 */
		public var type:int;

		/**
		 * 光环特效
		 * @default
		 */
		public var ringEffect:String;
		/**
		 * 攻击特效
		 * @default
		 */
		public var attackEffect:String;
		public var attackPosition:int;
		public var skillEffect:String;
		public var skillEffectPosition:int;
		public var callbackFrame:int;
		public var attackType:int;
		public var magicType:int;
		public var cmd:String;
		public var trigger:String;
		public var fireEffect:String; //施放特效
		/**
		 * 受击特效
		 * @default
		 */
		public var underAttackEffect:String;
		/**
		 * 受击特效位置
		 * @default
		 */
		public var underAttackPos:int;

		/**
		 *技能图标
		 */
		public var skillIcon:String;


		/**
		 *技能类型名字
		 */
		public var skillTypeName:String;


		/**
		 * 描述
		 * @default
		 */
		public var desc:String="";

		/**
		 *
		 * @param id
		 */
		public function SkillData(id:int=0)
		{
			this.id=id;
		}

		/**
		 *
		 * @param vo
		 */
		public function decode(vo:*):void
		{


		}

		/**
		 *
		 * @param id
		 * @return
		 */
		public static function create(id:int):SkillData
		{
			var skill:SkillData=_skillDatas.getValue(id);
			return skill.clone() as SkillData;
		}

		private static var _skillDatas:HashMap;

		/**
		 *
		 * @param id
		 * @return
		 */
		public static function getSkill(id:int):SkillData
		{
			return _skillDatas.getValue(id);
		}

		/**
		 *
		 * @param id
		 * @return
		 */
		public static function getAttackEffect(id:int):String
		{
			return (_skillDatas.getValue(id) as SkillData).attackEffect;
		}

		/**
		 *
		 * @param id
		 * @return
		 */
		public static function getUnderAttackEffect(id:int):String
		{
			return (_skillDatas.getValue(id) as SkillData).underAttackEffect;
		}

		/**
		 * 技能表数据
		 *
		 * @param data
		 */
		public static function init(data:ByteArray):void
		{
			_skillDatas=new HashMap();
			initData(data, _skillDatas, SkillData);
		}
	}
}
