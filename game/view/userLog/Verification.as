package game.view.userLog
{
	/**
	 * 
	 * 登录规则
	 * @author litao
	 * 
	 */	
	public class Verification
	{
		/**
		 * 
		 * @param sign  字符
		 *  min 最少字符 8
		 *  max 最大字符 16
		 * @return   如果没有特殊符号并且达到条件，返回ture,否则返回flase
		 * 
		 */		
		public static function specialSign(sign:String):Boolean
		{
			var pattern:RegExp=/^[a-zA-Z0-9][a-zA-Z0-9_-]{5,16}$/;		
			return pattern.test(sign);
		}
		
		/**
		 * 
		 * @param sign 单个字符   字节小于255，如果超过255可能是中文或者其他字符,返回flase,否则true
		 * @return 
		 * 
		 */		
		public static function specialUnicode(sign:String):Boolean
		{	
			return sign.charCodeAt(0)  < 255 && sign != " ";//不能为空
		}
		
		/**
		 * 
		 * @param signs 多字符  ,每个字节小于255，如果有字符超过255可能是中文或者其他字符,返回flase,否则true
		 * @return 
		 * 
		 */		
		public static function specialUnicodes(signs:String):Boolean
		{
			var i:int = 0 ; 
			var length:int = signs.length;
			for(i ; i < length ; i ++)
			{
				if(!specialUnicode(signs.charAt(i)))
				{
					return false;
				}
			}
			return true;
		}
		
		
		/**
		 * 
		 * @param sign  字符
		 * @return   如果没有特殊符号并且达到条件，返回ture,否则返回flase
		 * 
		 */		
		public static function special(sign:String):Boolean
		{
			var pattern:RegExp=/^-?[a-zA-Z0-9_]\d*$/		
			return pattern.test(sign);
		}
	}
}