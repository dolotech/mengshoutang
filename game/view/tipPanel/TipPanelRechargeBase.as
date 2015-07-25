package game.view.tipPanel
{
	import game.manager.AssetMgr;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class TipPanelRechargeBase extends Sprite
	{
		
		public var clickButton:Button;
		public var ButtonNameTxt:TextField;

		public var TipCaptionTxt:TextField;
		
		public function TipPanelRechargeBase()
		{
			var ui_gongyong_xinxidikuang1252479Texture:Texture = AssetMgr.instance.getTexture('ui_gongyong_xinxidikuang1');
			var ui_gongyong_xinxidikuang1252479Image:Image = new Image(ui_gongyong_xinxidikuang1252479Texture);
			ui_gongyong_xinxidikuang1252479Image.x = 252;
			ui_gongyong_xinxidikuang1252479Image.y = 479;
			ui_gongyong_xinxidikuang1252479Image.width = 477;
			ui_gongyong_xinxidikuang1252479Image.height = 95;
			ui_gongyong_xinxidikuang1252479Image.scaleY = -1.289642333984375;
			ui_gongyong_xinxidikuang1252479Image.touchable = false;
			this.addChild(ui_gongyong_xinxidikuang1252479Image);
			var ui_gongyong_xinxidikuang2251263Texture:Texture = AssetMgr.instance.getTexture('ui_gongyong_xinxidikuang2');
			var ui_gongyong_xinxidikuang2251263Image:Image = new Image(ui_gongyong_xinxidikuang2251263Texture);
			ui_gongyong_xinxidikuang2251263Image.x = 251;
			ui_gongyong_xinxidikuang2251263Image.y = 263;
			ui_gongyong_xinxidikuang2251263Image.width = 477;
			ui_gongyong_xinxidikuang2251263Image.height = 123;
			ui_gongyong_xinxidikuang2251263Image.touchable = false;
			this.addChild(ui_gongyong_xinxidikuang2251263Image);
			var clickTexture:Texture = AssetMgr.instance.getTexture('ui_fumoqianghua_anjian');
			clickButton = new Button(clickTexture);
			clickButton.x = 411;
			clickButton.y = 364;
			clickButton.width = 163;
			clickButton.height = 98;
			this.addChild(clickButton);
			ButtonNameTxt = new TextField(160,53,'','',35,0xffffff,false);
			ButtonNameTxt.touchable = false;
			ButtonNameTxt.hAlign = 'center'
			ButtonNameTxt.x = 408;
			ButtonNameTxt.y = 392;
			this.addChild(ButtonNameTxt);
			var ui_gongyong_xinxidikuang1252169Texture:Texture = AssetMgr.instance.getTexture('ui_gongyong_xinxidikuang1');
			var ui_gongyong_xinxidikuang1252169Image:Image = new Image(ui_gongyong_xinxidikuang1252169Texture);
			ui_gongyong_xinxidikuang1252169Image.x = 252;
			ui_gongyong_xinxidikuang1252169Image.y = 169;
			ui_gongyong_xinxidikuang1252169Image.width = 477;
			ui_gongyong_xinxidikuang1252169Image.height = 95;
			ui_gongyong_xinxidikuang1252169Image.touchable = false;
			this.addChild(ui_gongyong_xinxidikuang1252169Image);
			TipCaptionTxt = new TextField(350,122,'','',30,0xffffff,false);
			TipCaptionTxt.touchable = false;
			TipCaptionTxt.hAlign = 'left'
			TipCaptionTxt.x = 325;
			TipCaptionTxt.y = 250;
			this.addChild(TipCaptionTxt);
			
//			this.clipRect = new Rectangle(0,0,960,200);
			
			
//			Starling.juggler.tween();
		
		}
		override public function dispose():void
		{
			super.dispose();
			clickButton.dispose();
		}
	}
}