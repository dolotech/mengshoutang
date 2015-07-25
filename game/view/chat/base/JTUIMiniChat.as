package game.view.chat.base
{
	import flash.geom.Rectangle;
	
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import game.base.JTSprite;
	import game.manager.AssetMgr;
	
	import starling.display.Button;
	import starling.textures.Texture;
	import com.utils.Constants;
	
	public class JTUIMiniChat extends JTSprite
	{
		public var mc_chatpanel9Scale:Scale9Image;
		public var btn_maxButton:Button;
		
		public function JTUIMiniChat()
		{
			//var spri:JTScale9Sprite = new JTScale9Sprite();
			var mc_chatpanelTexture:Texture = AssetMgr.instance.getTexture('ui_city_information_bar');
			var mc_chatpanelRect:Rectangle = new Rectangle(24,30,48,61);
			var mc_chatpanel9ScaleTexture:Scale9Textures = new Scale9Textures(mc_chatpanelTexture,mc_chatpanelRect);
			mc_chatpanel9Scale = new Scale9Image(mc_chatpanel9ScaleTexture);
			mc_chatpanel9Scale.x = 18;
			mc_chatpanel9Scale.y = 5;
			mc_chatpanel9Scale.width = 449;
			mc_chatpanel9Scale.height = 121;
			mc_chatpanel9Scale.smoothing=Constants.smoothing;
		//	spri.addChild(mc_chatpanel9Scale);
			//this.addQuiackChild(mc_chatpanel9Scale);
			//spri.touchable = false;
			//this.addChild(spri);
			
			
			var btn_maxTexture:Texture = AssetMgr.instance.getTexture('ui_button_chat_change1');
			btn_maxButton = new Button(btn_maxTexture);
			btn_maxButton.x = 0;
			btn_maxButton.y = 0;
			this.addQuiackChild(btn_maxButton);
			
		}
		
		override public function dispose():void
		{
			btn_maxButton.dispose();
			super.dispose();
			
		}
		
	}
}