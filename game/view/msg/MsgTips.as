package game.view.msg
{
	import com.components.RollTips;
	import com.langue.Langue;
	import com.singleton.Singleton;
	/**
	 * 
	 * @author后台推送提示
	 * 
	 */
	public class MsgTips
	{
		public function MsgTips()
		{
		}
		
		public static  function get instance():MsgTips
		{
			return Singleton.getInstance(MsgTips) as MsgTips;
		}
		
		public function tips(code:int):void
		{
			if(code == 1001)
			{
				RollTips.add(Langue.getLangue("ServerClose"));
			}
			else if(code == 1002)
			{
				RollTips.add(Langue.getLangue("elsewhereLogin"));
			}
			else if(code == 1003)
			{
				RollTips.add(Langue.getLangue("serverFull"));
			}
			else if(code == 1004)
			{
				RollTips.add(Langue.getLangue("serverBusy"));
			}
			else if(code == 1008)
			{
				RollTips.add(Langue.getLangue("packFulls"));
			}
		}
	}
}