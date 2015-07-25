package game.fight
{
	import com.utils.StringUtil;
	
	import game.manager.AssetMgr;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	/**
	 * 
	 * @author joy
	 */
	public class BattleWordsBehavior extends Sprite
	{
		private var _data:String;
		public static const DELAY:Number = 1.5;
		/**
		 * 
		 * @param entity
		 */
		public function BattleWordsBehavior(caption:String)
		{
			_data = caption;			
			
			var len:int = StringUtil.charCount(caption);
			var size:int = 26;		// 字体大小
			var count:int = 8;		// 单行中文个数
			var gap:int = 15;		//左右间隔
			
			var chineseSizeW:int = size * 1.4;
			var chineseSizeH:int = size * 1.1;
			
			/*var h:int = ((len/count+1)>>0) * chineseSizeH;
			var w:int = count * chineseSizeW;*/
			
		
			
			var paneTexture:Texture = AssetMgr.instance.getTexture('ui_zhandouduihua');
			var image:Image = new Image(paneTexture);
//			image.alpha = 1;
			
			var txt:TextField = new TextField(paneTexture.width,paneTexture.height,caption,"",size,0xffffff);
			txt.hAlign = HAlign.LEFT;
			txt.vAlign = VAlign.TOP;
			txt.autoScale = true;
			
			image.width = txt.width+2*gap;
			image.height = txt.height+2*gap;
			txt.y = txt.x = gap;
			/*this.x = -image.width/2;
			this.y = -image.height/2;*/
			this.addChild(image);
			this.addChild(txt);
		}
	}
}