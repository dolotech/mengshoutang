package game.view.chat.component
{
	import com.langue.Langue;
	
	import game.base.JTSprite;
	
	import game.common.JTGlobalDef;
	
	import game.manager.AssetMgr;
	
	import game.managers.JTFunctionManager;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class JTButtonPullUI extends JTSprite
	{
		public var onSelect:ISignal;
		private static var instance:JTButtonPullUI = null;
		public function JTButtonPullUI()
		{
			super();
			onSelect = new Signal();
			initialize();
		}
		
		public function initialize():void
		{
			var btn:Button = null;
			var texts:Array = Langue.getLans("chatNumbers");
			var i:int = 0;
			var l:int = texts.length;
			for (i = 0; i < l; i++)
			{
				btn	= new Button(AssetMgr.instance.getTexture("ui_button_chat1"));
				btn.y = i * (btn.height + 10);
				btn.text = texts[i];
				btn.fontSize = 23;
				btn.fontColor = 0xffffff;
				btn.name = "btn" + i;
				btn.addEventListener(Event.TRIGGERED, onChangeChannel);
				this.addChild(btn);
			}
		}
		
		private function onChangeChannel(e:Event):void
		{
			var list:Array = Langue.getLans("chatNumbers");
			var target:Button = e.target as Button;
			var name:String = target.name;
			var index:int = name.split("btn")[1];
			JTFunctionManager.executeFunction(JTGlobalDef.CHAT_INPUT_SWITCH, index);
		}
		
		public static function open(parent:Sprite, selectBtn:Button):void
		{
			  if (!instance)
			  {
				  instance = new JTButtonPullUI();
				  instance.name = "buttonPullUI";
				  instance.y = selectBtn.y - instance.height;
				  instance.x = selectBtn.x + 15;
				  parent.addChild(instance);
			  }
		}
		
		public static function close():void
		{
			if (instance)
			{
				instance.removeFromParent();
				instance = null;
			}
		}
	}
}
