package game.common
{
	import starling.display.Sprite;
	/**
	 *  
	 * @author CabbageWrom
	 * 
	 */	
	public class JTSession
	{
		 public static const layerGuideGlobal:Sprite = new Sprite(); //新手引导 <最顶层>
		 public static const layerGlobal:Sprite = new Sprite(); //全局层 <最顶层>
		 public static const layerChat:Sprite = new Sprite(); //聊天层
		 public static const layerPanel:Sprite = new Sprite();//dialog层<第二层>
		 public static const layerSence:Sprite = new Sprite(); //场景层<第三层>
		 
		 public static var currentScene:String = null;
		 
		 
		 public static var isPvp:Boolean = false; //是否在PVP里面
		 public static var isPvped:Boolean = false; //是否打过PVP
	}
}